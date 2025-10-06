local appLauncher = require("application_launcher")
local Modal = require("common.modal")
local helpers = require("common.helpers")
local registry = require("common.feature_registry")

local togglePersonalOverride = appLauncher.togglePersonalOverride

local M = {}

local RAYCAST_URLS = {
   ai_personal = "raycast://extensions/raycast/raycast-ai/ai-chat?context=%7B%22preset%22:%2264DC923F-8179-4BA9-A27E-B8F2A2229FE1%22%7D",
   snippets = "raycast://extensions/raycast/snippets/search-snippets",
   emoji = "raycast://extensions/raycast/emoji-symbols/search-emoji-symbols",
   clipboard = "raycast://extensions/raycast/clipboard-history/clipboard-history",
   reasonable_size = "raycast://extensions/raycast/window-management/reasonable-size",
}

local EDITOR_CONFIGS = {
   cursor = {
      appName = "Cursor",
      backupAppName = "",
      displayName = "--Cursor--",
      modalLabel = "Cursor: modal",
   },
   vscode = {
      appName = "visual studio code",
      backupAppName = "code",
      displayName = "--VSCode--",
      modalLabel = "VSCode: modal",
   },
}

---@type "cursor" | "vscode"
local CODE_EDITOR_NAME = "vscode"
local editorConfig = EDITOR_CONFIGS[CODE_EDITOR_NAME]

local function getToggleLabel(value, label)
   return (value and "●" or "○") .. " Toggle " .. label .. " " .. (value and "off" or "on") .. ""
end

local function findEditorApp()
   local app = hs.application.find(editorConfig.appName)
   local targetAppName = editorConfig.appName

   if not app and editorConfig.backupAppName ~= "" then
      app = hs.application.find(editorConfig.backupAppName)
      targetAppName = editorConfig.backupAppName
   end

   return app, targetAppName
end

local function sendCodeEditorKey(keystroke, actionMsg)
   local app, targetAppName = findEditorApp()

   if not app then
      local alertMsg = editorConfig.appName .. " not running"
      if editorConfig.backupAppName ~= "" then
         alertMsg = alertMsg .. " (backup: " .. editorConfig.backupAppName .. " also not running)"
      end
      hs.alert(alertMsg)
   else
      hs.timer.doAfter(1, function()
         hs.alert(actionMsg)
         hs.eventtap.keyStroke(keystroke.modifiers, keystroke.key, 0, hs.application.find(targetAppName))
      end)
   end
end

local function openRaycastURL(url, modal)
   hs.urlevent.openURL(url)
   modal:exit()
end

local function executeRaycastURL(url, modal)
   hs.execute("open -g " .. url)
   modal:exit()
end

local function launchApp(appName, modal)
   hs.application.launchOrFocus(appName)
   modal:exit()
end

-- Modal instances - will be created in Start()
local mainModal, editorModal, raycastModal, systemModal

---@param key string
---@param label string | function
---@param callback function
---@return ModalEntry
local function createModalEntry(key, label, callback)
   return {
      key = key,
      label = label,
      callback = callback,
   }
end

---@param key string
---@param label string
---@param appName string
---@return ModalEntry
local function launchModalEntry(key, label, appName)
   return createModalEntry(key, label, function()
      launchApp(appName, mainModal)
   end)
end

---@param key string
---@param label string
---@param url string
---@return ModalEntry
local function openRaycastModalEntry(key, label, url)
   return createModalEntry(key, label, function()
      openRaycastURL(url, raycastModal)
   end)
end

---@param key string
---@param label string
---@param url string
---@return ModalEntry
local function executeRaycastModalEntry(key, label, url)
   return createModalEntry(key, label, function()
      executeRaycastURL(url, raycastModal)
   end)
end

