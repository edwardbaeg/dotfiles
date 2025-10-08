local set = require("utils").set

return {
   {
      -- opens 'foo/bar' in github with gx
      "gabebw/vim-github-link-opener",
      -- Usage: :OpenGitHubLink -- TODO: would be nice to disable this? bc it is too close to :GitPortalOpenLink
      init = function()
         vim.g.github_link_opener_no_mappings = 1 -- disable default mapping. the default mapping is gx but it is not silent.
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
         local gitsigns = require("gitsigns")
         gitsigns.setup({
            sign_priority = 10,
            signs = {
               add = { text = "•" },
               change = { text = "•" },
               delete = { text = "•" },
               untracked = { text = "·" },
            },
            preview_config = {
               border = "rounded",
            },
         })

         -- NOTE: previously, these highlight groups need to be loaded async
         vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#009900" })
         vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#bbbb00" })
         vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#626880" })
         vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff2222" })

         set("n", "gh", function() -- NOTE: the default mapping for gh is start select mode
            gitsigns.nav_hunk("next")
         end, { desc = "Next hunk" })

         -- Submode hunk navigation (via mini.clue)
         -- TODO: consider creating a helper to generate standalone and submode mappings
         -- Press <leader>g<space> then use j/k to navigate hunks, p to preview, i for inline
         set("n", "<leader>g<space>j", function()
            gitsigns.nav_hunk("next")
         end, { desc = "Next hunk" })
         set("n", "<leader>g<space>k", function()
            gitsigns.nav_hunk("prev")
         end, { desc = "Prev hunk" })
         set("n", "<leader>g<space>p", gitsigns.preview_hunk, { desc = "Preview hunk" })
         set("n", "<leader>g<space>i", gitsigns.preview_hunk_inline, { desc = "Preview inline" })

         -- set("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git hunk: [p]review" })
         -- set("n", "<leader>hl", gitsigns.setloclist, { desc = "git hunk: [l]ist in location list" })
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

   {
      -- Open remote github repos
      -- Usage: :GitDevOpen <url>
      "moyiz/git-dev.nvim",
      cmd = { "GitDevOpen" },
      opts = {},
   },

   {
      -- Github
      -- usage: :Octo
      "pwntester/octo.nvim",
      -- enabled = false,
      cmd = { "Octo" },
      dependencies = {
         "nvim-lua/plenary.nvim",
         "folke/snacks.nvim",
         "nvim-tree/nvim-web-devicons",
      },
      opts = {
         picker = "snacks",
      },
   },
}
