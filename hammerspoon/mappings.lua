-- functions for remapping key combos with press and hold behavior
local module = {}

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

return module
