return {
   -- Quick access marks
   -- TODO: fix showing the statusline icon
   "cbochs/grapple.nvim",
   opts = {
      scope = "git",
      statusline = {
         icon = "󰛢",
      },
   },
   event = { "BufReadPost", "BufNewFile" },
   cmd = "Grapple",
   keys = {
      { "<leader>m", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
      { "<c-m>", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },

      { "<c-k>", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple toggle tags" },
      -- { "<leader>k", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple toggle tags" },

      { "<leader>K", "<cmd>Grapple toggle_scopes<cr>", desc = "Grapple toggle scopes" },

      { "<leader>L", "<cmd>Grapple cycle forward<cr>", desc = "Grapple cycle forward" },
      { "<leader>H", "<cmd>Grapple cycle backward<cr>", desc = "Grapple cycle backward" },

      { "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Grapple select 1" },
      { "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Grapple select 2" },
      { "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Grapple select 3" },
      { "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Grapple select 4" },
   },
}
