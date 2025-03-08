local constants = require("common/constants")
local hyperkey = constants.hyperkey
local allkey = constants.allkey

-- TODO?: if the application is already focused, then hide it
---@param modifiers table
---@param key string
---@param appName string
---@param callback? function
local function assignAppHotKey(modifiers, key, appName, callback)
   hs.hotkey.bind(modifiers, key, function()
      local success = hs.application.launchOrFocus(appName)
      callback = callback or function() end
      if success then
         callback()
      end
   end)
end

---@param profileIndex string
local function setArcProfile(profileIndex)
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
local function getArcProfileSetter(profileIndex)
   return function()
      setArcProfile(profileIndex)
   end
end

local mappings = {
   { "0", "Wezterm" },
   { "8", "Slack" },
}

function Main()
   for _, pair in pairs(mappings) do
      assignAppHotKey(hyperkey, pair[1], pair[2])
   end

   if constants.isPersonal then
      assignAppHotKey(hyperkey, "9", "Arc")
      assignAppHotKey(allkey, "9", "Arc")
   else
      assignAppHotKey(allkey, "9", "Arc", getArcProfileSetter("2")) -- personal
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
