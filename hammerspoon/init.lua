-- ~/.hammerspoon/init.lua
require("config_reloader") -- config watcher and reloader, load this first

require("application_launcher") -- app launcher and switcher
require("caffeine") -- force awake menubar
require("modals") -- modal mode keymaps
require("remapper") -- simple system keymaps
require("url_listeners") -- url listeners
require("window_grid") -- grid window positions
require("window_management") -- window sizing and positions

-- NOTE: these are disabled because they are very slow
-- require("application_shortcuts") -- app specific keymaps
-- require("window_highlight") -- replaced with janky borders

-- Install command line interface `hs`
hs.ipc.cliInstall()

-- Builds annotations for Hammerspoon and install Spoons for lua lsp in ${configDir}/annotations
-- This requires configuring lua_lsp workspace.library to point to the annotations dir
-- https://github.com/Hammerspoon/Spoons/pull/240
hs.loadSpoon("EmmyLua")

-- Use Spotlight to find alternative application names for hs.application.find (and similar)
hs.application.enableSpotlightForNameSearches(true)

-- Run this last
hs.alert("Config loaded!")
