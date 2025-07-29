-- Windows grids ---------------------------------------------------------
--------------------------------------------------------------------------
---@type Constants
local constants = require("common/constants")
local PADDING = constants.screenPadding

hs.grid.setMargins({ x = 0, y = 0 }) -- margins between windows

-- Set grid UI settings
hs.grid.ui.textColor = { 1, 1, 1, 0.7 }

hs.grid.ui.highlightColor = { 0.8, 0.8, 0, 0.1 } -- highlights the frontmost window behind grid
hs.grid.ui.highlightStrokeColor = { 0.8, 0.8, 0, 0.2 }

hs.grid.ui.selectedColor = { 0.2, 0.7, 0, 0.2 } -- for the first selected cell during a modal resize
hs.grid.ui.textSize = 150

local function getScreenAndPaddedFrame()
   local win = hs.window.focusedWindow()
   local screen = win and win:screen() or hs.screen.mainScreen()
   local frame = screen:frame()
   local paddedFrame =
      hs.geometry.rect(frame.x + PADDING, frame.y + PADDING, frame.w - 2 * PADDING, frame.h - 2 * PADDING)
   return screen, paddedFrame
end

hs.hotkey.bind(constants.hyperkey, "F", function()
   local screen, paddedFrame = getScreenAndPaddedFrame()
   hs.grid.setGrid("5x3", screen, paddedFrame)
   hs.grid.show()
end)

-- show interactive modal interface for resizing
hs.hotkey.bind(constants.hyperkey, "G", function()
   local screen, paddedFrame = getScreenAndPaddedFrame()
   hs.grid.setGrid("8x4", screen, paddedFrame)
   hs.grid.show()
end)
