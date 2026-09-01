--[[ Resolve JS/TS module specifiers to file paths for `gf` (via 'includeexpr').

Handles tsconfig `paths` aliases (@common/*, @dispatch-private/ui, ...) and bare
node_modules packages, neither of which the builtin 'suffixesadd' can reach.
]]

local M = {}

-- Ordered: first match wins, so .ts beats .js for a transpiled sibling pair.
local EXTENSIONS = { "", ".ts", ".tsx", ".d.ts", ".js", ".jsx", ".mjs", ".cjs", ".json" }

---@type table<string, table[]> keyed by the directory the lookup started from
local alias_cache = {}

local function is_file(path)
   local stat = vim.uv.fs_stat(path)
   return stat ~= nil and stat.type == "file"
end

--- Apply extension and /index guessing to a path prefix
---@param base string
---@return string|nil
local function resolve_file(base)
   local function found(path)
      -- Workspace packages are reached through a node_modules symlink; resolve
      -- it so the buffer name matches the one you'd get from the real path.
      return vim.uv.fs_realpath(path) or path
   end
   for _, ext in ipairs(EXTENSIONS) do
      if is_file(base .. ext) then
         return found(base .. ext)
      end
   end
   for _, ext in ipairs(EXTENSIONS) do
      if ext ~= "" and is_file(base .. "/index" .. ext) then
         return found(base .. "/index" .. ext)
      end
   end
   return nil
end

--- tsconfig files are JSONC: strip comment-only lines and trailing commas.
--- Line-based on purpose, so `//` inside a string value (e.g. $schema) survives.
---@param path string
---@return table|nil
local function read_jsonc(path)
   local ok, lines = pcall(vim.fn.readfile, path)
   if not ok then
      return nil
   end

   local kept = {}
   local in_block = false
   for _, line in ipairs(lines) do
      if in_block then
         if line:find("%*/") then
            in_block = false
         end
      elseif line:match("^%s*/%*") and not line:find("%*/") then
         in_block = true
      elseif not line:match("^%s*//") then
         table.insert(kept, (line:gsub("/%*.-%*/", "")))
      end
   end

   local text = table.concat(kept, "\n"):gsub(",(%s*[}%]])", "%1")
   local decoded_ok, decoded = pcall(vim.json.decode, text, { luanil = { object = true } })
   return decoded_ok and decoded or nil
end

--- Walk a tsconfig `extends` chain, nearest config first.
--- `paths` are resolved against the config that declared them (or its baseUrl),
--- which is what tsc does and why each entry carries its own dir.
---@param config_path string
---@param out table[]
---@param seen table<string, boolean>
local function collect_aliases(config_path, out, seen)
   if seen[config_path] then
      return
   end
   seen[config_path] = true

   local config = read_jsonc(config_path)
   if not config then
      return
   end

   local dir = vim.fs.dirname(config_path)
   local options = config.compilerOptions or {}
   if options.paths then
      local base = options.baseUrl and vim.fs.normalize(dir .. "/" .. options.baseUrl) or dir
      for pattern, targets in pairs(options.paths) do
         table.insert(out, { pattern = pattern, targets = targets, dir = base })
      end
   end

   local extends = config.extends
   if type(extends) == "string" then
      extends = { extends }
   end
   for _, parent in ipairs(extends or {}) do
      if parent:match("^%.") then
         local parent_path = vim.fs.normalize(dir .. "/" .. parent)
         if not parent_path:match("%.json$") then
            parent_path = parent_path .. ".json"
         end
         collect_aliases(parent_path, out, seen)
      end
   end
end

---@param from_dir string
---@return table[]
local function get_aliases(from_dir)
   if alias_cache[from_dir] then
      return alias_cache[from_dir]
   end

   local aliases = {}
   local seen = {}
   local dir = from_dir
   -- Keep climbing past the first hit: a package tsconfig may add aliases the
   -- workspace root also defines, and both are in play.
   while dir and dir ~= "/" do
      for _, name in ipairs({ "tsconfig.json", "tsconfig.base.json" }) do
         local path = dir .. "/" .. name
         if is_file(path) then
            collect_aliases(path, aliases, seen)
         end
      end
      local parent = vim.fs.dirname(dir)
      if parent == dir then
         break
      end
      dir = parent
   end

   -- tsc picks the pattern with the longest literal prefix.
   table.sort(aliases, function(a, b)
      return #a.pattern:gsub("%*", "") > #b.pattern:gsub("%*", "")
   end)

   alias_cache[from_dir] = aliases
   return aliases
end

---@param fname string
---@param from_dir string
---@return string|nil
local function resolve_alias(fname, from_dir)
   for _, alias in ipairs(get_aliases(from_dir)) do
      local prefix, suffix = alias.pattern:match("^(.-)%*(.*)$")
      local rest
      if prefix then
         local body = fname:match("^" .. vim.pesc(prefix) .. "(.*)" .. vim.pesc(suffix) .. "$")
         rest = body
      elseif fname == alias.pattern then
         rest = ""
      end

      if rest then
         for _, target in ipairs(alias.targets) do
            local candidate = vim.fs.normalize(alias.dir .. "/" .. target:gsub("%*", (rest:gsub("%%", "%%%%"))))
            local found = resolve_file(candidate)
            if found then
               return found
            end
         end
      end
   end
   return nil
end

--- Entry point for the `main`/`types`/`exports` of a bare package specifier
---@param pkg_dir string
---@return string|nil
local function resolve_package_entry(pkg_dir)
   local manifest = read_jsonc(pkg_dir .. "/package.json") or {}
   local exports = manifest.exports
   local dot = type(exports) == "table" and exports["."] or nil
   -- Source-first: workspace packages point `types`/`main` at dist/, and a
   -- generated .d.ts is never what you wanted to jump to.
   local candidates = { "index", "src/index" }
   local function add(value)
      if type(value) == "string" then
         table.insert(candidates, value)
      end
   end
   if type(dot) == "string" then
      add(dot)
   elseif type(dot) == "table" then
      add(dot.types or dot.import or dot.default)
   end
   add(manifest.types)
   add(manifest.typings)
   add(manifest.module)
   add(manifest.main)

   for _, entry in ipairs(candidates) do
      local found = resolve_file(vim.fs.normalize(pkg_dir .. "/" .. entry))
      if found then
         return found
      end
   end
   return nil
end

---@param fname string
---@param from_dir string
---@return string|nil
local function resolve_node_module(fname, from_dir)
   local pkg, subpath
   if fname:sub(1, 1) == "@" then
      pkg, subpath = fname:match("^(@[^/]+/[^/]+)/?(.*)$")
   else
      pkg, subpath = fname:match("^([^/]+)/?(.*)$")
   end
   if not pkg then
      return nil
   end

   for dir in vim.fs.parents(from_dir .. "/x") do
      local pkg_dir = dir .. "/node_modules/" .. pkg
      if vim.uv.fs_stat(pkg_dir) then
         if subpath == "" then
            return resolve_package_entry(pkg_dir)
         end
         -- Workspace packages are symlinked, so a bare subpath usually lands
         -- directly; `src/` covers the built-package layout.
         return resolve_file(pkg_dir .. "/" .. subpath) or resolve_file(pkg_dir .. "/src/" .. subpath)
      end
   end
   return nil
end

--- 'includeexpr' implementation. Returns the original name when unresolved so
--- the builtin 'path'/'suffixesadd' search still gets its turn.
---@param fname string
---@return string
function M.resolve(fname)
   if fname == nil or fname == "" then
      return fname or ""
   end

   fname = fname:gsub("[?#].*$", ""):gsub("%.js$", "")
   local from_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
   if from_dir == "" or from_dir == "." then
      from_dir = vim.uv.cwd()
   end

   if fname:match("^%.") then
      return resolve_file(vim.fs.normalize(from_dir .. "/" .. fname)) or fname
   end
   if fname:match("^/") then
      return resolve_file(fname) or fname
   end

   return resolve_alias(fname, from_dir) or resolve_node_module(fname, from_dir) or fname
end

function M.clear_cache()
   alias_cache = {}
end

return M
