return {
   -- color the line separating windows
   "nvim-zh/colorful-winsep.nvim",
   enabled = not vim.g.vscode,
   branch = "alpha",
   event = "VeryLazy",
   -- config = true,

   config = function()
      -- local frappe = require("catppuccin.palettes").get_palette("frappe")
      require("colorful-winsep").setup({
         -- events = { "WinEnter", "WinResized" },
         hi = {
            --    bg = "none",
            -- fg = "cyan4",
         },
         --
         -- integrations = {
         --    bufferline = true,
         -- },
         -- interval = 1000,

         -- These aren't working...
         only_line_seq = false,
         smooth = true,
         exponential_smoothing = true,
         anchor = {
            left = { height = 1, x = -1, y = -1 },
            right = { height = 1, x = -1, y = 0 },
            up = { width = 0, x = -1, y = 0 },
            bottom = { width = 0, x = 1, y = 0 },
         },
      })
   end,
}
