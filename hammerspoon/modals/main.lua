local config = require("modals.config")
local helpers = require("common.helpers")
local registry = require("common.feature_registry")

---@type SimpleModalItem[]
return {
   "--Apps--",
   { type = "app", "A", "AI Chat (Claude)", "Claude" },
   { type = "app", "B", "Browser (Arc)",    "Arc" },
   { type = "app", "L", "Linear",           "Linear" },
   { type = "app", "T", "Telegram",         "Telegram" },
   { type = "app", "Z", "Zen",              "zen" },
   { type = "app", "S", "Slack",            "Slack" },
   { type = "app", "I", "iMessage",         "Messages" },
   { type = "app", "F", "Figma",            "Figma" },
   {
      type = "custom",
      "O",
      "Todoist",
      function()
         local constants = require("common/constants")
         local personalOverride = registry.get("personalOverride")
         local isPersonal = constants.isPersonal

         -- If personalOverride is enabled, invert the behavior
         if personalOverride and personalOverride.isEnabled() then
            isPersonal = not isPersonal
         end

         if isPersonal then
            hs.application.launchOrFocus("Todoist")
         else
            hs.urlevent.openURL("todoist://project?id=work-6fhMfJp63x2pVhjX")
         end
      end,
   },
   { type = "app", "P", "Spotify", "Spotify" },
   { type = "app", "N", "Notion",  "Notion" },
   { type = "app", "V", "Zoom",    "zoom.us" },
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
   { type = "submodal", "U", config.editorConfig.modalLabel, "editor" },
   { type = "submodal", "X", "System",                "system" },
}
