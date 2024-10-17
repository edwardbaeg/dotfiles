-- [[ Keymaps ]]

-- TODO: break up into modules or something with more structure

local set = vim.keymap.set

-- escaping
set("i", "jk", "<Esc>") -- leave insert mode
set("i", "<c-c>", "<Esc>") -- make <c-c> trigger InsertLeave

set("n", "_", '"_') -- empty register shortcut
set({"n", "v"}, "H", "^") -- move cursor to start of line
set({"n", "v"}, "L", "$") -- move cursor to end of line
set("n", "Y", "y$") -- yank to end of line (like C or D)
set("n", "gp", "`[v`]") -- visually select previouly selected text
-- set("n", "p", "p`[v`]=") -- indent after pasting -- this breaks yanky
-- set("n", "<c-f>", "za") -- toggle folds
-- set("n", "<bs>", [[ciw]], { noremap = true }) -- ciw -- this is unused
-- set("n", "<cr>", "o<esc>0D") -- add empty line below -- this keymap breaks various things, eg mini-files
set("n", "<leader><cr>", "o<esc>0D") -- add empty line below
set("n", "gjk", "gcc", { desc = "comment line", remap = true }) -- comment line
-- set("n", "<leader>j", function() -- show inlay lsp hints
--    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
-- end)
set("n", "<cr>", "G", { desc = "jump to line number" })
-- set("n", "]]", "<cmd>call search('[([{<]')<cr>", { desc = "jump to next [{(]" })
set("n", "]]", "<cmd>call search('^[{]')<cr>", { desc = "jump to next {" })
set("n", "[[", "<cmd>call search('^[}]', 'b')<cr>", { desc = "jump to previous }" })

-- TODO: disable the default s substitute command. This can have issues with keymaps that start with s, such as sx
set('n', 's', '<nop>', { noremap = true, silent = true }) -- kinda works, but blocks other keymaps if not pressed quickly enough
-- vim.keymap.del("n", "s") -- disable s -- doesn't work
-- vim.cmd([[unmap s]]) -- doesn't work

-- various leader keymaps
set("n", "<leader>ex", ":ex .<cr>", { desc = "open netrw in directory :ex ." }) -- open netrw
set("n", "<leader>q", "") -- close whichkey / cancel leader without starting macro
set("n", "<leader><space>", ":nohlsearch<Bar>:echo<cr>", { desc = "clear search highlights" })
-- set("n", "<esc>", ":nohlsearch<Bar>:echo<cr><esc>", { desc = "clear search highlights" })
set("n", "<leader>yy", ":%yank<cr>") -- yank whole file
-- set("n", "<leader>o", "i<cr><esc>") -- split line
set("n", "<m-o>", "i<cr><esc>") -- split line
-- TODO: consider making these require double press; <leader>nn and <leader>pp
set("n", "<leader>nn", "<cmd>bnext<cr>") -- next buffer
set("n", "<leader>pp", "<cmd>bprevious<cr>") -- previous buffer
set("n", "<leader>+", "<c-a>", { desc = "increment" }) -- increment
set("n", "<leader>-", "<c-x>", { desc = "decrement" }) -- decrement
-- TODO: make this do :EslintFixAll in js/ts and :Format in others
set("n", "<leader>es", ":EslintFixAll<cr>")
set("n", "<leader>tn", "<cmd>tabnext<cr>") -- next tab
set("n", "<leader>tp", "<cmd>tabprevious<cr>") -- previous tab
set("n", "<leader>ew", "<cmd>w<cr>", { desc = "[w]rite changes" }) -- save
set("n", "<leader>eq", "<cmd>q<cr>", { desc = "[q]uit" }) -- quit
set("n", "<leader>qa", "<cmd>qa<cr>", { desc = "[q]uit [a]ll" }) -- quit
set("n", "<leader>vs", ":vs<cr>", { desc = "[vs]plit" }) -- vertical split
set("n", "<leader>gi", ":Inspect<cr>") -- inspect treesitter nodes, helps with highlighting
set("n", "<leader>tq", ":cclose<cr>", { desc = "close [q]uickfix window" }) -- close quickfix window

-- macros
set("n", "Q", "q") -- use Q to start/stop recording a macro
set("n", "q", "<nop>") -- disable q for macros as it interferes with completions

-- Remaps for dealing with word wrap
set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
-- set('n', 'gE', vim.diagnostic.goto_prev)
-- set('n', 'ge', vim.diagnostic.goto_next)
-- set('n', '<leader>e', vim.diagnostic.open_float)
-- set('n', '<leader>q', vim.diagnostic.setloclist)

-- Edit configuration files
set("n", "<leader>ev", ":edit $MYVIMRC<cr> :cd %:h<cr>", { desc = "edit [v]imrc" }) -- also set as working directory
set("n", "<leader>et", ":edit ~/.tmux.conf<cr>", { desc = "edit [t]mux.conf" })
set("n", "<leader>ez", ":edit ~/.zshrc<cr>", { desc = "edit [z]shrc" })
set("n", "<leader>eh", ":edit ~/.hammerspoon/init.lua<cr>", { desc = "edit [h]ammerspoon" })

-- Buffers
-- emacs style buffer movement
set("n", "<leader>bn", ":bn<cr>")
set("n", "<leader>bp", ":bp<cr>")
set("n", "<leader>bd", ":bd<cr>")

set("n", "<leader>bf", ":Format<cr>", { desc = "[f]ormat buffer" }) -- format the buffer

-- emacs style window movement
set("n", "<leader>w", "<c-w>")
-- set("n", "<leader>wj", "<cmd>wincmd j<cr>")
-- set("n", "<leader>wk", "<cmd>wincmd k<cr>")
-- set("n", "<leader>wh", "<cmd>wincmd h<cr>")
-- set("n", "<leader>wl", "<cmd>wincmd l<cr>")

-- Move to window using the arrow keys
-- replaced with vim-tmux-navigator
-- set("n", "<left>", "<C-w>h")
-- set("n", "<down>", "<C-w>j")
-- set("n", "<up>", "<C-w>k")
-- set("n", "<right>", "<C-w>l")

-- Use builtin go to definition/tag
set("n", "gD", "<C-]>") -- using this allows for <c-t> to return. Also works in helpfiles
-- open goto definition in vertical split
set("n", "g>d", "<cmd>vs<cr><c-]>", { desc = "Goto [d]efinition in vertical split" })
set("n", "g>f", "<cmd>vs<cr>gf", { desc = "Goto [f]ile in vertical split" })
set("n", "<leader>v>", "<cmd>vs<cr><c-]>", { desc = "[V]ertical split Goto Definition" })

-- yank and then paste
-- set("n", "yp", "yyp") -- replaced with mini.operators `gmm`
-- set("n", "yp", "yypkgccj") -- NOTE: this doesn't work, comment the previous one
-- set("n", "yp", "yypp")

-- type console.log with yanked text
vim.api.nvim_set_keymap("n", "<leader>cl", 'oconsole.log({ <C-r>" });<Esc>', { noremap = true, silent = true })

-- Don't copy empty lines to the register
set("n", "dd", function()
   if vim.fn.getline(".") == "" then
      return '"_dd'
   end
   return "dd"
end, { expr = true })


-- Abbreviations
-- TODO: refactor to lua first class api when available
vim.cmd([[
   ab functino function
   ab fn function
   ab exfn export function
]])
