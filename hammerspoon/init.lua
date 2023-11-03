-- ~/.hammerspoon/init.lua

local hyperkey = { "cmd", "ctrl" }

---@diagnostic disable-next-line: undefined-global
local hs = hs

-- Install command line interface as `hs`
hs.ipc.cliInstall()

-- Expose ----------------------------------------------------------------
--------------------------------------------------------------------------
-- hs.expose.ui.backgroundColor = { 0.30, 0.03, 0.03, 0.5 }
hs.expose.highlightColor = { 1, 1 }
hs.expose.ui.showThumbnails = true -- [true]
hs.expose.ui.fitWindowsInBackground = true -- [true] improve performance with false
hs.expose.ui.thumbnailAlpha = 0.5 -- [0] improve performance with false
hs.expose.ui.textSize = 60 -- [40]

-- expose = hs.expose.new(nil,  {  })
-- hs.hotkey.bind(hyperkey, "E", function()
--   expose:toggleShow()
-- end)
-- hs.hotkey.bind({ "cmd" }, "E", function()
--   expose:toggleShow()
-- end)

-- Some shortcuts --------------------------------------------------------
--------------------------------------------------------------------------
hs.hotkey.bind({ "cmd" }, "M", function()
   hs.alert("[ cmd + m ] disabled")
end)

-- Spoons ----------------------------------------------------------------
--------------------------------------------------------------------------
-- hs.loadSpoon("AClock")
-- this doesn't work
-- local clock = AClock.init()
-- clock:show()

-- Window highlighting ---------------------------------------------------
--------------------------------------------------------------------------
hs.window.highlight.ui.overlayColor = { 0, 0, 0, 0.01 } -- overlay color
hs.window.highlight.ui.overlay = false
hs.window.highlight.ui.frameWidth = 12 -- draw a frame around the focused window in overlay mode; 0 to disable
hs.window.highlight.start()

-- Toggle on fullscreen toggle
hs.window.filter.default:subscribe(hs.window.filter.hasNoWindows, function(window, appName)
   -- hs.alert("hasNoWindows")
   -- hs.window.highlight.ui.overlay = false
end)
hs.window.filter.default:subscribe(hs.window.filter.windowFullscreened, function(window, appName)
   hs.window.highlight.ui.overlay = false
end)
hs.window.filter.default:subscribe(hs.window.filter.windowUnfullscreened, function(window, appName)
   hs.window.highlight.ui.overlay = true
end)

hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(window, appName)
   local win = hs.window.focusedWindow()
   local isFullScreen = win:isFullScreen()

   if isFullScreen and hs.window.highlight.ui.overlay then
      hs.window.highlight.ui.overlay = false
   elseif not isFullScreen and not hs.window.highlight.ui.overlay then
      hs.window.highlight.ui.overlay = true
   end
end)

-- Detect when focusing an application that has no windows
applicationWatcher = hs.application.watcher
   .new(function(appName, eventType, appObject)
      if eventType == hs.application.watcher.activated then
         local win = hs.window.focusedWindow()
         if win == nil then
            hs.alert("[" .. appName .. "]" .. " has no windows")
         end
         -- local allwindows = appObject:allWindows()
         -- print(allwindows)
      end
   end)
   :start()

-- Not good
-- hs.window.highlight.ui.windowShownFlashColor = { 0, 1, 0, 0.8 } -- flash color when a window is shown (created or unhidden)
-- hs.window.highlight.ui.flashDuration = 0.3

-- Reload Config ---------------------------------------------------------
--------------------------------------------------------------------------
-- Automatically reload config on file changes
-- NOTE: this does not work with symlinked files, point to source
-- TODO: refactor to check for symlinks and to reload linked file
hs.pathwatcher
   .new(os.getenv("HOME") .. "/dev/dotfiles/", function(files)
      local doReload = false
      for _, file in pairs(files) do
         if file:sub(-4) == ".lua" then
            doReload = true
         end
      end

      if doReload then
         hs.reload()
      end
   end)
   :start()

-- NOTE: hs.reload() destroys current Lua interpreter so anything after it is ignored
hs.hotkey.bind(hyperkey, "R", function()
   hs.reload()
end)

