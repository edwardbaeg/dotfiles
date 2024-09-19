-- ~/.hammerspoon/init.lua

-- Set up modifier combos
local hyperkey = { "cmd", "ctrl" }
local cmdShift = { "cmd", "shift" }
local altShift = { "alt", "shift" }
local altCtrl = { "alt", "ctrl" }
local allkey = { "cmd", "ctrl", "shift" }

---@diagnostic disable-next-line: undefined-global
local hs = hs

-- Install command line interface as `hs`
hs.ipc.cliInstall()

local hostname = hs.host.localizedName()
local isPersonal = hostname == "MacBook Pro14"

-- Remaps ----------------------------------------------------------------
--------------------------------------------------------------------------

-- Disable global macos hotkeys
hs.hotkey.bind({ "cmd" }, "M", function()
   hs.alert("[ cmd + m ] disabled") -- minimizes the current window. Annoying because does not unminimize on focus
end)

function _G.pressAndHoldKeyCb(sendModifiers, key)
   return function()
      hs.eventtap.keyStroke(sendModifiers, key, 1000)
   end
end

function _G.pressAndHoldRemap(modifiers, key, sendModifiers, sendKey)
   hs.hotkey.bind(
      modifiers,
      key,
      pressAndHoldKeyCb(sendModifiers, sendKey),
      nil,
      pressAndHoldKeyCb(sendModifiers, sendKey)
   )
end

-- Arrow keys
pressAndHoldRemap(cmdShift, "J", {}, "DOWN")
pressAndHoldRemap(cmdShift, "K", {}, "UP")
pressAndHoldRemap(cmdShift, "H", {}, "LEFT")
pressAndHoldRemap(cmdShift, "L", {}, "RIGHT")

-- Arrow and option
pressAndHoldRemap(altShift, "H", { "alt" }, "LEFT")
pressAndHoldRemap(altShift, "L", { "alt" }, "RIGHT")

function _G.systemKeyRemap(modifiers, key, sendKey)
   hs.hotkey.bind(modifiers, key, function()
      hs.eventtap.event.newSystemKeyEvent(sendKey, true):post()
      hs.eventtap.event.newSystemKeyEvent(sendKey, false):post()
   end)
end

-- Media controls
systemKeyRemap(cmdShift, ".", "NEXT")
systemKeyRemap(cmdShift, ",", "PREVIOUS")
systemKeyRemap(cmdShift, "/", "PLAY")
systemKeyRemap(cmdShift, "o", "SOUND_UP")
systemKeyRemap(cmdShift, "i", "SOUND_DOWN")

-- App Specific bindings -------------------------------------------------
--------------------------------------------------------------------------
hs.loadSpoon("AppBindings")
-- spoon.AppBindings:bind("Google Chrome", { -- this is the same as vimium H / L
--    { { "alt", "ctrl" }, "l", { "ctrl" }, "tab" },
--    { { "alt", "ctrl" }, "h", { "ctrl", "shift" }, "tab" },
-- })

-- These may be causing preformance issues
-- spoon.AppBindings:bind("Arc", { -- option tab doesn't work...
--    { { "alt" }, "tab", { "ctrl" }, "tab" },
--    { { "alt" }, "tab", { "ctrl", "shift" }, "tab" },
-- })
-- spoon.AppBindings:bind("Arc", { -- option tab doesn't work...
--    { { "alt", "ctrl" }, "l", { "ctrl" }, "tab" },
--    { { "alt", "ctrl" }, "h", { "ctrl", "shift" }, "tab" },
-- })

-- Window highlighting ---------------------------------------------------
--------------------------------------------------------------------------
hs.window.highlight.ui.overlayColor = { 0, 0, 0, 0.01 } -- overlay color
hs.window.highlight.ui.overlay = false
hs.window.highlight.ui.frameWidth = 8 -- draw a frame around the focused window in overlay mode; 0 to disable
hs.window.highlight.start()

hs.window.highlight.ui.overlay = true

-- Toggle window highlighting
hs.hotkey.bind(altCtrl, "H", function()
   if hs.window.highlight.ui.overlay then
      hs.alert("Disabling window highlighting")
   else
      hs.alert("Enabling window highlighting")
   end
   hs.window.highlight.ui.overlay = not hs.window.highlight.ui.overlay
end)

