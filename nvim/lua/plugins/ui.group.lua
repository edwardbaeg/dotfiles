-- Plugins that adds or modifies visual elements to the vim ui
return {
   {
      -- indentation guides and highlight the current indent chunk -- this replaced indent-blankline.nvim
      -- TODO?: replace with mini.indentscope
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
               duration = 100, -- default 200
               delay = 100, -- default 300
               exclude_filetypes = {
                  snacks_picker_list = true,
               },
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
               exclude_filetypes = {
                  snacks_picker_list = true,
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
               color = "#444444",
               -- color = "#111111",
               -- color = "grey9",
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
      -- adds icons to netrw
      "prichrd/netrw.nvim",
      config = true,
   },

   {
      -- tree style file explorer
      -- has / fuzzy search to quickly jump to items
      "nvim-tree/nvim-tree.lua",
      event = "VeryLazy",
      enabled = false,
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
      -- markdown previewer in neovim
      -- :Markview
      "OXY2DEV/markview.nvim",
      enabled = false,
      lazy = false, -- Recommended
      dependencies = {
         "nvim-treesitter/nvim-treesitter",
         "nvim-tree/nvim-web-devicons",
      },
   },

   {
      -- improved markdown view in neovim
      -- :RenderMarkdownToggle
      "MeanderingProgrammer/render-markdown.nvim",
      -- enabled = false,
      event = "VeryLazy",
      ft = {
         "markdown",
         "codecompanion",
      },
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
         require("render-markdown").setup({
            enabled = false, -- render by default
         })
         vim.api.nvim_create_user_command("RenderMarkdownToggle", function()
            require("render-markdown").toggle()
         end, {})
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

   {
      -- automatically centers and buffers window(s) if the screen is wide
      -- :NoNeckPain
      "shortcuts/no-neck-pain.nvim",
      opts = {
         width = 100,
         -- autocmds = {
         --    enableOnVimEnter = true,
         -- },
      },
      init = function()
         vim.keymap.set("n", "<leader>np", ":NoNeckPain<cr>")
      end,
   },

   {
      -- animated cursor smear effect
      "sphamba/smear-cursor.nvim",
      enabled = false, -- replaced with kitty cli effect
      opts = {
         stiffness = 0.8, -- 0.6      [0, 1]
         trailing_stiffness = 0.6, -- 0.3      [0, 1], tail length?
         -- trailing_exponent = 0, -- 0.1      >= 0
         -- 0.5 here disables letter to letter trailing
         distance_stop_animating = 0.5, -- 0.1      > 0
         -- hide_target_hack = false, -- true     boolean
      },
   },

   {
      -- Show key strokes in window
      "NStefan002/screenkey.nvim",
      cmd = "Screenkey",
      version = "*",
      config = true,
   },

   {
      -- image support
      "3rd/image.nvim"
   }
}
