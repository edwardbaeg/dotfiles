-- [[ Keymaps ]]

-- TODO: break up into modules or something with more structure
-- also consider better organization for legibility

local M = {}

local set = function(mode, lhs, rhs, opts)
   opts = vim.tbl_extend("force", { silent = true }, opts or {})
   vim.keymap.set(mode, lhs, rhs, opts)
end
M.set = set

-- Escaping
set("i", "jk", "<Esc>") -- leave insert mode
set("i", "<c-c>", "<Esc>") -- make <c-c> trigger InsertLeave

-- Experimental; move these after settled
-- set("n", ":", ";") -- no shift for command line
-- set("n", ";", ":")

-- Cursor movement
set({ "n", "v" }, "H", "^") -- move cursor to start of line
set({ "n", "v" }, "L", "$") -- move cursor to end of line
set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true }) -- deal with wordwrap
set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Buffers
-- set("n", "<leader>bn", ":bnext<cr>") -- emacs style -- replaced with bufferline to follow visual order
-- set("n", "<leader>bp", ":bprevious<cr>")
-- set("n", "<tab>", "<cmd>bnext<cr>") -- navigate buffers with tab
-- set("n", "<s-tab>", "<cmd>bprevious<cr>")
set("n", "<leader>bf", ":Format<cr>", { desc = "[f]ormat buffer" }) -- format the buffer
set("n", "<leader>bd", ":bd<cr>")

-- TODO: refactor this to abstract functionality and add a force quit.
local function confirm_and_execute()
   local confirm = vim.fn.input("Are you sure you want to FORCE close the buffer? (y/n): ")
   if confirm == "y" or confirm == "Y" then
      vim.cmd("bd!")
   else
      print("Buffer close canceled.")
   end
end

set("n", "<leader>bD", confirm_and_execute)

-- Yank and paste
set("n", "Y", "y$") -- yank to end of line (like C or D)
set("n", "gp", "`[v`]") -- visually select previouly selected text
set("n", "p", "p`[v`]=") -- indent after pasting
set("n", "<leader>yy", ":%yank<cr>") -- yank whole file

-- Deletion
set("n", "_", '"_') -- empty register shortcut
-- don't copy empty lines to the register
set("n", "dd", function()
   if vim.fn.getline(".") == "" then
      return '"_dd'
   end
   return "dd"
end, { expr = true })

-- Quick insertion
set("n", "<leader>o", "o<esc>0D") -- add empty line below
set("n", "<m-o>", "i<cr><esc>") -- split line
-- set("n", "<leader>cl", 'oconsole.log({ <C-r>" });<Esc>', { noremap = true }) -- console.log with yanked text
set("n", "<leader>cl", 'yiwoconsole.log({ <C-r>" });<Esc>', { noremap = true }) -- console.log with yanked text

-- Tabs
set("n", "<leader>tn", "<cmd>tabnext<cr>") -- next tab
set("n", "<leader>tp", "<cmd>tabprevious<cr>") -- previous tab

-- Commands
set("n", "<leader>ew", "<cmd>w<cr>", { desc = "[w]rite changes" }) -- save
set("n", "<leader>eq", "<cmd>q<cr>", { desc = "[q]uit" }) -- quit
set("n", "<leader>qa", "<cmd>qa<cr>", { desc = "[q]uit [a]ll" }) -- quit
set("n", "<leader>+", "<c-a>", { desc = "increment" }) -- increment
set("n", "<leader>-", "<c-x>", { desc = "decrement" }) -- decrement

-- LSP
-- set("n", "<leader>j", function() -- show inlay lsp hints
--    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
-- end)

-- Misc
set("n", "<leader>q", "") -- close whichkey / cancel leader without starting macro
set("n", "<leader><space>", ":nohlsearch<Bar>:echo<cr>", { desc = "clear search highlights" })
-- set("n", "<esc>", ":nohlsearch<Bar>:echo<cr><esc>", { desc = "clear search highlights" })
-- vim.keymap.set("n", "<leader>o", "i<cr><esc>") -- new blank line
-- Disable the default s substitute command. This can have issues with keymaps that start with s, such as sx
set("n", "s", "<nop>", { noremap = true }) -- kinda works, but blocks other keymaps if not pressed quickly enough
-- vim.keymap.del("n", "s") -- disable s -- doesn't work
-- vim.cmd([[unmap s]]) -- doesn't work

