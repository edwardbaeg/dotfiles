local mod = require("modifiers")

function _G.within(a, b, margin)
   return math.abs(a - b) <= margin
end

function _G.moveAndResizeFocused(callback)
   local win = hs.window.focusedWindow()
   local frame = win:frame()
   local screenFrame = win:screen():frame()
   local prevW = frame.w
   local prevH = frame.h

   callback(frame, screenFrame)
   local needsResize = not (within(frame.h, prevH, 1) and within(frame.w, prevW, 1))
   win:setFrame(frame, needsResize and 0 or 0.15)
end

---Cycles through a list of rects to set focused window position
---@param options {h: number, w: number, x: number, y: number}[] list of rect to cycle through
--TODO: consider refactor: https://xenodium.com/cycling-through-window-layout-revisited/
function _G.cyclePositions(options)
   local win = hs.window.focusedWindow()
   local frame = win:frame()

   -- check if the window matches any of the options
   -- if so, then move to the next option
   -- otherwise set the first option.
   local firstOption = options[1]
   for i, option in ipairs(options) do
      if
         within(frame.h, option.h, 1)
         and within(frame.w, option.w, 1)
         and within(frame.x, option.x, 1)
         and within(frame.y, option.y, 1)
      then
         local nextOption = options[i + 1] or firstOption

         -- three different animation levels: same size, same one dimension, different size
         local sameSize = within(frame.h, nextOption.h, 1) and within(frame.w, nextOption.w, 1)
         local sameHeight = within(frame.h, nextOption.h, 1)
         local duration = sameSize and 0.15 or sameHeight and 0.1 or 0

         win:setFrame(nextOption, duration)
         return
      end
   end

   local sameSize = within(frame.h, firstOption.h, 1) and within(frame.w, firstOption.w, 1)
   local sameHeight = within(frame.h, firstOption.h, 1)
   local duration = sameSize and 0.15 or sameHeight and 0.1 or 0
   win:setFrame(firstOption, duration)
end

-- Left positions
hs.hotkey.bind(mod.hyperkey, "H", function()
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
hs.hotkey.bind(mod.hyperkey, "L", function()
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

-- Top half
hs.hotkey.bind(mod.hyperkey, "K", function()
   moveAndResizeFocused(function(frame, screen)
      frame.x = screen.x
      frame.y = screen.y
      frame.w = screen.w
      frame.h = screen.h / 2
   end)
end)

-- Bottom half
hs.hotkey.bind(mod.hyperkey, "J", function()
   moveAndResizeFocused(function(frame, screen)
      frame.x = screen.x
      frame.y = screen.y + (screen.h / 2)
      frame.w = screen.w
      frame.h = screen.h / 2
   end)
end)

-- Resize and center windows ---------------------------------------------
--------------------------------------------------------------------------
function _G.resizeAndCenter(fraction)
   local win = hs.window.focusedWindow()
   local f = win:frame()
   local screenMax = win:screen():frame()

   f.w = screenMax.w * fraction
   f.h = screenMax.h * fraction
   f.x = screenMax.x + (screenMax.w - f.w) / 2
   f.y = screenMax.y + (screenMax.h - f.h) / 2
   win:setFrame(f, 0)
end

-- Maximize window
hs.hotkey.bind(mod.hyperkey, "M", function()
   resizeAndCenter(0.99)
end)

-- Resize window 80%
hs.hotkey.bind(mod.hyperkey, "N", function()
   resizeAndCenter(0.81)
end)

-- Resize window 64%
hs.hotkey.bind(mod.hyperkey, "B", function()
   resizeAndCenter(0.64)
end)

-- Resize window 50%
hs.hotkey.bind(mod.hyperkey, "V", function()
   resizeAndCenter(0.49)
end)

-- TODO: add hotkeys to increase and decrease window size (from raycast)
-- cmd + ctrl + -/=

-- Move to display -------------------------------------------------------
--------------------------------------------------------------------------
-- Move to the left screen
-- TODO: check if its firefox, and then use raycast instead
hs.hotkey.bind({ "ctrl", "shift", "cmd" }, "L", function()
   local win = hs.window.focusedWindow()
   local screen = win:screen()
   win:move(win:frame():toUnitRect(screen:frame()), screen:previous(), true, 0)
end)

-- Move to the right screen
hs.hotkey.bind({ "ctrl", "shift", "cmd" }, "H", function()
   -- Get focused window
   local win = hs.window.focusedWindow()
   -- Get screen of focused window
   local screen = win:screen()
   -- move to window
   win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end)

