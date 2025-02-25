---@diagnostic disable: missing-fields
-- plugins that focus on improving coding and typing experience

return {
   -- "christoomey/vim-sort-motion", -- add sort operator
   "peitalin/vim-jsx-typescript", -- better support for react?

   {
      -- Automatically add, pad closing brackets
      -- Fastwarp: <A-e> and <A-E>
      "altermo/ultimate-autopair.nvim",
      event = { "InsertEnter", "CmdlineEnter" },
      branch = "v0.6", -- plugin is currently in maintenance mode
      opts = {
         -- move closing bracket
         -- TODO: see if we can add normal mode mapping?
         fastwarp = {
            enable = true,
            faster = true, -- skip over pairs
         },
      },
   },

   {
      -- automatically adds closing brackets
      -- note: doesn't automatically pad brackets... sometimes doesn't move closing {} when opening {} {}
      "windwp/nvim-autopairs",
      enabled = false,
      config = function()
         require("nvim-autopairs").setup({
            map_cr = true,
         })
      end,
   },

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
      -- adds motions for surrounding, has preview highlight
      "kylechui/nvim-surround",
      config = function()
         -- add operator maps for [r]ight angle braces and [a]ngle brances -- replaced with mini.ai
         -- vim.keymap.set("o", "ir", "i[")
         -- vim.keymap.set("o", "ar", "a[")
         -- vim.keymap.set("o", "ia", "i<")
         -- vim.keymap.set("o", "aa", "a<")

         require("nvim-surround").setup({
            keymaps = {
               insert = false,
               insert_line = false,
               normal = "sa", -- default is ys
               normal_cur = false,
               normal_line = false,
               normal_cur_line = false,
               visual = "s", -- default is S
               -- visual = "a", -- default is S
               visual_line = false,
               -- delete = "sd", -- default is ds
               -- change = "sc", -- default is cs
            },
            aliases = {
               ["b"] = { ")", "}", "]" }, -- adds the other brackets
            },
         })
      end,
   },

   {
      -- this adds surround motions, but disable those and just use the ib / ab operators
      "machakann/vim-sandwich",
      enabled = false, -- replaced with mini.ai
      init = function()
         vim.cmd([[
        let g:sandwich_no_default_key_mappings = 1 " disable vim-sandwich bindings, we just want the textobjects
        omap ib <Plug>(textobj-sandwich-auto-i)
        xmap ib <Plug>(textobj-sandwich-auto-i)
        omap ab <Plug>(textobj-sandwich-auto-a)
        xmap ab <Plug>{textobj-sandwich-auto-a}

        omap is <Plug>(textobj-sandwich-query-i)
        xmap is <Plug>(textobj-sandwich-query-i)
        omap as <Plug>(textobj-sandwich-query-a)
        xmap as <Plug>(textobj-sandwich-query-a)
        ]])
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

   -- {
   --    -- multiple cursors mode
   --    -- use <ctrl-n> to add multiple cursors
   --    "mg979/vim-visual-multi",
   -- },

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
