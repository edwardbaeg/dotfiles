-- Test out modal bindings
local d = hs.hotkey.modal.new({ "cmd", "ctrl" }, "d")
local id

local modalMessage = table.concat({
   "Modal Mode:\n",
   "S: Open Raycast Snippets",
   "T: Open Telegram",
   "C: Open Cursor",
   "\n<Esc> Exit",
}, "\n")

function d:entered()
   id = hs.alert.show(modalMessage, "indefinite")
end

function d:exited()
   hs.alert.closeSpecific(id)
   -- hs.alert("Exited Modal Mode")
end

d:bind("", "escape", function()
   hs.alert("Exited Modal Mode")
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
