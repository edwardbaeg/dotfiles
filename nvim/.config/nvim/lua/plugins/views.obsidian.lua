local home_path = vim.fn.expand("~")

return {
   "obsidian-nvim/obsidian.nvim",
   version = "*", -- recommended, use latest release instead of latest commit
   lazy = true,
   -- ft = "markdown",
   -- only load on obsidian .md files
   event = {
      "BufReadPre " .. home_path .. "/Sync/Obsidian Vault/*.md",
      "BufNewFile  " .. home_path .. "/Sync/Obsidian Vault/*.md",
   },
   dependencies = {
      "nvim-lua/plenary.nvim", -- Required
      "nvim-treesitter", -- to improve syntax highlighting
   },
   opts = {
      workspaces = {
         {
            name = "main",
            path = "~/Sync/Obsidian Vault/",
         },
      },
      picker = {
         name = "snacks.pick",
      },
      completion = {
         nvim_cmp = false,
         blink = true,
         min_chars = 1,
      },
      daily_notes = {
        folder = "dailies",
      },

      --- FIXME: does not work
      -- open = {
      --    func = function(uri)
      --       vim.ui.open(uri, { cmd = { "open", "-a", "/Applications/Obsidian.app" } })
      --    end,
      -- },
   },
   init = function()
      vim.api.nvim_create_autocmd("FileType", {
         pattern = { "markdown", "md" },
         callback = function()
            vim.wo.conceallevel = 2
         end,
      })

      -- Open vault home directory
      -- vim.api.nvim_create_user_command("OpenObsidianVault", function()
      --    vim.cmd("edit ~/Sync/Obsidian\\ Vault/")
      -- end, {})
      -- vim.keymap.set("n", "<leader>eo", ":OpenObsidianVault<CR>", { noremap = true, silent = true })

      vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian<cr>", { noremap = true, silent = true })
   end,
}
