-- [[ TODO ]]
-- split into multiple files
-- rewrite all vimscript stuff to lua
-- fix showing git stuff (lua line and vim fugitive) for lua line (but it works for gitsigns?)
-- fix super slow and sometimes crashing <c-g> grepping; maybe use fzf-lua?
-- upgrade from ts-server to https://github.com/pmizio/typescript-tools.nvim ; this is supposed to be much faster
-- determine a way to open *.stories for the given file

vim = vim

require("plugins")
require("settings")

-- [[Vim Options]]
vim.o.lazyredrew = true -- improve performance
vim.o.hlsearch = false -- Set highlight on search
vim.o.number = true -- Make line numbers default
-- vim.o.relativenumber = true -- show relative line numbers
vim.o.wrap = false -- Don't wrap lines
vim.o.breakindent = true -- wrapped lines will have consistent indents
vim.o.updatetime = 250 -- Decrease update time
vim.o.signcolumn = "yes" -- always show sign column
vim.o.completeopt = "menuone,noselect" -- better completion experience
vim.o.mouse = "a" -- Enable mouse moedwardbaeg9@gmail.com@de
vim.wo.cursorline = true -- highlight line with cursor, window scoped for use with reticle.nvim

vim.o.ignorecase = true -- case insensitive searching
vim.o.smartcase = true -- ...unless /C or capital in search

vim.o.undofile = true -- Save undo history
vim.o.undodir = vim.fn.expand("~/.vim/undo") -- set save directory. This must exist first... I think

vim.o.list = true -- show types of whitespace
vim.o.listchars = "tab:‣ ,trail:•,precedes:«,extends:»"

vim.o.hidden = true -- allow switching buffers without saving

vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true

vim.api.nvim_create_autocmd("FileType", {
   pattern = "sh",
   callback = function()
      vim.api.nvim_buf_set_option(0, "tabstop", 4)
      vim.api.nvim_buf_set_option(0, "tabstop", 4)
   end,
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "lua",
-- 	callback = function()
-- 		vim.api.nvim_buf_set_option(0, "tabstop", 3)
-- 		vim.api.nvim_buf_set_option(0, "tabstop", 3)
-- 	end,
-- })

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

-- [[ Firenvim overrides ]]
if vim.g.started_by_firenvim then
   vim.o.wrap = true
   vim.o.number = false
   vim.o.relativenumber = false
   vim.o.spell = true
end

-- [[ Smart clipboard ]]
vim.cmd([[
  if has("win32")
    echo "is this windows?"
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

-- [[ Keymaps ]]
vim.keymap.set("i", "jk", "<Esc>") -- leave insert mode

vim.keymap.set("n", "<leader>+", "<c-a>") -- increment and decrement
vim.keymap.set("n", "<leader>-", "<c-x>")
vim.keymap.set("n", "<leader>ex", ":ex .<cr>", { desc = "open netrw in directory :ex ." }) -- open netrw
vim.keymap.set("n", "_", '"_') -- empty register shortcut
vim.keymap.set("n", "<leader>q", "") -- close whichkey / cancel leader without starting macro

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true }) -- Remaps for dealing with word wrap
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<leader>yy", "ggyG''") -- yank whole file

-- vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev) -- Diagnostic keymaps
-- vim.keymap.set('n', 'ge', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.keymap.set("n", "<c-f>", "za") -- toggle folds

-- emacs style
vim.keymap.set("n", "<leader>bn", ":bn<cr>")
vim.keymap.set("n", "<leader>bp", ":bp<cr>")
vim.keymap.set("n", "<leader>bd", ":bd<cr>")

vim.keymap.set("n", "<leader>wj", "<cmd>wincmd j<cr>")
vim.keymap.set("n", "<leader>wk", "<cmd>wincmd k<cr>")
vim.keymap.set("n", "<leader>wh", "<cmd>wincmd h<cr>")
vim.keymap.set("n", "<leader>wl", "<cmd>wincmd l<cr>")

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

-- [[ Highlight on yank ]]
-- local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
-- vim.api.nvim_create_autocmd("TextYankPost", {
--    callback = function()
--       vim.highlight.on_yank({ timeout = 500 }) -- timeout default is 150
--    end,
--    group = highlight_group,
--    pattern = "*",
-- })

-- [[ Highlights ]]
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1c1c1c" }) -- set background color of floating windows; plugins: telescope, which-key
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#546178", bg = "#1c1c1c" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#101010" }) -- darker cursorline
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffffff" }) -- make matching parens easier to see

vim.api.nvim_set_hl(0, "@operator", { italic = false, fg = "#99d1db" }) -- eg +, =, || only do for js?
vim.api.nvim_set_hl(0, "@variable.builtin", { italic = true, fg = "#e78284" }) -- eg +, =, || only do for js?
-- vim.api.nvim_set_hl(0, '@keyword.function', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, 'Keyword', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, '@method.call', { italic = false }) -- highlights the keyword 'Instance.method'

-- [[ Legacy config syntax ]]
vim.cmd([[
set showmatch
set matchtime=2 " multiple of 100ms
highlight Whitespace ctermbg=white " make whitespace easier to see
set scrolloff=24 " buffer top and bottom
set linebreak " don't break in the middle of a word

set incsearch " search realtime
set hlsearch
nnoremap <silent> <Leader><Space> :nohlsearch<Bar>:echo<CR>
set ignorecase
set smartcase
set inccommand=nosplit " live substitutions

" Center after jumps
nnoremap g; g;zz
" nnoremap gi gi<esc>zzi

" center after search
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Remap move cursor to ends of lines H / L
noremap <S-h> ^
noremap <S-l> $

" Quick edit configs
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>et :edit ~/.tmux.conf<cr>
nnoremap <leader>ez :edit ~/.zshrc<cr>
nnoremap <leader>eh :edit ~/.hammerspoon/init.lua<cr>

" Split into two lines
" nnoremap K i<CR><ESC>
nnoremap <leader><cr> i<CR><ESC>

" Make Y consistent with C and D, until EOL
nnoremap Y y$

" Visual select previously pasted text
nnoremap gp `[v`]

" View output from running in terminal
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

set spelllang=en
set spellsuggest=best,9

set splitright " open splits on the right
set splitbelow " open splits on the bottom
]])

-- Usability Notes
-- Buffers/Splits/Windows
--  - move window: `<c-w>HJKL`
--  - move buffer to split where # is the buffer id, :buffers: :vert sb#
-- Find and replace
--  - when in a visual block, omit the `%`: <'>'/s
-- Motions
--  - % - jump to matching bracket
--  - {} - jump to empty lines
-- Files
--  - do :e to reload a file from external changes
-- commands
--  - set showmatch? <- add ? to check its setting
--  Telescope
--  - open [help] in new tab -> <c-t>
