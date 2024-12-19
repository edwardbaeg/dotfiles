return {
   {
      -- quick access menu for yanks
      -- :YankBank
      "ptdewey/yankbank-nvim",
      config = function()
         require("yankbank").setup()
         -- vim.keymap.set("n", "<c-y>", "<cmd>YankBank<CR>", { noremap = true })
         vim.keymap.set("n", "<leader>yb", "<cmd>YankBank<CR>", { noremap = true })
      end,
   },

}
