-- [[ NVIM CONFIG ROOT ]]

require("lazysetup")
require("lazy").setup("plugins", { change_detection = { enabled = false } })
require("keymaps")
require("settings")

-- [[ TODO ]]
-- rewrite all vimscript stuff to lua
-- fix showing git stuff (lua line and vim fugitive) for lua line (but it works for gitsigns?)
-- upgrade from ts-server to https://github.com/pmizio/typescript-tools.nvim ; this is supposed to be much faster
-- determine a way to open *.stories or *.test for the given file

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
--  - set showmatch? <- add ? to check its setting
--  Telescope
--  - open [help] in new tab -> <c-t>
-- :options
