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
