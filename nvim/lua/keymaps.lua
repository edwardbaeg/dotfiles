-- [[ Keymaps ]]
vim.keymap.set("i", "jk", "<Esc>") -- leave insert mode
vim.keymap.set("n", "_", '"_') -- empty register shortcut
vim.keymap.set("n", "H", "^") -- go to start of line
vim.keymap.set("n", "L", "$") -- go to start of line
vim.keymap.set("n", "Y", "y$") -- yank to end of line (like C or D)
vim.keymap.set("n", "gp", "`[v`]") -- visually select previouly selected text
-- vim.keymap.set("n", "p", "p`[v`]=") -- indent after pasting -- this breaks yanky
vim.keymap.set("n", "<c-f>", "za") -- toggle folds

-- leader keymaps
vim.keymap.set("n", "<leader>+", "<c-a>") -- increment and decrement
vim.keymap.set("n", "<leader>-", "<c-x>")
vim.keymap.set("n", "<leader>ex", ":ex .<cr>", { desc = "open netrw in directory :ex ." }) -- open netrw
vim.keymap.set("n", "<leader>q", "") -- close whichkey / cancel leader without starting macro
vim.keymap.set("n", "<leader><space>", ":nohlsearch<Bar>:echo<cr>", { desc = "clear searches" })
vim.keymap.set("n", "<leader>yy", "ggyG''") -- yank whole file
vim.keymap.set("n", "<leader>o", "i<cr><esc>") -- split line

-- Remaps for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
-- vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', 'ge', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Edit configuration files
vim.keymap.set("n", "<leader>ev", ":edit $MYVIMRC<cr>")
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

-- Abbreviations
-- TODO: in a future release, this can be refactored to: vim.keymap.set('ca', 'foo', 'bar')
vim.cmd([[ab functino function]])