-- Helpers ---------------------------------------------------------------
--------------------------------------------------------------------------
function _G.within(a, b, margin)
   return math.abs(a - b) <= margin
end

-- Application hotkeys ---------------------------------------------------
--------------------------------------------------------------------------
local hostname = hs.host.localizedName()

function _G.launchOrFocus(modifiers, key, appName)
   hs.hotkey.bind(modifiers, key, function()
      local success = hs.application.launchOrFocus(appName)
      print(success)
   end)
end

launchOrFocus(hyperkey, "0", "Wezterm")

if hostname == "MacBook Pro14" then
   launchOrFocus(hyperkey, "9", "Microsoft Edge")
   launchOrFocus({ "cmd", "shift", "ctrl" }, "9", "Google Chrome")
else
   launchOrFocus(hyperkey, "9", "Google Chrome")
   launchOrFocus({ "cmd", "shift", "ctrl" }, "9", "Microsoft Edge")
end

-- Windows grids ---------------------------------------------------------
--------------------------------------------------------------------------

hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.GRIDWIDTH = 6
hs.grid.GRIDHEIGHT = 4

-- show interactive modal interface for a 3x3 grid
hs.hotkey.bind(hyperkey, "G", function()
   hs.grid.show()
end)

function _G.moveAndResizeFocused(callback)
   local win = hs.window.focusedWindow()
   local f = win:frame()
   local screenMax = win:screen():frame()
   local prevW = f.w
   local prevH = f.h

   callback(f, screenMax)
   local needsResize = not (within(f.h, prevH, 1) and within(f.w, prevW, 1))
   win:setFrame(f, needsResize and 0 or 0.1)
end

-- Left half
hs.hotkey.bind(hyperkey, "H", function()
   moveAndResizeFocused(function(frame, screen)
      frame.x = screen.x
      frame.y = screen.y
      frame.w = screen.w / 2
      frame.h = screen.h
   end)
end)

-- Left two thirds
-- hs.hotkey.bind(hyperkey, "U", function()
-- 	local win = hs.window.focusedWindow()
-- 	local frame = win:frame()
-- 	local screen = win:screen():frame()
-- 	if frame.x == screen.x and frame.y == screen.y and frame.w == screen.w * 2 / 3 and frame.h == screen.h then
-- 		moveAndResizeFocused(function(frame, screen)
-- 			frame.x = screen.x
-- 			frame.y = screen.y
-- 			frame.w = screen.w * 1 / 3
-- 			frame.h = screen.h
-- 		end)
-- 		return
-- 	end
-- 	moveAndResizeFocused(function(frame, screen)
-- 		frame.x = screen.x
-- 		frame.y = screen.y
-- 		frame.w = screen.w * 2 / 3
-- 		frame.h = screen.h
-- 	end)
-- end)

-- Right half
hs.hotkey.bind(hyperkey, "L", function()
   moveAndResizeFocused(function(frame, screen)
      frame.x = screen.x + (screen.w / 2)
      frame.y = screen.y
      frame.w = screen.w / 2
      frame.h = screen.h
   end)
end)

-- Right two thirds
-- hs.hotkey.bind(hyperkey, "I", function()
-- 	local win = hs.window.focusedWindow()
-- 	local frame = win:frame()
-- 	local screen = win:screen():frame()
-- 	if
-- 		frame.x == screen.x + screen.w / 3
-- 		and frame.y == screen.y
-- 		and frame.w == screen.w * 2 / 3
-- 		and frame.h == screen.h
-- 	then
-- 		moveAndResizeFocused(function(frame, screen)
-- 			frame.x = screen.x + screen.w * 2 / 3
-- 			frame.y = screen.y
-- 			frame.w = screen.w * 1 / 3
-- 			frame.h = screen.h
-- 		end)
-- 		return
-- 	end
-- 	moveAndResizeFocused(function(frame, screen)
-- 		frame.x = screen.x + screen.w / 3
-- 		frame.y = screen.y
-- 		frame.w = screen.w * 2 / 3
-- 		frame.h = screen.h
-- 	end)
-- end)

