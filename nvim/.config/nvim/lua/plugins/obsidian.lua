return {
   "obsidian-nvim/obsidian.nvim",
   version = "*", -- recommended, use latest release instead of latest commit
   lazy = true,
   -- ft = "markdown",
   event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
      -- refer to `:h file-pattern` for more examples
      "BufReadPre " .. vim.fn.expand("~") .. "/Sync/Obsidian Vault/*.md",
      "BufNewFile  " .. vim.fn.expand("~") .. "/Sync/Obsidian Vault/*.md",
   },
   dependencies = {
      "nvim-lua/plenary.nvim", -- Required
   },
   opts = {
      workspaces = {
         {
            name = "main",
            path = "~/Sync/Obsidian Vault/",
         },
         -- {
         --   name = "work",
         --   path = "~/vaults/work",
         -- },
      },
      picker = {
         name = "mini.pick",
      },
      completion = {
         nvim_cmp = false,
         blink = true,
         min_chars = 1,
      },
   },
   init = function()
      vim.api.nvim_create_autocmd("FileType", {
         pattern = { "markdown", "md" },
         callback = function()
            vim.wo.conceallevel = 2
         end,
      })
   end,
}
