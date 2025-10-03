return {
   -- shows available keybinds, hydra mode
   -- NOTE: this can prevent reactive.nvim from working for operators if triggered
   -- Replaced with mini.clue
   "folke/which-key.nvim",
   enabled = false,
   -- dependencies = {
   --    "aaronik/treewalker.nvim", -- move around in a syntax aware manner with treesitter
   -- },
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
            border = "rounded",
         },
      })

      -- add grouping labels
      wk.add({
         { "<leader>fg", group = "Fuzzy git" },
         { "<leader>a", group = "Claude Code" },
         { "<leader>ob", group = "Obsidian" },
      })

      -- Hydra modes:
      -- TODO: set these up for git, diagnostics
      -- Would be nice if this "mode" could be styled differently

      -- Hydra: window navigation
      vim.keymap.set("n", "<c-w><space>", function()
         ---@type wk.Filter
         require("which-key").show({
            keys = "<c-w>",
            loop = true,
         })
      end)
   end,
}
