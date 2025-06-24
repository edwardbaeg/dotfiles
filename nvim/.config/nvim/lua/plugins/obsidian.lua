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
   },
   opts = {
      workspaces = {
         {
            name = "main",
            path = "~/Sync/Obsidian Vault/",
         },
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
