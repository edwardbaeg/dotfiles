return {
   {
      -- automatically save sessions
      -- TODO: add an entry to the Alpha dashboard for this
      "folke/persistence.nvim",
      dependencies = { "iofq/dart.nvim" },
      event = "BufReadPre",
      config = true,
      init = function()
         vim.keymap.set("n", "<leader>sl", function()
            require("persistence").load()
         end, { desc = "[s]ession [l]oad", silent = true })
         vim.keymap.set("n", "<leader>ss", function()
            require("persistence").save()
         end, { desc = "[s]ession [s]ave", silent = true })
         vim.keymap.set("n", "<leader>sf", function()
            require("persistence").select()
         end, { desc = "[s]ession select [f]uzzy", silent = true })

         -- Dart session integration
         vim.api.nvim_create_autocmd("User", {
            pattern = "PersistenceLoadPost",
            callback = function()
               require("dart").read_session("test")
            end,
         })

         vim.api.nvim_create_autocmd("User", {
            pattern = "PersistenceSavePre",
            callback = function()
               require("dart").write_session("test")
            end,
         })
      end,
   },
}
