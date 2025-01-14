---@diagnostic disable: undefined-global the plugin adds Snacks as a global variable
return {
   -- TODO consider using bigfile, gitbrowse, notify, notifier, rename
   -- Lazygit opens files as buffers but doesn't support hiding terminal during async functions
   "folke/snacks.nvim",
   lazy = false,
   priority = 1000,
   keys = {
      -- {
      --    "<c-\\>",
      --    function()
      --       Snacks.lazygit()
      --    end,
      --    desc = "lazygit",
      -- },
      -- {
      --    "<leader>lg",
      --    function()
      --       Snacks.lazygit()
      --    end,
      --    desc = "lazygit",
      -- },
      {
         "<leader>.",
         function()
            Snacks.scratch()
         end,
         desc = "Toggle Scratch Buffer",
      },
   },
   config = function(_, opts)
      Snacks.setup(opts)

      vim.api.nvim_create_user_command("Scratch", function()
         Snacks.scratch()
      end, {})
   end,
}
