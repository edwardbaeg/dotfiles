local config = require("modals.config")
local registry = require("common.feature_registry")
local appLauncher = require("application_launcher")

local togglePersonalOverride = appLauncher.togglePersonalOverride

---@type SimpleModalItem[]
return {
   "--Hammerspoon--",
   {
      type = "custom",
      "C",
      function()
         local caffeine = registry.get("caffeine")
         return config.getToggleLabel(caffeine and caffeine.isEnabled() or false, "Caffeine")
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
         return config.getToggleLabel(autoreload and autoreload.isEnabled() or false, "Autoreload")
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
         return config.getToggleLabel(personalOverride and personalOverride.isEnabled() or false, "Arc personal")
      end,
      function()
         togglePersonalOverride()
      end,
   },
   {
      type = "custom",
      "W",
      "Window hints",
      function()
         hs.hints.windowHints()
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
