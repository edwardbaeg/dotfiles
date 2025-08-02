local helpers = require("common/helpers")
local sendKey = helpers.sendKey
local sendSystemKey = helpers.sendSystemKey

---@type Constants
local constants = require("common/constants")
local cmdShift = constants.cmdShift
local altShift = constants.altShift

-- Arrow keys
sendKey(cmdShift, "J", {}, "DOWN")
sendKey(cmdShift, "K", {}, "UP")
sendKey(cmdShift, "H", {}, "LEFT")
sendKey(cmdShift, "L", {}, "RIGHT")

-- Arrow and option
sendKey(altShift, "H", { "alt" }, "LEFT")
sendKey(altShift, "L", { "alt" }, "RIGHT")

-- Media controls
sendSystemKey(cmdShift, ".", "NEXT")
sendSystemKey(cmdShift, ",", "PREVIOUS")
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
   hs.execute("open -g raycast://extensions/raycast/window-management/make-larger")
end)
