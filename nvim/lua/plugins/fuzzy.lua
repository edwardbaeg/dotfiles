-- fuzzy finders
return {
   {
      "ibhagwan/fzf-lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
         require("fzf-lua").setup({
            winopts = {
               preview = {
                  layout = "vertical",
               },
            },
         })
      end,
      init = function()
         vim.keymap.set("n", "<c-g>", "<cmd>lua require('fzf-lua').grep_project()<cr>", { silent = true })
         vim.keymap.set("n", "<c-b>", "<cmd>lua require('fzf-lua').buffers()<cr>", { silent = true })
      end,
   },

   {
      -- Fuzzy Finder (files, lsp, etc)
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      cmd = "Telescope",
      dependencies = {
         "nvim-lua/plenary.nvim", -- library of async functons
         "nvim-telescope/telescope-ui-select.nvim", -- replace nvim's ui select with telescope
         "debugloop/telescope-undo.nvim", -- visually shows undo history
         "nvim-telescope/telescope-fzf-native.nvim", -- c port of fzf
         "tsakirist/telescope-lazy.nvim", -- for navigating plugins installed by lazy.nvim
         {
            "aaronhallaert/ts-advanced-git-search.nvim", -- look through git history
            dependencies = "tpope/vim-fugitive",
         },
      },
      init = function()
         vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>")

         vim.keymap.set("n", "<c-p>", "<cmd>Telescope find_files<cr>")
         -- vim.keymap.set("n", "<c-b>", "<cmd>Telescope buffers<cr>")
         vim.keymap.set("n", "<leader>bi", "<cmd>Telescope buffers<cr>")
         vim.keymap.set("n", "<c-l>", "<cmd>Telescope current_buffer_fuzzy_find<cr>")
         vim.keymap.set("n", "<c-h>", "<cmd>Telescope help_tags<cr>")
         -- vim.keymap.set("n", "<c-g>", '<cmd>Telescope grep_string search=""<cr>') -- set search="" to prevent searching the word under the cursor
         vim.keymap.set("n", "<c-t>", "<cmd>Telescope<cr>")

         vim.keymap.set("n", "<leader>fd", "<cmd>Telescope<cr>", { desc = "[f]uzzy [f]ind" })
         vim.keymap.set("n", "<leader>ff", "<cmd>Telescope<cr>", { desc = "[f]uzzy [f]ind" })
         vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "[f]uzzy [h]help" })
         vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "[f]uzzy [k]eymaps" })
         vim.keymap.set("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "[f]uzzy [c]ommands" })
         vim.keymap.set("n", "<leader>fi", "<cmd>Telescope highlights<cr>", { desc = "[f]uzzy h[i]ghlights" })
         vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "[f]uzzy [o]ldfiles" })
         vim.keymap.set("n", "<leader>fs", "<cmd>Telescope spell_suggest<cr>", { desc = "[f]uzzy [s]pell_suggest" })
         vim.keymap.set("n", "<leader>ss", "<cmd>Telescope spell_suggest<cr>", { desc = "fuzzy [s]pell_[s]uggest" })
      end,
      config = function()
         -- local actions = require("telescope.actions")
         require("telescope").setup({
            defaults = {
               mappings = {
                  i = {
                     ["<C-u>"] = false,
                     ["<C-d>"] = false,
                     -- ["<C-cr>"] = actions.select_tab, -- cannot map to <c-cr>
                  },
               },
               layout_strategy = "flex",
               layout_config = {
                  -- prompt_position = 'bottom',
                  width = 0.9,
                  height = 0.9,
               },
               dynamic_preview_title = true,
            },
            pickers = {
               buffers = {
                  theme = "dropdown",
                  sort_lastused = true,
                  -- previewer = true,
               },
               find_files = {
                  -- hidden = true,
               },
               spell_suggest = {
                  theme = "dropdown",
               },
            },
            extensions = {
               ["ui-select"] = {
                  require("telescope.themes").get_dropdown({}),
               },
               undo = {
                  use_delta = true,
                  diff_context_lines = 6, -- defaults to scroll
               },
            },
         })

         -- require("telescope").load_extension("harpoon")
         require("telescope").load_extension("ui-select")
         require("telescope").load_extension("undo")
         require("telescope").load_extension("lazy")
         require("telescope").load_extension("advanced_git_search")

         -- custom picker that greps the word under the cursor (cword)
         -- https://github.com/nvim-telescope/telescope.nvim/issues/1766#issuecomment-1150437074
         vim.keymap.set("n", "<leader>*", "<cmd>lua live_grep_cword()<cr>")
         _G.live_grep_cword = function()
            local cword = vim.fn.expand("<cword>")
            require("telescope.builtin").live_grep({
               default_text = cword,
               on_complete = cword ~= ""
                     and {
                        function(picker)
                           local mode = vim.fn.mode()
                           local keys = mode ~= "n" and "<ESC>" or ""
                           vim.api.nvim_feedkeys(
                              vim.api.nvim_replace_termcodes(keys .. [[^v$<C-g>]], true, false, true),
                              "n",
                              true
                           )
                           table.remove(picker._completion_callbacks, 1)
                           vim.tbl_map(function(mapping)
                              vim.api.nvim_buf_set_keymap(0, "s", mapping.lhs, mapping.rhs, {})
                           end, vim.api.nvim_buf_get_keymap(0, "i"))
                        end,
                     }
                  or nil,
            })
         end
      end,
   },
}
