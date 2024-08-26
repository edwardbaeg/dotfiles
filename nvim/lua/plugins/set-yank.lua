return {
   {
      -- ability to cycle through pastes, highlights yanks and pastes
      -- TODO: set up highlight on yank and put elsewhere
      "gbprod/yanky.nvim",
      -- enabled = false, -- replaced with yank-bank
      config = function()
         require("yanky").setup({
            highlight = {
               on_put = true,
               on_yank = true,
               timer = 500,
            },
         })
      end,
      init = function()
         -- vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
         -- vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")

         -- yank ring
         -- vim.keymap.set("n", "<leader>j", "<Plug>(YankyCycleForward)")
         -- vim.keymap.set("n", "<leader>k", "<Plug>(YankyCycleBackward)")
      end,
   },

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
