-- [[ NVIM CONFIG ROOT ]]

require("lazysetup")
require("lazy").setup("plugins", {
   change_detection = {
      enabled = false,
   },
})
require("mappings")
require("settings")

-- [[ TODO ]]
-- rewrite all vimscript stuff to lua
-- fix showing git stuff (lua line and vim fugitive) for lua line (but it works for gitsigns?)
-- determine a way to open *.stories or *.test for the given file
-- update virtual text priority -> codeium > eslint, or move eslint to the right side of the window?

-- [[ Usability Notes ]]
-- Buffers/Splits/Windows
--  - move window: `<c-w>HJKL`
--  - move buffer to split where # is the buffer id, :buffers: :vert sb#
--  - open in split with <c-v/x>
-- Find and replace
--  - when in a visual block, omit the `%`: <'>'/s
-- Files
--  - do :e to reload a file from external changes
-- commands
--  - :set showmatch? - add ? to check its setting
--  Telescope - open [help] in new tab -> <c-t>
--  - :options - interactive view and set all options
-- :TSPlaygroundToggle replaced with :Inspect
-- gv -> select last visual selection
-- :enew to open an empty buffer
-- after :recover a swapfile, do :e to delete the older one
-- :vert[ical] e[dit]
-- instead of using `dd` for an empty line, use `J`
-- ...and to add an empty line: `<cr>`
-- indent in insert mode with `<c-t>/<c-d>`
-- use <c-t> instead of <c-o>, tagstack
-- :copen to open the quickfix window

-- [[ KEYMAP GUIDE ]]
-- Don't add to operator pending for y, d
--  - and maybe c?
-- catchalls: g,
-- <leader>f: fuzzy/telescope
-- <leader>s: sessions
-- <leader>t: tab or toggle
