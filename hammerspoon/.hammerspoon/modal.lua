local appLauncher = require("application_launcher")
local togglePersonalOverride = appLauncher.togglePersonalOverride
local isPersonalOverride = appLauncher.isPersonalOverride
local caffeine = require("caffeine")

local d = hs.hotkey.modal.new({ "cmd", "ctrl" }, "d")
local id

---@diagnostic disable-next-line: duplicate-set-field
function d:entered()
   local function toggleStatus(value, label)
      return (value and "●" or "○") .. " Toggle " .. label .. " " .. (value and "off" or "on") .. ""
   end

   local modalMessage = table.concat({
      "Modal mode:\n",
      "S: Open Raycast snippets",
      "T: Telegram",
      "U: Cursor",
      "Z: Zen",
      "",
      "C: " .. toggleStatus(hs.caffeinate.get("displayIdle"), "caffeine"),
      "P: " .. toggleStatus(isPersonalOverride(), "personal override"),
      "",
      "<Esc> Exit",
   }, "\n")
   id = hs.alert.show(modalMessage, "indefinite")
end

---@diagnostic disable-next-line: duplicate-set-field
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

d:bind("", "U", nil, function()
   hs.application.launchOrFocus("Cursor")
   d:exit()
end)

d:bind("", "P", nil, function()
   togglePersonalOverride()
   d:exit()
end)

d:bind("", "C", nil, function()
   caffeine.toggle()
   d:exit()
end)

d:bind("", "Z", nil, function()
   hs.application.launchOrFocus("zen")
   d:exit()
end)
