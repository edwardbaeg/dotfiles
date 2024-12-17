return {
   -- shows available keybinds, hydra mode
   -- NOTE: this can prevent reactive.nvim from working for operators if triggered
   "folke/which-key.nvim",
   dependencies = {
      "aaronik/treewalker.nvim", -- move around in a syntax aware manner with treesitter
   },
   config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 200

      local wk = require("which-key")
      wk.setup({
         plugins = {
            presets = {
               -- operators = false,
            },
         },
         win = {
            border = "single",
         },
      })

      -- Hydra modes:
      -- TODO: set these up for git, diagnostics
      -- Would be nice if this "mode" could be styled differently
      vim.keymap.set("n", "<c-w><space>", function()
         ---@type wk.Filter
         require("which-key").show({
            keys = "<c-w>",
            loop = true,
         })
      end)

      -- Treewalker
      vim.keymap.set("n", "<leader>tj", ":Treewalker Down<cr>", { silent = true })
      vim.keymap.set("n", "<leader>tk", ":Treewalker Up<cr>", { silent = true })
      vim.keymap.set("n", "<leader>th", ":Treewalker Left<cr>", { silent = true })
      vim.keymap.set("n", "<leader>tl", ":Treewalker Right<cr>", { silent = true })

      vim.keymap.set("n", "<leader>t<space>", function()
         ---@type wk.Filter
         require("which-key").show({
            keys = "<leader>t",
            loop = true,
         })
      end)
   end,
}
