-- plugins that extend built in vim functionality
return {
   "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

   "arp242/undofile_warn.vim", -- warn when access undofile before current open

   {
      -- visual undotree
      "jiaoshijie/undotree",
      dependencies = "nvim-lua/plenary.nvim",
      config = true,
      keys = {
         { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
      },
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
      enabled = not vim.g.vscode,
      event = "VeryLazy",
      config = function()
         require("scrollbar.handlers.search").setup({}) -- integrate with nvim-scrollbar
         require("hlslens").setup({
            -- calm_down = true, -- this doesn't work? clear highlights when cursor leaves
            -- nearest_only = true, -- only add lens to the nearest matched instance
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
      -- enabled = false,
      config = function()
         require("oil").setup({
            default_file_explorer = false, -- this disabled netrw, which is needed for GBrowse, use :Oil
         })
      end,
   },

   {
      -- color f/t targets
      -- NOTE: consider removing this for `flash.nvim` or eye-liner (lua)
      "unblevable/quick-scope",
      enabled = true,
      init = function()
         vim.cmd([[ let g:qs_highlight_on_keys = ['f', 'F', 't', 'T'] ]]) -- only show after f/t
      end,
   },

   {
      -- quick navigation, extends search, extends char motions, remote operations
      -- F -> enter flash jump
      -- S -> select treesitter node
      -- r {operator} -> remote operations
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {
         labels = "asdfqwertgjklh",
         search = {
            mode = function(str)
               return "\\<" .. str
            end,
         },
         prompt = {
            enabled = true,
            prefix = { { "⚡Flash", "FlashPromptIcon" } },
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
            -- Visual select treesitter node
            "S",
            mode = { "n", "o" },
            function()
               require("flash").treesitter()
            end,
            desc = "Flash Treesitter",
         },
         {
            -- Operator on remote location
            -- Ex: yank remote word with yR<flash>iw or delete remote line with dR<flash>d
            "R",
            mode = "o",
            function()
               require("flash").remote()
            end,
            desc = "Remote Flash",
         },
         {
            -- same as above
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
      -- find dupes, suggest keybindings
      "tris203/hawtkeys.nvim",
      config = true,
   },

   {
      -- animated highlighting for yank, paste
      -- NOTE: this breaks insert mode <c-o>p
      "rachartier/tiny-glimmer.nvim",
      -- event = "TextYankPost",
      opts = {
         refresh_interval_ms = 10,
         transparency_color = "#021818",

         animations = {
            fade = {
               max_duration = 750,
               from_color = "#2d4f67",
            },
         },

         overwrite = {
            paste = {
               enabled = true,
            },
            undo = {
               enabled = true,
            },
            redo = {
               enabled = true,
            },
            -- search = {
            --    enabled = true,
            -- }
         },

         support = {
            -- TODO this doesnt seem to work https://github.com/rachartier/tiny-glimmer.nvim/issues/17
            -- integrate with gbprod/substitute.nvim
            substitute = {
               enabled = true,
               default_animation = "fade",
            },
         },
      },
   },

   {
      -- preview macros and norm commands with :Norm
      -- for macros, use :Norm 5@a syntax
      "smjonas/live-command.nvim",
      -- enabled = false,
      config = function()
         require("live-command").setup({
            commands = {
               -- create a previewable :Norm command
               Norm = { cmd = "norm" },
               -- this needs to be migrated for v2
               -- Reg = {
               --    cmd = "norm",
               --    -- This will transform ":5Reg a" into ":norm 5@a"
               --    args = function(opts)
               --       return (opts.count == -1 and "" or opts.count) .. "@" .. opts.args
               --    end,
               --    range = "",
               -- },
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
      },
      init = function()
         vim.g.tmux_navigator_no_mappings = 1 -- disable default mappings, TmuxNavigatePrevious
         vim.cmd([[
            nnoremap <silent> <c-h> :<C-U>TmuxNavigateLeft<cr>
            nnoremap <silent> <c-j> :<C-U>TmuxNavigateDown<cr>
            nnoremap <silent> <c-k> :<C-U>TmuxNavigateUp<cr>
            nnoremap <silent> <c-l> :<C-U>TmuxNavigateRight<cr>
         ]])

         -- vim.g.tmux_navigator_no_wrap = 1 -- disable wrapping at edges -- this breaks tmux unzoom
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

   {
      -- animated pretty notifications
      "rcarriga/nvim-notify",
      enabled = false,
      config = function()
         require("notify").setup({})
         vim.notify = require("notify")
      end,
   },

   {
      -- show keys that are and are not mapped in a keyboard visual
      -- :KeyAnalyzer <prefix>
      "meznaric/key-analyzer.nvim",
      opts = {},
   },

   {
      -- jumplist but just buffers
      "kwkarlwang/bufjump.nvim",
      config = function()
         require("bufjump").setup({
            forward_key = "<leader><c-i>",
            backward_key = "<leader><c-o>",
         })
      end,
   },

   {
      -- Improve marks experience
      -- dmx - delete mark x
      -- MarkListX - open marks in location lists or QF for quickfix
      "chentoast/marks.nvim",
      event = "VeryLazy",
      opts = {},
   },

   {
      -- highlights visual select matches
      "wurli/visimatch.nvim",
      opts = {},
   },

   {
      -- better helpview
      "OXY2DEV/helpview.nvim",
      lazy = false, -- plugin lazy loads by default
   },

   {
      -- automatically set cmdheight, prevent needing to press enter
      "jake-stewart/auto-cmdheight.nvim",
      enabled = false, -- might not be needed with noice
      lazy = false,
   },

   {
      -- hints for faster vim motions
      -- TODO: disable hints for hjkl https://github.com/m4xshen/hardtime.nvim/issues/160
      "m4xshen/hardtime.nvim",
      enabled = false, -- this breaks <c-n>???
      lazy = false,
      dependencies = { "MunifTanjim/nui.nvim" },
      opts = {
         restriction_mode = "hint", -- disble restrictions
         notification = false, -- disable notifications for disabled and restricted keys
         disabled_keys = {
            -- arrow keys are disabled by default
            ["<Up>"] = false,
            ["<Down>"] = false,
            ["<Left>"] = false,
            ["<Right>"] = false,
         },
      },
   },

   {
      -- Adds line/char move mappings
      -- <A-h/j/k/l>
      "booperlv/nvim-gomove", -- replaces mini.move
      config = true,
   },

   {
      -- persist cursor location
      "ethanholz/nvim-lastplace",
      enabled = true,
      config = function()
         require("nvim-lastplace").setup({})
      end,
   },

   {
      -- prevents nested vim sessions from nvim terminal
      -- NOTE: doesnt seem to work with toggleterm
      "brianhuster/unnest.nvim",
      enabled = false, -- seems to break with lazygit?
   },
}
