---@type Constants
local constants = require("common/constants")
local isPersonal = constants.isPersonal

-- Caffeine menubar app --------------------------------------------------
--------------------------------------------------------------------------
-- Caffeine state can be toggled by clicking on the menu bar
-- or by linking to `hammerspoon://toggleCaffineState?state={true|false}`

-- Settings key for persisting caffeine state
local CAFFEINE_STATE_KEY = "caffeineState"

-- Create menubar item for tracking caffeinated state
-- TODO: persist state using hs.settings
-- https://www.hammerspoon.org/docs/hs.settings.html
local caffeineMenuBar = hs.menubar.new()

local caffeine = {}

local function setCaffeineDisplay(state)
   if caffeineMenuBar then
      if state then
         caffeineMenuBar:setTitle("A") -- for awake
      else
         caffeineMenuBar:setTitle("S") -- for sleep
      end
      -- Save state to settings
      hs.settings.set(CAFFEINE_STATE_KEY, state)
   end
end

local sleepType = "displayIdle"

function caffeine.enable()
   hs.caffeinate.set(sleepType, true)
   setCaffeineDisplay(true)
end

function caffeine.disable()
   hs.caffeinate.set(sleepType, false)
   setCaffeineDisplay(false)
end

function caffeine.toggle()
   local currentState = hs.caffeinate.get(sleepType)
   local newState = not currentState
   if newState then
      caffeine.enable()
   else
      caffeine.disable()
   end
end

---@diagnostic disable-next-line: unused-local _eventName is unused
local handleCaffeineUrl = function(_eventName, params)
   local state = params["state"]
   if state then
      if state == "true" then
         caffeine.enable()
      elseif state == "false" then
         caffeine.disable()
      else
         hs.alert("state is invalid value")
      end
   else
      caffeine.toggle()
   end
end

local function caffeineClicked()
   caffeine.toggle()
end

if caffeineMenuBar then
   caffeineMenuBar:setClickCallback(caffeineClicked)
   -- Initialize state from settings, defaulting to current system state if not set
   local savedState = hs.settings.get(CAFFEINE_STATE_KEY)
   if savedState ~= nil then
      if savedState then
         caffeine.enable()
      else
         caffeine.disable()
      end
   else
      setCaffeineDisplay(hs.caffeinate.get(sleepType))
   end
end

-- Usage: hammerspoon://toggleCaffeineState?state={true|false}
hs.urlevent.bind("toggleCaffeineState", handleCaffeineUrl)
hs.urlevent.bind("enableCaffeine", caffeine.enable)
hs.urlevent.bind("disableCaffeine", caffeine.disable)

-- Toggle sleepmode for ryujinx
local watchRyujinx = function(appName, eventType)
   if eventType == hs.application.watcher.activated then
      if string.sub(appName, 1, #"Ryujinx") == "Ryujinx" then
         hs.alert("Activating caffeine - Ryujinx")
         caffeine.enable()
      end
   end
   if eventType == hs.application.watcher.deactivated then
      if string.sub(appName, 1, #"Ryujinx") == "Ryujinx" then
         hs.alert("Disabling caffeine - Ryujinx")
         caffeine.disable()
      end
   end
end

if isPersonal then
   -- NOTE: do not create watcher as local variable or it will be garbage collected
   RyujinxWatcher = hs.application.watcher.new(watchRyujinx)
   RyujinxWatcher:start()
end

return caffeine
