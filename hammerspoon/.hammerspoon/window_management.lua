local constants = require("common/constants")
local hyperkey = constants.hyperkey

-- https://github.com/Hammerspoon/hammerspoon/issues/3224#issuecomment-1294971600
-- Some applications (eg Firefox) animate resize instead of moving, due to AXEnhancedUserInterface
-- So, temporarily disable it while moving the window
local function axHotfix(win)
   if not win then
      win = hs.window.frontmostWindow()
   end

   local axApp = hs.axuielement.applicationElement(win:application())
   if not axApp then
      return
   end
   local wasEnhanced = axApp.AXEnhancedUserInterface
   axApp.AXEnhancedUserInterface = false

   return function()
      hs.timer.doAfter(hs.window.animationDuration * 2, function()
         axApp.AXEnhancedUserInterface = wasEnhanced
      end)
   end
end

-- TODO?: add branching logic for firefox, for potential performance
local function withAxHotfix(fn, position)
   if not position then
      position = 1
   end
   local revert = axHotfix()
   fn()
   if revert then
      revert()
   end
end

local MARGIN = 5
-- Buffer margin space around screen edges
local function applyScreenEdgeMargins(window, screen)
   local x, y, width, height = window.x, window.y, window.w, window.h
   -- left edge
   if x - screen.x < MARGIN then
      width = width - MARGIN
      x = screen.x + MARGIN
   end
   -- right edge
   if screen.w - (x + width) < MARGIN then
      width = width - MARGIN
   end
   -- top edge
   if y - screen.y < MARGIN then
      height = height - MARGIN
      y = screen.y + MARGIN
   end
   -- bottom edge
   if screen.h - (y + height) < MARGIN then
      height = height - MARGIN
   end
   return { x = x, y = y, w = width, h = height }
end

local function withinMargin(a, b)
   return math.abs(a - b) <= MARGIN * 2
end

---@param win hs.window
---@param rect hs.geometry
---@param duration number
local function setFrame(win, rect, duration)
   local newRect = applyScreenEdgeMargins(rect, win:screen():frame())
   withAxHotfix(function()
      win:setFrame(newRect, duration)
   end)
end

---Cycles through a list of rects to set focused window position
---@param options {h: number, w: number, x: number, y: number}[] list of rect to cycle through
-- TODO: consider refactor: https://xenodium.com/cycling-through-window-layout-revisited/
-- TODO: consider refactoring with hs.window:moveToUnit
-- TODO: add some buffer margin to make space for the colored border
local function cyclePositions(options)
   local win = hs.window.focusedWindow()
   local frame = win:frame()

   -- if the window matches any of the options, set to the next one
   local firstOption = options[1]
   for i, option in ipairs(options) do
      if
         withinMargin(frame.h, option.h)
         and withinMargin(frame.w, option.w)
         and withinMargin(frame.x, option.x)
         and withinMargin(frame.y, option.y)
      then
         local nextOption = options[i + 1] or firstOption

         -- three different animation levels: same size, same one dimension, different size
         local sameSize = withinMargin(frame.h, nextOption.h) and withinMargin(frame.w, nextOption.w)
         local sameHeight = withinMargin(frame.h, nextOption.h)

         -- TODO: add an ignore list of apps
         ---@diagnostic disable-next-line: undefined-field name is a valid field of application
         local duration = win:application():name() == "Acrobat Reader" and 0
            or (sameSize and 0.15 or sameHeight and 0.1 or 0)

         setFrame(win, nextOption, duration)
         return
      end
   end

   -- otherwise, set to the first option
   local sameSize = withinMargin(frame.h, firstOption.h) and withinMargin(frame.w, firstOption.w)
   local sameHeight = withinMargin(frame.h, firstOption.h)
   local duration = sameSize and 0.15 or sameHeight and 0.1 or 0
   setFrame(win, firstOption, duration)
end

-- Left positions
hs.hotkey.bind(hyperkey, "H", function()
   local win = hs.window.focusedWindow()
   local screenFrame = win:screen():frame()

   cyclePositions({
      {
         x = screenFrame.x,
         y = screenFrame.y,
         w = screenFrame.w / 2,
         h = screenFrame.h,
      },
      {
         x = screenFrame.x,
         y = screenFrame.y,
         w = screenFrame.w / 3,
         h = screenFrame.h,
      },
      {
         x = screenFrame.x,
         y = screenFrame.y,
         w = screenFrame.w * 2 / 3,
         h = screenFrame.h,
      },
   })
end)

