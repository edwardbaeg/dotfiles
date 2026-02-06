-- plugins that use nvim treesitter
return {
   {
      -- Highlight, edit, and navigate code
      -- TODO: add auto install capability
      -- Update all with :TSUpdate
      -- Uninstall with :TSUninstall
      "nvim-treesitter/nvim-treesitter",
      -- NOTE: Do NOT lazy load -- TODO: validate this
      lazy = false,
      dependencies = {
         -- NOTE: master branch is old; newer main branch requires main branch for nvim-treesitter
         { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" }, -- adds more text objects for treesitter
         "windwp/nvim-ts-autotag", -- autoclose and autorename html tags using treesitter
         "RRethy/nvim-treesitter-endwise", -- wisely add "end" in lua, vimscript, ruby, etc
         "andymass/vim-matchup", -- extend % matching, with opt in treesitter integration. Also highlights matches -- TODO: add END and START comment matching
      },
      -- NOTE: Run :TSInstall tsx after initial install
      branch = "master", -- this is the old branch. new default branch "main" requires breaking changes, eg no incremental_selection
      -- consider using https://github.com/MeanderingProgrammer/treesitter-modules.nvim
      build = ":TSUpdate",
      config = function()
         ---@diagnostic disable-next-line: missing-fields, param-type-mismatch
         require("nvim-treesitter.configs").setup({
            incremental_selection = {
               enable = true,
               keymaps = {
                  init_selection = "<leader>gx", -- this is just to disable the default keymap gnn, to use `gn` with navbuddy
                  node_incremental = "v",
                  node_decremental = "V",
               },
            },
            -- RRethy/nvim-treesitter-endwise
            endwise = {
               enable = true,
            },
            -- andymass/vim-matchup
            matchup = {
               enable = true,
            },
            ensure_installed = {
               "bash",
               "c",
               "css",
               "go",
               "html",
               "javascript",
               "json",
               "kdl", -- zellij config file
               "lua",
               "make", -- makefiles
               "markdown",
               "markdown_inline",
               "python",
               "query",
               "regex",
               "terraform",
               "toml",
               "tsx",
               "typescript",
               "vim",
               "vimdoc",
               "yaml",
               -- "cpp",
               -- "rust",
               -- "vue",
            },
            highlight = {
               enable = true,
               additional_vim_regex_highlighting = true, -- regex highlighting helps with jsx indenting, but otherwise its bad
            },
            -- FIXME: indentation not always working with js files. May need to try something like nvim-yati
            indent = {
               enable = true,
               disable = { "python" }, -- there are issues with python https://github.com/nvim-treesitter/nvim-treesitter/issues/1136
            },
            textobjects = {
               select = {
                  enable = true,
                  lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                  keymaps = {
                     -- Can use the capture groups defined in textobjects.scm
                     ["af"] = "@function.outer",
                     ["if"] = "@function.inner",
                     -- ['aa'] = '@parameter.outer',
                     -- ['ia'] = '@parameter.inner',
                     -- ['ac'] = '@class.outer',
                     -- ['ic'] = '@class.inner',
                  },
               },
               move = {
                  enable = true,
                  set_jumps = true, -- whether to set jumps in the jumplist
                  goto_next_start = {
                     -- [']m'] = '@function.outer',
                     -- [']]'] = '@class.outer',
                  },
                  goto_next_end = {
                     -- [']M'] = '@function.outer',
                     -- [']['] = '@class.outer',
                     ["sfb"] = "@punctuation.bracket", -- doesn't work :(
                  },
                  goto_previous_start = {
                     -- ['[m'] = '@function.outer',
                     -- ['[['] = '@class.outer',
                  },
                  goto_previous_end = {
                     -- ['[M'] = '@function.outer',
                     -- ['[]'] = '@class.outer',
                  },
               },
               swap = {
                  enable = true,
                  swap_next = {
                     ["<leader>."] = "@parameter.inner",
                  },
                  swap_previous = {
                     ["<leader>,"] = "@parameter.inner",
                  },
               },
            },
         })

         ---@diagnostic disable-next-line: missing-fields
         require("nvim-ts-autotag").setup({
            opts = {
               enable_close = true, -- Auto close tags
               enable_rename = true, -- Auto rename pairs of tags
               enable_close_on_slash = false, -- Auto close on trailing </
            },
         })

         vim.g.matchup_matchparen_deferred = 1 -- deferred highlighting to improve cursor movement performance
         -- vim.api.nvim_set_hl(0, 'MatchParen', {
         --    -- ctermbg = 'blue',
         --    -- bg = 'lightgrey',
         -- })
      end,
   },

   {
      -- consistently color function arguments. Works without LSP
      -- TODO: add italics to this highlight group, adding to Hlargs doesn't work
      "m-demare/hlargs.nvim",
      config = function()
         require("hlargs").setup({})
         vim.api.nvim_set_hl(0, "Hlargs", { italic = true })
      end,
   },

   {
      -- Enhance nvim native commenting
      -- this replaced "numToStr/Comment.nvim" and "JoosepAlviste/nvim-ts-context-commentstring"
      "folke/ts-comments.nvim",
      opts = {},
      event = "VeryLazy",
      -- enabled = vim.fn.has("nvim-0.10.0") == 1,
   },

   {
      -- Commenting plugin
      -- this is now part of nvim 0.10, but doesn't seem to be context aware...
      -- eg sometimes it will do blockwise instead of linewise in typescriptreact
      "numToStr/Comment.nvim",
      -- enabled = false,
      event = "VeryLazy",
      dependencies = {
         "JoosepAlviste/nvim-ts-context-commentstring", -- context aware commenting
      },
      config = function()
         require("ts_context_commentstring").setup({
            enable_autocmd = true,
         })
         ---@diagnostic disable-next-line: missing-fields
         require("Comment").setup({
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
         })
         -- comment line in insert mode
         -- vim.keymap.set(
         --    "i",
         --    "<c-g>c",
         --    "<esc><Plug>(comment_toggle_linewise_current)",
         --    { noremap = false, silent = true }
         -- )
      end,
   },

   {
      -- show code context at the top of the buffer
      "nvim-treesitter/nvim-treesitter-context",
      -- enabled = false,
      config = function()
         require("treesitter-context").setup({
            multiwindow = true, -- default is false
            -- max_lines = 3,
            -- max_lines = 0, -- 0 is unlimited
            max_lines = "10%", -- 0 is unlimited
            -- hi TreesitterContextLineNumberBottom sets an underline
            -- separator = "-",
            -- separator = "—",
            -- separator = "─",
            zindex = 1, -- default is 20, lower to show under floating windows
         })
      end,
   },

   {
      -- split or join blocks of code using treesitter
      -- note: the treesitter integration works well with jsx compared to mini.splitjoin
      "Wansmer/treesj",
      cmd = "TSJToggle",
      config = function()
         require("treesj").setup({
            use_default_keymaps = false,
         })
      end,
      init = function()
         vim.keymap.set("n", "<leader>sj", ":TSJToggle<CR>", { desc = "[S]plit/[J]oin", silent = true })
         -- vim.keymap.set("n", "sj", ":TSJToggle<CR>", { desc = "[S]plit/[J]oin" })
      end,
   },

   {
      -- create annotations for func, class, type
      "danymat/neogen",
      event = "VeryLazy",
      dependencies = "nvim-treesitter/nvim-treesitter",
      config = function()
         require("neogen").setup({
            enabled = true,
            languages = {
               typescriptreact = {
                  template = {
                     annotation_convention = "tsdoc",
                  },
               },
            },
         })
      end,
   },

   {
      -- Add virtual text to ending parens with context
      "code-biscuits/nvim-biscuits",
      dependencies = "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      enabled = false, -- this drastically slows down help file scrolling... and disabling does not work
      -- lazy loading is currently broken https://github.com/code-biscuits/nvim-biscuits/issues/47
      -- event = "VeryLazy",
      config = function()
         require("nvim-biscuits").setup({
            cursor_line_only = true,
            default_config = {
               prefix_string = "- ",
            },
            language_config = {
               help = {
                  disabled = true,
               },
            },
         })
      end,
   },

   {
      -- Navigate with treesitter syntax context
      -- Also set up to move sibling nodes
      "aaronik/treewalker.nvim",
      opts = {
         highlight = true, -- highlight node after jumpting to it
      },
      event = "VeryLazy",
      config = function(_, opts)
         require("treewalker").setup(opts)
         -- vim.keymap.set("n", "<leader>,", "<cmd>Treewalker SwapLeft<cr>")
         -- vim.keymap.set("n", "<leader>.", "<cmd>Treewalker SwapRight<cr>")

         -- Hydra: Treewalker submode (via mini.clue)
         -- Press <leader>t<space> then use hjkl to navigate
         vim.keymap.set("n", "<leader>t<space>j", ":Treewalker Down<cr>", { silent = true, desc = "Down" })
         vim.keymap.set("n", "<leader>t<space>k", ":Treewalker Up<cr>", { silent = true, desc = "Up" })
         vim.keymap.set("n", "<leader>t<space>h", ":Treewalker Left<cr>", { silent = true, desc = "Left" })
         vim.keymap.set("n", "<leader>t<space>l", ":Treewalker Right<cr>", { silent = true, desc = "Right" })
         -- FIXME: this doesn't work. Want the ability to exit hydramode without having to press <esc>
         vim.keymap.set("n", "<leader>tq", "<Esc>", { silent = true })
      end,
   },

   {
      -- Swap sibling nodes with treesitter
      -- Usage: <leader>. and <leader>,
      -- NOTE: setting this with lazy.opts/keys doesnt work well - cannot disable default keymaps and use lazy.keys at the same time
      -- FIXME?: disable its keymaps for <a-j/k>?
      "Wansmer/sibling-swap.nvim",
      enabled = false, -- replaced with tree-walker, treesitter-textobjects
      event = "VeryLazy",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
         local sibling_swap = require("sibling-swap")
         ---@diagnostic disable-next-line: missing-fields they are not required
         sibling_swap.setup({
            use_default_keymaps = true, -- this needs to be true to use the `keymaps` field?
            keymaps = {
               ["<leader>."] = "swap_with_right",
               ["<leader>,"] = "swap_with_left",
            },
         })

         vim.keymap.set("n", "<leader>,", sibling_swap.swap_with_left)
         vim.keymap.set("n", "<leader>.", sibling_swap.swap_with_right)
      end,
   },

   {
      -- tree sitter powered print/log statements
      -- usage: gl*
      "Goose97/timber.nvim",
      dependencies = "nvim-treesitter/nvim-treesitter",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      -- config = true,
      opts = {
         -- FIXME these arent working, trying to replace double quotes with single quotes in js/ts
         log_templates = {
            default = {
               javascript = [[console.log('%log_target', %log_target)]],
               typescript = [[console.log('%log_target', %log_target)]],
               javascriptreact = [[console.log('%log_target', %log_target)]],
               typescriptreact = [[console.log('%log_target', %log_target)]],
            },
            plain = {
               javascript = [[console.log('%insert_cursor')]],
               typescript = [[console.log('%insert_cursor')]],
               javascriptreact = [[console.log('%insert_cursor')]],
               typescriptreact = [[console.log('%insert_cursor')]],
            },
         },
         batch_log_templates = {
            default = {
               javascript = [[console.log({ %repeat<'%log_target': %log_target><, > })]],
               typescript = [[console.log({ %repeat<'%log_target': %log_target><, > })]],
               javascriptreact = [[console.log({ %repeat<'%log_target': %log_target><, > })]],
               typescriptreact = [[console.log({ %repeat<'%log_target': %log_target><, > })]],
            },
         },
         keymaps = {
            insert_log_below = "<leader>lj",
            insert_log_above = "<leader>lk",
            -- insert_plain_log_below = "glo",
            -- insert_plain_log_above = "gl<S-o>",
            -- insert_batch_log = "glb",
            -- add_log_targets_to_batch = "gla",
            -- insert_log_below_operator = "g<S-l>j",
            -- insert_log_above_operator = "g<S-l>k",
            -- insert_batch_log_operator = "g<S-l>b",
            -- add_log_targets_to_batch_operator = "g<S-l>a",
         },
         default_keymaps_enabled = false,
      },
   },
}
