-- ~/.hammerspoon/init.lua

require("application_launcher")
require("application_shortcuts")
require("caffeine")
require("config_reloader")
require("remapper")
-- require("wifi")
require("window_grid")
require("window_highlight")
require("window_management")

-- required but doesn't have executed code
require("constants")
require("helpers")

---@diagnostic disable-next-line: undefined-global
local hs = hs

-- Install command line interface as `hs`
hs.ipc.cliInstall()

-- Builds annotations for Hammerspoon and install Spoons for lua lsp in ${configDir}/annotations
-- This requires configuring lua_lsp workspace.library to point to the annotations dir
-- https://github.com/Hammerspoon/Spoons/pull/240
hs.loadSpoon("EmmyLua")

--[[
Created ojects should be captured in gloal variables.
Otherwise, they will be garbage collected.
https://www.hammerspoon.org/go/ "A quick aside about variable lifecycles"

Get the name of screens
  hs.screen.allScreens()[1]:name()

Get the name of running apps
  hs.fnutils.each(hs.application.runningApplications(), function(app) print(app:title()) end)

Native notification example
Doesn't work anymore?
   hs.hotkey.bind(mod.hyperkey, "W", function()
     hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
   end)
--]]

-- We want to call this last for it to be accurate
hs.alert("Config loaded!")
