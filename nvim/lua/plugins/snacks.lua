-- -@diagnostic disable: undefined-global the plugin adds Snacks as a global variable
return {
   -- TODO consider using bigfile, gitbrowse, notify, notifier, rename,
   "folke/snacks.nvim",
   lazy = false,
   priority = 1000,
   opts = {
      animate = {
         fps = 144,
      },
      scroll = {
      ---@class snacks.animate.Config
         animate = {
            -- The minimum of duration or duration per step will be used
            duration = {
               -- step = 15,
               total = 75,
            },
            easing = "linear",
         }
      },
   },
   keys = {
      -- prefer toggle term for better
      -- {
      --    "<leader>lg",
      --    function()
      --       Snacks.lazygit()
      --    end,
      --    desc = "lazygit",
      -- },
   },
}
