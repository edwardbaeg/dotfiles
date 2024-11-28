---@diagnostic disable: undefined-global the plugin adds Snacks as a global variable
return {
   -- TODO consider using bigfile, gitbrowse, notify, notifier, rename,
   "folke/snacks.nvim",
   lazy = false,
   priority = 1000,
   enable = false,
   keys = {
      {
         "<leader>lg",
         function()
            Snacks.lazygit()
         end,
         desc = "lazygit",
      },
   },
}
