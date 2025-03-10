-- Windows grids ---------------------------------------------------------
--------------------------------------------------------------------------
local constants = require("common/constants")

-- TODO: replace with hs.grid.setMargins
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

-- show interactive modal interface for resizing
hs.hotkey.bind(constants.hyperkey, "G", function()
   hs.grid.setGrid("6x4")
   hs.grid.show()
end)

hs.hotkey.bind(constants.hyperkey, "F", function()
   hs.grid.setGrid("5x3")
   hs.grid.show()
end)
