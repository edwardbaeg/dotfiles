local mod = require("modifiers")
local hostname = hs.host.localizedName()
local isPersonal = hostname == "MacBook Pro14"

-- Application hotkeys ---------------------------------------------------
--------------------------------------------------------------------------

-- TODO?: if the application is already focused, then hide it
function _G.assignAppHotKey(modifiers, key, appName, callback)
   hs.hotkey.bind(modifiers, key, function()
      local success = hs.application.launchOrFocus(appName)
      callback = callback or function() end
      if success then
         callback()
      end
   end)
end

function _G.arcProfile(profileNum)
   return function()
      hs.eventtap.keyStroke({ "ctrl" }, profileNum)
      hs.timer.doAfter(0.1, function()
         hs.eventtap.keyStroke({ "ctrl" }, profileNum)
      end)
   end
end

assignAppHotKey(mod.hyperkey, "0", "Wezterm")
assignAppHotKey(mod.hyperkey, "8", "Slack")

if isPersonal then
   assignAppHotKey(mod.hyperkey, "9", "Arc")
else -- work
   assignAppHotKey(mod.allkey, "9", "Arc", arcProfile("2")) -- personal
   assignAppHotKey(mod.hyperkey, "9", "Arc", arcProfile("4")) -- work
end

-- LEGACY: separate browsers / keymaps for personal and work
-- local personalBrowser = "Arc"
-- local workBrowser = "Arc"
--
-- if isPersonal then
--    assignAppHotKey(mod.hyperkey, "9", personalBrowser)
--    assignAppHotKey({ "cmd", "shift", "ctrl" }, "9", workBrowser)
-- end
--
-- if not isPersonal then
--    assignAppHotKey(mod.hyperkey, "9", workBrowser, function()
--       hs.eventtap.keyStroke({ "ctrl" }, "4")
--       hs.timer.doAfter(0.1, function()
--          hs.eventtap.keyStroke({ "ctrl" }, "4")
--       end)
--    end)
--    assignAppHotKey({ "cmd", "shift", "ctrl" }, "9", personalBrowser, function()
--       hs.eventtap.keyStroke({ "ctrl" }, "2")
--       hs.timer.doAfter(0.1, function()
--          hs.eventtap.keyStroke({ "ctrl" }, "2")
--       end)
--    end)
-- end
