local appLauncher = require("application_launcher")
local caffeine = require("caffeine")

local isPersonalOverride = appLauncher.isPersonalOverride
local togglePersonalOverride = appLauncher.togglePersonalOverride

local M = {}

---@alias ModalEntry string | ModalEntryTable

---@class ModalEntryTable
---@field key string The key to bind for this entry
---@field label string | function The label to display (can be a function that returns a string)
---@field callback function The function to call when the key is pressed

local modal = hs.hotkey.modal.new({ "cmd", "ctrl" }, "d")
local id

-- TODO: abstract to different module?
local cursorSubmodal = hs.hotkey.modal.new()
local cursorSubmodalId

local raycastSubmodal = hs.hotkey.modal.new()
local raycastSubmodalId

local function getToggleLabel(value, label)
   return (value and "●" or "○") .. " Toggle " .. label .. " " .. (value and "off" or "on") .. ""
end

---@class ModalConfig
---@field entries ModalEntry[] The entries to display in the modal
---@field fillColor table The background color for the modal

---@param config ModalConfig Configuration object for the modal
---@return string alertId The alert ID for closing the modal later
local function showModal(config)
   local mappedEntries = {}
   for _, entry in ipairs(config.entries) do
      if type(entry) == "string" then
         table.insert(mappedEntries, entry)
      elseif type(entry) == "table" and entry.key and entry.label then
         local label = type(entry.label) == "function" and entry.label() or entry.label
         table.insert(mappedEntries, "[" .. entry.key .. "] " .. label)
      end
   end
   local modalContent = table.concat(mappedEntries, "\n")
   modalContent = modalContent .. "\n\n" .. "Esc/q: Exit"
   ---@diagnostic disable-next-line: return-type-mismatch its right
   return hs.alert.show(modalContent, {
      fillColor = config.fillColor,
      textFont = "0xProto",
      textSize = 20,
      radius = 16,
   }, "indefinite")
end

---@type ModalEntry[]
local cursorSubModalEntries = {
   "--Cursor--",
   {
      key = "O",
      label = "Open",
      callback = function()
         hs.application.launchOrFocus("Cursor")
         cursorSubmodal:exit()
      end,
   },
   {
      key = "S",
      label = "Start debug server",
      callback = function()
         local cursorApp = hs.application.find("Cursor")
         if not cursorApp then
            hs.alert("Cursor not running")
         else
            hs.timer.doAfter(1, function()
               hs.eventtap.keyStroke({}, "F5", 0, hs.application.find("Cursor"))
            end)
         end
         cursorSubmodal:exit()
      end,
   },
   {
      key = "R",
      label = "Restart debug server",
      callback = function()
         local cursorApp = hs.application.find("Cursor")
         if not cursorApp then
            hs.alert("Cursor not running")
         else
            hs.timer.doAfter(1, function()
               hs.eventtap.keyStroke({ "cmd", "shift" }, "F5", 0, hs.application.find("Cursor"))
            end)
         end
         cursorSubmodal:exit()
      end,
   },
}

function cursorSubmodal:entered()
   cursorSubmodalId = showModal({
      entries = cursorSubModalEntries,
      fillColor = require("common.constants").colors.lightBlue,
   })
end

function cursorSubmodal:exited()
   hs.alert.closeSpecific(cursorSubmodalId, 0.1)
end

---@type ModalEntry[]
local raycastSubModalEntries = {
   "--Raycast--",
   {
      key = "A",
      label = "AI - Personal Extensions",
      callback = function()
         hs.urlevent.openURL(
            "raycast://extensions/raycast/raycast-ai/ai-chat?context=%7B%22preset%22:%2264DC923F-8179-4BA9-A27E-B8F2A2229FE1%22%7D"
         )
         raycastSubmodal:exit()
      end,
   },
   {
      key = "S",
      label = "Snippets",
      callback = function()
         hs.urlevent.openURL("raycast://extensions/raycast/snippets/search-snippets")
         raycastSubmodal:exit()
      end,
   },
   {
      key = "E",
      label = "Emoji",
      callback = function()
         hs.urlevent.openURL("raycast://extensions/raycast/emoji-symbols/search-emoji-symbols")
         raycastSubmodal:exit()
      end,
   },
   {
      key = "C",
      label = "Clipboard",
      callback = function()
         hs.urlevent.openURL("raycast://extensions/raycast/clipboard-history/clipboard-history")
         raycastSubmodal:exit()
      end,
   },
}

