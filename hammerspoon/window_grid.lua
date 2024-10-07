-- Windows grids ---------------------------------------------------------
--------------------------------------------------------------------------
local mod = require("modifiers")

hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.GRIDWIDTH = 6
hs.grid.GRIDHEIGHT = 4

-- show interactive modal interface for resizing
hs.hotkey.bind(mod.hyperkey, "G", function()
   hs.grid.show()
end)

