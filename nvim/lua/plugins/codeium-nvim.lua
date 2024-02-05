return {
   {
      -- AI code autocompletion
      -- This is used to show suggestions in the popup menu
      "Exafunction/codeium.nvim",
      enabled = not vim.g.vscode,
      event = "VeryLazy",
      -- event = "CmdwinEnter",
      -- enabled = false,
      dependencies = {
         "nvim-lua/plenary.nvim",
         "hrsh7th/nvim-cmp",
      },
      config = function()
         require("codeium").setup({})
      end,
   },
}
