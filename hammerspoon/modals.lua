local appLauncher = require("application_launcher")
local Modal = require("common.modal")
local helpers = require("common.helpers")
local registry = require("common.feature_registry")
local modalUtils = require("modals-utils")

local togglePersonalOverride = appLauncher.togglePersonalOverride

local M = {}

local RAYCAST_URLS = {
   ai_personal =
   "raycast://extensions/raycast/raycast-ai/ai-chat?context=%7B%22preset%22:%2264DC923F-8179-4BA9-A27E-B8F2A2229FE1%22%7D",
   snippets = "raycast://extensions/raycast/snippets/search-snippets",
   emoji = "raycast://extensions/raycast/emoji-symbols/search-emoji-symbols",
   clipboard = "raycast://extensions/raycast/clipboard-history/clipboard-history",
   reasonable_size = "raycast://extensions/raycast/window-management/reasonable-size",
   center = "raycast://extensions/raycast/window-management/center",
}

local EDITOR_CONFIGS = {
   cursor = {
      appName = "Cursor",
      backupAppName = "",
      displayName = "--Cursor--",
      modalLabel = "Cursor",
   },
   vscode = {
      appName = "visual studio code",
      backupAppName = "code",
      displayName = "--VSCode--",
      modalLabel = "VSCode",
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

-- util helpers
local processSimpleEntries = modalUtils.processSimpleEntries

---@type SimpleModalItem[]
local editorModalEntries = {
   editorConfig.displayName,
   {
      type = "custom",
      "O",
      "Open",
      function()
         local success = hs.application.launchOrFocus(editorConfig.appName)
         if not success then
            hs.alert(editorConfig.appName .. " cannot be opened")
         end
      end,
   },
   {
      type = "custom",
      "S",
      "Start debug server",
      function()
         sendCodeEditorKey({ modifiers = {}, key = "F5" }, "Starting debug server...")
      end,
   },
   {
      type = "custom",
      "R",
      "Restart debug server",
      function()
         sendCodeEditorKey({ modifiers = { "cmd", "shift" }, key = "F5" }, "Restarting debug server...")
      end,
   },
}

---@type SimpleModalItem[]
local raycastModalEntries = {
   "--Raycast--",
   { type = "url", "A", "AI - Personal Extensions", RAYCAST_URLS.ai_personal },
   { type = "url", "S", "Snippets", RAYCAST_URLS.snippets },
   { type = "url", "E", "Emoji", RAYCAST_URLS.emoji },
   { type = "url", "V", "Clipboard", RAYCAST_URLS.clipboard },
   { type = "url_bg", "C", "Center window", RAYCAST_URLS.center },
   { type = "url_bg", "R", "Reasonable size", RAYCAST_URLS.reasonable_size },
}

---@type SimpleModalItem[]
local hammerspoonModalEntries = {
   "--Hammerspoon--",
   {
      type = "custom",
      "C",
      function()
         local caffeine = registry.get("caffeine")
         return getToggleLabel(caffeine and caffeine.isEnabled() or false, "Caffeine")
      end,
      function()
         local caffeine = registry.get("caffeine")
         if caffeine then
            caffeine.toggle()
         end
      end,
   },
   {
      type = "custom",
      "A",
      function()
         local autoreload = registry.get("autoreload")
         return getToggleLabel(autoreload and autoreload.isEnabled() or false, "Autoreload")
      end,
      function()
         local autoreload = registry.get("autoreload")
         if autoreload then
            autoreload.toggle()
         end
      end,
   },
   {
      type = "custom",
      "P",
      function()
         local personalOverride = registry.get("personalOverride")
         return getToggleLabel(personalOverride and personalOverride.isEnabled() or false, "Arc personal")
      end,
      function()
         togglePersonalOverride()
      end,
   },
   {
      type = "custom",
      "R",
      "Reload config",
      function()
         hs.alert("Reloading config...")
         hs.timer.doAfter(0.1, function()
            hs.reload()
         end)
      end,
   },
}

---@type SimpleModalItem[]
local systemModalEntries = {
   "--System--",
   { type = "url", "S", "Sleep", "raycast://extensions/raycast/system/sleep" },
}

---@type SimpleModalItem[]
local browserModalEntries = {
   "--Browser--",
   { type = "custom", "1", "Arc Work Tab 1", function()
      helpers.switchArcToWorkTab(1)
   end },
   { type = "custom", "3", "Arc Work Tab 3", function()
      helpers.switchArcToWorkTab(3)
   end },
   { type = "custom", "2", "Arc Work Tab 2", function()
      helpers.switchArcToWorkTab(2)
   end },
   { type = "url", "P", "GitHub PRs", "https://github.com/oneadvisory/frontend/pulls?q=is%3Apr+is%3Aopen+draft%3Afalse+" },
   { type = "url", "A", "GitHub Actions", "https://github.com/oneadvisory/frontend/actions" },
}

---@type SimpleModalItem[]
local dispatchModalEntries = {
   "--Dispatch--",
   { type = "url", "P", "FE PRs", "https://github.com/oneadvisory/frontend/pulls?q=is%3Apr+is%3Aopen+draft%3Afalse+" },
}

---@type SimpleModalItem[]
local mainModalEntries = {
   "--Apps--",
   { type = "app", "A", "Arc Browser", "Arc" },
   { type = "app", "L", "Linear",      "Linear" },
   { type = "app", "T", "Telegram",    "Telegram" },
   { type = "app", "Z", "Zen",         "zen" },
   { type = "app", "S", "Slack",       "Slack" },
   { type = "app", "I", "iMessage",    "Messages" },
   { type = "app", "F", "Figma",       "Figma" },
   { type = "app", "O", "Todoist",     "Todoist" },
   { type = "app", "P", "Spotify",     "Spotify" },
   { type = "app", "N", "Notion",      "Notion" },
   {
      type = "custom",
      "3",
      "Arc Work Tab 3",
      function()
         helpers.restoreAppFocus(function()
            helpers.switchArcToWorkTab(3)
         end)
      end,
   },

   "",
   "--Submodals--",
   { type = "submodal", "B", "Browser",               "browser" },
   { type = "submodal", "D", "Dispatch",              "dispatch" },
   { type = "submodal", "R", "Raycast",               "raycast" },
   { type = "submodal", "H", "Hammerspoon",           "hammerspoon" },
   { type = "submodal", "U", editorConfig.modalLabel, "editor" },
   { type = "submodal", "X", "System",                "system" },
}

-- Create submodals first
M.submodals = {
   editor = Modal.new({
      entries = function(m)
         return processSimpleEntries(editorModalEntries, m, {})
      end,
      fillColor = require("common.constants").colors.lightBlue,
   }),
   raycast = Modal.new({
      entries = function(m)
         return processSimpleEntries(raycastModalEntries, m, {})
      end,
      fillColor = require("common.constants").colors.orange,
   }),
   hammerspoon = Modal.new({
      entries = function(m)
         return processSimpleEntries(hammerspoonModalEntries, m, {})
      end,
      fillColor = require("common.constants").colors.grey,
   }),
   system = Modal.new({
      entries = function(m)
         return processSimpleEntries(systemModalEntries, m, {})
      end,
      fillColor = require("common.constants").colors.purple,
   }),
   browser = Modal.new({
      entries = function(m)
         return processSimpleEntries(browserModalEntries, m, {})
      end,
      fillColor = require("common.constants").colors.navy,
   }),
   dispatch = Modal.new({
      entries = function(m)
         return processSimpleEntries(dispatchModalEntries, m, {})
      end,
      fillColor = require("common.constants").colors.purple,
   }),
}

-- Create main modal with hotkey binding (depends on submodals)
M.mainModal = Modal.new({
   entries = function(m)
      return processSimpleEntries(mainModalEntries, m, M.submodals)
   end,
   fillColor = require("common.constants").colors.grey,
   hotkey = {
      modifiers = { "cmd", "ctrl" },
      key = "d",
   },
})

-- Bind shift+O to send cmd+shift+t
M.mainModal:getModal():bind("shift", "o", function()
   hs.eventtap.keyStroke({ "cmd", "ctrl" }, "t")
   M.mainModal:exit()
end)

return M
