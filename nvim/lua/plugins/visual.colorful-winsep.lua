return {
   -- color the line separating windows
   "nvim-zh/colorful-winsep.nvim",
   enabled = not vim.g.vscode,
   event = "VeryLazy",

   config = function()
      -- local frappe = require("catppuccin.palettes").get_palette("frappe")
      require("colorful-winsep").setup({
         animate = {
            enabled = 'shift', -- default is false
            shift = {
               delta_time = 0.1,
               smooth_speed = 1,
               delay = 3,
            },
         },
         indicator_for_2wins = {
            position = "both", -- default is nil
         },
      })
   end,
}
