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
      config = true,
      cmd = "Trouble", -- lazy load
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
      -- Add indentation guides
      "lukas-reineke/indent-blankline.nvim",
      enabled = not vim.g.vscode,
      config = function()
         require("ibl").setup({
            indent = {
               char = "┊",
            },
            scope = {
               enabled = false,
            },
         })
      end,
   },

   {
      -- highlight the current indent chunk
      "shellRaining/hlchunk.nvim",
      enabled = not vim.g.vscode,
      config = function()
         require("hlchunk").setup({
            indent = {
               enable = false,
            },
            line_num = {
               enable = false,
            },
            blank = {
               enable = false,
            },
         })
      end,
   },

   {
      -- smooth scrolling
      "karb94/neoscroll.nvim",
      -- NOTE: this can be replaced with mini.animate
      -- enabled = not vim.g.vscode,
      enabled = false,
      config = function()
         require("neoscroll").setup({
            mappings = {}, -- do not set default mappings... only use for <c-d/u>
            -- easing_function = "sine",
            easing_function = nil,
            -- disable sending events with each line scroll. has weird interactions with nvim-scrollbar
            -- pre_hook = function()
            --    vim.opt.eventignore:append({
            --       "WinScrolled",
            --       "CursorMoved",
            --    })
            -- end,
            -- post_hook = function()
            --    vim.opt.eventignore:remove({
            --       "WinScrolled",
            --       "CursorMoved",
            --    })
            -- end,
         })

         -- speed up the animation time https://github.com/karb94/neoscroll.nvim/pull/68
         local t = {}
         -- Syntax: t[keys] = {function, {function arguments}}
         t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "100" } }
         t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "100" } }

         require("neoscroll.config").set_mappings(t)
      end,
   },

   {
      -- add visual scrollbar
      "petertriho/nvim-scrollbar",
      event = "VeryLazy",
      enabled = not vim.g.vscode,
      config = function()
         local frappe = require("catppuccin.palettes").get_palette("frappe")
         local tokyonight = require("tokyonight.colors").setup()
         local util = require("tokyonight.util")

         --          {
         --   none = "NONE",
         --   bg_dark = "#1f2335",
         --   bg = "#24283b",
         --   bg_highlight = "#292e42",
         --   terminal_black = "#414868",
         --   fg = "#c0caf5",
         --   dark5 = "#737aa2",
         --   blue0 = "#3d59a1",
         --   blue = "#7aa2f7",
         --   cyan = "#7dcfff",
         --   blue1 = "#2ac3de",
         --   blue2 = "#0db9d7",
         --   blue5 = "#89ddff",
         --   blue6 = "#b4f9f8",
         --   blue7 = "#394b70",
         --   magenta = "#bb9af7",
         --   magenta2 = "#ff007c",
         --   purple = "#9d7cd8",
         --   orange = "#ff9e64",
         --   yellow = "#e0af68",
         --   green = "#9ece6a",
         --   green1 = "#73daca",
         --   green2 = "#41a6b5",
         --   teal = "#1abc9c",
         --   red = "#f7768e",
         --   red1 = "#db4b4b",
         --   git = { change = "#6183bb", add = "#449dab", delete = "#914c54" },
         --   gitSigns = {
         --     add = "#266d6a",
         --     change = "#536c9e",
         --     delete = "#b2555b",
         --   },
         -- }

         require("scrollbar").setup({
            handle = {
               color = "#111111",
               -- color = "black",
               -- color = frappe.base,
               -- color = tokyonight.black,
               -- color = util.darken(tokyonight.orange, 0.5),
               -- color = util.darken(tokyonight.black, 0.5),
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
      config = function()
         -- local frappe = require("catppuccin.palettes").get_palette("frappe")
         require("colorful-winsep").setup({
            highlight = {
               bg = "none",
               fg = "cyan4",
            },
            integrations = {
               bufferline = true,
            },
            -- interval = 1000,
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
      -- floating statusline
      "b0o/incline.nvim",
      event = "VeryLazy",
      config = function()
         require("incline").setup({
            window = {
               padding = 0,
               margin = {
                  horizontal = 0,
               },
            },
            render = function(props)
               local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
               if filename == "" then
                  filename = "[No Name]"
               end
               local modified = vim.bo[props.buf].modified
               return {
                  { filename .. (modified and " [+]" or ""), gui = modified and "bold,italic" or "bold" },
               }
            end,
         })
      end,
   },
}
