-- ~/.hammerspoon/init.lua
-- TODO: split up this into modules

local remap = require("mappings")
local mod = require("modifiers") -- TODO: consider renaming to constants and adding others

require("application_launcher")
require("caffeine")
require("config_reloader")
require("wifi")
require("window_grid")
require("window_highlight")
require("window_management")

---@diagnostic disable-next-line: undefined-global
local hs = hs

-- Install command line interface as `hs`
hs.ipc.cliInstall()

-- Remaps ----------------------------------------------------------------
--------------------------------------------------------------------------

hs.hotkey.bind({ "cmd" }, "M", function()
   hs.alert("[ cmd + m ] disabled") -- minimizes the current window. Annoying because does not unminimize on focus
end)

-- Arrow keys
remap.sendKey(mod.cmdShift, "J", {}, "DOWN")
remap.sendKey(mod.cmdShift, "K", {}, "UP")
remap.sendKey(mod.cmdShift, "H", {}, "LEFT")
remap.sendKey(mod.cmdShift, "L", {}, "RIGHT")

-- Arrow and option
remap.sendKey(mod.altShift, "H", { "alt" }, "LEFT")
remap.sendKey(mod.altShift, "L", { "alt" }, "RIGHT")

-- Media controls
remap.sendSystemKey(mod.cmdShift, ".", "NEXT")
remap.sendSystemKey(mod.cmdShift, ",", "PREVIOUS")
remap.sendSystemKey(mod.cmdShift, "/", "PLAY")
remap.sendSystemKey(mod.cmdShift, "o", "SOUND_UP")
remap.sendSystemKey(mod.cmdShift, "i", "SOUND_DOWN")

-- Spoons ----------------------------------------------------------------
--------------------------------------------------------------------------
-- Builds annotations for Hammerspoon and install Spoons for lua lsp in ${configDir}/annotations
-- This requires configuring lua_lsp workspace.library to point to the annotations dir
-- https://github.com/Hammerspoon/Spoons/pull/240
hs.loadSpoon("EmmyLua")

-- App Specific bindings -------------------------------------------------
--------------------------------------------------------------------------
-- hs.loadSpoon("AppBindings")
-- spoon.AppBindings:bind("Google Chrome", { -- this is the same as vimium H / L
--    { { "alt", "ctrl" }, "l", { "ctrl" }, "tab" },
--    { { "alt", "ctrl" }, "h", { "ctrl", "shift" }, "tab" },
-- })

-- These may be causing preformance issues
-- spoon.AppBindings:bind("Arc", { -- option tab doesn't work...
--    { { "alt" }, "tab", { "ctrl" }, "tab" },
--    { { "alt" }, "tab", { "ctrl", "shift" }, "tab" },
-- })
-- spoon.AppBindings:bind("Arc", { -- option tab doesn't work...
--    { { "alt", "ctrl" }, "l", { "ctrl" }, "tab" },
--    { { "alt", "ctrl" }, "h", { "ctrl", "shift" }, "tab" },
-- })

-- Notes -----------------------------------------------------------------
--------------------------------------------------------------------------
--[[

Created ojects should be captured in gloal variables.
Otherwise, they will be garbage collected.
https://www.hammerspoon.org/go/ "A quick aside about variable lifecycles"

Get the name of screens
  hs.screen.allScreens()[1]:name()

Get the name of running apps
  hs.fnutils.each(hs.application.runningApplications(), function(app) print(app:title()) end)

Native notification example
   hs.hotkey.bind(mod.hyperkey, "W", function()
     hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
   end)

--]]

hs.alert("Config loaded!")
