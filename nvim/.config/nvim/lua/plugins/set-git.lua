return {
   {
      -- opens 'foo/bar' in github with gx
      "gabebw/vim-github-link-opener",
      init = function()
         -- this remaps the default mapping with silent flag
         vim.g.github_link_opener_no_mappings = 1
         vim.keymap.set("n", "gx", ":OpenGitHubLink<cr>", { silent = true })
      end,
   },

   {
      -- open current line in github permalink
      "ruifm/gitlinker.nvim",
      config = function()
         require("gitlinker").setup({
            -- mappings = "<leader>gg", -- default is gy
         })
         vim.keymap.set(
            "n",
            "<leader>gl",
            '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
            { silent = true }
         )
         vim.keymap.set(
            "v",
            "<leader>gl",
            '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
            { silent = true }
         )
         vim.api.nvim_create_user_command(
            "Glink",
            'lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})',
            { desc = "Open github link in browser" }
         )
         vim.api.nvim_create_user_command(
            "Gbrowse",
            'lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})',
            { desc = "Open github link in browser" }
         )
      end,
   },

   {
      -- Adds git blame line as virtual text or in the status bar
      "f-person/git-blame.nvim",
      config = function()
         require("gitblame").setup({})
         -- vim.g.gitblame_message_template = "<author> • <summary> • <date>"
         -- vim.g.gitblame_message_template = "<author>, <summary>, <date>"
         vim.g.gitblame_message_template = "<author>, <date>"
         vim.g.gitblame_date_format = "%r" -- relative date
         vim.g.gitblame_message_when_not_committed = "Not committed"
      end,
   },

   {
      -- Adds git commands
      -- This is mostly used for :Git blame, TODO find replacement for it
      -- NOTE: would be nice if `q` for the blame window would focus the previous buffer...
      "tpope/vim-fugitive",
      -- dependencies = { "tpope/vim-rhubarb" }, -- this is required for :Gbrowse
      init = function()
         vim.g.fugitive_no_maps = true -- disable default mappings (specifically y<c-g>)

         vim.keymap.set("n", "<leader>gb", ":Git blame<cr>")
      end,
   },

   {
      -- git actions and visual git signs
      "lewis6991/gitsigns.nvim",
      config = function()
         require("gitsigns").setup({
            signs = {
               add = { text = "•" },
               change = { text = "•" },
               delete = { text = "•" },
               untracked = { text = "·" },
            },
         })

         -- test!
         -- vim.keymap.set("n", "gh", ":Gitsigns next_hunk<cr>")
         -- vim.keymap.set("n", "gH", ":Gitsigns prev_hunk<cr>")

         -- these highlight groups need to be loaded async?
         -- vim.defer_fn(function ()
         vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#009900" })
         vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#bbbb00" })
         vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#626880" })
         vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff2222" })
         -- end, 0)

         vim.keymap.set("n", "gh", ":Gitsigns next_hunk<cr>", { silent = true })
         vim.keymap.set("n", "gH", ":Gitsigns prev_hunk<cr>", { silent = true })
      end,
   },

   {
      -- Open git links
      -- currently only used for opening external links within nvim
      -- :GitPortal open_link or :GitPortalOpenLink
      "trevorhauter/gitportal.nvim",
      config = true,
      init = function()
         vim.api.nvim_create_user_command("GitPortalOpenLink", function()
            require("gitportal").open_file_in_neovim()
         end, {})
      end,
   },
}
