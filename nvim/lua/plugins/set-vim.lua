-- plugins that extend built in vim functionality
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
      -- persist undo history even if file is changes outside nvim
      "kevinhwang91/nvim-fundo",
      dependencies = { "kevinhwang91/promise-async" },
      build = function()
         require("fundo").install()
      end,
      config = function()
         require("fundo").setup({})
      end,
   },

   {
      -- show search status in virtual text
      "kevinhwang91/nvim-hlslens",
      event = "VeryLazy",
      config = function()
         require("scrollbar.handlers.search").setup({}) -- integrate with nvim-scrollbar
         require("hlslens").setup({
            calm_down = true, -- this doesn't work? clear highlights wen cursor leaves
            nearest_only = true,
         })

         -- change highlight colors for search matches away from nearest
         vim.api.nvim_set_hl(0, "HlSearchLens", { fg = "#737994", bg = "grey20" })

         local kopts = { noremap = true, silent = true }

         vim.keymap.set(
            "n",
            "n",
            "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
            kopts
         )
         vim.keymap.set(
            "n",
            "N",
            "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
            kopts
         )
         vim.keymap.set("n", "*", "*<Cmd>lua require('hlslens').start()<CR>", kopts)
         vim.keymap.set("n", "#", "#<Cmd>lua require('hlslens').start()<CR>", kopts)
         vim.keymap.set("n", "g*", "g*<Cmd>lua require('hlslens').start()<CR>", kopts)
         vim.keymap.set("n", "g#", "g#<Cmd>lua require('hlslens').start()<CR>", kopts)
      end,
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
      -- file explorer as nvim buffer
      "stevearc/oil.nvim",
      config = function()
         require("oil").setup({
            default_file_explorer = false, -- this disabled netrw, which is needed for GBrowse, use :Oil
         })
      end,
   },

   {
      -- color f/t targets
      -- NOTE: consier removing this for `flash.nvim`
      "unblevable/quick-scope",
      enabled = true,
      init = function()
         vim.cmd([[ let g:qs_highlight_on_keys = ['f', 'F', 't', 'T'] ]]) -- only show after f/t
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
               enabled = false,
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
            mode = { "n", "o" },
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
         vim.keymap.set("n", "<c-y>", "<cmd>YankBank<CR>", { noremap = true })
      end,
   },

   {
      -- find dupes, suggest keybindings
      "tris203/hawtkeys.nvim",
      config = true,
   },

   {
      -- highlight undo and redo changes
      -- NOTE: this doesn't work with `d`
      "tzachar/highlight-undo.nvim",
      config = function()
         require("highlight-undo").setup({})
      end,
   },

   {
      -- improve interacting with quickfix and location list
      "kevinhwang91/nvim-bqf",
      config = function()
         require("bqf").setup()
      end,
   },

   {
      -- preview macros and norm commands
      -- for macros, use :Norm 5@a syntax
      "smjonas/live-command.nvim",
      config = function()
         require("live-command").setup({
            commands = {
               -- create a previewable :Norm command
               Norm = { cmd = "norm" },
               Reg = {
                  cmd = "norm",
                  -- This will transform ":5Reg a" into ":norm 5@a"
                  args = function(opts)
                     return (opts.count == -1 and "" or opts.count) .. "@" .. opts.args
                  end,
                  range = "",
               },
            },
         })
      end,
   },

   {
      -- automatically disable certain features in large files
      "LunarVim/bigfile.nvim",
   },

   {
      -- navigate between vim and tmux splits
      "christoomey/vim-tmux-navigator",
      cmd = {
         "TmuxNavigateLeft",
         "TmuxNavigateDown",
         "TmuxNavigateUp",
         "TmuxNavigateRight",
         "TmuxNavigatePrevious",
      },
      keys = {
         { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
         { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
         { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
         { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
         { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
   },

   {
      -- Prevent nested vim sessions
      "samjwill/nvim-unception",
      enabled = false, -- this breaks lazygit commit messages
      init = function()
         -- Optional settings go here!
         -- e.g.) vim.g.unception_open_buffer_in_new_tab = true
      end,
   },

   {
      -- show preview for jump list options
      "cbochs/portal.nvim",
      enabled = false,
      -- Optional dependencies
      dependencies = {
         "cbochs/grapple.nvim",
         "ThePrimeagen/harpoon",
      },
      config = function()
         require("portal").setup()
         vim.keymap.set("n", "<leader>o", "<cmd>Portal jumplist backward<cr>")
         vim.keymap.set("n", "<leader>i", "<cmd>Portal jumplist forward<cr>")
      end,
   },
}
