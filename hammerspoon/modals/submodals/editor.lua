local config = require("modals.config")

---@type SimpleModalItem[]
return {
   config.editorConfig.displayName,
   {
      type = "custom",
      "O",
      "Open",
      function()
         local success = hs.application.launchOrFocus(config.editorConfig.appName)
         if not success then
            hs.alert(config.editorConfig.appName .. " cannot be opened")
         end
      end,
   },
   {
      type = "custom",
      "S",
      "Start debug server",
      function()
         config.sendCodeEditorKey({ modifiers = {}, key = "F5" }, "Starting debug server...")
      end,
   },
   {
      type = "custom",
      "R",
      "Restart debug server",
      function()
         config.sendCodeEditorKey({ modifiers = { "cmd", "shift" }, key = "F5" }, "Restarting debug server...")
      end,
   },
}