-- Macros
set("n", "Q", "q") -- use Q to start/stop recording a macro
set("n", "q", "<nop>") -- disable q for macros as it interferes with completions

-- Diagnostic keymaps -- replaced with lspsaga
-- set('n', 'gE', vim.diagnostic.goto_prev)
-- set('n', 'ge', vim.diagnostic.goto_next)
-- set('n', '<leader>e', vim.diagnostic.open_float)
-- set('n', '<leader>q', vim.diagnostic.setloclist)

-- Edit configuration files
-- TODO: consider opening the file in the dotfiles dir? to try to fix session storage stuffs
set("n", "<leader>ev", ":edit $MYVIMRC<cr> :cd ~/dev/dotfiles/nvim/.config/nvim<cr>", { desc = "[e]dit [v]imrc" }) -- also set as working directory
set("n", "<leader>et", ":edit ~/.tmux.conf<cr>", { desc = "[e]dit [t]mux.conf" })
set("n", "<leader>ez", ":edit ~/.zshrc<cr>", { desc = "[e]dit [z]shrc" })
set("n", "<leader>eh", ":edit ~/.hammerspoon/init.lua<cr>", { desc = "[e]dit [h]ammerspoon" })
set("n", "<leader>ek", ":edit ~/.config/kitty/kitty.conf<cr>", { desc = "[e]dit [k]itty.conf" })
set("n", "<leader>eo", ":edit ~/Sync/Obsidian Vault/<cr>", { desc = "[e]dit [o]bsidian" })

-- Windows
set("n", "<leader>w", "<c-w>")
-- set("n", "<leader>wj", "<cmd>wincmd j<cr>") -- emacs style
-- set("n", "<leader>wk", "<cmd>wincmd k<cr>")
-- set("n", "<leader>wh", "<cmd>wincmd h<cr>")
-- set("n", "<leader>wl", "<cmd>wincmd l<cr>")

-- Go to definition/tag
set("n", "gD", "<C-]>") -- using this allows for <c-t> to return. Also works in helpfiles

-- Vertical splits
set("n", "<leader>vs", ":vsplit<cr>", { desc = "[vs]plit" })
set("n", "<leader>ve", ":vsplit edit<cr>", { desc = "[v]split [e]dit" })
set("n", "g>>", "<cmd>vs<cr><c-]>", { desc = "Goto [d]efinition in vertical split" })
set("n", "g>d", "<cmd>vs<cr><c-]>", { desc = "Goto [d]efinition in vertical split" })
set("n", "g>f", "<cmd>vs<cr>gf", { desc = "Goto [f]ile in vertical split" })
set("n", "g>h", function ()
  local cword = vim.fn.expand("<cword>")
  vim.cmd("vert help " .. cword)
end, { desc = "Goto [h]elpfile in vertical split" })
-- set("n", "<leader>v>", "<cmd>vs<cr><c-]>", { desc = "[V]ertical split Goto Definition" })

-- Abbreviations
-- TODO: refactor to lua first class api when available
vim.cmd([[
   ab functino function
   ab exfn export function
]])

-- Smart enter key that tries gx (open URL) or gf (open file)
-- ~/Downloads
-- https://example.com
-- local function smart_enter()
--    -- vim.cmd("normal gx")
--    -- TODO: check if the vim.ui.open/gx worked first. this command opens the html file for urls
--    vim.cmd("normal! gf")
--
--    -- this doesn't include the mapping for open in git
--    -- local cmd, err = vim.ui.open(vim.fn.expand("<cfile>"))
--    -- if cmd then
--    --    cmd:wait()
--    -- else
--    --    print('fail?')
--    -- end
-- end

-- set("n", "<CR>", smart_enter, { desc = "Smart Enter: try gx (URL) or gf (file)" })

set("n", "<CR>", "gf", { silent = true })

return M
