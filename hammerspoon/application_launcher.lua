local constants = require("constants")

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

function _G.getSetArcProfileFn(profileNum)
   return function()
      hs.eventtap.keyStroke({ "ctrl" }, profileNum)
      hs.timer.doAfter(0.1, function()
         hs.eventtap.keyStroke({ "ctrl" }, profileNum)
      end)
   end
end

assignAppHotKey(constants.hyperkey, "0", "Wezterm")
assignAppHotKey(constants.hyperkey, "8", "Slack")

if constants.isPersonal then
   assignAppHotKey(constants.hyperkey, "9", "Arc")
else
   assignAppHotKey(constants.allkey, "9", "Arc", getSetArcProfileFn("2")) -- personal
   assignAppHotKey(constants.hyperkey, "9", "Arc", getSetArcProfileFn("4")) -- work
end

-- LEGACY: separate browsers / keymaps for personal and work
-- local personalBrowser = "Arc"
-- local workBrowser = "Arc"
--
-- if constants.isPersonal then
--    assignAppHotKey(constants.hyperkey, "9", personalBrowser)
--    assignAppHotKey({ "cmd", "shift", "ctrl" }, "9", workBrowser)
-- end
--
-- if not constants.isPersonal then
--    assignAppHotKey(constants.hyperkey, "9", workBrowser, function()
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
