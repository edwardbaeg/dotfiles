local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
   config = wezterm.config_builder()
end

config.window_padding = {
   left = "3cell",
   right = "3cell",
   top = "1cell",
   bottom = "1cell",
}

config.color_scheme = "tokyonight"
-- config.color_scheme = "nord"
-- config.color_scheme = "Catppuccin Mocha"
config.colors = {
   -- cursor_bg = "#008080",
   cursor_bg = "teal",
   cursor_fg = "white",
   background = "#1e1e1e",
   visual_bell = "#202020",
}

-- Makes the background flash/opaque for visual bell
config.visual_bell = {
   fade_in_function = "EaseIn",
   fade_in_duration_ms = 150,
   fade_out_function = "EaseOut",
   fade_out_duration_ms = 150,
}

config.window_background_opacity = 0.95
config.macos_window_background_blur = 75
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

config.line_height = 1

config.font = wezterm.font("Operator Mono", { weight = "Book" })
-- config.font = wezterm.font("Operator Mono", { weight = "Medium" })
-- config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
-- config.font = wezterm.font("Nerd Font Symbols", { weight = "Medium" })

-- offset for rendering underline
config.underline_position = -4

if wezterm.hostname() == "OA.local" then
   config.font_size = 16
else
   config.font_size = 17
end

config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" } -- disable ligatures

config.max_fps = 120 -- default is 60

return config

-- Notes
-- ctrl+shift+L to show the debug overlay, ctrl+c/esc to close
