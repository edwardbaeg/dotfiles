---@type Constants
local constants = require("common/constants")
local hyperkey, allkey = constants.hyperkey, constants.allkey
local toggleFeature = require("common/toggle_feature")

local M = {}

-- TODO?: if the application is already focused, then hide it
---@param modifiers table
---@param key string
---@param appName string
---@param callback? function
local function assignAppHotKey(modifiers, key, appName, callback)
   hs.hotkey.bind(modifiers, key, function()
      local targetApp = hs.application.find(appName)
      print("targetApp", targetApp)
      -- NOTE: this doesnt always work for some applications
      if targetApp == nil then
         hs.alert("Launching " .. appName)
      end
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
   -- hs.timer.doAfter(0.1, function()
   --    hs.eventtap.keyStroke({ "ctrl" }, profileIndex)
   -- end)
end

local BROWSER_KEY = ";"
-- local BROWSER_KEY = "9"

-- Forward declaration for setupArcHotkeys
local setupArcHotkeys

-- Create personal override toggle feature using the common abstraction
local personalOverride = toggleFeature.new({
   name = "personalOverride",
   settingsKey = "isPersonalOverride",
   menubar = {
      enabledTitle = "P",
      disabledTitle = "-P"
   },
   onEnable = function()
      setupArcHotkeys()
   end,
   onDisable = function()
      setupArcHotkeys()
   end,
   defaultState = false
})

-- Export for compatibility
M.isPersonalOverride = function()
   return personalOverride.isEnabled()
end

-- Function to set up Arc hotkeys based on current state
-- TODO: move out to module
setupArcHotkeys = function()
   -- Clear existing Arc hotkeys
   hs.hotkey.disableAll(hyperkey, BROWSER_KEY)
   hs.hotkey.disableAll(allkey, BROWSER_KEY)

   local setPersonal = function()
      setArcProfile("2")
   end
   local setWork = function()
      setArcProfile("4")
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

-- Export toggle function for compatibility
M.togglePersonalOverride = function()
   personalOverride.toggle()
end

local mappings = {
   -- { "0", "Kitty" },
   { "return", "Kitty" },
   { "'", "Kitty" },
   -- { "8", "Slack" },
   { "P", "Claude" },
   -- { "P", "Perplexity" },
}

function Main()

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
      hs.alert("Deprecated. Use <enter>")
   end)

   hs.hotkey.bind(hyperkey, "9", function()
      hs.alert("Deprecated. Use ;")
   end)

   -- replaced with iterm2 hotkey window
   -- hs.hotkey.bind(hyperkey, "w", function()
   --    -- NOTE: need to use full paths
   --    -- TODO: consider auto attaching to a tmux session
   --    hs.task
   --       .new("/bin/bash", nil, { "-c", "cd $HOME/dev/dotfiles && /opt/homebrew/bin/kitten quick-access-terminal" })
   --       :start()
   -- end)
end

Main()

return M
