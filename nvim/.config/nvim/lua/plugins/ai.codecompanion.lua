return {
   -- AI code programming
   -- :CodeCompanion <prompt> to do an inline change
   -- <leader>cc to open chat
   -- ga to change adapter+model
   "olimorris/codecompanion.nvim",
   lazy = false,
   dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
   },
   opts = {
      strategies = {
         chat = {
            -- adapter = "copilot", -- faster
            adapter = "anthropic",
         },
         inline = {
            -- adapter = "copilot",
            adapter = "anthropic",
         }
      }
   },
   keys = {
      {
         -- TODO: in v mode, open an input and then pass that to :CodeCompanion <prompt>
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
