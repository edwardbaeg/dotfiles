return {
   "epwalsh/obsidian.nvim",
   version = "*", -- recommended, use latest release instead of latest commit
   lazy = true,
   ft = "markdown",
   -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
   -- event = {
   --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
   --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
   --   -- refer to `:h file-pattern` for more examples
   --   "BufReadPre path/to/my-vault/*.md",
   --   "BufNewFile path/to/my-vault/*.md",
   -- },
   dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
   },
   opts = {
      workspaces = {
         {
            name = "main",
            path = "~/Documents/Obsidian Vault/",
         },
         -- {
         --   name = "work",
         --   path = "~/vaults/work",
         -- },
      },
      picker = {
         name = "mini.pick",
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
