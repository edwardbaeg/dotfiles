return {
   -- add tabpage interface for cycling through diffs
   -- :DiffView*
   "sindrets/diffview.nvim",
   config = function()
      require("diffview").setup()

      -- TODO: add g to each keymap
      vim.keymap.set("n", "<leader>do", "<cmd>DiffviewOpen<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>dq", "<cmd>DiffviewClose<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>gdq", "<cmd>DiffviewClose<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>df", "<cmd>DiffviewFileHistory %<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>dm", "<cmd>DiffviewOpen master..HEAD<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>gdm", "<cmd>DiffviewOpen master..HEAD<cr>", { noremap = true })

      local actions = require("diffview.actions")
      vim.keymap.set("n", "<leader>dn", actions.next_conflict, { noremap = true, desc = "[n]ext conflict" })
      vim.keymap.set("n", "<leader>gdn", actions.next_conflict, { noremap = true, desc = "[n]ext conflict" })
      vim.keymap.set("n", "<leader>dp", actions.prev_conflict, { noremap = true, desc = "[p]revious conflict" })
      vim.keymap.set("n", "<leader>gdp", actions.prev_conflict, { noremap = true, desc = "[p]revious conflict" })

      local function diffOpenWithInput()
         -- local user_input = vim.fn.input("Revision to Open: ")
         -- todo replace with some ui plugin like dressing.nvim or nui
         vim.ui.input({ prompt = "Revision to Open: " }, function(input)
            vim.cmd("DiffviewOpen " .. input)
         end)
      end

      -- ignore changes in the amount of whitespace
      vim.o.diffopt = "iwhite"

      require("which-key").add({
         {
            "<leader>di", diffOpenWithInput, desc = "Diffview [I]nput"
         }
      })
   end,
}