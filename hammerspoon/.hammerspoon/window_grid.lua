-- Windows grids ---------------------------------------------------------
--------------------------------------------------------------------------
local constants = require("common/constants")

hs.grid.setMargins({ x = 0, y = 0 }) -- margins between windows

-- Set grid UI settings
hs.grid.ui.textColor = { 1, 1, 1, 0.7 }

hs.grid.ui.highlightColor = { 0.8, 0.8, 0, 0.1 } -- highlights the frontmost window behind grid
hs.grid.ui.highlightStrokeColor = { 0.8, 0.8, 0, 0.2 }

hs.grid.ui.selectedColor = { 0.2, 0.7, 0, 0.2 } -- for the first selected cell during a modal resize
hs.grid.ui.textSize = 150

-- show interactive modal interface for resizing
hs.hotkey.bind(constants.hyperkey, "G", function()
   -- TODO: update this so that it adds some margins
   hs.grid.setGrid("6x4")
   hs.grid.show()
end)

hs.hotkey.bind(constants.hyperkey, "F", function()
   hs.grid.setGrid("5x3")
   hs.grid.show()
end)