-- Right positions
hs.hotkey.bind(hyperkey, "L", function()
   local win = hs.window.focusedWindow()
   local screenFrame = win:screen():frame()

   cyclePositions({
      {
         x = screenFrame.x + (screenFrame.w / 2),
         y = screenFrame.y,
         w = screenFrame.w / 2,
         h = screenFrame.h,
      },
      {
         x = screenFrame.x + (screenFrame.w * 2 / 3),
         y = screenFrame.y,
         w = screenFrame.w / 3,
         h = screenFrame.h,
      },
      {
         x = screenFrame.x + (screenFrame.w * 1 / 3),
         y = screenFrame.y,
         w = screenFrame.w * 2 / 3,
         h = screenFrame.h,
      },
   })
end)

-- Top positions
hs.hotkey.bind(hyperkey, "K", function()
   local win = hs.window.focusedWindow()
   local screenFrame = win:screen():frame()

   cyclePositions({
      {
         x = screenFrame.x,
         y = screenFrame.y,
         w = screenFrame.w,
         h = screenFrame.h / 2,
      },
      {
         x = screenFrame.x,
         y = screenFrame.y,
         w = screenFrame.w,
         h = screenFrame.h / 3,
      },
      {
         x = screenFrame.x,
         y = screenFrame.y,
         w = screenFrame.w,
         h = screenFrame.h * 2 / 3,
      },
   })
end)

-- Bottom positions
hs.hotkey.bind(hyperkey, "J", function()
   local win = hs.window.focusedWindow()
   local screenFrame = win:screen():frame()

   cyclePositions({
      {
         x = screenFrame.x,
         y = screenFrame.y + (screenFrame.h / 2),
         w = screenFrame.w,
         h = screenFrame.h / 2,
      },
      {
         x = screenFrame.x,
         y = screenFrame.y + (screenFrame.h * 2 / 3),
         w = screenFrame.w,
         h = screenFrame.h / 3,
      },
      {
         x = screenFrame.x,
         y = screenFrame.y + (screenFrame.h / 3),
         w = screenFrame.w,
         h = screenFrame.h * 2 / 3,
      },
   })
end)

local function centerThin()
   local win = hs.window.focusedWindow()
   if not win then
      hs.alert("No focused window")
      return
   end
   local screenFrame = win:screen():frame()
   local widthFraction = 0.2

   cyclePositions({
      {
         x = screenFrame.x + (screenFrame.w * (1 - widthFraction) / 2),
         y = screenFrame.y,
         w = screenFrame.w * widthFraction,
         h = screenFrame.h,
      },
   })
end

-- FIXME: calling this form raycast results in win being nil
hs.urlevent.bind("centerThin", function()
   hs.timer.doAfter(1, centerThin)
end)

-- Resize and center windows ---------------------------------------------
--------------------------------------------------------------------------
local function resizeAndCenter(fraction)
   local win = hs.window.focusedWindow()
   local f = win:frame()
   local screenMax = win:screen():frame()

   f.w = screenMax.w * fraction
   f.h = screenMax.h * fraction
   f.x = screenMax.x + (screenMax.w - f.w) / 2
   f.y = screenMax.y + (screenMax.h - f.h) / 2

   setFrame(win, f, 0)
end

-- Maximize window
hs.hotkey.bind(hyperkey, "M", function()
   resizeAndCenter(0.99)
end)

-- Resize window 80%
hs.hotkey.bind(hyperkey, "N", function()
   resizeAndCenter(0.81)
end)

-- Resize window 64%
hs.hotkey.bind(hyperkey, "B", function()
   resizeAndCenter(0.64)
end)

-- Resize window 50%
hs.hotkey.bind(hyperkey, "V", function()
   resizeAndCenter(0.49)
end)

-- Move to display -------------------------------------------------------
--------------------------------------------------------------------------
-- Move to the right screen
-- TODO: maintain relative size after moving
-- tried refactoring with hs.window:moveToScreen -- this doesn't wrap
hs.hotkey.bind({ "ctrl", "shift", "cmd" }, "L", function()
   local win = hs.window.focusedWindow()
   local screen = win:screen()
   -- local app = win:application()

   withAxHotfix(function()
      -- two methods for this
      -- win:moveOneScreenEast(false, nil, 0) -- does not wrap
      win:move(win:frame():toUnitRect(screen:frame()), screen:previous(), true, 0)
   end)

   -- Another method
end)

-- Move to the left screen
hs.hotkey.bind({ "ctrl", "shift", "cmd" }, "H", function()
   local win = hs.window.focusedWindow()
   local screen = win:screen()

   withAxHotfix(function()
      win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
   end)
end)
