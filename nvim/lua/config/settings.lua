--[[ Vim Options ]]
--vim.o -> global options
--vim.bo -> buffer local options
--vim.wo -> window local options

-- TODO: create new sections or files for autocommands and user commands

vim.o.number = true -- Make line numbers default
-- vim.o.relativenumber = true -- show relative line numbers

-- Wrapping
vim.o.wrap = true -- set visual wrapping of long lines
vim.o.linebreak = true -- wrap at spaces instead of the middle of a word
vim.o.breakindent = true -- wrapped lines will have consistent indents
vim.o.showbreak = "… " -- string added to the start of wrapped lines -- ellipsis -- this is highlighted with NonText
-- vim.api.nvim_set_hl(0, "NonText", { fg = "grey30" }) -- highlights showbreak characters, slightly different than comment text -- NOTE: this is also used by snacks.picker for the directory

vim.o.updatetime = 250 -- Decrease update time (ms), default is 4000 ms
vim.o.signcolumn = "yes" -- always show sign column
vim.o.completeopt = "menuone,noselect" -- better completion experience
vim.o.mouse = "a" -- Enable mouse mode
vim.o.cursorline = true -- highlight line with cursor
vim.o.hidden = true -- allow switching buffers without saving
vim.o.scrolloff = 20 -- number of lines to keep above/below the cursor -- FIXME: this sometimes get unset?
-- vim.o.winblend = 10 -- floating window transparency -- disable for transparent mode

-- vim.o.winborder = "rounded" -- default border for floating windows, can mess up some many uis

vim.o.ignorecase = true -- case insensitive searching
vim.o.smartcase = true -- ...unless /C or capital in search
vim.o.inccommand = "nosplit" -- show likve search and replace

vim.o.undofile = true -- Save undo history
vim.o.undodir = vim.fn.expand("~/.vim/undo") -- set save directory. This must exist first... I think

vim.o.list = true -- show types of whitespace
vim.o.listchars = "tab:‣ ,trail:•,precedes:«,extends:»"

vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true

vim.o.spelllang = "en"
vim.o.spellsuggest = "best,9"

vim.o.splitright = true -- open splits on the right
vim.o.splitbelow = true -- open splits on the bottom

-- vim.o.cmdheight = 2 -- number of screen lines for command-line
vim.o.cmdheight = 1 -- number of screen lines for command-line
vim.o.showmode = false --whether to show -- INSERT -- in command-line

-- vim.o.showmatch = true -- briefly flash matching bracket -- replaced with vim-matchup
-- vim.o.matchtime = 2 = multiple of 100ms

-- set tabstop for specific filetypes
-- FIXME this doesnt seem to always work?
vim.api.nvim_create_autocmd("FileType", {
   pattern = { "sh", "bash" },
   callback = function()
      vim.notify("set tabstop to 4 for bash", vim.log.levels.INFO)
      vim.bo.tabstop = 4
   end,
})

-- searching
-- vim.opt.path:append("**") -- fuzzy searching for :find -- NOTE: this can be SUPER slow -- this can slow down "smart enter"
-- vim.keymap.set("n", "<leader>fi", ":find ", { desc = "Find files recursively" }) -- is this better than ctrl-p?

vim.opt.grepprg = "rg --vimgrep" -- replace grep with rg -- TODO: check why a noice window opens for this -- NOTE: the default fallback here if rg is available is rg --vimgrep -uu

-- Folding

-- vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.foldcolumn = '2' -- show fold nesting
-- vim.cmd([[set foldopen-=block]]) -- don't open folds with block {} motions

-- vim.cmd([[
-- augroup remember_folds
--   autocmd!
--   au BufWinLeave ?* mkview 1
--   au BufWinEnter ?* silent! loadview 1
-- augroup END
-- ]])

-- set clipboard for wsl
if vim.fn.has("wsl") == 1 then
   -- print("is wsl")
   vim.cmd([[set clipboard=unnamedplus]])
   vim.g.clipboard = {
      name = "WslClipboard",
      copy = {
         ["+"] = "clip.exe",
         ["*"] = "clip.exe",
      },
      paste = {
         ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
         ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      },
      cache_enabled = 0,
   }
end

-- integrate with system clipboards
if vim.fn.has("win32") == 1 then
   -- print("is windows?")
   vim.o.clipboard = "unnamed"
elseif vim.fn.has("unix") == 1 then
   local uname = vim.fn.system("uname")
   if uname == "Darwin\n" then
      -- print("is mac")
      vim.opt.clipboard = "unnamedplus"
   end
end

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

-- [[ Highlights ]]
-- NOTE: a number of these highlights are set after plugins are loaded -- so we load this file after plugins

-- UI
-- local frappe = require("catppuccin.palettes").get_palette("frappe")
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1c1c1c" }) -- set background color of floating windows; plugins: telescope, which-key
-- vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#546178", bg = "#1c1c1c" }) -- border of floating windows
-- vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#546178" }) -- border of floating windows -- this is set by some plugins
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#101010" })
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#141414" })
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "grey9" }) -- set with reactive.nvim
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#0A2222" }) -- set with reactive.nvim
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffffff" }) -- make matching parens easier to see

-- TODO: only highlight trailing whitespace
-- vim.api.nvim_set_hl(0, "Whitespace", { fg = "#ffffff" })

-- Syntax
vim.api.nvim_set_hl(0, "@operator", { italic = false, fg = "#99d1db", ctermfg = "NONE" }) -- eg +, =, ||
vim.api.nvim_set_hl(0, "Operator", { italic = false, fg = "#99d1db", ctermfg = "NONE" }) -- eg +, =, ||
vim.api.nvim_set_hl(0, "@variable.builtin", { italic = true, fg = "#e78284" }) -- eg +, =, || -- TODO?: only do for js?
vim.api.nvim_set_hl(0, "Exception", { italic = true }) -- eg try, catch, TODO: set to green?
-- vim.api.nvim_set_hl(0, '@keyword.function', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, 'Keyword', { italic = true }) -- highlights the keyword 'function' vim.api.nvim_set_hl(0, 'Keyword', { italic = true }) -- highlights the keyword 'function' vim.api.nvim_set_hl(0, 'Keyword', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, '@method.call', { italic = false }) -- highlights the keyword 'Instance.method'
vim.api.nvim_set_hl(0, "LspInlayHint", { italic = true, bg = "#333333" }) -- highlight codeium suggestions

-- Plugins
vim.api.nvim_set_hl(0, "CodeiumSuggestion", { fg = "#bbbbbb" }) -- highlight codeium suggestions -- TODO: move to plugin file?

-- Disable line wrapping for csv
vim.api.nvim_create_augroup("csv_settings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
   group = "csv_settings",
   pattern = "csv",
   callback = function()
      vim.opt_local.wrap = false
   end,
})

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