-- Focused window listener for highlighting
hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(window)
   local isFullScreen = window:isFullScreen()

   -- Disable when focusing full screen app
   if isFullScreen and hs.window.highlight.ui.overlay then
      hs.window.highlight.ui.overlay = false
   end

   -- force highlighting to fix some bugs when focusing windows in a different screen
   if not isFullScreen and hs.window.highlight.ui.overlay then
      hs.timer.doAfter(0.1, function()
         hs.window.highlight.ui.overlay = true
      end)
   end

   -- Enable when leaving full screen app focus
   if not isFullScreen and not hs.window.highlight.ui.overlay then
      hs.window.highlight.ui.overlay = true
   end
end)

ApplicationWatcher = hs.application.watcher
   .new(function(appName, eventType, _appObject)
      -- When focusing an application that has no windows
      if eventType == hs.application.watcher.activated then
         -- hs.alert("[" .. appName .. "]" .. " focused")
         local win = hs.window.focusedWindow()
         if win == nil then
            hs.alert("[" .. appName .. "]" .. " has no windows")
         end
      end

      -- highlight when unhiding an application
      if eventType == hs.application.watcher.unhidden then
         hs.window.highlight.ui.overlay = true
      end
   end)
   :start()

-- Toggle on fullscreen toggle
hs.window.filter.default:subscribe(hs.window.filter.windowFullscreened, function(window, _appName)
   hs.window.highlight.ui.overlay = false
end)
hs.window.filter.default:subscribe(hs.window.filter.windowUnfullscreened, function(window, _appName)
   hs.window.highlight.ui.overlay = true
end)

hs.window.filter.default:subscribe(hs.window.filter.hasNoWindows, function(window, appName)
   -- hs.alert("hasNoWindows")
   -- hs.window.highlight.ui.overlay = false
end)

-- Reload Config ---------------------------------------------------------
--------------------------------------------------------------------------
-- Automatically reload config on file changes
ReloadWatcher = hs.pathwatcher
   .new(os.getenv("HOME") .. "/dev/dotfiles/hammerspoon/", function(files)
      local doReload = false
      for _, file in pairs(files) do
         if file:sub(-4) == ".lua" then
            doReload = true
         end
      end

      if doReload then
         hs.alert("Autoreloading...")
         hs.timer.doAfter(0.1, function()
            hs.reload()
         end)
      end
   end)
   :start()

-- NOTE: hs.reload() destroys current Lua interpreter so anything after it is ignored
hs.hotkey.bind(hyperkey, "R", function()
   hs.alert("Reloading config...")
   hs.timer.doAfter(0.1, function() -- put reload async so alert executes
      hs.reload()
   end)
end)

-- hammerspoon://reloadConfig
hs.urlevent.bind("reloadConfig", function()
   hs.alert("Reloading config...")
   hs.timer.doAfter(0.1, function() -- put reload async so alert executes
      hs.reload()
   end)
end)

-- Application hotkeys ---------------------------------------------------
--------------------------------------------------------------------------

-- TODO?: if the application is already focused, then hide it
function _G.assignAppHotKey(modifiers, key, appName, callback)
   hs.hotkey.bind(modifiers, key, function()
      local success = hs.application.launchOrFocus(appName)
      callback = callback or function() end
      if success then
         callback()
      end
   end)
end

assignAppHotKey(hyperkey, "0", "Wezterm")
assignAppHotKey(hyperkey, "8", "Slack")

if isPersonal then
   -- personal profile
   assignAppHotKey(hyperkey, "9", "Arc", function()
      hs.eventtap.keyStroke({ "ctrl" }, "2")
      hs.timer.doAfter(0.1, function()
         hs.eventtap.keyStroke({ "ctrl" }, "2")
      end)
   end)
   -- work profile
   assignAppHotKey(allkey, "9", "Arc", function()
      hs.eventtap.keyStroke({ "ctrl" }, "4")
      hs.timer.doAfter(0.1, function()
         hs.eventtap.keyStroke({ "ctrl" }, "4")
      end)
   end)
else
   -- personal profile
   assignAppHotKey(allkey, "9", "Arc", function()
      hs.eventtap.keyStroke({ "ctrl" }, "2")
      hs.timer.doAfter(0.1, function()
         hs.eventtap.keyStroke({ "ctrl" }, "2")
      end)
   end)
   -- work profile
   assignAppHotKey(hyperkey, "9", "Arc", function()
      hs.eventtap.keyStroke({ "ctrl" }, "4")
      hs.timer.doAfter(0.1, function()
         hs.eventtap.keyStroke({ "ctrl" }, "4")
      end)
   end)
