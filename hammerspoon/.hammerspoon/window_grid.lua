-- Windows grids ---------------------------------------------------------
--------------------------------------------------------------------------
local constants = require("common/constants")

hs.grid.setMargins({ x = 0, y = 0 }) -- margins betwen windows. doesn't set from bottom or right

-- show interactive modal interface for resizing
hs.hotkey.bind(constants.hyperkey, "G", function()
   hs.grid.setGrid("6x4")
   hs.grid.show()
end)

hs.hotkey.bind(constants.hyperkey, "F", function()
   hs.grid.setGrid("5x3")
   hs.grid.show()
end)
