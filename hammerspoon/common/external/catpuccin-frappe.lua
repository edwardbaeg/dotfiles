-- https://github.com/catppuccin/lua/blob/main/catppuccin/frappe.lua
local catppuccin = {
   name = "frappe",
   rosewater = {
      hex = "#f2d5cf",
      rgb = { 242, 213, 207 },
      hsl = { 10, 0.57, 0.88 },
   },
   flamingo = {
      hex = "#eebebe",
      rgb = { 238, 190, 190 },
      hsl = { 0, 0.59, 0.84 },
   },
   pink = {
      hex = "#f4b8e4",
      rgb = { 244, 184, 228 },
      hsl = { 316, 0.73, 0.84 },
   },
   mauve = {
      hex = "#ca9ee6",
      rgb = { 202, 158, 230 },
      hsl = { 277, 0.59, 0.76 },
   },
   red = {
      hex = "#e78284",
      rgb = { 231, 130, 132 },
      hsl = { 359, 0.68, 0.71 },
   },
   maroon = {
      hex = "#ea999c",
      rgb = { 234, 153, 156 },
      hsl = { 358, 0.66, 0.76 },
   },
   peach = {
      hex = "#ef9f76",
      rgb = { 239, 159, 118 },
      hsl = { 20, 0.79, 0.70 },
   },
   yellow = {
      hex = "#e5c890",
      rgb = { 229, 200, 144 },
      hsl = { 40, 0.62, 0.73 },
   },
   green = {
      hex = "#a6d189",
      rgb = { 166, 209, 137 },
      hsl = { 96, 0.44, 0.68 },
   },
   teal = {
      hex = "#81c8be",
      rgb = { 129, 200, 190 },
      hsl = { 172, 0.39, 0.65 },
   },
   sky = {
      hex = "#99d1db",
      rgb = { 153, 209, 219 },
      hsl = { 189, 0.48, 0.73 },
   },
   sapphire = {
      hex = "#85c1dc",
      rgb = { 133, 193, 220 },
      hsl = { 199, 0.55, 0.69 },
   },
   blue = {
      hex = "#8caaee",
      rgb = { 140, 170, 238 },
      hsl = { 222, 0.74, 0.74 },
   },
   lavender = {
      hex = "#babbf1",
      rgb = { 186, 187, 241 },
      hsl = { 239, 0.66, 0.84 },
   },
   text = {
      hex = "#c6d0f5",
      rgb = { 198, 208, 245 },
      hsl = { 227, 0.70, 0.87 },
   },
   subtext1 = {
      hex = "#b5bfe2",
      rgb = { 181, 191, 226 },
      hsl = { 227, 0.44, 0.80 },
   },
   subtext0 = {
      hex = "#a5adce",
      rgb = { 165, 173, 206 },
      hsl = { 228, 0.29, 0.73 },
   },
   overlay2 = {
      hex = "#949cbb",
      rgb = { 148, 156, 187 },
      hsl = { 228, 0.22, 0.66 },
   },
   overlay1 = {
      hex = "#838ba7",
      rgb = { 131, 139, 167 },
      hsl = { 227, 0.17, 0.58 },
   },
   overlay0 = {
      hex = "#737994",
      rgb = { 115, 121, 148 },
      hsl = { 229, 0.13, 0.52 },
   },
   surface2 = {
      hex = "#626880",
      rgb = { 98, 104, 128 },
      hsl = { 228, 0.13, 0.44 },
   },
   surface1 = {
      hex = "#51576d",
      rgb = { 81, 87, 109 },
      hsl = { 227, 0.15, 0.37 },
   },
   surface0 = {
      hex = "#414559",
      rgb = { 65, 69, 89 },
      hsl = { 230, 0.16, 0.30 },
   },
   base = {
      hex = "#303446",
      rgb = { 48, 52, 70 },
      hsl = { 229, 0.19, 0.23 },
   },
   mantle = {
      hex = "#292c3c",
      rgb = { 41, 44, 60 },
      hsl = { 231, 0.19, 0.20 },
   },
   crust = {
      hex = "#232634",
      rgb = { 35, 38, 52 },
      hsl = { 229, 0.20, 0.17 },
   },
}

-- custom code

---@alias CatppuccinColor
---| "rosewater"
---| "flamingo"
---| "pink"
---| "mauve"
---| "red"
---| "maroon"
---| "peach"
---| "yellow"
---| "green"
---| "teal"
---| "sky"
---| "sapphire"
---| "blue"
---| "lavender"
---| "text"
---| "subtext1"
---| "subtext0"
---| "overlay2"
---| "overlay1"
---| "overlay0"
---| "surface2"
---| "surface1"
---| "surface0"
---| "base"
---| "mantle"
---| "crust"

-- Helper function added to the catppuccin table

---Get a Catppuccin color in Hammerspoon's normalized RGB format (0-1)
---@param colorName CatppuccinColor The name of the color to get
---@param alpha? number Optional alpha value (0-1), defaults to 1.0
---@return table rgb A table with red, green, blue, alpha keys normalized to 0-1
function catppuccin.getRgbColor(colorName, alpha)
   local color = catppuccin[colorName]
   if not color then
      error("Invalid Catppuccin color name: " .. tostring(colorName))
   end

   return {
      red = color.rgb[1] / 255,
      green = color.rgb[2] / 255,
      blue = color.rgb[3] / 255,
      alpha = alpha or 1.0,
   }
end

return catppuccin
