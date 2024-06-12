---@diagnostic disable: missing-fields

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
      -- shows possible key bindings
      -- NOTE: this can prevent reactive.nvim from working for operators
      "folke/which-key.nvim",
      -- enabled = false,
      config = function()
         vim.o.timeout = true
         vim.o.timeoutlen = 200
         require("which-key").setup({
            plugins = {
               presets = {
                  operators = false,
               },
            },
            operators = {
               -- only works if pressed after timeout
               gc = "Comments",
               sa = "Surround",
               gR = "Replace",
               gs = "Sort",
               gX = "Exchange",
            },
            window = {
               border = "single",
               margin = { 0, 0, 0, 0 },
               padding = { 1, 0, 1, 0 },
               -- winblend = 10, -- disable for transparency mode
            },
         })
      end,
   },

   {
      -- indentation guides and highlight the current indent chunk -- this replaced indent-blankline.nvim
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
               delay = 300, -- default 300
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
            handle = {
               -- color = "#111111",
               color = "grey9",
            },
            handlers = {
               cursor = false,
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
      -- branch = "alpha", -- doesn't seem to work for me...
      -- local frappe = require("catppuccin.palettes").get_palette("frappe")
      config = function()
         require("colorful-winsep").setup({
            hi = {
               bg = "none",
               fg = "cyan4",
            },

            -- integrations = {
            --    bufferline = true,
            -- },
            -- interval = 1000,

            -- these are curerntly on the alpha branch:
            -- smooth = true,
            -- exponential_smoothing = true,
         })
      end,
   },

   {
      -- adds icons to netrw
      "prichrd/netrw.nvim",
      config = true,
   },

   {
      "nvim-tree/nvim-tree.lua",
      enabled = false,
      config = function()
         require("nvim-tree").setup({})
      end,
   },

   {
      "nvim-neo-tree/neo-tree.nvim",
      enabled = false,
      branch = "v3.x",
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
      -- per window floating statusline
      "b0o/incline.nvim",
      event = "VeryLazy",
      config = function()
         require("incline").setup({
            window = {
               padding = 0,
               margin = {
                  horizontal = 0,
                  vertical = 0, -- overlap window border
               },
            },
            render = function(props)
               local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
               local modified = vim.bo[props.buf].modified

               if filename == "" then
                  filename = "[No Name]"
               end
               if modified then
                  filename = "[+] " .. filename
               end

               return {
                  { filename, gui = modified and "bold,italic" or "bold" },
               }
            end,
         })
      end,
   },

   {
      -- improved markdown view in neovim
      "MeanderingProgrammer/markdown.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
         require("render-markdown").setup({})
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