end
-- LEGACY: separate browsers / keymaps for personal and work
-- local personalBrowser = "Arc"
-- local workBrowser = "Arc"
--
-- if isPersonal then
--    assignAppHotKey(hyperkey, "9", personalBrowser)
--    assignAppHotKey({ "cmd", "shift", "ctrl" }, "9", workBrowser)
-- end
--
-- if not isPersonal then
--    assignAppHotKey(hyperkey, "9", workBrowser, function()
--       hs.eventtap.keyStroke({ "ctrl" }, "4")
--       hs.timer.doAfter(0.1, function()
--          hs.eventtap.keyStroke({ "ctrl" }, "4")
--       end)
--    end)
--    assignAppHotKey({ "cmd", "shift", "ctrl" }, "9", personalBrowser, function()
--       hs.eventtap.keyStroke({ "ctrl" }, "2")
--       hs.timer.doAfter(0.1, function()
--          hs.eventtap.keyStroke({ "ctrl" }, "2")
--       end)
--    end)
-- end
--
-- Windows grids ---------------------------------------------------------
--------------------------------------------------------------------------

hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.GRIDWIDTH = 6
hs.grid.GRIDHEIGHT = 4

-- show interactive modal interface for resizing
hs.hotkey.bind(hyperkey, "G", function()
   hs.grid.show()
end)

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

-- Top half
hs.hotkey.bind(hyperkey, "K", function()
   moveAndResizeFocused(function(frame, screen)
      frame.x = screen.x
      frame.y = screen.y
      frame.w = screen.w
      frame.h = screen.h / 2
   end)
end)

