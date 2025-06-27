return {
   "olimorris/codecompanion.nvim",
   dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
   },
   opts = {
      strategies = {
         chat = {
            adapter = "copilot",
         },
         inline = {
            adapter = "copilot",
         }
      }
   },
   keys = {
      {
         mode = { "n", "v" },
         "<leader>cc",
         function()
            -- require("codecompanion").chat()
            require("codecompanion").toggle()
         end,
         desc = "CodeCompanion",
      },
   }
}
