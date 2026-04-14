local M = {}

M.RAYCAST_URLS = {
   ai_personal =
   "raycast://extensions/raycast/raycast-ai/ai-chat?context=%7B%22preset%22:%2264DC923F-8179-4BA9-A27E-B8F2A2229FE1%22%7D",
   snippets = "raycast://extensions/raycast/snippets/search-snippets",
   emoji = "raycast://extensions/raycast/emoji-symbols/search-emoji-symbols",
   clipboard = "raycast://extensions/raycast/clipboard-history/clipboard-history",
   reasonable_size = "raycast://extensions/raycast/window-management/reasonable-size",
   center = "raycast://extensions/raycast/window-management/center",
}

M.EDITOR_CONFIGS = {
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
M.CODE_EDITOR_NAME = "vscode"
M.editorConfig = M.EDITOR_CONFIGS[M.CODE_EDITOR_NAME]

function M.getToggleLabel(value, label)
   return (value and "●" or "○") .. " Toggle " .. label .. " " .. (value and "off" or "on") .. ""
end

function M.findEditorApp()
   local app = hs.application.find(M.editorConfig.appName)
   local targetAppName = M.editorConfig.appName

   if not app and M.editorConfig.backupAppName ~= "" then
      app = hs.application.find(M.editorConfig.backupAppName)
      targetAppName = M.editorConfig.backupAppName
   end

   return app, targetAppName
end

function M.sendCodeEditorKey(keystroke, actionMsg)
   local app, targetAppName = M.findEditorApp()

   if not app then
      local alertMsg = M.editorConfig.appName .. " not running"
      if M.editorConfig.backupAppName ~= "" then
         alertMsg = alertMsg .. " (backup: " .. M.editorConfig.backupAppName .. " also not running)"
      end
      hs.alert(alertMsg)
   else
      hs.timer.doAfter(1, function()
         hs.alert(actionMsg)
         hs.eventtap.keyStroke(keystroke.modifiers, keystroke.key, 0, hs.application.find(targetAppName))
      end)
   end
end

return M
