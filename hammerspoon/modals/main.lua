local config = require("modals.config")
local helpers = require("common.helpers")
local arc = require("utils-arc")

---@type SimpleModalItem[]
return {
   "--Apps--",
   { type = "app", "A", "AI Chat (Claude)", "Claude" },
   { type = "app", "F", "Figma", "Figma" },
   { type = "app", "I", "iMessage", "Messages" },
   { type = "app", "L", "Linear", "Linear" },
   { type = "app", "S", "Slack", "Slack" },
   { type = "app", "T", "Telegram", "Telegram" },
   { type = "app", "Z", "Zen", "zen" },
   {
      type = "custom",
      "O",
      "Todoist",
      function()
         if arc.getBrowser() ~= "arcWork" then
            hs.application.launchOrFocus("Todoist")
         else
            hs.urlevent.openURL("todoist://project?id=work-6fhMfJp63x2pVhjX")
         end
      end,
   },
   { type = "app", "P", "Spotify", "Spotify" },
   { type = "app", "N", "Notion", "Notion" },
   { type = "app", "V", "Zoom", "zoom.us" },
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
   { type = "submodal", "B", "Browser", "browser" },
   { type = "submodal", "D", "Dispatch", "dispatch" },
   { type = "submodal", "R", "Raycast", "raycast" },
   { type = "submodal", "H", "Hammerspoon", "hammerspoon" },
   { type = "submodal", "U", config.editorConfig.modalLabel, "editor" },
   { type = "submodal", "X", "System", "system" },
}
