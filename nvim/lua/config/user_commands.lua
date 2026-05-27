-- View output from running in terminal
local function run_build()
   local ft = vim.bo.filetype
   local file = vim.fn.expand("%")
   if ft == "javascript" then
      vim.cmd("terminal node " .. file)
   elseif ft == "typescript" then
      vim.cmd("terminal ts-node " .. file)
   elseif ft == "lua" then
      vim.cmd("luafile " .. file)
   elseif ft == "python" then
      vim.cmd("terminal python3 " .. file)
   elseif ft == "sh" then
      vim.cmd("terminal bash " .. file)
   end
end

vim.keymap.set("n", "<A-b>", run_build, { noremap = true, silent = true })
vim.api.nvim_create_user_command("Build", run_build, {})

vim.api.nvim_create_user_command("PrintFile", "echo @%", { desc = "Show the path for the current file" })
vim.api.nvim_create_user_command("Pwf", "echo @%", { desc = "Show the path for the current file" })

vim.api.nvim_create_user_command("Bda", "bufdo bd", { desc = "Close all buffers" })

-- add modified files to quickfix, filtered to cwd
vim.api.nvim_create_user_command("ModifiedQuickfix", function()
   local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
   local cwd = vim.fn.getcwd()
   local files = vim.fn.systemlist("git diff HEAD --name-only")
   local filtered = vim.tbl_filter(function(f)
      local abs = git_root .. "/" .. f
      return abs:sub(1, #cwd) == cwd
   end, files)
   vim.fn.setqflist(vim.tbl_map(function(f)
      return { filename = git_root .. "/" .. f, lnum = 1 }
   end, filtered))
   vim.cmd("copen")
end, {})

-- Quick open file in Cursor.app
local function open_in_cursor()
   local file_path = vim.fn.expand("%:p")
   local line_number = vim.fn.line(".")
   vim.fn.system(string.format("cursor -g %s:%d", file_path, line_number))
end

vim.keymap.set(
   "n",
   "<leader>gu",
   open_in_cursor,
   { noremap = true, silent = true, desc = "Open current file and line in Cursor" }
)

vim.api.nvim_create_user_command("OpenInCursor", open_in_cursor, {
   nargs = 0,
   desc = "Open current file and line in Cursor",
})
