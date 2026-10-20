---@type Constants
local constants = require("common/constants")
local hyperkey, allkey = constants.hyperkey, constants.allkey
local toggleFeature = require("common/toggle_feature")

local M = {}

local BROWSER_KEY = ";"
-- local BROWSER_KEY = "9"

local PERSONAL_PROFILE = "2"
local WORK_PROFILE = "4"

---@type fun(modifiers: table, key: string, appName: string, callback?: function)
local assignAppHotKey

---@param profileIndex string
local function setArcProfile(profileIndex)
   hs.eventtap.keyStroke({ "ctrl" }, profileIndex)
   hs.timer.doAfter(0.05, function()
      hs.eventtap.keyStroke({ "ctrl" }, profileIndex)
   end)
   -- hs.timer.doAfter(0.1, function()
   --    hs.eventtap.keyStroke({ "ctrl" }, profileIndex)
   -- end)
end

-- Forward declaration for setupArcHotkeys
local setupArcHotkeys

-- Create personal override toggle feature using the common abstraction
local personalOverride = toggleFeature.new({
   name = "personalOverride",
   abbreviation = "PO",
   settingsKey = "isPersonalOverride",
   onEnable = function()
      setupArcHotkeys()
   end,
   onDisable = function()
      setupArcHotkeys()
   end,
   defaultState = false,
   registryName = "personalOverride",
})

M.isPersonalOverride = function()
   return personalOverride.isEnabled()
end

M.togglePersonalOverride = function()
   personalOverride.toggle()
end

-- Function to set up Arc hotkeys based on current state
setupArcHotkeys = function()
   -- Toggling the override can fire before setup() has received the hotkey binder
   if not assignAppHotKey then
      return
   end

   -- Clear existing Arc hotkeys
   hs.hotkey.disableAll(hyperkey, BROWSER_KEY)
   hs.hotkey.disableAll(allkey, BROWSER_KEY)

   local setPersonal = function()
      setArcProfile(PERSONAL_PROFILE)
   end
   local setWork = function()
      setArcProfile(WORK_PROFILE)
   end

   if personalOverride.isEnabled() then
      assignAppHotKey(hyperkey, BROWSER_KEY, "Arc", setPersonal)
      assignAppHotKey(allkey, BROWSER_KEY, "Arc", setWork)
   elseif constants.isPersonal then
      assignAppHotKey(hyperkey, BROWSER_KEY, "Arc")
      assignAppHotKey(allkey, BROWSER_KEY, "Arc")
   else
      assignAppHotKey(hyperkey, BROWSER_KEY, "Arc", setWork)
      assignAppHotKey(allkey, BROWSER_KEY, "Arc", setPersonal)
   end
end

-- Passed in rather than required to avoid a circular require with application_launcher
---@param hotKeyBinder fun(modifiers: table, key: string, appName: string, callback?: function)
function M.setup(hotKeyBinder)
   assignAppHotKey = hotKeyBinder

   setupArcHotkeys()

   -- usage: hammerspoon://arcPersonal
   hs.urlevent.bind("arcPersonal", function()
      local success = hs.application.launchOrFocus("Arc")
      if success then
         setArcProfile(PERSONAL_PROFILE)
      end
   end)

   -- usage: hammerspoon://arcWork
   hs.urlevent.bind("arcWork", function()
      local success = hs.application.launchOrFocus("Arc")
      if success then
         setArcProfile(WORK_PROFILE)
      end
   end)

   hs.urlevent.bind("arc", function(_name, params)
      local success = hs.application.launchOrFocus("Arc")
      if success and params.profile ~= nil and params.profile ~= "" then
         setArcProfile(params.profile)
      end
   end)
end

return M
