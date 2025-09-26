local M = {}

-- functions for remapping key combos with press and hold behavior
local function getPressAndHoldFn(sendModifiers, key)
   return function()
      hs.eventtap.keyStroke(sendModifiers, key, 1000)
   end
end

function M.sendKey(modifiers, key, sendModifiers, sendKey)
   hs.hotkey.bind(
      modifiers,
      key,
      getPressAndHoldFn(sendModifiers, sendKey),
      nil,
      getPressAndHoldFn(sendModifiers, sendKey)
   )
end

-- TODO: rename
function M.sendSystemKey(modifiers, key, sendKey)
   hs.hotkey.bind(modifiers, key, function()
      -- TODO: abstract this
      hs.eventtap.event.newSystemKeyEvent(sendKey, true):post()
      hs.eventtap.event.newSystemKeyEvent(sendKey, false):post()
   end)
end

hs.hotkey.bind({ "cmd" }, "m", function()
   hs.alert("[ cmd + m ] disabled") -- minimizes the current window. Annoying because does not unminimize on focus
end)

-- NOTE: detecting if the app had switched does not seem to work
function M.restoreAppFocus(callback)
   local currentApp = hs.application.frontmostApplication()

   callback()

   -- Wait for operations to complete
   hs.timer.usleep(100000) -- 0.1s

   currentApp:activate()
end

function M.switchArcToWorkTab(tabIndex)
   hs.application.launchOrFocus("Arc")

   -- Wait for operations to complete
   hs.timer.usleep(100000)                              -- 0.1s

   hs.eventtap.keyStroke({ "ctrl" }, "4")               -- switch to work
   hs.eventtap.keyStroke({ "cmd" }, tostring(tabIndex)) -- switch to tab
end

return M
