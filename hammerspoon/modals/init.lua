local Modal = require("common.modal")
local colors = require("common.constants").colors
local processSimpleEntries = require("modals.utils").processSimpleEntries

local mainModalEntries    = require("modals.main")
local editorEntries       = require("modals.submodals.editor")
local raycastEntries      = require("modals.submodals.raycast")
local hammerspoonEntries  = require("modals.submodals.hammerspoon")
local systemEntries       = require("modals.submodals.system")
local browserEntries      = require("modals.submodals.browser")
local dispatchEntries     = require("modals.submodals.dispatch")

local M = {}

-- Create submodals first
M.submodals = {
   editor = Modal.new({
      entries = function(m)
         return processSimpleEntries(editorEntries, m, {})
      end,
      fillColor = colors.lightBlue,
   }),
   raycast = Modal.new({
      entries = function(m)
         return processSimpleEntries(raycastEntries, m, {})
      end,
      fillColor = colors.orange,
   }),
   hammerspoon = Modal.new({
      entries = function(m)
         return processSimpleEntries(hammerspoonEntries, m, {})
      end,
      fillColor = colors.grey,
   }),
   system = Modal.new({
      entries = function(m)
         return processSimpleEntries(systemEntries, m, {})
      end,
      fillColor = colors.purple,
   }),
   browser = Modal.new({
      entries = function(m)
         return processSimpleEntries(browserEntries, m, {})
      end,
      fillColor = colors.navy,
   }),
   dispatch = Modal.new({
      entries = function(m)
         return processSimpleEntries(dispatchEntries, m, {})
      end,
      fillColor = colors.purple,
   }),
}

-- Create main modal with hotkey binding (depends on submodals)
M.mainModal = Modal.new({
   entries = function(m)
      return processSimpleEntries(mainModalEntries, m, M.submodals)
   end,
   fillColor = colors.grey,
   hotkey = {
      modifiers = { "cmd", "ctrl" },
      key = "d",
   },
})

-- Bind shift+O to send cmd+ctrl+t
M.mainModal:getModal():bind("shift", "o", function()
   hs.eventtap.keyStroke({ "cmd", "ctrl" }, "t")
   M.mainModal:exit()
end)

-- Bind cmd+ctrl+D to open dispatch modal directly
M.mainModal:getModal():bind({ "cmd", "ctrl" }, "d", function()
   M.mainModal:exit()
   M.submodals.dispatch:enter()
end)

return M
