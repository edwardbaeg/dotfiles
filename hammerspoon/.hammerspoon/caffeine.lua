local isPersonal = require("constants").isPersonal

-- Caffeine menubar app --------------------------------------------------
--------------------------------------------------------------------------
-- Caffeine state can be toggled by clicking on the menu bar
-- or by linking to `hammerspoon://toggleCaffineState?state={true|false}`

-- Create menubar item for tracking caffeinated state
-- TODO: persist state using hs.settings
-- https://www.hammerspoon.org/docs/hs.settings.html
local caffeineMenuBar = hs.menubar.new()
local function setCaffeineDisplay(state)
   if caffeineMenuBar then
      if state then
         caffeineMenuBar:setTitle("A") -- for awake
      else
         caffeineMenuBar:setTitle("S") -- for sleep
      end
   end
end

local sleepType = "displayIdle"
local enableCaffeine = function()
   hs.caffeinate.set(sleepType, true)
   setCaffeineDisplay(true)
end

local disableCaffeine = function()
   hs.caffeinate.set(sleepType, false)
   setCaffeineDisplay(false)
end

-- TODO: add some way to automatically disable awake after some time
local toggleCaffeine = function()
   setCaffeineDisplay(hs.caffeinate.toggle(sleepType))
end

---@diagnostic disable-next-line: unused-local _eventName is unused
local handleCaffeineUrl = function(_eventName, params)
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

local function caffeineClicked()
   toggleCaffeine()
end

if caffeineMenuBar then
   caffeineMenuBar:setClickCallback(caffeineClicked)
   setCaffeineDisplay(hs.caffeinate.get(sleepType))
end

-- Usage: hammerspoon://toggleCaffeineState?state={true|false}
hs.urlevent.bind("toggleCaffeineState", handleCaffeineUrl)
hs.urlevent.bind("enableCaffeine", enableCaffeine)
hs.urlevent.bind("disableCaffeine", disableCaffeine)

-- Toggle sleepmode for ryujinx
local watchRyujinx = function(appName, eventType)
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
