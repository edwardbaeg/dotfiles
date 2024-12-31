local constants = require("constants")
local hyperkey = constants.hyperkey

-- TODO?: if the application is already focused, then hide it
---@param modifiers table
---@param key string
---@param appName string
---@param callback? function
function _G.assignAppHotKey(modifiers, key, appName, callback)
   hs.hotkey.bind(modifiers, key, function()
      local success = hs.application.launchOrFocus(appName)
      callback = callback or function() end
      if success then
         callback()
      end
   end)
end

---@param profileIndex string
function _G.setArcProfile(profileIndex)
   hs.eventtap.keyStroke({ "ctrl" }, profileIndex)
   hs.timer.doAfter(0.05, function()
      hs.eventtap.keyStroke({ "ctrl" }, profileIndex)
   end)
   hs.timer.doAfter(0.1, function()
      hs.eventtap.keyStroke({ "ctrl" }, profileIndex)
   end)
end

---@param profileIndex string
---@return function
function _G.getArcProfileSetter(profileIndex)
   return function()
      setArcProfile(profileIndex)
   end
end

function Main()
   assignAppHotKey(hyperkey, "0", "Wezterm")
   assignAppHotKey(hyperkey, "8", "Slack")

   if constants.isPersonal then
      assignAppHotKey(hyperkey, "9", "Arc")
      assignAppHotKey(constants.allkey, "9", "Arc")
   else
      assignAppHotKey(constants.allkey, "9", "Arc", getArcProfileSetter("2")) -- personal
      assignAppHotKey(hyperkey, "9", "Arc", getArcProfileSetter("4")) -- work
   end

   -- usage: hammerspoon://arcPersonal
   hs.urlevent.bind("arcPersonal", function()
      local success = hs.application.launchOrFocus("Arc")
      if success then
         setArcProfile("2")
      end
   end)

   -- usage: hammerspoon://arcWork
   hs.urlevent.bind("arcWork", function()
      local success = hs.application.launchOrFocus("Arc")
      if success then
         setArcProfile("4")
      end
   end)
end

Main()
