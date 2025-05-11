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
      end,
   },
}
