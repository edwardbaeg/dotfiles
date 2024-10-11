-- plugins that use nvim treesitter
return {
   {
      -- Highlight, edit, and navigate code
      -- Uninstall with :TSUninstall
      "nvim-treesitter/nvim-treesitter",
      dependencies = {
         "nvim-treesitter/nvim-treesitter-textobjects", -- adds more text objects for treesitter
         "windwp/nvim-ts-autotag", -- autoclose and autorename html tags using treesitter
         "RRethy/nvim-treesitter-endwise", -- wisely add "end" in lua, vimscript, ruby, etc
         "andymass/vim-matchup", -- extend % matching
      },
      -- NOTE: Don't lazy load treesitter
      -- Run :TSInstall tsx after initial install
      build = function()
         pcall(require("nvim-treesitter.install").update({ with_sync = true }))
      end,
      config = function()
         ---@diagnostic disable-next-line: missing-fields
         require("nvim-treesitter.configs").setup({
            incremental_selection = {
               enable = true,
               keymaps = {
                  init_selection = "<leader>gx", -- this is just to disable the default keymap gnn, to use `gn` with navbuddy
                  node_incremental = "v",
                  node_decremental = "V",
               },
            },
            endwise = { -- for "RRethy/nvim-treesitter-endwise"
               enable = true,
            },
            matchup = { -- for "andymass/vim-matchup"
               enable = true,
            },
            ensure_installed = {
               "c",
               -- "cpp",
               "css",
               "go",
               "html",
               "javascript",
               "lua",
               "markdown",
               "markdown_inline",
               "python",
               "terraform",
               "tsx",
               "typescript",
               "vim",
               "vimdoc",
               -- "rust",
               -- "vue",
               "query",
            },
            highlight = {
               enable = true,
               additional_vim_regex_highlighting = true, -- regex highlighting helps with jsx indenting, but otherwise its bad
            },
            indent = { enable = true, disable = { "python" } },
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
                     ["<leader>a"] = "@parameter.inner",
                  },
                  swap_previous = {
                     ["<leader>A"] = "@parameter.inner",
                  },
               },
            },
         })

         require("nvim-ts-autotag").setup({
            opts = {
               enable_close = true, -- Auto close tags
               enable_rename = true, -- Auto rename pairs of tags
               enable_close_on_slash = false, -- Auto close on trailing </
            },
         })
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
      -- comment
      -- this is now part of nvim 0.10, but doesn't seem to be context aware...
      "numToStr/Comment.nvim",
      -- enabled = false,
      lazy = false,
      dependencies = {
         "JoosepAlviste/nvim-ts-context-commentstring", -- context aware commenting
      },
      config = function()
         require("ts_context_commentstring").setup({
            enable_autocmd = false,
         })
         ---@diagnostic disable-next-line: missing-fields
         require("Comment").setup({
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
         })
         -- alternative keymap to toggle comment line; rolling keys is faster
         vim.keymap.set("n", "gjk", "<Plug>(comment_toggle_linewise_current)", { noremap = false, silent = true })
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
            max_lines = 3,
            separator = "-",
         })
      end,
   },

   {
      -- split or join blocks of code using treesitter
      "Wansmer/treesj",
      cmd = "TSJToggle",
      config = function()
         require("treesj").setup({
            use_default_keymaps = false,
         })
      end,
      init = function()
         vim.keymap.set("n", "<leader>sj", ":TSJToggle<CR>", { desc = "[S]plit/[J]oin" })
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
            snippet_engine = "luasnip",
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
}
