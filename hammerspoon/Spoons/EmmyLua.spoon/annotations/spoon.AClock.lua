--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Just another clock, floating above all.
--
-- Configurable properties (with default values):
--     format = "%H:%M",
--     textFont = "Impact",
--     textSize = 135,
--     textColor = {hex="#1891C3"},
--     width = 320,
--     height = 230,
--     showDuration = 4,  -- seconds
--     hotkey = 'escape',
--     hotkeyMods = {},
--
-- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/AClock.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/AClock.spoon.zip)
---@class spoon.AClock
local M = {}
spoon.AClock = M

-- Hide AClock.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The AClock object
function M:hide() end

-- init.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The AClock object
function M:init() end

-- Show AClock.
--
-- Parameters:
--  * None
--
-- Returns:
--  * The AClock object
function M:show() end

-- Show AClock for 4 seconds. If already showing, hide it.
function M:toggleShow() end

-- Show AClock. If already showing, hide it.
function M:toggleShowPersistent() end

