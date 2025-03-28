--[[ NEOVIM CONFIG ROOT ]]

require("config.lazy")
require("config.keymaps")
require("config.settings")
require("config.autocommands")

require("lazy").setup("plugins", {
   -- automatically change for config file changes and reload ui
   change_detection = {
      enabled = true,
      notify = true, -- show notification when changes are found
   },
   -- check for plugin updates and notify on launch
   checker = { enabled = false },
})
require("config.post-plugins")

--[[ TODO

- rewrite all vimscript stuff to lua
- determine a way to open *.stories or *.test for the given file
- move legacy/inactive settings to a separate file that is not loaded?
]]

--[[ Usability Notes

- Buffers/Splits/Windows/Tabs
   - move window -> `<c-w>HJKL`
   - move buffer to split where # is the buffer id -> :buffers :vert sb#
   - open in split with <c-v/x>
   - open given buffer in a new tab (to "maximize it temporarilty") -> :tab split
   - :enew to open an empty buffer
      - empty buffer in split -> :vert[ical] e[dit] -- doesn't work?
- Find and replace
   - when in a visual block, omit the `%`: <'>'/s
   - to skip typing the text to replace, use * and then start search and skip the argument
      - example: :s//foo
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
- Quickfix
   - use `:copen` to open the quickfix window
- Builtin commands
   - :TSPlaygroundToggle replaced with :Inspect
   - <c-t> to use tag stack to jump
]]

--[[ KEYMAP GUIDE

- Don't add to operator pending for y, d
-  - and maybe c?
- catchalls: g,
- <leader>f: fuzzy/telescope
- <leader>s: sessions
- <leader>t: tab or toggle
]]
