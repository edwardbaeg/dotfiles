local helpers = require("common/helpers")
local sendKey = helpers.sendKey
local sendSystemKey = helpers.sendSystemKey

---@type Constants
local constants = require("common/constants")
local cmdShift = constants.cmdShift
local altShift = constants.altShift

-- Arrow keys
sendKey(cmdShift, "J", {}, "DOWN")
sendKey(cmdShift, "N", {}, "DOWN")
sendKey(cmdShift, "K", {}, "UP")
sendKey(cmdShift, "P", {}, "UP")
sendKey(cmdShift, "H", {}, "LEFT")
sendKey(cmdShift, "L", {}, "RIGHT")

-- Arrow and option
sendKey(altShift, "H", { "alt" }, "LEFT")
sendKey(altShift, "L", { "alt" }, "RIGHT")

-- Media controls
sendSystemKey(cmdShift, ".", "NEXT")
-- send media previous unless application is raycast
hs.hotkey.bind(cmdShift, ",", function()
   local frontmostApp = hs.application.frontmostApplication()
   if frontmostApp and frontmostApp:name() == "Raycast" then
      hs.eventtap.keyStroke(cmdShift, ",", frontmostApp)
   else
      hs.eventtap.event.newSystemKeyEvent("PREVIOUS", true):post()
      hs.eventtap.event.newSystemKeyEvent("PREVIOUS", false):post()
   end
end)
sendSystemKey(cmdShift, "/", "PLAY")
sendSystemKey(cmdShift, "o", "SOUND_UP")
sendSystemKey(cmdShift, "i", "SOUND_DOWN")

-- Page up/down
sendKey({ "alt", "ctrl" }, "k", {}, "pageup")
sendKey({ "alt", "ctrl" }, "j", {}, "pagedown")

-- Raycast commands can only have one hotkey
-- This command is remapped to cmd+ctrl+shift+= for zmk based keyoards
-- This remap is specific for apple based keyboards
-- TODO: consider if remapping to cmd+ctrl+shift+= is more performant
hs.hotkey.bind(constants.hyperkey, "=", function()
   hs.execute("open -g raycast-x://extensions/raycast/window-management/make-larger")
end)

-- Todoist: cmd+n -> q (quick add). Todoist does not have builtin support to remap.
-- NOTE: use eventtap to so that the keymap can be passed through. Using hs.hotkey
-- fails for things like raycast notes, where the app with keyboard focus is not
-- the frontmost app.
todoistQuickAdd = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
   local isCmdN = event:getKeyCode() == hs.keycodes.map["n"] and event:getFlags():containExactly({ "cmd" })
   if not isCmdN then
      return false
   end

   local frontmostApp = hs.application.frontmostApplication()
   if frontmostApp and frontmostApp:name() == "Todoist" then
      hs.eventtap.keyStroke({}, "q", frontmostApp)
      return true
   end

   return false
end)
todoistQuickAdd:start()