function raycastSubmodal:entered()
   raycastSubmodalId = showModal({
      entries = raycastSubModalEntries,
      fillColor = require("common.constants").colors.orange,
   })
end

function raycastSubmodal:exited()
   hs.alert.closeSpecific(raycastSubmodalId, 0.1)
end

---@type ModalEntry[]
local modalEntries = {
   "--Apps--",
   {
      key = "L",
      label = "Linear",
      callback = function()
         hs.application.launchOrFocus("Linear")
         modal:exit()
      end,
   },
   {
      key = "T",
      label = "Telegram",
      callback = function()
         hs.application.launchOrFocus("Telegram")
         modal:exit()
      end,
   },
   {
      key = "Z",
      label = "Zen",
      callback = function()
         hs.application.launchOrFocus("zen")
         modal:exit()
      end,
   },
   "",
   "--System--",
   {
      key = "C",
      label = function()
         return getToggleLabel(hs.caffeinate.get("displayIdle"), "C")
      end,
      callback = function()
         caffeine.toggle()
         modal:exit()
      end,
   },
   {
      key = "P",
      label = function()
         return getToggleLabel(isPersonalOverride(), "Arc personal")
      end,
      callback = function()
         togglePersonalOverride()
         modal:exit()
      end,
   },
   {
      key = "S",
      label = "Sleep",
      callback = function()
         hs.urlevent.openURL("raycast://extensions/raycast/system/sleep")
         modal:exit()
      end,
   },
   "",
   "--Submodals--",
   {
      key = "R",
      label = "Raycast: modal",
      callback = function()
         modal:exit()
         raycastSubmodal:enter()
      end,
   },
   {
      key = "U",
      label = "Cursor: modal",
      callback = function()
         modal:exit()
         cursorSubmodal:enter()
      end,
   },
}

function modal:entered()
   id = showModal({
      entries = modalEntries,
      fillColor = require("common.constants").colors.grey,
   })
end

function modal:exited()
   hs.alert.closeSpecific(id, 0.1)
end

function Start()
   -- TODO: wrap these
   -- Create bindings for each entry
   for _, entry in ipairs(modalEntries) do
      -- Skip string entries (display-only)
      if type(entry) == "table" and entry.key and entry.callback then
         modal:bind("", entry.key, entry.callback)
      end
   end

   -- Create bindings for sub-modal entries
   for _, entry in ipairs(cursorSubModalEntries) do
      -- Skip string entries (display-only)
      if type(entry) == "table" and entry.key and entry.callback then
         cursorSubmodal:bind("", entry.key, entry.callback)
      end
   end

   for _, entry in ipairs(raycastSubModalEntries) do
      -- Skip string entries (display-only)
      if type(entry) == "table" and entry.key and entry.callback then
         raycastSubmodal:bind("", entry.key, entry.callback)
      end
   end

   -- TODO?: create bindings for all other key presses to exit the modal
   -- https://github.com/Hammerspoon/hammerspoon/issues/848#issuecomment-930456782

   -- Register exit bindings
   ---@param modalInstance hs.hotkey.modal
   local function bindExitKeys(modalInstance)
      local exitFunction = function()
         modalInstance:exit()
      end
      modalInstance:bind("", "escape", exitFunction)
      modalInstance:bind("", "q", exitFunction)
   end

   for _, modalInstance in ipairs({ modal, cursorSubmodal, raycastSubmodal }) do
      bindExitKeys(modalInstance)
   end
end

M.Start = Start
M.Start()
