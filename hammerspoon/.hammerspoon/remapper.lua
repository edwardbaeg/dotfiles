local helpers = require("common/helpers")
local sendKey = helpers.sendKey
local sendSystemKey = helpers.sendSystemKey

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
