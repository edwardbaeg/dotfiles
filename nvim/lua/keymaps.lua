-- [[ Keymaps ]]
vim.keymap.set("i", "jk", "<Esc>") -- leave insert mode
vim.keymap.set("i", "<c-c>", "<Esc>") -- make <c-c> trigger InsertLeave

vim.keymap.set("n", "_", '"_') -- empty register shortcut
vim.keymap.set("n", "H", "^") -- go to start of line
vim.keymap.set("n", "L", "$") -- go to start of line
vim.keymap.set("n", "Y", "y$") -- yank to end of line (like C or D)
vim.keymap.set("n", "gp", "`[v`]") -- visually select previouly selected text
-- vim.keymap.set("n", "p", "p`[v`]=") -- indent after pasting -- this breaks yanky
vim.keymap.set("n", "<c-f>", "za") -- toggle folds
vim.keymap.set("n", "<bs>", [[ciw]], { noremap = true }) -- ciw
vim.keymap.set("n", "<cr>", "o<esc>0D") -- add empty line below

-- various leader keymaps
vim.keymap.set("n", "<leader>ex", ":ex .<cr>", { desc = "open netrw in directory :ex ." }) -- open netrw
vim.keymap.set("n", "<leader>q", "") -- close whichkey / cancel leader without starting macro
vim.keymap.set("n", "<leader><space>", ":nohlsearch<Bar>:echo<cr>", { desc = "clear searches" })
vim.keymap.set("n", "<leader>yy", "ggyG''") -- yank whole file
vim.keymap.set("n", "<leader>o", "i<cr><esc>") -- split line
vim.keymap.set("n", "<leader>n", "<cmd>bnext<cr>") -- next buffer
vim.keymap.set("n", "<leader>p", "<cmd>bprevious<cr>") -- previous buffer
vim.keymap.set("n", "<leader>+", "<c-a>") -- increment and decrement
vim.keymap.set("n", "<leader>-", "<c-x>")
vim.keymap.set("n", "<leader>es", ":EslintFixAll<cr>")
vim.keymap.set("n", "<leader>ew", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>eq", "<cmd>q<cr>")
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>")
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<cr>")

-- macros
vim.keymap.set("n", "Q", "q") -- use Q to start/stop recording a macro
vim.keymap.set("n", "q", "<nop>") -- disable q for macros as it interferes with completions

-- Remaps for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
-- vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', 'ge', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Edit configuration files
vim.keymap.set("n", "<leader>ev", ":edit $MYVIMRC<cr> :cd %:h<cr>")
vim.keymap.set("n", "<leader>et", ":edit ~/.tmux.conf<cr>")
vim.keymap.set("n", "<leader>ez", ":edit ~/.zshrc<cr>")
vim.keymap.set("n", "<leader>eh", ":edit ~/.hammerspoon/init.lua<cr>")

-- emacs style buffer movement
vim.keymap.set("n", "<leader>bn", ":bn<cr>")
vim.keymap.set("n", "<leader>bp", ":bp<cr>")
vim.keymap.set("n", "<leader>bd", ":bd<cr>")

-- emacs style window movement
vim.keymap.set("n", "<leader>wj", "<cmd>wincmd j<cr>")
vim.keymap.set("n", "<leader>wk", "<cmd>wincmd k<cr>")
vim.keymap.set("n", "<leader>wh", "<cmd>wincmd h<cr>")
vim.keymap.set("n", "<leader>wl", "<cmd>wincmd l<cr>")

-- Move to window using the arrow keys
vim.keymap.set("n", "<left>", "<C-w>h")
vim.keymap.set("n", "<down>", "<C-w>j")
vim.keymap.set("n", "<up>", "<C-w>k")
vim.keymap.set("n", "<right>", "<C-w>l")

-- Use builtin go to definition/tag
vim.keymap.set("n", "gD", "<C-]>")

-- yank and then paste
vim.keymap.set("n", "yp", "yyp")
-- vim.keymap.set("n", "yp", "yypkgccj") -- NOTE: this doesn't work, comment the previous one
-- vim.keymap.set("n", "yp", "yypp")

-- Don't copy empty lines to the register
vim.keymap.set("n", "dd", function()
   if vim.fn.getline(".") == "" then
      return '"_dd'
   end
   return "dd"
end, { expr = true })

-- Searching
-- center after search "don't really need this with scrolloffset
-- vim.keymap.set("n", "n", "nzz")
-- vim.keymap.set("n", "N", "Nzz")
-- vim.keymap.set("n", "*", "*zz")
-- vim.keymap.set("n", "#", "#zz")
-- vim.keymap.set("n", "g*", "g*zz")
-- vim.keymap.set("n", "g#", "g#zz")

-- Abbreviations
-- TODO: in a future release, this can be refactored to: vim.keymap.set('ca', 'foo', 'bar')
vim.cmd([[
ab functino function
ab fn function
]])

-- work
vim.keymap.set("n", "<leader>mo", "Hfs/xwct/localhost:5173<esc>") -- convert link to localhost
