local constants = require("common/constants")
local hyperkey = constants.hyperkey

local utils = require("window_management-utils")
local cyclePositions = utils.cyclePositions
local withAxHotfix = utils.withAxHotfix
local mapScreenUnitRects = utils.mapScreenUnitRects
local resizeAndCenter = utils.resizeAndCenter

-- Move to position --------------------------
----------------------------------------------

-- Left positions
hs.hotkey.bind(hyperkey, "H", function()
   local unitRects = {
      { x = 0, y = 0, w = 0.5, h = 1 },
      { x = 0, y = 0, w = 1 / 3, h = 1 },
      { x = 0, y = 0, w = 2 / 3, h = 1 },
   }

   cyclePositions(mapScreenUnitRects(unitRects))
end)

-- Right positions
hs.hotkey.bind(hyperkey, "L", function()
   local unitRects = {
      { x = 0.5, y = 0, w = 0.5, h = 1 },
      { x = 2 / 3, y = 0, w = 1 / 3, h = 1 },
      { x = 1 / 3, y = 0, w = 2 / 3, h = 1 },
   }

   cyclePositions(mapScreenUnitRects(unitRects))
end)

-- Top positions
hs.hotkey.bind(hyperkey, "K", function()
   local unitRects = {
      { x = 0, y = 0, w = 1, h = 0.5 },
      { x = 0, y = 0, w = 1, h = 1 / 3 },
      { x = 0, y = 0, w = 1, h = 2 / 3 },
   }

   cyclePositions(mapScreenUnitRects(unitRects))
end)

-- Bottom positions
hs.hotkey.bind(hyperkey, "J", function()
   local unitRects = {
      { x = 0, y = 0.5, w = 1, h = 0.5 },
      { x = 0, y = 2 / 3, w = 1, h = 1 / 3 },
      { x = 0, y = 1 / 3, w = 1, h = 2 / 3 },
   }

   cyclePositions(mapScreenUnitRects(unitRects))
end)

-- Center, full height positions
hs.hotkey.bind(hyperkey, "C", function()
    -- Cycle through center positions
    local unitRects = {
        { x = 0.25, y = 0, w = 0.5, h = 1 },
        { x = 1 / 6, y = 0, w = 2 / 3, h = 1 },
        { x = 1 / 3, y = 0, w = 1 / 3, h = 1 },
    }

    cyclePositions(mapScreenUnitRects(unitRects))
end)

-- Resize and center windows --------------------
-------------------------------------------------

-- Cycle through window sizes based on current position
local function cycleWindowSize(sizes)
   local win = hs.window.focusedWindow()
   local f = win:frame()
   local screenMax = win:screen():frame()

   local nextSizeIndex = 1

   for i, size in ipairs(sizes) do
      local targetW = screenMax.w * size
      local targetH = screenMax.h * size
      local widthMatch = math.abs(f.w - targetW) / targetW < 0.03
      local heightMatch = math.abs(f.h - targetH) / targetH < 0.03
      if widthMatch and heightMatch then
         nextSizeIndex = (i % #sizes) + 1
         break
      end
   end

   resizeAndCenter(sizes[nextSizeIndex])
end

-- TODO: consider creating a generic utils file
local function reverse_list(list)
   local reversed = {}
   for i = #list, 1, -1 do
      table.insert(reversed, list[i])
   end
   return reversed
end

local sizes = { 1, 0.49, 0.64, 0.81 }

-- Start full size, then increase in size
hs.hotkey.bind(hyperkey, "M", function()
   cycleWindowSize(sizes)
end)

-- the same as above, but in reverse
hs.hotkey.bind(hyperkey, "N", function()
   cycleWindowSize(reverse_list(sizes))
end)

-- Move to display -------------------------------
--------------------------------------------------

-- To the right
-- NOTE: hs.window:moveToScreen doesn't wrap
hs.hotkey.bind({ "ctrl", "shift", "cmd" }, "L", function()
   local win = hs.window.focusedWindow()
   local screen = win:screen()

   withAxHotfix(function()
      win:move(win:frame():toUnitRect(screen:frame()), screen:previous(), true, 0)
   end)
end)

-- To the left
hs.hotkey.bind({ "ctrl", "shift", "cmd" }, "H", function()
   local win = hs.window.focusedWindow()
   local screen = win:screen()

   withAxHotfix(function()
      win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
   end)
end)
