---@diagnostic disable: missing-fields
-- plugins that focus on improving coding and typing experience

return {
   -- "christoomey/vim-sort-motion", -- add sort operator -- replaced with mini.operators
   "peitalin/vim-jsx-typescript", -- better support for react?

   {
      -- add motions for substituting text
      "gbprod/substitute.nvim",
      dependencies = {
         "rachartier/tiny-glimmer.nvim",
      },
      config = function()
         require("substitute").setup({
            on_substitute = require("tiny-glimmer.support.substitute").substitute_cb,
            highlight_substituted_text = {
               enabled = false,
            },
         })
         -- Disable the default s substitute command. This can have issues with keymaps that start with s, such as sx
         vim.keymap.set("n", "s", "<nop>", { noremap = true, desc = "substitute" }) -- kinda works, but blocks other keymaps if not pressed quickly enough
         -- vim.keymap.del("n", "s") -- disable s -- doesn't work
         -- vim.cmd([[unmap s]]) -- doesn't work

         -- add exchange operator, invoke twice, cancel with <esc>
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
      -- color highlighter
      -- :ColorizerToggle
      -- #FFF, #FFF000
      "NvChad/nvim-colorizer.lua",
      opts = {},
   },

   {
      -- align text by delimiters
      "junegunn/vim-easy-align",
      enabled = false, -- keymaps conflict with code companion. Also consider using mini.align
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
      -- this is currently only used for its remote operations -- this could be replaced with Flash's remote
      url = "https://codeberg.org/andyg/leap.nvim", -- this is the updated repo location
      config = function()
         require("leap").setup({})
      end,

      vim.keymap.set({ "n", "o" }, "<leader>gr", function()
         require("leap.remote").action()
      end, { desc = "Leap [r]emote" }),
   },

   {
      -- automatically indent from the first column to the current indent level
      "vidocqh/auto-indent.nvim",
      opts = {},
   },

   {
      -- shows explanations for regex
      -- Usage: Regexexplainer*
      -- NOTE: requires treesitter `regex`
      -- NOTE: can be configured to used images in kitty
      "bennypowers/nvim-regexplainer",
      lazy = true,
      opts = {
         mappings = {
            toggle = '<leader>gR'
         }
      },
      requires = {
         "nvim-treesitter/nvim-treesitter",
         "MunifTanjim/nui.nvim",
      },
   },
}
