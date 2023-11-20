-- plugins that focus on improving coding and typing experience
return {
   -- "christoomey/vim-sort-motion", -- add sort operator
   "peitalin/vim-jsx-typescript", -- better support for react?

   {
      -- a collection of mini 'submodules'
      "echasnovski/mini.nvim",
      config = function()
         require("mini.move").setup({}) -- adds ability to move text around with <m-h/j/k/l>
         require("mini.cursorword").setup({ -- highlighs the word under the cursor
            delay = 500, -- in ms
         })
         require("mini.files").setup({ -- file explorer
            windows = {
               preview = true,
            },

            options = {
               use_as_default_explorer = false,
            },
         })

         -- open with focus on the current file
         vim.api.nvim_create_user_command("MiniFiles", "lua MiniFiles.open(vim.api.nvim_buf_get_name(0))", {})
         vim.api.nvim_create_user_command("Files", "lua MiniFiles.open(vim.api.nvim_buf_get_name(0))", {})

         -- require("mini.pairs").setup({}) -- automatic pair closing

         -- TODO: remap gx
         -- g= -> evaluate
         -- gx -> exchange
         -- gm -> multiply/duplicate
         -- gr -> replace
         -- gs -> sort
         require("mini.operators").setup({
            replace = {
               prefix = "gR",
            },
            exhange = {
               prefix = "", -- this doesn't disable??
            },
         })
      end,
   },

   {
      "altermo/ultimate-autopair.nvim",
      event = { "InsertEnter", "CmdlineEnter" },
      branch = "v0.6",
      opts = {
         --Config goes here
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
         vim.keymap.set("n", "sx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
         vim.keymap.set("n", "sxx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
         vim.keymap.set("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })

         -- add substitute operator, replaces with register
         vim.keymap.set("n", "ss", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
         -- vim.keymap.set("n", "S", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
         vim.keymap.set("x", "s", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })
      end,
   },

   {
      -- adds motions for surrounding, has preview highlight
      "kylechui/nvim-surround",
      config = function()
         -- add operator maps for [r]ight angle braces and [a]ngle brances
         vim.keymap.set("o", "ir", "i[")
         vim.keymap.set("o", "ar", "a[")
         vim.keymap.set("o", "ia", "i<")
         vim.keymap.set("o", "aa", "a<")

         require("nvim-surround").setup({
            keymaps = {
               insert = false,
               insert_line = false,
               normal = "sa", -- default is ys
               normal_cur = false,
               normal_line = false,
               normal_cur_line = false,
               visual = "A", -- default is S
               visual_line = false,
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
      init = function()
         vim.cmd([[
        let g:sandwich_no_default_key_mappings = 1 " disable vim-sandwich bindings, we just want the textobjects
        omap ib <Plug>(textobj-sandwich-auto-i)
        xmap ib <Plug>(textobj-sandwich-auto-i)
        omap ab <Plug>(textobj-sandwich-auto-a)
        xmap ab <Plug>(textobj-sandwich-auto-a)

        omap is <Plug>(textobj-sandwich-query-i)
        xmap is <Plug>(textobj-sandwich-query-i)
        omap as <Plug>(textobj-sandwich-query-a)
        xmap as <Plug>(textobj-sandwich-query-a)
        ]])
      end,
   },
   {
      -- colorizer and color picker
      "uga-rosa/ccc.nvim",
      config = function()
         require("ccc").setup({
            highlighter = {
               auto_enable = true,
            },
         })
      end,
   },

   {
      -- AI code autocompletion
      -- NOTE: to fix an issue with the macos language server, delete the ~/.codeium dir
      "Exafunction/codeium.vim",
      init = function()
         vim.g.codeium_disable_bindings = 1 -- turn off tab and defaults
         -- vim.g.codeium_enabled = false -- disable by default
         vim.keymap.set("i", "<C-l>", function()
            return vim.fn["codeium#Accept"]()
         end, { expr = true }) -- there isn't a plug command for this yet
         vim.keymap.set("i", "<C-j>", "<Plug>(codeium-next)")
         vim.keymap.set("i", "<C-k>", "<Plug>(codeium-previous)")
         -- vim.keymap.set({ "i", "n" }, "<c-h>", "<Plug>(codeium-dismiss)")
         vim.keymap.set("i", "<c-h>", "<Plug>(codeium-dismiss)")
      end,
   },

   {
      -- AI code autocompletion
      "Exafunction/codeium.nvim",
      enabled = false,
      dependencies = {
         "nvim-lua/plenary.nvim",
         "hrsh7th/nvim-cmp",
      },
   },

   {
      -- align text by delimiters
      "junegunn/vim-easy-align",
      init = function()
         vim.keymap.set("n", "ga", "<Plug>(EasyAlign)")
         vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")
      end,
   },

   { -- adds kakoune/helix style select first editing
      "00sapo/visual.nvim",
      enabled = false,
      config = function()
         require("visual").setup({})
      end,
      event = "VeryLazy", -- this is for making sure our keymaps are applied after the others: we call the previous mapppings, but other plugins/configs usually not!
   },
}