---@type ModalEntry[]
local editorModalEntries = {
   editorConfig.displayName,
   createModalEntry("O", "Open", function()
      local success = hs.application.launchOrFocus(editorConfig.appName)
      if not success then
         hs.alert(editorConfig.appName .. " cannot be opened")
      end
      editorModal:exit()
   end),
   createModalEntry("S", "Start debug server", function()
      sendCodeEditorKey({ modifiers = {}, key = "F5" }, "Starting debug server...")
      editorModal:exit()
   end),
   createModalEntry("R", "Restart debug server", function()
      sendCodeEditorKey({ modifiers = { "cmd", "shift" }, key = "F5" }, "Restarting debug server...")
      editorModal:exit()
   end),
}

---@type ModalEntry[]
local raycastModalEntries = {
   "--Raycast--",
   openRaycastModalEntry("A", "AI - Personal Extensions", RAYCAST_URLS.ai_personal),
   openRaycastModalEntry("S", "Snippets", RAYCAST_URLS.snippets),
   openRaycastModalEntry("E", "Emoji", RAYCAST_URLS.emoji),
   openRaycastModalEntry("C", "Clipboard", RAYCAST_URLS.clipboard),
   executeRaycastModalEntry("R", "Reasonable size", RAYCAST_URLS.reasonable_size),
}

---@type ModalEntry[]
local systemModalEntries = {
   "--System--",
   createModalEntry("C", function()
      local caffeine = registry.get("caffeine")
      return getToggleLabel(caffeine and caffeine.isEnabled() or false, "Caffeine")
   end, function()
      local caffeine = registry.get("caffeine")
      if caffeine then
         caffeine.toggle()
      end
      systemModal:exit()
   end),
   createModalEntry("A", function()
      local autoreload = registry.get("autoreload")
      return getToggleLabel(autoreload and autoreload.isEnabled() or false, "Autoreload")
   end, function()
      local autoreload = registry.get("autoreload")
      if autoreload then
         autoreload.toggle()
      end
      systemModal:exit()
   end),
   createModalEntry("P", function()
      local personalOverride = registry.get("personalOverride")
      return getToggleLabel(personalOverride and personalOverride.isEnabled() or false, "Arc personal")
   end, function()
      togglePersonalOverride()
      systemModal:exit()
   end),
   createModalEntry("S", "Sleep", function()
      openRaycastURL("raycast://extensions/raycast/system/sleep", systemModal)
   end),
}

---@type ModalEntry[]
local mainModalEntries = {
   "--Apps--",
   launchModalEntry("L", "Linear", "Linear"),
   launchModalEntry("T", "Telegram", "Telegram"),
   launchModalEntry("Z", "Zen", "zen"),
   launchModalEntry("S", "Slack", "Slack"),
   launchModalEntry("I", "iMessage", "Messages"),
   launchModalEntry("F", "Figma", "Figma"),
   launchModalEntry("O", "Obsidian", "Obsidian"),
   launchModalEntry("P", "Spotify", "Spotify"),
   launchModalEntry("A", "Arc Browser", "Arc"),
   createModalEntry("3", "Arc Work Tab 3", function()
      helpers.restoreAppFocus(function()
         helpers.switchArcToWorkTab(3)
      end)
      mainModal:exit()
   end),
   "",
   "--Submodals--",
   createModalEntry("R", "Raycast: modal", function()
      mainModal:exit()
      raycastModal:enter()
   end),
   createModalEntry("X", "System: modal", function()
      mainModal:exit()
      systemModal:enter()
   end),
   createModalEntry("U", editorConfig.modalLabel, function()
      mainModal:exit()
      editorModal:enter()
   end),
}

function Start()
   -- Create main modal with hotkey binding
   mainModal = Modal.new({
      entries = mainModalEntries,
      fillColor = require("common.constants").colors.grey,
      hotkey = {
         modifiers = { "cmd", "ctrl" },
         key = "d",
      },
   })

   -- Create GUI editor submodal
   editorModal = Modal.new({
      entries = editorModalEntries,
      fillColor = require("common.constants").colors.lightBlue,
   })

   -- Create Raycast submodal
   raycastModal = Modal.new({
      entries = raycastModalEntries,
      fillColor = require("common.constants").colors.orange,
   })

   -- Create System submodal
   systemModal = Modal.new({
      entries = systemModalEntries,
      fillColor = require("common.constants").colors.purple,
   })
end

M.Start = Start
M.Start()