-- Left 60
-- hs.hotkey.bind(hyperkey, "Y", function()
-- 	moveAndResizeFocused(function(frame, screen)
-- 		frame.x = screen.x
-- 		frame.y = screen.y
-- 		frame.w = screen.w * 0.6
-- 		frame.h = screen.h
-- 	end)
-- end)

-- Right 40
-- hs.hotkey.bind(hyperkey, "O", function()
-- 	moveAndResizeFocused(function(frame, screen)
-- 		frame.x = screen.x + (screen.w * 0.6)
-- 		frame.y = screen.y
-- 		frame.w = screen.w * 0.4
-- 		frame.h = screen.h
-- 	end)
-- end)

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

_G.quadKey = { "cmd", "ctrl", "shift" }

-- Top left quadrant
hs.hotkey.bind(quadKey, "J", function()
   moveAndResizeFocused(function(frame, screen)
      frame.x = screen.x
      frame.y = screen.y
      frame.w = screen.w / 2
      frame.h = screen.h / 2
   end)
end)

-- Top right quadrant
hs.hotkey.bind(quadKey, "K", function()
   moveAndResizeFocused(function(frame, screen)
      frame.x = screen.x + (screen.w / 2)
      frame.y = screen.y
      frame.w = screen.w / 2
      frame.h = screen.h / 2
   end)
end)

-- Bottom left quadrant
hs.hotkey.bind(quadKey, "N", function()
   moveAndResizeFocused(function(frame, screen)
      frame.x = screen.x
      frame.y = screen.y + (screen.h / 2)
      frame.w = screen.w / 2
      frame.h = screen.h / 2
   end)
end)

-- Bottom right quadrant
-- hs.hotkey.bind(quadKey, "M", function()
--   moveAndResizeFocused(function (frame, screen)
--     frame.x = screen.x + (screen.w / 2)
--     frame.y = screen.y + (screen.h / 2)
--     frame.w = screen.w / 2
--     frame.h = screen.h / 2
--   end)
-- end)

-- Middle 60%
hs.hotkey.bind(quadKey, "M", function()
   moveAndResizeFocused(function(frame, screen)
      frame.x = screen.x + (screen.w * 0.15)
      frame.y = screen.y
      frame.w = screen.w * 0.7
      frame.h = screen.h * 0.99
   end)
end)

-- Resize and center windows ---------------------------------------------
--------------------------------------------------------------------------
function _G.resizeAndCenter(frac)
   local win = hs.window.focusedWindow()
   local f = win:frame()
   local screenMax = win:screen():frame()

   f.w = screenMax.w * frac
   f.h = screenMax.h * frac
   f.x = screenMax.x + (screenMax.w - f.w) / 2
   f.y = screenMax.y + (screenMax.h - f.h) / 2
   win:setFrame(f, 0)
end

-- Maximize window
hs.hotkey.bind(hyperkey, "M", function()
   resizeAndCenter(0.99)
end)

-- Resize window
hs.hotkey.bind(hyperkey, "N", function()
   resizeAndCenter(0.81)
end)

-- Resize window
hs.hotkey.bind(hyperkey, "B", function()
   resizeAndCenter(0.64)
end)

-- Resize window
hs.hotkey.bind(hyperkey, "V", function()
   resizeAndCenter(0.49)
end)

-- Change monitor --------------------------------------------------------
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

-- Arrow key remaps ------------------------------------------------------
--------------------------------------------------------------------------
function _G.pressAndHoldKey(key)
   return function()
      hs.eventtap.keyStroke({}, key, 1000)
   end
end

function _G.simpleKeyRemap(modMap, keyMap, sendKey)
   hs.hotkey.bind(modMap, keyMap, pressAndHoldKey(sendKey), nil, pressAndHoldKey(sendKey))
end

simpleKeyRemap({ "ctrl", "alt" }, "J", "DOWN")
simpleKeyRemap({ "ctrl", "alt" }, "K", "UP")
simpleKeyRemap({ "ctrl", "alt" }, "H", "LEFT")
simpleKeyRemap({ "ctrl", "alt" }, "L", "RIGHT")

