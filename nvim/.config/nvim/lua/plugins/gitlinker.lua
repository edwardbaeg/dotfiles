return {
   -- open current line in github permalink
   "ruifm/gitlinker.nvim",
   config = function()
      require("gitlinker").setup({
         -- mappings = "<leader>gg", -- default is gy
      })
      vim.keymap.set(
         "n",
         "<leader>gl",
         '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
         { silent = true }
      )
      vim.keymap.set(
         "v",
         "<leader>gl",
         '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
         { silent = true }
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
