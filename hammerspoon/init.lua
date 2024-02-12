-- ~/.hammerspoon/init.lua

local hyperkey = { "cmd", "ctrl" }

---@diagnostic disable-next-line: undefined-global
local hs = hs

-- Install command line interface as `hs`
hs.ipc.cliInstall()

-- Remaps ----------------------------------------------------------------
--------------------------------------------------------------------------
-- TODO: remap caps to control?

local cmdShift = { "cmd", "shift" }
local altShift = { "alt", "shift" }

-- Disable default hotkey
hs.hotkey.bind({ "cmd" }, "M", function()
   hs.alert("[ cmd + m ] disabled")
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

-- Window highlighting ---------------------------------------------------
--------------------------------------------------------------------------
hs.window.highlight.ui.overlayColor = { 0, 0, 0, 0.01 } -- overlay color
hs.window.highlight.ui.overlay = false
hs.window.highlight.ui.frameWidth = 12 -- draw a frame around the focused window in overlay mode; 0 to disable
hs.window.highlight.start()

hs.window.highlight.ui.overlay = true

-- When focusing a window that is fullscreen or not
hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(window)
   local isFullScreen = window:isFullScreen()

   if isFullScreen and hs.window.highlight.ui.overlay then
      hs.window.highlight.ui.overlay = false
   elseif not isFullScreen and not hs.window.highlight.ui.overlay then
      hs.window.highlight.ui.overlay = true
   end
end)

ApplicationWatcher = hs.application.watcher
   .new(function(appName, eventType, _appObject)
      -- When focusing an application that has no windows
      if eventType == hs.application.watcher.activated then
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
hs.window.filter.default:subscribe(hs.window.filter.windowFullscreened, function(window, appName)
   hs.window.highlight.ui.overlay = false
end)
hs.window.filter.default:subscribe(hs.window.filter.windowUnfullscreened, function(window, appName)
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

local personalBrowser = "Arc"
local workBrowser = "Google Chrome"
if hostname == "MacBook Pro14" then
   launchOrFocus(hyperkey, "9", personalBrowser)
   launchOrFocus({ "cmd", "shift", "ctrl" }, "9", workBrowser)
else
   launchOrFocus(hyperkey, "9", workBrowser)
   launchOrFocus({ "cmd", "shift", "ctrl" }, "9", personalBrowser)
end

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
   local f = win:frame()
   local screenMax = win:screen():frame()
   local prevW = f.w
   local prevH = f.h

   callback(f, screenMax)
   local needsResize = not (within(f.h, prevH, 1) and within(f.w, prevW, 1))
   win:setFrame(f, needsResize and 0 or 0.1)
end

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

-- Left half
hs.hotkey.bind(hyperkey, "H", function()
   moveAndResizeFocused(function(frame, screen)
      frame.x = screen.x
      frame.y = screen.y
      frame.w = screen.w / 2
      frame.h = screen.h
   end)
end)

-- Right half
hs.hotkey.bind(hyperkey, "L", function()
   moveAndResizeFocused(function(frame, screen)
      frame.x = screen.x + (screen.w / 2)
      frame.y = screen.y
      frame.w = screen.w / 2
      frame.h = screen.h
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

-- Caffeine menubar app --------------------------------------------------
--------------------------------------------------------------------------
-- Caffeine state can be toggled by clicking on the menu bar
-- or by linking to `hammerspoon://toggleCaffineState?state={true|false}`

local caffeineMenuBar = hs.menubar.new()
function _G.setCaffeineDisplay(state)
   if state then
      caffeineMenuBar:setTitle("A") -- for awake
   else
      caffeineMenuBar:setTitle("S") -- for sleep
   end
end

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
   hs.caffeinate.set("displayIdle", true)
   setCaffeineDisplay(true)
end

_G.disableCaffeine = function()
   hs.caffeinate.set("displayIdle", false)
   setCaffeineDisplay(false)
end

_G.toggleCaffeine = function()
   setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

function _G.caffeineClicked()
   toggleCaffeine()
end

if caffeineMenuBar then
   caffeineMenuBar:setClickCallback(caffeineClicked)
   setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

hs.urlevent.bind("toggleCaffeineState", handleCaffeineUrl)
hs.urlevent.bind("enableCaffeine", enableCaffeine)
hs.urlevent.bind("disableCaffeine", disableCaffeine)

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

WifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
WifiWatcher:start()

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
