-- Set up modifier combos
-- TODO: add typings
local module = {}

module.hyperkey = { "cmd", "ctrl" }
module.cmdShift = { "cmd", "shift" }
module.altShift = { "alt", "shift" }
module.allkey = { "cmd", "ctrl", "shift" }

local hostname = hs.host.localizedName()
module.isPersonal = hostname == "MacBook Pro14"

-- screen edge padding
M.screenPadding = 6

return module
