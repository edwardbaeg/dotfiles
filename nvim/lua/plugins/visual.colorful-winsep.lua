return {
   -- color, animate, and indicate the line separating windows
   "nvim-zh/colorful-winsep.nvim",
   enabled = not vim.g.vscode,
   event = "VeryLazy",

   config = function()
      local frappe = require("catppuccin.palettes").get_palette("frappe")
      require("colorful-winsep").setup({
         highlight = {
            fg = frappe.sapphire,
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
