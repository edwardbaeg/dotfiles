---@diagnostic disable: missing-fields

-- plugins that use nvim treesitter
return {
   {
      -- Highlight, edit, and navigate code
      "nvim-treesitter/nvim-treesitter",
      dependencies = {
         "nvim-treesitter/nvim-treesitter-textobjects", -- adds more text objects for treesitter
         "windwp/nvim-ts-autotag", -- autoclose html tags using treesitter
         "RRethy/nvim-treesitter-endwise", -- wisely add "end" in lua
      },
      -- NOTE: Don't lazy load treesitter
      -- Run :TSInstall tsx after initial install
      build = function()
         pcall(require("nvim-treesitter.install").update({ with_sync = true }))
      end,
      config = function()
         require("nvim-treesitter.configs").setup({
            incremental_selection = {
               enable = true,
               keymaps = {
                  init_selection = "<leader>gi", -- this is just to disable the default keymap gnn
                  node_incremental = "v",
                  node_decremental = "V",
               },
            },
            endwise = {
               enable = true, -- for "RRethy/nvim-treesitter-endwise"
            },
            matchup = {
               enable = true,
            },
            autotag = {
               enable = true,
               enable_close_on_slash = false,
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
            },
            highlight = {
               enable = true, --[[ additional_vim_regex_highlighting = true ]]
            }, -- regex highlighting helps with jsx indenting, but otherwise its bad
            indent = { enable = true, disable = { "python" } },
            textobjects = {
               select = {
                  enable = true,
                  lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                  keymaps = {
                     -- Can use the capture groups defined in textobjects.scm
                     ["af"] = "@function.outer",
                     -- ['aa'] = '@parameter.outer',
                     -- ['ia'] = '@parameter.inner',
                     -- ['if'] = '@function.inner',
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
      end,
   },

   {
      -- consistently color function arguments. Works without LSP
      -- TODO: add italics to this highlight group, adding to Hlargs doesn't work
      "m-demare/hlargs.nvim",
      config = function()
         require("hlargs").setup({})
      end,
   },

   {
      -- comment
      "numToStr/Comment.nvim",
      event = "VeryLazy",
      dependencies = {
         "JoosepAlviste/nvim-ts-context-commentstring", -- context aware commenting
      },
      config = function()
         require("ts_context_commentstring").setup({
            enable_autocmd = false,
         })
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
            max_lines = 5,
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
         vim.keymap.set("n", "sj", ":TSJToggle<CR>", { desc = "[S]plit/[J]oin" })
      end,
   },

   {
      -- quickly select wrapping text objects with <cr>
      "sustech-data/wildfire.nvim",
      enabled = false, -- this can be replaced with treesitter's built in incremental_selection
      event = "VeryLazy",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
         require("wildfire").setup({})
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
}
