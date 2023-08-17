-- [[Vim Options]]

vim.o.number = true -- Make line numbers default
-- vim.o.relativenumber = true -- show relative line numbers
vim.o.wrap = false -- Don't wrap lines
vim.o.breakindent = true -- wrapped lines will have consistent indents
vim.o.updatetime = 250 -- Decrease update time
vim.o.signcolumn = "yes" -- always show sign column
vim.o.completeopt = "menuone,noselect" -- better completion experience
vim.o.mouse = "a" -- Enable mouse moedwardbaeg9@gmail.com@de
vim.o.cursorline = true -- highlight line with cursor, window scoped for use with reticle.nvim
vim.o.hidden = true -- allow switching buffers without saving
vim.o.scrolloff = 24 -- number of lines to keep above/below the cursor
vim.o.linebreak = true -- wrap at spaces instead of the middle of a word
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

-- vim.o.showmatch = true -- briefly flash matching bracket -- replaced with a plugin
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

-- set clipboard per os
vim.cmd([[
  if has("win32")
    " echo "is this windows?"
    set clipboard=unnamed " integrate with windows
  else
    if has("unix")
      let s:uname = system("uname")
      if s:uname == "Darwin\n"
        set clipboard=unnamedplus " integrate with mac
      endif
    endif
  endif
]])

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
  elseif &filetype == "sh"
  elseif &filetype == "sh"
    exec "!bash %"
  endif
endfunction
]])

-- remap netrw keymaps
vim.api.nvim_create_autocmd("filetype", {
   pattern = "netrw",
   desc = "Better mappings for netrw",
   callback = function()
      local bind = function(lhs, rhs)
         vim.keymap.set("n", lhs, rhs, { remap = true, buffer = true })
      end

      bind("n", "%") -- edit new file
      bind("r", "R") -- rename file
      bind("R", "<c-I>") -- refresh
      -- bind('h', '-^') -- go up directory -- this breaks netrw...
      -- bind('l', '<cr>') -- enter -- this breaks netrw...
   end,
})

vim.api.nvim_create_user_command("PrintFile", "echo @%", { desc = "Show the path for the current file" })

-- show cursor line only in active window
-- this doesn't work with <c-c>, only with <esc>
-- https://github.com/folke/dot/blob/master/nvim/lua/config/autocmds.lua
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
   callback = function()
      local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
      if ok and cl then
         vim.wo.cursorline = true
         vim.api.nvim_win_del_var(0, "auto-cursorline")
      end
   end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
   callback = function()
      local cl = vim.wo.cursorline
      if cl then
         vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
         vim.wo.cursorline = false
      end
   end,
})

-- [[ Highlights ]]
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1c1c1c" }) -- set background color of floating windows; plugins: telescope, which-key
-- vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#546178", bg = "#1c1c1c" }) -- border of floating windows
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#546178" }) -- border of floating windows
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#101010" }) -- darker cursorline
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffffff" }) -- make matching parens easier to see
-- vim.api.nvim_set_hl(0, "Whitespace", { fg = "#ffffff" }) -- TODO: only highlight trailing whitespace

vim.api.nvim_set_hl(0, "@operator", { italic = false, fg = "#99d1db" }) -- eg +, =, || -- TODO?: only do for js?
vim.api.nvim_set_hl(0, "@variable.builtin", { italic = true, fg = "#e78284" }) -- eg +, =, || -- TODO?: only do for js?
-- vim.api.nvim_set_hl(0, '@keyword.function', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, 'Keyword', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, '@method.call', { italic = false }) -- highlights the keyword 'Instance.method'

vim.api.nvim_set_hl(0, "CodeiumSuggestion", { fg = "#bbbbbb" }) -- highlight codeium suggestions

-- [[ Legacy config syntax ]]
vim.cmd([[

" Center after jumps
nnoremap g; g;zz

" center after search "don't really need this with scrolloffset
" nnoremap n nzz
" nnoremap N Nzz
" nnoremap * *zz
" nnoremap # #zz
" nnoremap g* g*zz
" nnoremap g# g#zz
]])
