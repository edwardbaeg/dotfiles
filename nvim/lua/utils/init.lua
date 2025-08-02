local M = {}

--- Combine two tables
---@param t1 table
---@param t2 table
---@return table
function M.object_assign(t1, t2)
   for key, value in pairs(t2) do
      t1[key] = value
   end

   return t1
end

---@param name string
local function is_index_file(name)
   return name:find("^index.") or name:find("^[i]nit.")
end

---@param path string
function M.get_filename_from_path(path)
   return path:gsub(".*/", "")
end

---This could be refactored to just use the path of the file...
---@param filename string file name
---@param path string file path
---@param short? boolean whether to display index filename as "index" or "i"
---@return string text shorthand filename that includes the parent directory for index.* files
function M.get_filename_display(filename, path, short)
   short = short or false
   if not is_index_file(filename) then
      return filename
   else
      local parentDirName = path:match("(.*)/(.*)$")
      parentDirName = parentDirName:gsub(".*/", "")
      if short then
         return parentDirName .. "/" .. "i"
      end
      return parentDirName .. "/" .. filename
   end
end

function M.get_visual_selection()
   -- Store the visual selection in a register and get it
   vim.cmd('normal! "vy')
   local selected_text = vim.fn.getreg("v")

   -- Clean up whitespace and newlines
   selected_text = selected_text:gsub("\n", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")

   return selected_text
end

return M
