-- App specific keybindings

function Main()
   local function linearCopyUrl()
      local linearApp = hs.application.find("Linear")
      if linearApp then
         linearApp:activate()
         hs.eventtap.keyStroke({ "cmd", "shift" }, "c", linearApp)
      end
   end

   local function linearCopyBranchName()
      local linearApp = hs.application.find("Linear")
      if linearApp then
         linearApp:activate()
         hs.eventtap.keyStroke({ "cmd", "shift" }, ".", linearApp)
      end
   end

   -- usage: hammerspoon://linearCopyUrl
   hs.urlevent.bind("linearCopyUrl", function()
      linearCopyUrl()
   end)

   local mapLinearCopyUrl = hs.hotkey.new({ " ctrl " }, "c", linearCopyUrl)
   local mapLinearCopyBranchName = hs.hotkey.new({ " ctrl " }, "b", linearCopyBranchName)
   hs.window.filter
      .new("Linear")
      :subscribe(hs.window.filter.windowFocused, function()
         mapLinearCopyUrl:enable()
         mapLinearCopyBranchName:enable()
      end)
      :subscribe(hs.window.filter.windowUnfocused, function()
         mapLinearCopyUrl:disable()
         mapLinearCopyBranchName:disable()
      end)
end

Main()
