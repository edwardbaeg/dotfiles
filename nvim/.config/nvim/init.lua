--[[ NEOVIM CONFIG ROOT ]]--

require("config.lazy")
require("config.keymaps")
require("config.settings")
require("lazy").setup("plugins", {
   -- automatically change for config file changes and reload ui
   change_detection = {
      enabled = true,
      notify = true, -- show notification when changes are found
   },
   -- check for plugin updates and notify on launch
   checker = { enabled = true },
})
require("config.post-plugins")

--[[ TODO
- rewrite all vimscript stuff to lua
- determine a way to open *.stories or *.test for the given file
- move legacy/inactive settings to a separate file that is not loaded?
]]
--

--[[ Usability Notes
- Buffers/Splits/Windows
 - move window: `<c-w>HJKL`
 - move buffer to split where # is the buffer id, :buffers: :vert sb#
 - open in split with <c-v/x>

- Find and replace
 - when in a visual block, omit the `%`: <'>'/s

- Files
 - do :e to reload a file from external changes

- Commands
 - :set showmatch? - add ? to check its setting

- Telescope - open [help] in new tab -> <c-t>
 - :options - interactive view and set all options

- Formatting
 - use `gq` operator to edit text to fit within the textwidth

- :TSPlaygroundToggle replaced with :Inspect
- gv -> select last visual selection
- :enew to open an empty buffer
- after :recover a swapfile, do :e to delete the older one
- :vert[ical] e[dit]
- instead of using `dd` for an empty line, use `J`
- ...and to add an empty line: `<cr>`
- indent in insert mode with `<c-t>/<c-d>`
- use <c-t> instead of <c-o>, tagstack
- :copen to open the quickfix window
- :e to read external changes to a file
]]
--

--[[ KEYMAP GUIDE
- Don't add to operator pending for y, d
-  - and maybe c?
- catchalls: g,
- <leader>f: fuzzy/telescope
- <leader>s: sessions
- <leader>t: tab or toggle
]]
--
