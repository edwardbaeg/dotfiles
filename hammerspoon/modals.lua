local appLauncher = require("application_launcher")
local Modal = require("common.modal")
local helpers = require("common.helpers")
local registry = require("common.feature_registry")
local modalUtils = require("modals-utils")

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

-- util helpers
local createModalEntry = modalUtils.createModalEntry
local openRaycastURL = modalUtils.openRaycastURL
local executeRaycastURL = modalUtils.executeRaycastURL
local launchAppAndExit = modalUtils.launchAppAndExit

local function editorModalEntries(m)
   return {
      editorConfig.displayName,
      createModalEntry("O", "Open", function()
         local success = hs.application.launchOrFocus(editorConfig.appName)
         if not success then
            hs.alert(editorConfig.appName .. " cannot be opened")
         end
         m:exit()
      end),
      createModalEntry("S", "Start debug server", function()
         sendCodeEditorKey({ modifiers = {}, key = "F5" }, "Starting debug server...")
         m:exit()
      end),
      createModalEntry("R", "Restart debug server", function()
         sendCodeEditorKey({ modifiers = { "cmd", "shift" }, key = "F5" }, "Restarting debug server...")
         m:exit()
      end),
   }
end

local function raycastModalEntries(m)
   return {
      "--Raycast--",
      createModalEntry("A", "AI - Personal Extensions", function()
         openRaycastURL(RAYCAST_URLS.ai_personal)
         m:exit()
      end),
      createModalEntry("S", "Snippets", function()
         openRaycastURL(RAYCAST_URLS.snippets)
         m:exit()
      end),
      createModalEntry("E", "Emoji", function()
         openRaycastURL(RAYCAST_URLS.emoji)
         m:exit()
      end),
      createModalEntry("C", "Clipboard", function()
         openRaycastURL(RAYCAST_URLS.clipboard)
         m:exit()
      end),
      createModalEntry("R", "Reasonable size", function()
         executeRaycastURL(RAYCAST_URLS.reasonable_size)
         m:exit()
      end),
   }
end

local function systemModalEntries(m)
   return {
      "--System--",
      createModalEntry("C", function()
         local caffeine = registry.get("caffeine")
         return getToggleLabel(caffeine and caffeine.isEnabled() or false, "Caffeine")
      end, function()
         local caffeine = registry.get("caffeine")
         if caffeine then
            caffeine.toggle()
         end
         m:exit()
      end),
      createModalEntry("A", function()
         local autoreload = registry.get("autoreload")
         return getToggleLabel(autoreload and autoreload.isEnabled() or false, "Autoreload")
      end, function()
         local autoreload = registry.get("autoreload")
         if autoreload then
            autoreload.toggle()
         end
         m:exit()
      end),
      createModalEntry("P", function()
         local personalOverride = registry.get("personalOverride")
         return getToggleLabel(personalOverride and personalOverride.isEnabled() or false, "Arc personal")
      end, function()
         togglePersonalOverride()
         m:exit()
      end),
      createModalEntry("S", "Sleep", function()
         openRaycastURL("raycast://extensions/raycast/system/sleep")
      end),
   }
end

local function browserModalEntries(m)
   return {
      "--Browser--",
      createModalEntry("1", "Arc Work Tab 1", function()
         helpers.switchArcToWorkTab(1)
         m:exit()
      end),
      createModalEntry("3", "Arc Work Tab 3", function()
         helpers.switchArcToWorkTab(3)
         m:exit()
      end),
      createModalEntry("2", "Arc Work Tab 2", function()
         helpers.switchArcToWorkTab(2)
         m:exit()
      end),
      createModalEntry("P", "GitHub PRs", function()
         hs.urlevent.openURL("https://github.com/oneadvisory/frontend/pulls?q=is%3Apr+is%3Aopen+draft%3Afalse+")
         m:exit()
      end),
      createModalEntry("A", "GitHub Actions", function()
         hs.urlevent.openURL("https://github.com/oneadvisory/frontend/actions")
         m:exit()
      end),
   }
end

local function mainModalEntries(m, submodals)
   return {
      "--Apps--",
      createModalEntry("A", "Arc Browser", function()
         launchAppAndExit("Arc", m)
      end),
      createModalEntry("L", "Linear", function()
         launchAppAndExit("Linear", m)
      end),
      createModalEntry("T", "Telegram", function()
         launchAppAndExit("Telegram", m)
      end),
      createModalEntry("Z", "Zen", function()
         launchAppAndExit("zen", m)
      end),
      createModalEntry("S", "Slack", function()
         launchAppAndExit("Slack", m)
      end),
      createModalEntry("I", "iMessage", function()
         launchAppAndExit("Messages", m)
      end),
      createModalEntry("F", "Figma", function()
         launchAppAndExit("Figma", m)
      end),
      createModalEntry("O", "Obsidian", function()
         launchAppAndExit("Obsidian", m)
      end),
      createModalEntry("P", "Spotify", function()
         launchAppAndExit("Spotify", m)
      end),
      createModalEntry("N", "Notion", function()
         launchAppAndExit("Notion", m)
      end),
      createModalEntry("3", "Arc Work Tab 3", function()
         helpers.restoreAppFocus(function()
            helpers.switchArcToWorkTab(3)
         end)
         m:exit()
      end),

      "",
      "--Submodals--",
      createModalEntry("B", "Browser: modal", function()
         m:exit()
         submodals.browser:enter()
      end),
      createModalEntry("R", "Raycast: modal", function()
         m:exit()
         submodals.raycast:enter()
      end),
      createModalEntry("U", editorConfig.modalLabel, function()
         m:exit()
         submodals.editor:enter()
      end),
      createModalEntry("X", "System: modal", function()
         m:exit()
         submodals.system:enter()
      end),
   }
end

-- Create submodals first (they don't depend on other modals)
M.submodals = {
   editor = Modal.new({
      entries = editorModalEntries,
      fillColor = require("common.constants").colors.lightBlue,
   }),
   raycast = Modal.new({
      entries = raycastModalEntries,
      fillColor = require("common.constants").colors.orange,
   }),
   system = Modal.new({
      entries = systemModalEntries,
      fillColor = require("common.constants").colors.purple,
   }),
   browser = Modal.new({
      entries = browserModalEntries,
      fillColor = require("common.constants").colors.navy,
   }),
}

-- Create main modal with hotkey binding (depends on submodals)
M.mainModal = Modal.new({
   entries = function(m)
      return mainModalEntries(m, M.submodals)
   end,
   fillColor = require("common.constants").colors.grey,
   hotkey = {
      modifiers = { "cmd", "ctrl" },
      key = "d",
   },
})

return M
