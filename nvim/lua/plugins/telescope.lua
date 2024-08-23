return {

   -- Fuzzy Finder (files, lsp, etc)
   "nvim-telescope/telescope.nvim",
   cmd = "Telescope",
   dependencies = {
      "nvim-lua/plenary.nvim", -- library of async functons
      "nvim-telescope/telescope-ui-select.nvim", -- replace nvim's ui select with telescope
      "debugloop/telescope-undo.nvim", -- visually shows undo history
      { -- c port of fzf
         "nvim-telescope/telescope-fzf-native.nvim",
         build = "make",
      },
      "tsakirist/telescope-lazy.nvim", -- for navigating plugins installed by lazy.nvim
   },
   init = function()
      -- vim.keymap.set("n", "<c-p>", "<cmd>Telescope find_files<cr>") -- replaced with fzflua
      -- vim.keymap.set("n", "<c-b>", "<cmd>Telescope buffers<cr>") -- replaced with fzflua
      -- vim.keymap.set("n", "<c-l>", "<cmd>Telescope current_buffer_fuzzy_find<cr>") -- replace with tmux navigator keymap
      -- vim.keymap.set("n", "<c-g>", '<cmd>Telescope grep_string search=""<cr>') -- set search="" to prevent searching the word under the cursor -- replaced with fzflua

      vim.keymap.set("n", "<leader>ft", "<cmd>Telescope<cr>", { desc = "[f]uzzy [T]elescope" })
      -- vim.keymap.set("n", "<leader>fl", "<cmd>Telescope current_buffer_fuzzy_find<cr>") -- replace with fzflua
      vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "[f]uzzy [h]help" })
      vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "[f]uzzy [k]eymaps" })
      vim.keymap.set("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "[f]uzzy [c]ommands" })
      vim.keymap.set("n", "<leader>fi", "<cmd>Telescope highlights<cr>", { desc = "[f]uzzy h[i]ghlights" })
      -- vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "[f]uzzy [o]ldfiles" })
      vim.keymap.set("n", "<leader>fs", "<cmd>Telescope spell_suggest<cr>", { desc = "[f]uzzy [s]pell_suggest" })
      vim.keymap.set("n", "<leader>ss", "<cmd>Telescope spell_suggest<cr>", { desc = "fuzzy [s]pell_[s]uggest" })
      -- vim.keymap.set("n", "<leader>fj", "<cmd>Telescope jumplist<cr>", { desc = "[f]uzzy [j]umplist" }) -- replaced with fzflua
      vim.keymap.set("n", "<leader>bi", "<cmd>Telescope buffers<cr>")
      -- vim.keymap.set("n", "<leader>fg", "<cmd>Telescope git_bcommits<cr>", { desc = "[f]uzzy [g]ic bcommits" })

      -- NOTE: use <c-r> to revert to selected commit
      vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>", { desc = "[f]uzzy [u]ndo" })
   end,
   config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
         defaults = {
            -- TODO: add the ability to move up and down selections with <c-j/k>
            mappings = {
               i = {
                  ["<C-u>"] = false,
                  ["<C-d>"] = false,

                  -- open selections in new buffers
                  -- OR can use <c-q> to open all matches to a quickfix
                  ["<C-o>"] = function(p_bufnr)
                     actions.send_selected_to_qflist(p_bufnr)
                     vim.cmd.cfdo("edit")
                  end,
               },
            },
            layout_strategy = "flex",
            -- TODO: add a max width
            layout_config = {
               -- prompt_position = 'bottom',
               width = 0.9,
               height = 0.9,
               -- flip_columns = 150, -- this is in the wrong spot?
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
               -- TODO: look up what this is
               vim_diff_opts = {
                  ctxlen = 6,
               },
            },
         },
      })

      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("undo")
      require("telescope").load_extension("lazy")
      require("telescope").load_extension("session-lens")

      -- custom picker that greps the word under the cursor (cword)
      -- https://github.com/nvim-telescope/telescope.nvim/issues/1766#issuecomment-1150437074
      -- vim.keymap.set("n", "<leader>*", "<cmd>lua live_grep_cword()<cr>")
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
}
