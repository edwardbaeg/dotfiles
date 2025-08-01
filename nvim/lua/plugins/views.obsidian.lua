local home_path = vim.fn.expand("~")

return {
   -- Obsidian functionality in neovim
   "obsidian-nvim/obsidian.nvim", -- this is the community maintained fork
   version = "*", -- recommended, use latest release instead of latest commit
   lazy = true,
   -- only load on obsidian .md files, replaces ft = "markdown",
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
         folder = "Dailies",
      },
      backlinks = {
         parse_headers = false, -- whether to parse header under cursor -- default is true
      },

      notes_subdir = "Quick Notes",
      new_notes_location = "notes_subdir",

      --- FIXME: does not work
      -- open = {
      --    func = function(uri)
      --       vim.ui.open(uri, { cmd = { "open", "-a", "/Applications/Obsidian.app" } })
      --    end,
      -- },

      ---@class obsidian.config.FooterOpts
      ---@field enabled? boolean
      ---@field format? string
      ---@field hl_group? string
      ---@field separator? string|false Set false to disable separator; set an empty string to insert a blank line separator.
      footer = {
         enabled = true,
         -- format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
         format = "{{backlinks}} backlinks  {{properties}} properties",
         hl_group = "Whitespace", -- TODO: find an alternative, check :h highlight-groups
         separator = string.rep("─", 80),
      },
      ---@class obsidian.config.CheckboxOpts
      ---@field order? string[]
      checkbox = {
         ---Order of checkbox state chars, e.g.{ " ", "~", "!", ">", "x" },
         order = { " ", "x" },
      },
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

      vim.keymap.set("n", "<leader>obs", "<cmd>Obsidian<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>obb", "<cmd>Obsidian backlinks<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>obn", "<cmd>Obsidian new<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>obq", "<cmd>Obsidian quick_switch<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>obr", "<cmd>Obsidian rename<cr>", { noremap = true, silent = true })
   end,
}
