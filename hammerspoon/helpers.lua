local module = {}

-- functions for remapping key combos with press and hold behavior
function module.getPressAndHoldFn(sendModifiers, key)
   return function()
      hs.eventtap.keyStroke(sendModifiers, key, 1000)
   end
end

function module.sendKey(modifiers, key, sendModifiers, sendKey)
   hs.hotkey.bind(
      modifiers,
      key,
      module.getPressAndHoldFn(sendModifiers, sendKey),
      nil,
      module.getPressAndHoldFn(sendModifiers, sendKey)
   )
end

function module.sendSystemKey(modifiers, key, sendKey)
   hs.hotkey.bind(modifiers, key, function()
      hs.eventtap.event.newSystemKeyEvent(sendKey, true):post()
      hs.eventtap.event.newSystemKeyEvent(sendKey, false):post()
   end)
end

hs.hotkey.bind({ "cmd" }, "M", function()
   hs.alert("[ cmd + m ] disabled") -- minimizes the current window. Annoying because does not unminimize on focus
end)

-- NOTE: this doesn't seem to work with window-management, "cannot get focused window"
-- openRaycastDeeplink("raycast://extensions/raycast/window-management/move-right")
-- openRaycastDeeplink("raycast://extensions/raycast/raycast/confetti")
function module.openDeeplink(deeplink)
    hs.execute("open '" .. deeplink .. "'")
end

return module
