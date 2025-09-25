---@alias ModifierKeys string[] Array of modifier key names

---@class Color
---@field red number Red component (0-1)
---@field green number Green component (0-1)
---@field blue number Blue component (0-1)
---@field alpha number Alpha component (0-1)

---@class Colors
---@field orange Color
---@field grey Color
---@field lightBlue Color
---@field purple Color
---@field navy Color

---@class Constants
---@field hyperkey ModifierKeys Modifier keys for hyperkey (cmd + ctrl)
---@field cmdShift ModifierKeys Modifier keys for cmd + shift
---@field altShift ModifierKeys Modifier keys for alt + shift
---@field allkey ModifierKeys Modifier keys for cmd + ctrl + shift
---@field isPersonal boolean Whether this is running on personal machine
---@field screenPadding number Screen edge padding in pixels
---@field colors Colors Color definitions
local M = {}

M.hyperkey = { "cmd", "ctrl" }
M.cmdShift = { "cmd", "shift" }
M.altShift = { "alt", "shift" }
M.allkey = { "cmd", "ctrl", "shift" }

---@type string
local hostname = hs.host.localizedName()
M.isPersonal = hostname == "MacBook Pro14"

M.screenPadding = 5

local catppuccin = require("common.external.catpuccin-frappe")

M.colors = {
   orange = catppuccin.getRgbColor("base", 0.9),      -- Very dark for Raycast modal
   grey = catppuccin.getRgbColor("surface0", 0.9),    -- Keep main modal as is
   lightBlue = catppuccin.getRgbColor("base", 0.9),   -- Very dark for Editor modal
   purple = catppuccin.getRgbColor("base", 0.9),      -- Very dark for purple modal
   navy = catppuccin.getRgbColor("mantle", 0.9),      -- Darkest for navy
}

return M
