local M = {}

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
M.withAxHotfix = function (fn, position)
   if not position then
      position = 1
   end
   local revert = axHotfix()
   fn()
   if revert then
      revert()
   end
end

local MARGIN = 4
-- Buffer margin space around screen edges
-- FIXME: some of these edges don't work for all screens if there are multiple monitors
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
local function setFrameWithMargins(win, rect, duration)
   local newRect = applyScreenEdgeMargins(rect, win:screen():frame())
   M.withAxHotfix(function()
      win:setFrame(newRect, duration)
   end)
end

---Cycles through a list of rects to set focused window position
---@param options {h: number, w: number, x: number, y: number}[] list of rects to cycle through
M.cyclePositions = function(options)
   local win = hs.window.focusedWindow()
   local frame = win:frame()

   local function calculateDuration(appName, sameSize, sameHeight)
      if appName == "Acrobat Reader" then
         return 0
      end
      return sameSize and 0.15 or sameHeight and 0.1 or 0
   end

   local function matchesOption(rect, option)
      return withinMargin(rect.h, option.h)
         and withinMargin(rect.w, option.w)
         and withinMargin(rect.x, option.x)
         and withinMargin(rect.y, option.y)
   end

   local firstOption = options[1]
   local nextOption = firstOption

   for i, option in ipairs(options) do
      if matchesOption(frame, option) then
         nextOption = options[i + 1] or firstOption
         break
      end
   end

   local sameSize = withinMargin(frame.h, nextOption.h) and withinMargin(frame.w, nextOption.w)
   local sameHeight = withinMargin(frame.h, nextOption.h)
   local duration = calculateDuration(win:application():name(), sameSize, sameHeight)

   setFrameWithMargins(win, nextOption, duration)
end

---Converts a list of unit rects to screen rects
---@param unitRects {x: number, y: number, w: number, h: number}[]
---@return hs.geometry
M.mapScreenUnitRects = function(unitRects)
   local win = hs.window.focusedWindow()
   local screenFrame = win:screen():frame()

   ---@diagnostic disable-next-line: return-type-mismatch it's correct
   return hs.fnutils.imap(unitRects, function(unitRect)
      return hs.geometry.fromUnitRect(unitRect, screenFrame)
   end)
end

-- Resize and center windows ---------------------------------------------
--------------------------------------------------------------------------
M.resizeAndCenter = function(fraction)
   local win = hs.window.focusedWindow()
   local f = win:frame()
   local screenMax = win:screen():frame()

   f.w = screenMax.w * fraction
   f.h = screenMax.h * fraction
   f.x = screenMax.x + (screenMax.w - f.w) / 2
   f.y = screenMax.y + (screenMax.h - f.h) / 2

   setFrameWithMargins(win, f, 0)
end

return M
