return {
   -- Quick access marks
   -- TODO: consider opening PR to add the ability to customize keybinds for floating window, eg to open in splits
   "cbochs/grapple.nvim",
   opts = {
      scope = "git",
      statusline = {
         -- icon = "󰛢", -- lualine options.icons_enabled must be true for this
      },
   },
   dependencies = { "WolfeCub/harpeek.nvim" },
   event = { "BufReadPost", "BufNewFile" },
   cmd = "Grapple",
   config = function()
      local columns = vim.api.nvim_get_option_value("columns", {})
      local lines = vim.api.nvim_get_option_value("lines", {})
      require("harpeek").setup({
         -- move to borrom right
         winopts = {
            row = lines * 0.80,
            col = columns,
         },
         -- todo include the parent dir for index files
         format = "filename",
      })

      local function harpeek_toggle()
         columns = vim.api.nvim_get_option_value("columns", {})
         lines = vim.api.nvim_get_option_value("lines", {})
         require("harpeek").toggle({ winopts = { row = lines * 0.80, col = columns } })
      end
      -- vim.keymap.set("n", "<c-h>", harpeek_toggle, { noremap = true, silent = true, desc = "[H]arpeek toggle" })
      vim.keymap.set("n", "<leader>h", harpeek_toggle, { noremap = true, silent = true, desc = "[H]arpeek toggle" })
      vim.api.nvim_create_user_command("HarpeekToggle", "lua require('harpeek').toggle()", {})
   end,
   keys = {
      { "<leader>m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
      -- { "<c-m>", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },

      -- { "<c-k>", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple toggle tags" },
      { "<leader>k", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple toggle tags" },

      -- { "<leader>K", "<cmd>Grapple toggle_scopes<cr>", desc = "Grapple toggle scopes" },

      { "<leader>L", "<cmd>Grapple cycle forward<cr>", desc = "Grapple cycle forward" },
      { "<leader>H", "<cmd>Grapple cycle backward<cr>", desc = "Grapple cycle backward" },

      { "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Grapple select 1" },
      { "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Grapple select 2" },
      { "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Grapple select 3" },
      { "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Grapple select 4" },
      { "<leader>5", "<cmd>Grapple select index=5<cr>", desc = "Grapple select 5" },
      { "<leader>6", "<cmd>Grapple select index=6<cr>", desc = "Grapple select 6" },
      { "<leader>7", "<cmd>Grapple select index=7<cr>", desc = "Grapple select 7" },
      { "<leader>8", "<cmd>Grapple select index=8<cr>", desc = "Grapple select 8" },
      { "<leader>9", "<cmd>Grapple select index=9<cr>", desc = "Grapple select 9" },
   },
}
