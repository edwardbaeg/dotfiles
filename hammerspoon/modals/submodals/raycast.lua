local config = require("modals.config")

---@type SimpleModalItem[]
return {
   "--Raycast--",
   { type = "url",    "A", "AI - Personal Extensions", config.RAYCAST_URLS.ai_personal },
   { type = "url",    "S", "Snippets",                 config.RAYCAST_URLS.snippets },
   { type = "url",    "E", "Emoji",                    config.RAYCAST_URLS.emoji },
   { type = "url",    "V", "Clipboard",                config.RAYCAST_URLS.clipboard },
   { type = "url_bg", "C", "Center window",            config.RAYCAST_URLS.center },
   { type = "url_bg", "R", "Reasonable size",          config.RAYCAST_URLS.reasonable_size },
}
