--[[ NEOVIM CONFIG ROOT --]]

require("config.lazy") -- bootstrap lazy
require("config.keymaps")
require("config.autocommands")

if not vim.g.disable_plugins then
   -- load plugins
   require("lazy").setup("plugins", {
      -- automatically watch for config file changes and reload ui
      change_detection = {
         enabled = true,
         notify = true, -- show notification when changes are found
      },
      -- check for plugin updates and notify on launch
      checker = { enabled = false },
   })
end

-- load settings after plugins
require("config.settings")

--[[ TODO
-- PLUGINS:
- an extenion for bufferline to reorder the list of buffers?
- add a custom % motion (endwise?) thing for START and END comments
- determine a way to open *.stories or *.test for the given file - maybe a plugin? or extension of snacks.picker?

-- OTHER:
- use exported `set` keymap function from config.keymaps
- rewrite all vimscript stuff to lua
- move legacy/inactive settings to a separate file that is not loaded?

- how to open link (gx) with netrw disabled: https://www.reddit.com/r/neovim/comments/ro6oye/comment/hpwkvae/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

]]

--[[ Usability Notes

- Buffers/Splits/Windows/Tabs
   - move window -> `<c-w>HJKL`
   - move buffer to split where # is the buffer id -> :buffers :vert sb#
   - open in split with <c-v/x>
   - open given buffer in a new tab (to "maximize it temporarilty") -> :tab split or <c-w>T (maybe remap this to <c-w>t)
   - :enew to open an empty buffer
      - vnew to open an empty buffer in a vertical split
   - move between tabs -> gt and gT
- Search and replace
   - %s/foo/bar/ to search whole file, at gc to confirm each
   - when in a visual block, omit the `%`: <'>'/s
   - to skip typing the text to replace, use * and then start search and skip the argument
      - example: :s//foo
   - to do quick search and replace, do `cgn` (change, go to next) to make it . (dot) repeatable
- Files
   - do :e to reload a file from external changes
- Settings
   - :set showmatch? - add ? to check its setting
   - :options - interactive view and set all options
- Formatting
   - use `gq` operator to edit text to fit within the textwidth
- Selecting
   - gv to select last visual selection
- Swapfiles
   - after :recover a swapfile, do :e to delete the older one
- Editing
   - instead of using `dd` for an empty line, use `J`
   - indent in insert mode with `<c-t>/<c-d>`
   - <c-o> to type a single command in normal mode and then return to insert mode
   - <c-r> access the register
     - <c-w> after to access cword
- Quickfix/Location Lists
   - quickfix is global, location list is per buffer
   - use `:copen` to open the quickfix window; `:lopen` for location list
- Builtin commands
   - :TSPlaygroundToggle replaced with :Inspect
   - <c-t> to use tag stack to jump
- Cmdline
   - :h filename-modifiers
   - :%:h -> parent directory
   - :%:p -> full path
   - :%:t -> filename

- Bug with TMUX
  - tmux cannot distinguish between <c-i> and <tab>
    - see :help CTRL-I
    - https://github.com/tmux/tmux/issues/2705
]]

--[[ KEYMAP GUIDE
--TODO: audit keymaps for g vs <leader>g
--TODO: use consistent style for keymap desc. Potentially: sentence case
--TODO: use a helper that defaults opts

- Don't add to operator pending for y, d
-  - and maybe c?
- catchalls: g,
- <leader>f: fuzzy/telescope
- <leader>s: sessions
- <leader>t: tab or toggle
]]