-- Modal mode ------------------------------------------------------------
--------------------------------------------------------------------------
-- appCuts = {
--   i = 'iterm',
--   c = 'Google chrome'
-- }

-- Caffeine menubar app --------------------------------------------------
--------------------------------------------------------------------------

local caffeine = hs.menubar.new()
function _G.setCaffeineDisplay(state)
   if state then
      caffeine:setTitle("A")
   else
      caffeine:setTitle("S")
   end
end

function _G.caffeineClicked()
   setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
   caffeine:setClickCallback(caffeineClicked)
   setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- Wifi switcher ---------------------------------------------------------
--------------------------------------------------------------------------

local wifiWatcher = nil
local homeSSID = "ORBI66"
local lastSSID = hs.wifi.currentNetwork()

function _G.ssidChangedCallback()
   local newSSID = hs.wifi.currentNetwork()

   if newSSID == homeSSID and lastSSID ~= homeSSID then
      -- We just joined our home WiFi network
      hs.audiodevice.defaultOutputDevice():setVOlume(25)
      hs.alert.show("Home network: setting volume.")
   elseif newSSID ~= homeSSID and lastSSID == homeSSID then
      -- We just departed our home WiFi network
      hs.alert.show("External network: muting volume.")
      hs.audiodevice.defaultOutputDevice():setVolume(0)
   end

   lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

-- Playground ------------------------------------------------------------
--------------------------------------------------------------------------
-- hs.dialog.alert()

-- k = hs.hotkey.modal.new({ "cmd", "ctrl" }, "I");
-- function k:entered()
--   hs.alert.show("Entered mode")
-- end
-- function k:exited()
--   hs.alert.show("Exited mode")
-- end
-- k:bind("", "escape", function()
--   k:exit()
-- end)
-- k:bind("", "I", "Select app", function()
--   for key, app in pairs(appCuts) do
--     hs.hotkey.bind({}, key, function()
--       k:exit()
--       hs.application.launchOrFocus(app)
--     end)
--   end
-- end)

--  Media remaps ---------------------------------------------------------
--------------------------------------------------------------------------

local cmdShift = { "cmd", "shift" }

hs.hotkey.bind(cmdShift, ".", function()
   hs.eventtap.event.newSystemKeyEvent("NEXT", true):post()
   hs.eventtap.event.newSystemKeyEvent("NEXT", false):post()
end)

hs.hotkey.bind(cmdShift, ",", function()
   hs.eventtap.event.newSystemKeyEvent("PREVIOUS", true):post()
   hs.eventtap.event.newSystemKeyEvent("PREVIOUS", false):post()
end)

hs.hotkey.bind(cmdShift, "/", function()
   hs.eventtap.event.newSystemKeyEvent("PLAY", true):post()
   hs.eventtap.event.newSystemKeyEvent("PLAY", false):post()
end)

-- hs.hotkey.bind(hyperkey, ".", function()
--    hs.eventtap.event.newSystemKeyEvent("NEXT", true):post()
--    hs.eventtap.event.newSystemKeyEvent("NEXT", false):post()
-- end)
--
-- hs.hotkey.bind(hyperkey, ",", function()
--    hs.eventtap.event.newSystemKeyEvent("PREVIOUS", true):post()
--    hs.eventtap.event.newSystemKeyEvent("PREVIOUS", false):post()
-- end)
--
-- hs.hotkey.bind(hyperkey, "/", function()
--    hs.eventtap.event.newSystemKeyEvent("PLAY", true):post()
--    hs.eventtap.event.newSystemKeyEvent("PLAY", false):post()
-- end)

-- Notes -----------------------------------------------------------------
--------------------------------------------------------------------------
--[[

Get the name of screens
  hs.screen.allScreens()[1]:name()

Get the name of running apps
  hs.fnutils.each(hs.application.runningApplications(), function(app) print(app:title()) end)


--]]
-- Native notification example
-- hs.hotkey.bind(hyperkey, "W", function()
--   hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
-- end)

hs.alert.show("Config loaded")
