-- Set up modifier combos
local module = {}

module.hyperkey = { "cmd", "ctrl" }
module.cmdShift = { "cmd", "shift" }
module.altShift = { "alt", "shift" }
module.allkey = { "cmd", "ctrl", "shift" }

local hostname = hs.host.localizedName()
module.isPersonal = hostname == "MacBook Pro14"

return module
