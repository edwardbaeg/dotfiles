local constants = require("common/constants")
local hyperkey, allkey = constants.hyperkey, constants.allkey

local M = {}

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

-- Function to get the current personal override state
local function isPersonalOverride()
   return hs.settings.get("isPersonalOverride") or false
end
M.isPersonalOverride = isPersonalOverride

-- Function to set up Arc hotkeys based on current state
-- TODO: move out to module
local function setupArcHotkeys()
   -- Clear existing Arc hotkeys
   hs.hotkey.disableAll(hyperkey, "9")
   hs.hotkey.disableAll(allkey, "9")

   local setPersonal = function()
      setArcProfile("2")
   end
   local setWork = function()
      setArcProfile("4")
   end

   if isPersonalOverride() then
      assignAppHotKey(hyperkey, "9", "Arc", setPersonal)
      assignAppHotKey(allkey, "9", "Arc", setWork)
   elseif constants.isPersonal then
      assignAppHotKey(hyperkey, "9", "Arc")
      assignAppHotKey(allkey, "9", "Arc")
   else
      assignAppHotKey(hyperkey, "9", "Arc", setWork)
      assignAppHotKey(allkey, "9", "Arc", setPersonal)
   end
end

local personalOverrideMenuBar = hs.menubar.new()

local function enablePersonalOverride()
   if personalOverrideMenuBar then
      personalOverrideMenuBar:setTitle("P")
   end
   hs.settings.set("isPersonalOverride", true)
   setupArcHotkeys()
end

hs.urlevent.bind("enablePersonalOverride", function()
   enablePersonalOverride()
end)

local function disablePersonalOverride()
   if personalOverrideMenuBar then
      personalOverrideMenuBar:setTitle("-")
   end
   hs.settings.set("isPersonalOverride", false)
   setupArcHotkeys()
end

hs.urlevent.bind("disablePersonalOverride", function()
   disablePersonalOverride()
end)

M.togglePersonalOverride = function()
   if isPersonalOverride() then
      disablePersonalOverride()
   else
      enablePersonalOverride()
   end
end

local mappings = {
   -- { "0", "Kitty" },
   { ";", "Kitty" },
   { "8", "Slack" },
   { "P", "Perplexity" },
}

function Main()
   -- Initialize menu bar title based on saved state
   if personalOverrideMenuBar then
      personalOverrideMenuBar:setTitle(isPersonalOverride() and "P" or "-")
   end

   for _, pair in pairs(mappings) do
      assignAppHotKey(hyperkey, pair[1], pair[2])
   end

   setupArcHotkeys()

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

   hs.urlevent.bind("arc", function(_name, params)
      local success = hs.application.launchOrFocus("Arc")
      if success and params.profile ~= nil and params.profile ~= "" then
         setArcProfile(params.profile)
      end
   end)

   hs.hotkey.bind(hyperkey, "0", function()
      hs.alert("Deprecated. Use ;")
   end)

   hs.hotkey.bind(hyperkey, "w", function()
      -- NOTE: need to use full paths
      -- TODO: consider auto attaching to a tmux session
      hs.task
         .new("/bin/bash", nil, { "-c", "cd $HOME/dev/dotfiles && /opt/homebrew/bin/kitten quick-access-terminal" })
         :start()
   end)
end

Main()

return M
