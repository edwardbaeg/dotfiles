---@alias ModifierKeys string[] Array of modifier key names

---@class Constants
---@field hyperkey ModifierKeys Modifier keys for hyperkey (cmd + ctrl)
---@field cmdShift ModifierKeys Modifier keys for cmd + shift
---@field altShift ModifierKeys Modifier keys for alt + shift
---@field allkey ModifierKeys Modifier keys for cmd + ctrl + shift
---@field isPersonal boolean Whether this is running on personal machine
---@field screenPadding number Screen edge padding in pixels
local M = {}

M.hyperkey = { "cmd", "ctrl" }
M.cmdShift = { "cmd", "shift" }
M.altShift = { "alt", "shift" }
M.allkey = { "cmd", "ctrl", "shift" }

---@type string
local hostname = hs.host.localizedName()
M.isPersonal = hostname == "MacBook Pro14"

M.screenPadding = 6

return M
