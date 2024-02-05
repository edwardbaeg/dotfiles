return {
   {
      -- AI code autocompletion
      -- This is used to show ghost text for suggestions
      -- NOTE: to fix an issue with the macos language server, delete the ~/.codeium dir
      "Exafunction/codeium.vim",
      enabled = not vim.g.vscode,
      event = "VeryLazy",
      init = function()
         vim.g.codeium_disable_bindings = 1 -- turn off tab and defaults
         -- vim.g.codeium_enabled = false -- disable by default
         vim.keymap.set("i", "<Right>", function()
            return vim.fn["codeium#Accept"]()
         end, { expr = true }) -- there isn't a plug command for this yet
         -- vim.keymap.set("i", "<C-l>", function()
         --    return vim.fn["codeium#Accept"]()
         -- end, { expr = true }) -- there isn't a plug command for this yet
         vim.keymap.set("i", "<C-j>", "<Plug>(codeium-next)")
         vim.keymap.set("i", "<C-k>", "<Plug>(codeium-previous)")
         -- vim.keymap.set({ "i", "n" }, "<c-h>", "<Plug>(codeium-dismiss)")
         vim.keymap.set("i", "<c-h>", "<Plug>(codeium-dismiss)")
      end,
   },

   {
      -- AI code autocompletion
      -- This is used to show suggestions in the popup menu
      "Exafunction/codeium.nvim",
      enabled = not vim.g.vscode,
      event = "VeryLazy",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "hrsh7th/nvim-cmp",
      },
      config = function()
         require("codeium").setup({})
      end,
   },
}