-- Bottom half
hs.hotkey.bind(hyperkey, "J", function()
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

-- TODO: add hotkeys to increase and decrease window size (from raycast)
-- cmd + ctrl + -/=

-- Move to monitor -------------------------------------------------------
--------------------------------------------------------------------------
-- Move to the left screen
hs.hotkey.bind({ "ctrl", "shift", "cmd" }, "L", function()
   -- Get focused window
   local win = hs.window.focusedWindow()
   -- Get screen of focused window
   local screen = win:screen()
   -- move to window
   win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end)

-- Move to the right screen
hs.hotkey.bind({ "ctrl", "shift", "cmd" }, "H", function()
   -- Get focused window
   local win = hs.window.focusedWindow()
   -- Get screen of focused window
   local screen = win:screen()
   -- move to window
   win:move(win:frame():toUnitRect(screen:frame()), screen:previous(), true, 0)
end)

-- Move cursor between screens -------------------------------------------
--------------------------------------------------------------------------
function _G.move_cursor_to_monitor(direction)
   return function()
      local screen = hs.mouse.getCurrentScreen()
      local nextScreen
      if direction == "right" then
         nextScreen = screen:next()
      else
         nextScreen = screen:previous()
      end

      local rect = nextScreen:fullFrame()
      -- get the center of the rect
      local center = hs.geometry.rect(rect).center

      local currentPosition = hs.mouse.absolutePosition()

      move_mouse(currentPosition.x, currentPosition.y, center.x, center.y, 10)
   end
end

--- Animate moving the mouse cursor
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param sleep number Duration in milliseconds
function _G.move_mouse(x1, y1, x2, y2, sleep)
   local xdiff = x2 - x1
   local ydiff = y2 - y1
   local loop = math.floor(math.sqrt((xdiff * xdiff) + (ydiff * ydiff)))
   local xinc = xdiff / loop
   local yinc = ydiff / loop
   sleep = math.floor((sleep * 1000) / loop)
   for i = 1, loop do
      x1 = x1 + xinc
      y1 = y1 + yinc
      hs.mouse.absolutePosition({ x = math.floor(x1), y = math.floor(y1) })
      hs.timer.usleep(sleep)
   end
   hs.mouse.absolutePosition({ x = math.floor(x2), y = math.floor(y2) })
end

-- hs.hotkey.bind(cmdShift, "f", move_cursor_to_monitor("right"))
-- hs.hotkey.bind(cmdShift, "d", move_cursor_to_monitor("left"))
-- hs.hotkey.bind(hyperkey, "f", move_cursor_to_monitor("right"))
-- hs.hotkey.bind(hyperkey, "d", move_cursor_to_monitor("left"))

-- Caffeine menubar app --------------------------------------------------
--------------------------------------------------------------------------
-- Caffeine state can be toggled by clicking on the menu bar
-- or by linking to `hammerspoon://toggleCaffineState?state={true|false}`

-- TODO: persist state using hs.settings
-- https://www.hammerspoon.org/docs/hs.settings.html
local caffeineMenuBar = hs.menubar.new()
function _G.setCaffeineDisplay(state)
   if state then
      caffeineMenuBar:setTitle("A") -- for awake
   else
      caffeineMenuBar:setTitle("S") -- for sleep
   end
end

local sleepType = "displayIdle"
_G.handleCaffeineUrl = function(_eventName, params)
   local state = params["state"]
   if state then
      if state == "true" then
         enableCaffeine()
      elseif state == "false" then
         disableCaffeine()
      else
         hs.alert("state is invalid value")
      end
   else
      toggleCaffeine()
   end
end

_G.enableCaffeine = function()
   hs.caffeinate.set(sleepType, true)
   setCaffeineDisplay(true)
end

_G.disableCaffeine = function()
   hs.caffeinate.set(sleepType, false)
   setCaffeineDisplay(false)
end

_G.toggleCaffeine = function()
   setCaffeineDisplay(hs.caffeinate.toggle(sleepType))
end

function _G.caffeineClicked()
   toggleCaffeine()
end

if caffeineMenuBar then
   caffeineMenuBar:setClickCallback(caffeineClicked)
   setCaffeineDisplay(hs.caffeinate.get(sleepType))
end

-- hammerspoon://toggleCaffeineState?state={true|false}
hs.urlevent.bind("toggleCaffeineState", handleCaffeineUrl)
hs.urlevent.bind("enableCaffeine", enableCaffeine)
hs.urlevent.bind("disableCaffeine", disableCaffeine)

-- Toggle sleepmode for ryujinx
local watchRyujinx = function(appName, eventType, appObject)
   if eventType == hs.application.watcher.activated then
      if string.sub(appName, 1, #"Ryujinx") == "Ryujinx" then
         hs.alert("Activating caffeine - Ryujinx")
         enableCaffeine()
      end
   end
   if eventType == hs.application.watcher.deactivated then
      if string.sub(appName, 1, #"Ryujinx") == "Ryujinx" then
         hs.alert("Disabling caffeine - Ryujinx")
         disableCaffeine()
      end
   end
end

if isPersonal then
   -- NOTE: do not create watcher as local variable or it will be garbage collected
   RyujinxWatcher = hs.application.watcher.new(watchRyujinx)
   RyujinxWatcher:start()
end

-- Spoons ----------------------------------------------------------------
--------------------------------------------------------------------------
-- Builds annotations for Hammerspoon and install Spoons for lua lsp in ${configDir}/annotations
-- This requires configuring lua_lsp workspace.library to point to the annotations dir
-- https://github.com/Hammerspoon/Spoons/pull/240
hs.loadSpoon("EmmyLua")

-- hs.loadSpoon("AClock")
-- this doesn't work
-- local clock = AClock.init()
-- clock:show()

-- Wifi switcher ---------------------------------------------------------
--------------------------------------------------------------------------
local homeSSID = "!wifi"
local lastSSID = hs.wifi.currentNetwork()

function _G.ssidChangedCallback()
   local newSSID = hs.wifi.currentNetwork()

   if newSSID == homeSSID and lastSSID ~= homeSSID then
      -- We just joined our home WiFi network
      hs.audiodevice.defaultOutputDevice():setVolume(25)
      hs.alert("Home network: setting volume.")
   elseif newSSID ~= homeSSID and lastSSID == homeSSID then
      -- We just departed our home WiFi network
      hs.alert("External network: muting volume.")
      hs.audiodevice.defaultOutputDevice():setVolume(0)
   end

   lastSSID = newSSID
end

-- WifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
-- WifiWatcher:start()

-- Notes -----------------------------------------------------------------
--------------------------------------------------------------------------
--[[

Created ojects should be captured in gloal variables.
Otherwise, they will be garbage collected.
https://www.hammerspoon.org/go/ "A quick aside about variable lifecycles"

Get the name of screens
  hs.screen.allScreens()[1]:name()

Get the name of running apps
  hs.fnutils.each(hs.application.runningApplications(), function(app) print(app:title()) end)


--]]
-- Native notification example
-- hs.hotkey.bind(hyperkey, "W", function()
--   hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
-- end)

hs.alert("Config loaded!")
