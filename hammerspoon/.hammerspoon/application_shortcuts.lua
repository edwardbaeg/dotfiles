-- App specific keybindings

function Linear()
   local function linearCopyUrl()
      local linearApp = hs.application.find("Linear")
      if linearApp then
         linearApp:activate()
         hs.eventtap.keyStroke({ "cmd", "shift" }, "c", linearApp)
      end
   end

   -- usage: hammerspoon://linearCopyUrl
   hs.urlevent.bind("linearCopyUrl", function()
      linearCopyUrl()
   end)

   local mapLinearCopyUrl = hs.hotkey.new({ " ctrl " }, "c", linearCopyUrl)
   hs.window.filter
      .new("Linear")
      :subscribe(hs.window.filter.windowFocused, function()
         mapLinearCopyUrl:enable()
      end)
      :subscribe(hs.window.filter.windowUnfocused, function()
         mapLinearCopyUrl:disable()
      end)
end

function Main()
   Linear()
end

Main()
