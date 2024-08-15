return {
   -- shows available keybinds
   -- NOTE: this can prevent reactive.nvim from working for operators
   "folke/which-key.nvim",
   -- enabled = false,
   config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 200
      require("which-key").setup({
         plugins = {
            presets = {
               -- operators = false,
            },
         },
         win = {
            border = "single",
         },
      })
   end,
}
