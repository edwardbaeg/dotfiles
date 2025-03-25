return {
   {
      -- automatically save sessions
      "folke/persistence.nvim",
      event = "BufReadPre",
      config = true,
      init = function()
         vim.keymap.set("n", "<leader>sl", function()
            require("persistence").load()
         end, { desc = "[s]ession [l]oad", silent = true })
      end,
   },

   {
      -- automatic sessions management
      -- TODO: consider folke/persistence.nvim
      "rmagatti/auto-session",
      enabled = false,
      config = function()
         require("auto-session").setup({
            auto_restore_enabled = false,
            auto_save_enabled = true,
         })
         -- vim.keymap.set("n", "<leader>ls", require("auto-session.session-lens").search_session, {
         --    noremap = true,
         -- })
         vim.keymap.set("n", "<leader>ss", "<cmd>SessionSave<cr>", {
            noremap = true,
         })
         vim.keymap.set("n", "<leader>sr", "<cmd>SessionRestore<cr>", {
            noremap = true,
         })

         -- recommended settings
         vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
      end,
   },

   {
      -- wrapper for session commands
      "Shatur/neovim-session-manager",
      enabled = false,
      config = function()
         require("session_manager").setup({
            -- autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir
            autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
         })

         vim.keymap.set(
            "n",
            "<leader>sc",
            ":SessionManager load_current_dir_session<CR>",
            { desc = "[S]essionManager load_[c]urrent_dir_session" }
         )
         vim.keymap.set(
            "n",
            "<leader>sl",
            ":SessionManager load_session<CR>",
            { desc = "[S]essionManager [l]oad_session" }
         )
         vim.keymap.set(
            "n",
            "<leader>sd",
            ":SessionManager delete_session<CR>",
            { desc = "[S]essionManager [d]elete_session" }
         )
      end,
   },
}
