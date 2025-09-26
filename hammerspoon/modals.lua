local appLauncher = require("application_launcher")
local caffeine = require("caffeine")
local Modal = require("common.modal")

local isPersonalOverride = appLauncher.isPersonalOverride
local togglePersonalOverride = appLauncher.togglePersonalOverride

local M = {}

local EDITOR_CONFIGS = {
   cursor = {
      appName = "Cursor",
      backupAppName = "",
      displayName = "--Cursor--",
      modalLabel = "Cursor: modal"
   },
   vscode = {
      appName = "visual studio code",
      backupAppName = "code",
      displayName = "--VSCode--",
      modalLabel = "VSCode: modal"
   }
}

---@type "cursor" | "vscode"
local CODE_EDITOR_NAME = "vscode"
local editorConfig = EDITOR_CONFIGS[CODE_EDITOR_NAME]

local function getToggleLabel(value, label)
   return (value and "●" or "○") .. " Toggle " .. label .. " " .. (value and "off" or "on") .. ""
end

local function sendCodeEditorKey(keystroke, actionMsg)
   local app = hs.application.find(editorConfig.appName)
   local targetApp = editorConfig.appName

   if not app and editorConfig.backupAppName ~= "" then
      app = hs.application.find(editorConfig.backupAppName)
      targetApp = editorConfig.backupAppName
   end

   if not app then
      local alertMsg = editorConfig.appName .. " not running"
      if editorConfig.backupAppName ~= "" then
         alertMsg = alertMsg .. " (backup: " .. editorConfig.backupAppName .. " also not running)"
      end
      hs.alert(alertMsg)
   else
      hs.timer.doAfter(1, function()
         hs.alert(actionMsg)
         hs.eventtap.keyStroke(keystroke.modifiers, keystroke.key, 0, hs.application.find(targetApp))
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
local mainModal, editorModal, raycastModal

---@type ModalEntry[]
local editorModalEntries = {
   editorConfig.displayName,
   {
      key = "O",
      label = "Open",
      callback = function()
         local success = hs.application.launchOrFocus(editorConfig.appName)
         if not success then
            hs.alert(editorConfig.appName .. " cannot be opened")
         end
         editorModal:exit()
      end,
   },
   {
      key = "S",
      label = "Start debug server",
      callback = function()
         sendCodeEditorKey({ modifiers = {}, key = "F5" }, "Starting debug server...")
         editorModal:exit()
      end,
   },
   {
      key = "R",
      label = "Restart debug server",
      callback = function()
         sendCodeEditorKey({ modifiers = { "cmd", "shift" }, key = "F5" }, "Restarting debug server...")
         editorModal:exit()
      end,
   },
}

---@type ModalEntry[]
local raycastModalEntries = {
   "--Raycast--",
   {
      key = "A",
      label = "AI - Personal Extensions",
      callback = function()
         openRaycastURL(
            "raycast://extensions/raycast/raycast-ai/ai-chat?context=%7B%22preset%22:%2264DC923F-8179-4BA9-A27E-B8F2A2229FE1%22%7D",
            raycastModal
         )
      end,
   },
   {
      key = "S",
      label = "Snippets",
      callback = function()
         openRaycastURL("raycast://extensions/raycast/snippets/search-snippets", raycastModal)
      end,
   },
   {
      key = "E",
      label = "Emoji",
      callback = function()
         openRaycastURL("raycast://extensions/raycast/emoji-symbols/search-emoji-symbols", raycastModal)
      end,
   },
   {
      key = "C",
      label = "Clipboard",
      callback = function()
         openRaycastURL("raycast://extensions/raycast/clipboard-history/clipboard-history", raycastModal)
      end,
   },
   {
      key = "R",
      label = "Reasonable size",
      callback = function()
         executeRaycastURL("raycast://extensions/raycast/window-management/reasonable-size", raycastModal)
      end,
   },
}

---@type ModalEntry[]
local mainModalEntries = {
   "--Apps--",
   {
      key = "L",
      label = "Linear",
      callback = function()
         launchApp("Linear", mainModal)
      end,
   },
   {
      key = "T",
      label = "Telegram",
      callback = function()
         launchApp("Telegram", mainModal)
      end,
   },
   {
      key = "F",
      label = "Figma",
      callback = function()
         launchApp("Figma", mainModal)
      end,
   },
   {
      key = "O",
      label = "Obsidian",
      callback = function()
         launchApp("Obsidian", mainModal)
      end,
   },
   {
      key = "Z",
      label = "Zen",
      callback = function()
         launchApp("zen", mainModal)
      end,
   },
   {
      key = "3",
      label = "Arc Work Tab 3",
      callback = function()
         local currentApp = hs.application.frontmostApplication()
         local wasArc = currentApp:name() == "Arc"

         if not wasArc then
            hs.application.launchOrFocus("Arc")
         end
         hs.timer.usleep(100000) -- Wait 0.1s for Arc to focus

         -- switch to work
         -- TODO: consider using existing helper
         hs.eventtap.keyStroke({ "ctrl" }, "4")

         -- switch to tab 3
         hs.eventtap.keyStroke({ "cmd" }, "3")

         if not wasArc then
            hs.timer.usleep(100000) -- Wait 0.1s before switching back
            currentApp:activate()
         end

         mainModal:exit()
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
         mainModal:exit()
      end,
   },
   {
      key = "P",
      label = function()
         return getToggleLabel(isPersonalOverride(), "Arc personal")
      end,
      callback = function()
         togglePersonalOverride()
         mainModal:exit()
      end,
   },
   {
      key = "S",
      label = "Sleep",
      callback = function()
         openRaycastURL("raycast://extensions/raycast/system/sleep", mainModal)
      end,
   },
   "",
   "--Submodals--",
   {
      key = "R",
      label = "Raycast: modal",
      callback = function()
         mainModal:exit()
         raycastModal:enter()
      end,
   },
   {
      key = "U",
      label = editorConfig.modalLabel,
      callback = function()
         mainModal:exit()
         editorModal:enter()
      end,
   },
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
end

M.Start = Start
M.Start()
