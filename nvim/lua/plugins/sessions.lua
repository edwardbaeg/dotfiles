return {
   {
      -- automatically save sessions
      -- TODO: add an entry to the Alpha dashboard for this
      "folke/persistence.nvim",
      event = "BufReadPre",
      config = true,
      init = function()
         vim.keymap.set("n", "<leader>sl", function()
            require("persistence").load()
         end, { desc = "[s]ession [l]oad", silent = true })
         vim.keymap.set("n", "<leader>ss", function()
            require("persistence").save()
         end, { desc = "[s]ession [s]ave", silent = true })
         vim.keymap.set("n", "<leader>sS", function()
            require("persistence").select()
         end, { desc = "[s]ession [S]elect", silent = true })
      end,
   },
}
