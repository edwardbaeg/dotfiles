return {
   -- add tabpage interface for cycling through diffs
   -- :DiffView*
   "sindrets/diffview.nvim",
   config = function()
      require("diffview").setup()

      vim.keymap.set("n", "<leader>do", "<cmd>DiffviewOpen<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>dq", "<cmd>DiffviewClose<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>df", "<cmd>DiffviewFileHistory %<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>dm", "<cmd>DiffviewOpen master..HEAD<cr>", { noremap = true })

      local function diffOpenWithInput()
         -- local user_input = vim.fn.input("Revision to Open: ")
         -- todo replace with some ui plugin like dressing.nvim or nui
         vim.ui.input({ prompt = "Revision to Open: " }, function(input)
            vim.cmd("DiffviewOpen " .. input)
         end)
      end

      require("which-key").add({
         {
            "<leader>di", diffOpenWithInput, desc = "Diffview [I]nput"
         }
      })
   end,
}
