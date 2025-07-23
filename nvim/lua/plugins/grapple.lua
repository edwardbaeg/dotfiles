return {
   -- Quick access marks
   "cbochs/grapple.nvim",
   dependencies = {
      "WolfeCub/harpeek.nvim", -- show options in persistent window
   },
   event = { "BufReadPost", "BufNewFile" },
   cmd = "Grapple",
   config = function()
      require("grapple").setup({
         scope = "git_branch", -- set default scope
         statusline = {
            -- icon = "󰛢", -- lualine options.icons_enabled must be true for this
         },
      })

      local columns = vim.api.nvim_get_option_value("columns", {})
      local lines = vim.api.nvim_get_option_value("lines", {})

      local utils = require("utils")

      -- TODO: open automatically if there are marks
      require("harpeek").setup({
         -- move to borrom right
         winopts = {
            row = lines * 0.80,
            col = columns,
         },
         format = function (path)
            local filename = utils.get_filename_from_path(path)
            return utils.get_filename_display(filename, path)
         end,
      })

      local function harpeek_toggle()
         columns = vim.api.nvim_get_option_value("columns", {})
         lines = vim.api.nvim_get_option_value("lines", {})
         require("harpeek").toggle({ winopts = { row = lines * 0.80, col = columns } })
      end
      -- vim.keymap.set("n", "<c-h>", harpeek_toggle, { noremap = true, silent = true, desc = "[H]arpeek toggle" })
      -- vim.keymap.set("n", "<leader>h", harpeek_toggle, { noremap = true, silent = true, desc = "[H]arpeek toggle" })
      vim.keymap.set("n", "<leader>kh", harpeek_toggle, { noremap = true, silent = true, desc = "[H]arpeek toggle" })
      vim.api.nvim_create_user_command("HarpeekToggle", "lua require('harpeek').toggle()", {})
   end,
   keys = {
      -- Toggle tag
      { "<leader>kl", function ()
         require("grapple").toggle()
         vim.notify("Grapple toggled buffer")
      end, desc = "Grapple toggle tag" },

      -- Show grapple tags
      { "<leader>kk", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple toggle tags" },

      -- Quick jump to tag
      -- this is not really used
      -- { "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Grapple select 1" },
      -- { "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Grapple select 2" },
      -- { "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Grapple select 3" },
      -- { "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Grapple select 4" },
      -- { "<leader>5", "<cmd>Grapple select index=5<cr>", desc = "Grapple select 5" },
      -- { "<leader>6", "<cmd>Grapple select index=6<cr>", desc = "Grapple select 6" },
      -- { "<leader>7", "<cmd>Grapple select index=7<cr>", desc = "Grapple select 7" },
      -- { "<leader>8", "<cmd>Grapple select index=8<cr>", desc = "Grapple select 8" },
      -- { "<leader>9", "<cmd>Grapple select index=9<cr>", desc = "Grapple select 9" },
   },
}
