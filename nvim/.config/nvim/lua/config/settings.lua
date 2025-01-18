--[[ Vim Options ]]--

vim.o.number = true -- Make line numbers default
-- vim.o.relativenumber = true -- show relative line numbers

-- Wrapping
-- vim.o.wrap = false -- set visual wrapping of long lines
vim.o.linebreak = true -- wrap at spaces instead of the middle of a word
vim.o.breakindent = true -- wrapped lines will have consistent indents
vim.o.showbreak = "… " -- string added to the start of wrapped lines, ellipsis, this is highlighted with NonText
vim.api.nvim_set_hl(0, "NonText", { fg = "grey30" }) -- highlights showbreak characters, slightly different than comment text

vim.o.updatetime = 250 -- Decrease update time
vim.o.signcolumn = "yes" -- always show sign column
vim.o.completeopt = "menuone,noselect" -- better completion experience
vim.o.mouse = "a" -- Enable mouse moedwardbaeg9@gmail.com@de
vim.o.cursorline = true -- highlight line with cursor
vim.o.hidden = true -- allow switching buffers without saving
vim.o.scrolloff = 20 -- number of lines to keep above/below the cursor -- FIXME: this sometimes get unset?
-- vim.o.winblend = 10 -- floating window transparency -- disable for transparent mode

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
vim.api.nvim_create_autocmd("FileType", {
   pattern = "sh",
   callback = function()
      vim.api.nvim_buf_set_option(0, "tabstop", 4)
   end,
})

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
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
if vim.fn.has('wsl') == 1 then
  -- print("is wsl")
  vim.cmd[[set clipboard=unnamedplus]]
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ['+'] = 'clip.exe',
      ['*'] = 'clip.exe',
    },
    paste = {
      ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

-- integrate with system clipboards
if vim.fn.has("win32") == 1 then
  -- print("is windows?")
  vim.opt.clipboard = "unnamed"
elseif vim.fn.has("unix") == 1 then
  local uname = vim.fn.system("uname")
  if uname == "Darwin\n" then
    -- print("is mac")
    vim.opt.clipboard = "unnamedplus"
  end
end

-- View output from running in terminal
vim.cmd([[
noremap <A-b> :call Build() <cr>
function! Build()
  if &filetype == "javascript"
    exec "! node %"
  elseif &filetype == 'typescript'
    exec "!ts-node %"
  elseif &filetype == 'lua'
    exec "!lua %"
  elseif &filetype == "python"
    exec "!python3 %"
  elseif &filetype == "sh"
  elseif &filetype == "sh"
    exec "!bash %"
  endif
endfunction
]])

vim.api.nvim_create_user_command("PrintFile", "echo @%", { desc = "Show the path for the current file" })
vim.api.nvim_create_user_command("Pwf", "echo @%", { desc = "Show the path for the current file" })

vim.api.nvim_create_user_command("Bda", "bufdo bd", { desc = "Close all buffers" })

-- [[ Highlights ]]
-- local frappe = require("catppuccin.palettes").get_palette("frappe")
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1c1c1c" }) -- set background color of floating windows; plugins: telescope, which-key
-- vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#546178", bg = "#1c1c1c" }) -- border of floating windows
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#546178" }) -- border of floating windows
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#101010" })
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#141414" })
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "grey9" }) -- set with reactive.nvim
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#0A2222" }) -- set with reactive.nvim
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffffff" }) -- make matching parens easier to see


-- TODO: only highlight trailing whitespace
-- vim.api.nvim_set_hl(0, "Whitespace", { fg = "#ffffff" })

vim.api.nvim_set_hl(0, "@operator", { italic = false, fg = "#99d1db" }) -- eg +, =, || -- TODO?: only do for js?
vim.api.nvim_set_hl(0, "@variable.builtin", { italic = true, fg = "#e78284" }) -- eg +, =, || -- TODO?: only do for js?
vim.api.nvim_set_hl(0, "Exception", { italic = true }) -- eg try, catch, TODO: set to green?
-- vim.api.nvim_set_hl(0, '@keyword.function', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, 'Keyword', { italic = true }) -- highlights the keyword 'function' vim.api.nvim_set_hl(0, 'Keyword', { italic = true }) -- highlights the keyword 'function' vim.api.nvim_set_hl(0, 'Keyword', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, '@method.call', { italic = false }) -- highlights the keyword 'Instance.method'
vim.api.nvim_set_hl(0, "LspInlayHint", { italic = true, bg = "#333333" }) -- highlight codeium suggestions

vim.api.nvim_set_hl(0, "CodeiumSuggestion", { fg = "#bbbbbb" }) -- highlight codeium suggestions
