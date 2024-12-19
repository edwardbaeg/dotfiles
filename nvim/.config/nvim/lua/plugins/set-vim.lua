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
      enabled = not vim.g.vscode,
      -- event = "VeryLazy",
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
      },
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
      enabled = false, -- replaced with luminate.nvim
      config = function()
         require("highlight-undo").setup({})
      end,
   },

   {
      -- highlight yank, paste, undo, redo
      -- TODO: sometimes has some issues after exiting floating windows, like for navbuddy?
      "mei28/luminate.nvim",
      event = { "VeryLazy" },
      config = function()
         require("luminate").setup({})
      end,
   },

   {
      -- improve interacting with quickfix and location list
      -- TODO: group together quickfix plugins
      "kevinhwang91/nvim-bqf",
      config = function()
         require("bqf").setup()
      end,
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

   {
      -- Fix "bad" vim habits
      -- TODO: remove mode from the cmd line
      "m4xshen/hardtime.nvim",
      enabled = false, -- this breaks multicursor.nvim
      dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
      opts = {
         disable_mouse = false,
         restriction_mode = "block", -- block | hint
         max_count = 7,
         -- resetting_keys = {
         --    ["h"] = {},
         -- },
         restricted_keys = {
            -- ["h"] = {},
            -- ["j"] = {},
            -- ["k"] = {},
            -- ["l"] = {},
         },
         disabled_keys = {
            -- Allow these keys
            ["<Up>"] = {},
            ["<Down>"] = {},
            ["<Left>"] = {},
            ["<Right>"] = {},
            ["<c-n>"] = {},
         },
         disabled_filetypes = { "grapple" },
         init = function()
            -- this doesn't work??
            -- vim.opt.cmdheight = 2
         end,
      },
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
      "chentoast/marks.nvim",
      event = "VeryLazy",
      opts = {},
   },
}
