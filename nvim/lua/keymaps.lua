-- [[ Keymaps ]]

-- escaping
vim.keymap.set("i", "jk", "<Esc>") -- leave insert mode
vim.keymap.set("i", "<c-c>", "<Esc>") -- make <c-c> trigger InsertLeave

vim.keymap.set("n", "_", '"_') -- empty register shortcut
vim.keymap.set("n", "H", "^") -- go to start of line
vim.keymap.set("n", "L", "$") -- go to start of line
vim.keymap.set("n", "Y", "y$") -- yank to end of line (like C or D)
vim.keymap.set("n", "gp", "`[v`]") -- visually select previouly selected text
-- vim.keymap.set("n", "p", "p`[v`]=") -- indent after pasting -- this breaks yanky
-- vim.keymap.set("n", "<c-f>", "za") -- toggle folds
-- vim.keymap.set("n", "<bs>", [[ciw]], { noremap = true }) -- ciw -- this is unused
-- vim.keymap.set("n", "<cr>", "o<esc>0D") -- add empty line below -- this keymap breaks various things, eg mini-files
vim.keymap.set("n", "<leader><cr>", "o<esc>0D") -- add empty line below
vim.keymap.set("n", "gjk", "gcc", { desc = "comment line", remap = true }) -- comment line
-- vim.keymap.set("n", "<leader>j", function() -- show inlay lsp hints
--    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
-- end)

-- TODO: Disable s command
vim.keymap.set('n', 's', '<nop>', { noremap = true, silent = true }) -- kinda works, but blocks other keymaps if not pressed quickly enough
-- vim.keymap.del("n", "s") -- disable s -- doesn't work
-- vim.cmd([[unmap s]]) -- doesn't work

-- various leader keymaps
vim.keymap.set("n", "<leader>ex", ":ex .<cr>", { desc = "open netrw in directory :ex ." }) -- open netrw
vim.keymap.set("n", "<leader>q", "") -- close whichkey / cancel leader without starting macro
vim.keymap.set("n", "<leader><space>", ":nohlsearch<Bar>:echo<cr>", { desc = "clear search highlights" })
vim.keymap.set("n", "<esc>", ":nohlsearch<Bar>:echo<cr>", { desc = "clear search highlights" })
vim.keymap.set("n", "<leader>yy", ":%yank<cr>") -- yank whole file
-- vim.keymap.set("n", "<leader>o", "i<cr><esc>") -- split line
vim.keymap.set("n", "<m-o>", "i<cr><esc>") -- split line
-- TODO: consider making these require double press; <leader>nn and <leader>pp
vim.keymap.set("n", "<leader>nn", "<cmd>bnext<cr>") -- next buffer
vim.keymap.set("n", "<leader>pp", "<cmd>bprevious<cr>") -- previous buffer
vim.keymap.set("n", "<leader>+", "<c-a>", { desc = "increment" }) -- increment
vim.keymap.set("n", "<leader>-", "<c-x>", { desc = "decrement" }) -- decrement
-- TODO: make this do :EslintFixAll in js/ts and :Format in others
vim.keymap.set("n", "<leader>es", ":EslintFixAll<cr>")
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>") -- next tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<cr>") -- previous tab
vim.keymap.set("n", "<leader>ew", "<cmd>w<cr>", { desc = "[w]rite changes" }) -- save
vim.keymap.set("n", "<leader>eq", "<cmd>q<cr>", { desc = "[q]uit" }) -- quit
vim.keymap.set("n", "<leader>qa", "<cmd>qa<cr>", { desc = "[q]uit [a]ll" }) -- quit
vim.keymap.set("n", "<leader>vs", ":vs<cr>", { desc = "[vs]plit" }) -- vertical split
vim.keymap.set("n", "<leader>gi", ":Inspect<cr>") -- inspect treesitter nodes, helps with highlighting
vim.keymap.set("n", "<leader>tq", ":cclose<cr>", { desc = "close [q]uickfix window" }) -- close quickfix window
vim.keymap.set("n", "<cr>", "G", { desc = "jump to line number" })

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
vim.keymap.set("n", "<leader>ev", ":edit $MYVIMRC<cr> :cd %:h<cr>", { desc = "edit [v]imrc" }) -- also set as working directory
vim.keymap.set("n", "<leader>et", ":edit ~/.tmux.conf<cr>", { desc = "edit [t]mux.conf" })
vim.keymap.set("n", "<leader>ez", ":edit ~/.zshrc<cr>", { desc = "edit [z]shrc" })
vim.keymap.set("n", "<leader>eh", ":edit ~/.hammerspoon/init.lua<cr>", { desc = "edit [h]ammerspoon" })

