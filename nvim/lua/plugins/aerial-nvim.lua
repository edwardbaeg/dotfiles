return {
   -- code outline window
   -- Usage: :Aerial*
   "stevearc/aerial.nvim",
   -- enabled = false, -- not as good compared to navbuddy, but this can work with just treesitter
   opts = {},
   -- Optional dependencies
   event = "VeryLazy",
   dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
   },
   config = function()
      require("aerial").setup()

      -- vim.keymap.set("n", "<leader>at", "<cmd>AerialToggle<CR>", { desc = "Aerial [T]oggle" })
      -- vim.keymap.set("n", "<leader>an", "<cmd>AerialNavToggle<CR>", { desc = "Aerial [N]av toggle" })
   end,
}
