return {
   -- open current line in github permalink
   -- TODO?: create a command :GBrowse/:GLink for this
   "ruifm/gitlinker.nvim",
   config = function()
      require("gitlinker").setup({
         -- mappings = "<leader>gg", -- default is gy
      })
      vim.api.nvim_set_keymap(
         "n",
         "<leader>gl",
         '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
         { silent = true }
      )
      vim.api.nvim_set_keymap(
         "v",
         "<leader>gl",
         '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
         {}
      )
      vim.api.nvim_create_user_command(
         "Glink",
         'lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})',
         { desc = "Open github link in browser" }
      )
      vim.api.nvim_create_user_command(
         "Gbrowse",
         'lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})',
         { desc = "Open github link in browser" }
      )
   end,
}
