return {
   -- color, animate, and indicate the line separating windows
   "nvim-zh/colorful-winsep.nvim",
   enabled = not vim.g.vscode,
   event = "VeryLazy",

   config = function()
      local frappe = require("catppuccin.palettes").get_palette("frappe")
      local util = require("tokyonight.util")
      local winsep_hl = vim.api.nvim_get_hl(0, {name = "WinSeparator"})
      local winsep_color = string.format("#%06x", winsep_hl.fg or 0x51576e)
      local blended_color = util.blend(frappe.sapphire, 0.5, winsep_color)

      require("colorful-winsep").setup({
         highlight = {
            fg = blended_color,
         },
         animate = {
            enabled = "shift", -- default is false
            shift = {
               delta_time = 0.1,
               smooth_speed = 1,
               delay = 3,
            },
         },
         indicator_for_2wins = {
            position = "both", -- default is nil
            symbols = {
               -- the meaning of left, down ,up, right is the position of separator
               -- start_left = "󱞬",
               -- end_left = "󱞪",
               start_left = "⮕",
               end_left = "⮕",
               -- start_down = "󱞾",
               -- end_down = "󱟀",
               start_down = "⬆",
               end_down = "⬆",
               -- start_up = "󱞢",
               -- end_up = "󱞤",
               start_up = "⬇",
               end_up = "⬇",
               -- start_right = "󱞨",
               -- end_right = "󱞦",
               start_right = "⬅",
               end_right = "⬅",
            },
         },
      })
   end,
}
