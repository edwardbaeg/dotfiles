-- plugins that extend builtin vim functionality
return {
   "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
   "gabebw/vim-github-link-opener", -- opens 'foo/bar' in github

   "arp242/undofile_warn.vim", -- warn when access undofile before current open
   {
      -- visual undotree
      "simnalamburt/vim-mundo",
      -- enabled = false,
      config = function()
         vim.g.mundo_width = 40
         vim.g.mundo_preview_bottom = 1
         vim.keymap.set("n", "<leader>u", ":MundoToggle<cr>")
      end,
   },

   {
      -- show search information in virtual text
      "kevinhwang91/nvim-hlslens",
      enabled = true,
      config = function()
         -- require('scrollbar.handlers.search').setup({}) -- integrate with scrollbar... this doesn't work!!!
         require("hlslens").setup({
            calm_down = true, -- this doesn't work? clear highlights wen cursor leaves
            nearest_only = true,
         })

         local kopts = { noremap = true, silent = true }

         -- NOTE this is the old keymap api
         vim.api.nvim_set_keymap(
            "n",
            "n",
            [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
            kopts
         )
         vim.api.nvim_set_keymap(
            "n",
            "N",
            [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
            kopts
         )
         vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
         vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
         vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
         vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      end,
   },

   {
      -- wrapper for session commands
      "Shatur/neovim-session-manager",
      config = function()
         require("session_manager").setup({
            -- autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir
            autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
         })

         vim.api.nvim_set_keymap(
            "n",
            "<leader>sc",
            ":SessionManager load_current_dir_session<CR>",
            { desc = "[S]essionManager load_[c]urrent_dir_session" }
         )
         vim.api.nvim_set_keymap(
            "n",
            "<leader>sl",
            ":SessionManager load_session<CR>",
            { desc = "[S]essionManager [l]oad_session" }
         )
         vim.api.nvim_set_keymap(
            "n",
            "<leader>sd",
            ":SessionManager delete_session<CR>",
            { desc = "[S]essionManager [d]elete_session" }
         )
      end,
   },

   {
      -- only show cursorline on active window
      "Tummetott/reticle.nvim",
      enabled = false,
      config = true,
      opts = {
         never = {
            cursorline = { "toggleterm" }, -- has issues with lazygit
         },
      },
   },

   {
      -- adds some visuals to folds
      "anuvyklack/pretty-fold.nvim",
      enabled = false, -- idk folds
      config = function()
         require("pretty-fold").setup({
            fill_char = "-",
         })
      end,
   },

   {
      -- better folding visuals
      "kevinhwang91/nvim-ufo",
      dependencies = { "kevinhwang91/promise-async" },
      enabled = false, -- idk folds
      config = function()
         require("ufo").setup()
         -- vim.o.foldcolumn = '2'
         -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
         -- vim.o.fillchars = [[eob: ,fold: ,foldopen:▼,foldsep: ,foldclose:►]]
      end,
   },

   {
      -- color f/t targets
      "unblevable/quick-scope",
      enabled = false,
      init = function()
         vim.cmd([[ let g:qs_highlight_on_keys = ['f', 'F', 't', 'T'] ]]) -- only show after f/t
      end,
   },

   {
      -- file explorer as nvim buffer
      "stevearc/oil.nvim",
      config = function()
         require("oil").setup({})
      end,
   },

   {
      -- quick navigation, extends search, extends char motions, remote operations
      "folke/flash.nvim",
      event = "VeryLazy",
      opts = {
         labels = "asdfqwertgjklh",
         search = {
            mode = function(str)
               return "\\<" .. str
            end,
         },
         modes = {
            search = {
               enabled = false,
            },
            char = {
               keys = { "f", "t", "T", ";", "," },
            },
            treesitter = {
               labels = "asdfqwertg",
            },
         },
      },
      keys = {
         {
            "F", -- default is s
            mode = { "n", "x", "o" },
            function()
               require("flash").jump()
            end,
            desc = "Flash",
         },
         {
            "S",
            mode = { "n", "o", "x" },
            function()
               require("flash").treesitter()
            end,
            desc = "Flash Treesitter",
         },
         {
            "r",
            mode = "o",
            function()
               require("flash").remote()
            end,
            desc = "Remote Flash",
         },
      },
   },

   {
      -- ability to cycle through pastes, highlights yanks and pastes
      "gbprod/yanky.nvim",
      config = function()
         require("yanky").setup({})
      end,
      init = function()
         vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
         vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")

         -- yank ring
         vim.keymap.set("n", "<c-j>", "<Plug>(YankyCycleForward)")
         vim.keymap.set("n", "<c-k>", "<Plug>(YankyCycleBackward)")
      end,
   },

   { -- extend % matching -- this is a vimscript plugin with treesitter integration
      "andymass/vim-matchup",
      config = true,
   },
}