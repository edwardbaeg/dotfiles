-- App specific keybindings
function _G.LinearCopyUrl()
   local linearApp = hs.application.find("Linear")
   if (linearApp) then
      linearApp:activate()
      hs.eventtap.keyStroke({ "cmd", "shift" }, "c", linearApp)
   end
end

function Main()
   -- usage: hammerspoon://linearCopyUrl
   hs.urlevent.bind("linearCopyUrl", function()
      LinearCopyUrl()
   end)
   hs.hotkey.bind({ "ctrl" }, "c", function()
      LinearCopyUrl()
   end)
end

Main()
