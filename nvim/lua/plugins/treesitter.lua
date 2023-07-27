return {
   {
      -- comment
      "numToStr/Comment.nvim",
      dependencies = {
         "JoosepAlviste/nvim-ts-context-commentstring", -- context aware commenting
      },
      config = function()
         require("Comment").setup({
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
         })
         -- comment line in insert mode
         vim.keymap.set(
            "i",
            "<c-g>c",
            "<esc><Plug>(comment_toggle_linewise_current)",
            { noremap = false, silent = true }
         )
      end,
   },

   {
      -- Highlight, edit, and navigate code
      "nvim-treesitter/nvim-treesitter",
      dependencies = {
         "nvim-treesitter/nvim-treesitter-textobjects", -- adds more text objects for treesitter
         "windwp/nvim-ts-autotag", -- autoclose html tags using treesitter
         "JoosepAlviste/nvim-ts-context-commentstring", -- context aware commenting
      },
      build = function()
         pcall(require("nvim-treesitter.install").update({ with_sync = true }))
      end,
      config = function()
         require("nvim-ts-autotag").setup({}) -- don't forget to run :TSInstall tsx
         require("nvim-treesitter.configs").setup({
            autotag = {
               enable = true,
            },
            ensure_installed = {
               "c",
               "cpp",
               "css",
               "go",
               -- "help",
               "html",
               "javascript",
               "lua",
               "markdown",
               "markdown_inline",
               "python",
               "rust",
               "tsx",
               "typescript",
               "vim",
               "vue",
            },
            context_commentstring = {
               enable = true,
               enable_autocmd = false,
            },
            highlight = {
               enable = true, --[[ additional_vim_regex_highlighting = true ]]
            }, -- regex highlighting helps with jsx indenting, but otherwise its bad
            indent = { enable = true, disable = { "python" } },
            incremental_selection = {
               enable = true,
               keymaps = {
                  init_selection = "<c-space>",
                  node_incremental = "<c-space>",
                  scope_incremental = "<c-s>",
                  node_decremental = "<c-backspace>",
               },
            },
            textobjects = {
               select = {
                  enable = true,
                  lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                  keymaps = {
                     -- You can use the capture groups defined in textobjects.scm
                     -- ['aa'] = '@parameter.outer',
                     -- ['ia'] = '@parameter.inner',
                     ["af"] = "@function.outer",
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
      -- visually shows treesitter data
      "nvim-treesitter/playground",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
      config = function()
         require("nvim-treesitter.configs").setup({})
      end,
      init = function()
         vim.keymap.set(
            "n",
            "<leader>ph",
            ":TSHighlightCapturesUnderCursor<CR>",
            { desc = "[P]layground[H]ighlightCapturesunderCursor" }
         )
         vim.keymap.set("n", "<leader>pt", ":TSPlaygroundToggle<CR>", { desc = "[P]layground[T]oggle" })
      end,
   },

   {
      -- visually shows treesitter data
      "nvim-treesitter/playground",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
      config = function()
         require("nvim-treesitter.configs").setup({})
      end,
      init = function()
         vim.keymap.set(
            "n",
            "<leader>ph",
            ":TSHighlightCapturesUnderCursor<CR>",
            { desc = "[P]layground[H]ighlightCapturesunderCursor" }
         )
         vim.keymap.set("n", "<leader>pt", ":TSPlaygroundToggle<CR>", { desc = "[P]layground[T]oggle" })
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
      end,
   },

   {
      -- show code context at the top of the buffer
      "nvim-treesitter/nvim-treesitter-context",
      enabled = false,
      config = function()
         require("treesitter-context").setup({})
      end,
   },
}
