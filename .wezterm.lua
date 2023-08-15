local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
   config = wezterm.config_builder()
end

config.window_padding = {
   left = 24,
   right = 24,
   top = 32,
   bottom = 32,
}

config.colors = {
   cursor_bg = "#008080",
   cursor_fg = "#ffffff",
   background = "#1e1e1e",
}

config.window_background_opacity = 0.70
config.macos_window_background_blur = 30
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

-- config.font = wezterm.font("Operator Mono", { weight = "Book" })
config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
-- config.font = wezterm.font("Nerd Font Symbols", { weight = "Medium" })
config.font_size = 16

-- config.color_scheme = "tokyonight"

return config
