local helpers = require("common.helpers")

---@type SimpleModalItem[]
return {
   "--Browser--",
   { type = "app", "A", "Arc",    "Arc" },
   { type = "app", "Z", "Zen",    "zen" },
   { type = "app", "S", "Safari", "Safari" },
   "",
   { type = "custom", "1", "Arc Work Tab 1", function()
      helpers.switchArcToWorkTab(1)
   end },
   { type = "custom", "3", "Arc Work Tab 3", function()
      helpers.switchArcToWorkTab(3)
   end },
   { type = "custom", "2", "Arc Work Tab 2", function()
      helpers.switchArcToWorkTab(2)
   end },
   { type = "url", "P", "GitHub PRs",     "https://github.com/oneadvisory/frontend/pulls?q=is%3Apr+is%3Aopen+draft%3Afalse+" },
   { type = "url", "G", "GitHub Actions", "https://github.com/oneadvisory/frontend/actions" },
}
