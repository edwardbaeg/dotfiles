-- remap netrw keymaps
vim.api.nvim_create_autocmd("filetype", {
   pattern = "netrw",
   desc = "Better mappings for netrw",
   callback = function()
      local bind = function(lhs, rhs)
         vim.keymap.set("n", lhs, rhs, { remap = true, buffer = true })
      end

      bind("n", "%")     -- edit new file
      bind("r", "R")     -- rename file
      bind("R", "<c-I>") -- refresh
      -- bind('h', '-^') -- go up directory -- this breaks netrw...
      -- bind('l', '<cr>') -- enter -- this breaks netrw...
   end,
})

-- From lazyvim
local function augroup(name)
   return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
   group = augroup("checktime"),
   callback = function()
      if vim.o.buftype ~= "nofile" then
         vim.cmd("checktime")
      end
   end,
})

-- resize splits if window got resized
-- TODO: this might be a little slow?
vim.api.nvim_create_autocmd({ "VimResized" }, {
   group = augroup("resize_splits"),
   callback = function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd("tabdo wincmd =")
      vim.cmd("tabnext " .. current_tab)
   end,
})

-- Highlight portions of lines that are too long
-- TODO: exclude some filetypes
-- vim.cmd([[
--    augroup vimrc_autocmds
--       autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#331111
--       autocmd BufEnter * match OverLength /\%100v.*/
--    augroup END
-- ]])

-- close/quit some filetypes with <q>
-- TODO?: add for help files that were added as markdown
vim.api.nvim_create_autocmd("FileType", {
   group = augroup("close_with_q"),
   pattern = {
      "PlenaryTestPopup",
      "help",
      "lspinfo",
      "man",
      "notify",
      "qf",
      "query",
      "spectre_panel",
      "startuptime",
      "tsplayground",
      "neotest-output",
      "checkhealth",
      "neotest-summary",
      "neotest-output-panel",

      "fugitiveblame", -- from vim-fugitive
      "git",           -- from vim-fugitive
      "grug-far",      -- from grug-far
   },
   callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
   end,
})

-- keep curosor position after yanking
-- https://nanotipsforvim.prose.sh/sticky-yank
local cursorPreYank
vim.keymap.set({ "n", "x" }, "y", function()
   cursorPreYank = vim.api.nvim_win_get_cursor(0)
   return "y"
end, { expr = true })

vim.keymap.set("n", "Y", function()
   cursorPreYank = vim.api.nvim_win_get_cursor(0)
   return "y$"
end, { expr = true })

vim.api.nvim_create_autocmd("TextYankPost", {
   callback = function()
      if vim.v.event.operator == "y" and cursorPreYank then
         vim.api.nvim_win_set_cursor(0, cursorPreYank)
      end
   end,
})

-- show cursor line only in active window
-- this doesn't work with <c-c>, only with <esc>
-- https://github.com/folke/dot/blob/master/nvim/lua/config/autocmds.lua
-- vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
--    callback = function()
--       local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
--       if ok and cl then
--          vim.wo.cursorline = true
--          vim.api.nvim_win_del_var(0, "auto-cursorline")
--       end
--    end,
-- })
-- vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
--    callback = function()
--       local cl = vim.wo.cursorline
--       if cl then
--          vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
--          vim.wo.cursorline = false
--       end
--    end,
-- })
