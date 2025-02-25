---@diagnostic disable: missing-fields
-- plugins that focus on improving coding and typing experience

return {
   -- "christoomey/vim-sort-motion", -- add sort operator
   "peitalin/vim-jsx-typescript", -- better support for react?

   {
      -- add motions for substituting text
      "gbprod/substitute.nvim",
      config = function()
         require("substitute").setup({})

         -- add exchange operator, invoke twice, cancle with <esc>
         -- NOTE: this needs to be pressed quickly until the s mapping is fixed
         -- this can be replaced with gX from mini.operators
         vim.keymap.set("n", "sx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
         vim.keymap.set("n", "sxx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
         vim.keymap.set("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })

         -- add substitute operator, replaces with register
         vim.keymap.set("n", "ss", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
         -- vim.keymap.set("n", "S", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
         -- vim.keymap.set("x", "s", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })
      end,
   },

   {
      -- highight colors
      -- NOTE: lazy loading this breaks automatic highlighting
      "NvChad/nvim-colorizer.lua",
      config = function()
         require("colorizer").setup({})
      end,
   },

   {
      -- align text by delimiters
      "junegunn/vim-easy-align",
      init = function()
         vim.keymap.set("n", "ga", "<Plug>(EasyAlign)")
         vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")
      end,
   },

   {
      -- adds kakoune/helix style select first editing
      "00sapo/visual.nvim",
      enabled = false,
      config = function()
         require("visual").setup({})
      end,
      event = "VeryLazy", -- this is for making sure our keymaps are applied after the others: we call the previous mapppings, but other plugins/configs usually not!
   },

   {
      -- jump to any location
      -- this is currently only used for its remote operations
      "ggandor/leap.nvim",
      config = function()
         require("leap").setup({})
      end,

      vim.keymap.set({ "n", "o" }, "<leader>gr", function()
         require("leap.remote").action()
      end, { desc = "Leap [r]emote" }),
   },
}
