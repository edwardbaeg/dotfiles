return {
   {
      -- lists of diagnostics, references, telescopes, quickfix, and location lists
      "folke/trouble.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      event = "VeryLazy",
      -- cmd = "Trouble", -- lazy load
      config = function()
         require("trouble").setup()
         -- vim.keymap.set("n", "<leader>tt", function()
         --    require("trouble").toggle()
         -- end, { silent = true, noremap = true, desc = "[T]oggle [T]rouble" })
      end,
   },

   {
      -- adds syntax highlighting for quickfix lists
      "stevearc/quicker.nvim",
      event = "FileType qf",
      ---@module "quicker"
      ---@type quicker.SetupOptions
      opts = {},
      -- config = function()
      --    require("quicker").setup({})
      -- end,
   },

   {
      -- adds preview window
      "kevinhwang91/nvim-bqf",
      config = function()
         require("bqf").setup()
      end,
   },
}
