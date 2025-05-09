local appLauncher = require("application_launcher")
local togglePersonalOverride = appLauncher.togglePersonalOverride
local isPersonalOverride = appLauncher.isPersonalOverride

local d = hs.hotkey.modal.new({ "cmd", "ctrl" }, "d")
local id

function d:entered()
   local modalMessage = table.concat({
      "Modal mode:\n",
      "S: Open Raycast snippets",
      "T: Open Telegram",
      "C: Open Cursor",
      "P: Toggle personal override (currently: " .. (isPersonalOverride() and "on" or "off") .. ")",
      "\n<Esc> Exit",
   }, "\n")
   id = hs.alert.show(modalMessage, "indefinite")
end

function d:exited()
   hs.alert.closeSpecific(id, 0.1)
   -- hs.alert("Exited Modal Mode")
end

d:bind("", "escape", function()
   -- hs.alert("Exited Modal Mode", 0.1)
   d:exit()
end)

d:bind("", "S", nil, function()
   hs.urlevent.openURL("raycast://extensions/raycast/snippets/search-snippets")
   d:exit()
end)

d:bind("", "T", nil, function()
   hs.application.launchOrFocus("Telegram")
   d:exit()
end)

d:bind("", "C", nil, function()
   hs.application.launchOrFocus("Cursor")
   d:exit()
end)

d:bind("", "P", nil, function()
   togglePersonalOverride()
   d:exit()
end)