-- emacs style buffer movement
vim.keymap.set("n", "<leader>bn", ":bn<cr>")
vim.keymap.set("n", "<leader>bp", ":bp<cr>")
vim.keymap.set("n", "<leader>bd", ":bd<cr>")

-- emacs style window movement
vim.keymap.set("n", "<leader>w", "<c-w>")
-- vim.keymap.set("n", "<leader>wj", "<cmd>wincmd j<cr>")
-- vim.keymap.set("n", "<leader>wk", "<cmd>wincmd k<cr>")
-- vim.keymap.set("n", "<leader>wh", "<cmd>wincmd h<cr>")
-- vim.keymap.set("n", "<leader>wl", "<cmd>wincmd l<cr>")

-- Move to window using the arrow keys
-- replaced with vim-tmux-navigator
-- vim.keymap.set("n", "<left>", "<C-w>h")
-- vim.keymap.set("n", "<down>", "<C-w>j")
-- vim.keymap.set("n", "<up>", "<C-w>k")
-- vim.keymap.set("n", "<right>", "<C-w>l")

-- Use builtin go to definition/tag
vim.keymap.set("n", "gD", "<C-]>") -- using this allows for <c-t> to return. Also works in helpfiles
-- open goto definition in vertical split
vim.keymap.set("n", "g>", "<cmd>vs<cr><c-]>", { desc = "Goto definition in vertical split" })
vim.keymap.set("n", "<leader>v>", "<cmd>vs<cr><c-]>", { desc = "[V]ertical split Goto Definition" })

-- yank and then paste
-- vim.keymap.set("n", "yp", "yyp") -- replaced with mini.operators `gmm`
-- vim.keymap.set("n", "yp", "yypkgccj") -- NOTE: this doesn't work, comment the previous one
-- vim.keymap.set("n", "yp", "yypp")

-- type console.log with yanked text
vim.api.nvim_set_keymap("n", "<leader>cl", 'oconsole.log({ <C-r>" });<Esc>', { noremap = true, silent = true })

-- Don't copy empty lines to the register
vim.keymap.set("n", "dd", function()
   if vim.fn.getline(".") == "" then
      return '"_dd'
   end
   return "dd"
end, { expr = true })

-- FIXME
vim.keymap.set('n', '<c-m>', function ()
   print"here"
  vim.api.nvim_win_set_cursor(0, {vim.api.nvim_win_get_cursor(0)[1] + vim.api.nvim_win_get_height(0) / 4, 0})
end, {noremap = true, silent = true})

-- Searching
-- center after search "don't really need this with scrolloffset
-- vim.keymap.set("n", "n", "nzz")
-- vim.keymap.set("n", "N", "Nzz")
-- vim.keymap.set("n", "*", "*zz")
-- vim.keymap.set("n", "#", "#zz")
-- vim.keymap.set("n", "g*", "g*zz")
-- vim.keymap.set("n", "g#", "g#zz")

-- Abbreviations
-- TODO: refactor to lua first class api when available
vim.cmd([[
   ab functino function
   ab fn function
   ab exfn export function
]])

-- work
-- vim.keymap.set("n", "<leader>mo", "Hfs/xwct/localhost:5173<esc>") -- convert link to localhost
