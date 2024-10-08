-- plugins that add visual elements to the vim ui
return {
   {
      -- show outline of symbols
      "hedyhli/outline.nvim",
      config = function()
         vim.keymap.set("n", "<leader>so", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

         require("outline").setup({
            -- autofold_depth = 1,
         })
      end,
   },

   {
      -- lists of diagnostics, references, telescopes, quickfix, and location lists
      "folke/trouble.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      event = "VeryLazy",
      -- cmd = "Trouble", -- lazy load
      config = function()
         require("trouble").setup()
         vim.keymap.set("n", "<leader>tt", function()
            require("trouble").toggle()
         end, { silent = true, noremap = true, desc = "[T]oggle [T]rouble" })
      end,
   },

   {
      -- indentation guides and highlight the current indent chunk -- this replaced indent-blankline.nvim
      -- TODO: replace with mini.indentscope
      "shellRaining/hlchunk.nvim",
      enabled = not vim.g.vscode,
      config = function()
         local frappe = require("catppuccin.palettes").get_palette("frappe")
         require("hlchunk").setup({
            -- highlight current indent chunk
            chunk = {
               enable = true,
               style = {
                  { fg = frappe.surface2 },
               },
               duration = 150, -- default 200
               delay = 200, -- default 300
            },
            -- highlight the line numbers for the current text chunk
            line_num = {
               enable = false,
            },
            -- add indent guides
            indent = {
               enable = true,
               -- chars = { "┊" }, -- default
               chars = { "┆" },
               -- chars = { "╎" },
               style = {
                  { fg = frappe.surface0 },
               },
            },
            blank = {
               enable = false,
            },
         })
      end,
   },

   {
      -- visual scrollbar
      "petertriho/nvim-scrollbar",
      event = "VeryLazy",
      enabled = not vim.g.vscode,
      config = function()
         require("scrollbar").setup({
            show_in_active_only = true, -- only show in active window
            handle = {
               -- color = "#111111",
               color = "grey9",
            },
            handlers = {
               -- cursor = false,
               gitsigns = true,
               search = true,
            },
         })
      end,
   },

   {
      -- start page for nvim
      "goolord/alpha-nvim",
      enabled = not vim.g.vscode,
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
         require("alpha").setup(require("alpha.themes.startify").config)
      end,
   },

   {
      -- color the line separating windows
      "nvim-zh/colorful-winsep.nvim",
      enabled = not vim.g.vscode,
      branch = "alpha",
      event = "VeryLazy",
      -- config = true,

      config = function()
         -- local frappe = require("catppuccin.palettes").get_palette("frappe")
         require("colorful-winsep").setup({
            -- events = { "WinEnter", "WinResized" },
            hi = {
               --    bg = "none",
               -- fg = "cyan4",
            },
            --
            -- integrations = {
            --    bufferline = true,
            -- },
            -- interval = 1000,

            -- These aren't working...
            only_line_seq = false,
            smooth = true,
            exponential_smoothing = true,
            anchor = {
               left = { height = 1, x = -1, y = -1 },
               right = { height = 1, x = -1, y = 0 },
               up = { width = 0, x = -1, y = 0 },
               bottom = { width = 0, x = 1, y = 0 },
            },
         })
      end,
   },

   {
      -- adds icons to netrw
      "prichrd/netrw.nvim",
      config = true,
   },

   {
      -- tree style file explorer
      -- has / fuzzy search to quickly jump to items
      "nvim-tree/nvim-tree.lua",
      event = "VeryLazy",
      -- enabled = false,
      config = function()
         require("nvim-tree").setup({
            actions = {
               open_file = {
                  window_picker = {
                     chars = "asdfjkl", -- default:  "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
                  },
               },
            },
         })
      end,
   },

   {
      "nvim-neo-tree/neo-tree.nvim",
      enabled = false,
      -- branch = "v3.x",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-tree/nvim-web-devicons",
         "MunifTanjim/nui.nvim",
      },
      config = function()
         require("neo-tree").setup({
            -- close_if_last_window = false, -- this closes vim entirely...
            filesystem = {
               hijack_netrw_behavior = "disabled",
            },
         })
      end,
   },

   {
      -- improved markdown view in neovim
      -- :RenderMarkdownToggle
      "MeanderingProgrammer/markdown.nvim",
      enabled = false,
      event = "VeryLazy",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
         require("render-markdown").setup({
            enabled = false,
         })
         vim.api.nvim_create_user_command("MarkdownRenderToggle", require("render-markdown").toggle, {})
      end,
   },

   {
      -- dim inactive windows
      "levouh/tint.nvim",
      config = function()
         require("tint").setup({
            tint = -20, -- default is -45, positive numbers will brighten
            saturation = 0.9, -- saturation to preserve
         })
      end,
   },

   {
      -- colors devicons to the nearest predefined color in the colorscheme
      "rachartier/tiny-devicons-auto-colors.nvim",
      dependencies = {
         "nvim-tree/nvim-web-devicons",
      },
      event = "VeryLazy",
      config = function()
         require("tiny-devicons-auto-colors").setup()
      end,
   },
}
