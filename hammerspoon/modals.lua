local appLauncher = require("application_launcher")
local caffeine = require("caffeine")
local Modal = require("common.modal")

local isPersonalOverride = appLauncher.isPersonalOverride
local togglePersonalOverride = appLauncher.togglePersonalOverride

local M = {}

-- Configuration: set to "vscode" to use VSCode instead of Cursor
-- local CODE_EDITOR = "cursor" -- "cursor" or "vscode"
local CODE_EDITOR = "vscode" -- "cursor" or "vscode"

local EDITOR_APP_NAME = CODE_EDITOR == "cursor" and "Cursor" or "visual studio code"
local EDITOR_DISPLAY_NAME = CODE_EDITOR == "cursor" and "--Cursor--" or "--VSCode--"
local EDITOR_MODAL_LABEL = CODE_EDITOR == "cursor" and "Cursor: modal" or "VSCode: modal"

local function getToggleLabel(value, label)
   return (value and "●" or "○") .. " Toggle " .. label .. " " .. (value and "off" or "on") .. ""
end

-- Modal instances - will be created in Start()
local mainModal, editorModal, raycastModal

---@type ModalEntry[]
local editorModalEntries = {
   EDITOR_DISPLAY_NAME,
   {
      key = "O",
      label = "Open",
      callback = function()
         local success = hs.application.launchOrFocus(EDITOR_APP_NAME)
         if not success then
            hs.alert(EDITOR_APP_NAME .. " cannot be opened")
         end
         editorModal:exit()
      end,
   },
   {
      key = "S",
      label = "Start debug server",
      callback = function()
         local app = hs.application.find(EDITOR_APP_NAME)
         if not app then
            hs.alert(EDITOR_APP_NAME .. " not running")
         else
            hs.timer.doAfter(1, function()
               hs.eventtap.keyStroke({}, "F5", 0, hs.application.find(EDITOR_APP_NAME))
            end)
         end
         editorModal:exit()
      end,
   },
   {
      key = "R",
      label = "Restart debug server",
      callback = function()
         local app = hs.application.find(EDITOR_APP_NAME)
         if not app then
            hs.alert(EDITOR_APP_NAME .. " not running")
         else
            hs.timer.doAfter(1, function()
               hs.eventtap.keyStroke({ "cmd", "shift" }, "F5", 0, hs.application.find(EDITOR_APP_NAME))
            end)
         end
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
         hs.urlevent.openURL(
            "raycast://extensions/raycast/raycast-ai/ai-chat?context=%7B%22preset%22:%2264DC923F-8179-4BA9-A27E-B8F2A2229FE1%22%7D"
         )
         raycastModal:exit()
      end,
   },
   {
      key = "S",
      label = "Snippets",
      callback = function()
         hs.urlevent.openURL("raycast://extensions/raycast/snippets/search-snippets")
         raycastModal:exit()
      end,
   },
   {
      key = "E",
      label = "Emoji",
      callback = function()
         hs.urlevent.openURL("raycast://extensions/raycast/emoji-symbols/search-emoji-symbols")
         raycastModal:exit()
      end,
   },
   {
      key = "C",
      label = "Clipboard",
      callback = function()
         hs.urlevent.openURL("raycast://extensions/raycast/clipboard-history/clipboard-history")
         raycastModal:exit()
      end,
   },
   {
      key = "R",
      label = "Reasonable size",
      callback = function()
         hs.execute("open -g raycast://extensions/raycast/window-management/reasonable-size")
         raycastModal:exit()
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
         hs.application.launchOrFocus("Linear")
         mainModal:exit()
      end,
   },
   {
      key = "T",
      label = "Telegram",
      callback = function()
         hs.application.launchOrFocus("Telegram")
         mainModal:exit()
      end,
   },
   {
      key = "Z",
      label = "Zen",
      callback = function()
         hs.application.launchOrFocus("zen")
         mainModal:exit()
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
         hs.urlevent.openURL("raycast://extensions/raycast/system/sleep")
         mainModal:exit()
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
      label = EDITOR_MODAL_LABEL,
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
