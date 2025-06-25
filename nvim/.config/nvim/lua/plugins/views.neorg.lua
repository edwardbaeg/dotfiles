return {
   {
      -- note taking
      -- NOTE: requires luarocks to be installed
      -- TODO: add `q` to quit
      "nvim-neorg/neorg",
      enabled = false,
      event = "VeryLazy",
      -- lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
      version = "*", -- Pin Neorg to the latest stable release
      config = function()
         require("neorg").setup({
            load = {
               ["core.defaults"] = {},
               ["core.concealer"] = {},
               ["core.dirman"] = {
                  config = {
                     -- TODO: set up workspaces, work, personal, dotfiles
                     workspaces = {
                        notes = "~/notes",
                        work = "~/work",
                        dotfiles = "~/dev/dotfiles",
                     },
                     default_workspace = "notes",
                  },
               },
            },
         })

         -- TODO: only set this for neog files
         -- vim.wo.foldlevel = 99
         -- vim.wo.conceallevel = 2
      end,
   },
}
