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

M.colors = {
   orange = {
      red = 0.6,
      green = 0.4,
      blue = 0.2,
      alpha = 1,
   },
   grey = {
      red = 0.3,
      green = 0.3,
      blue = 0.3,
      alpha = 1,
   },
   lightBlue = {
      red = 0.2,
      green = 0.4,
      blue = 0.6,
      alpha = 1,
   },
   purple = {
      red = 0.5,
      green = 0.1,
      blue = 0.6,
      alpha = 0.9,
   },
   navy = {
      red = 0.1,
      green = 0.2,
      blue = 0.4,
      alpha = 0.9,
   },
}

return M
