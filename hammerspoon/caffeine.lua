---@type Constants
local constants = require("common/constants")
local isPersonal = constants.isPersonal
local toggleFeature = require("common/toggle_feature")

-- Caffeine menubar app --------------------------------------------------
--------------------------------------------------------------------------
-- Caffeine state can be toggled by clicking on the menu bar
-- or by using URLs:
-- hammerspoon://caffeine?action=enable
-- hammerspoon://caffeine?action=disable
-- hammerspoon://caffeine?action=toggle (or just hammerspoon://caffeine)

local sleepType = "displayIdle"

-- Create caffeine toggle feature using the common abstraction
local caffeine = toggleFeature.new({
   name = "caffeine",
   settingsKey = "caffeineState",
   menubar = {
      enabledTitle = "A", -- for awake
      disabledTitle = "S" -- for sleep
   },
   onEnable = function()
      hs.caffeinate.set(sleepType, true)
   end,
   onDisable = function()
      hs.caffeinate.set(sleepType, false)
   end,
   defaultState = false
})

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

-- Initialize based on current caffeinate state if no saved setting exists
local savedState = hs.settings.get("caffeineState")
if savedState == nil then
   -- Sync with current system state on first run
   local currentSystemState = hs.caffeinate.get(sleepType)
   if currentSystemState then
      caffeine.enable()
   else
      caffeine.disable()
   end
end

return caffeine