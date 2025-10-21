-- collection of colorschemes
return {
   {
      -- colorscheme
      "catppuccin/nvim",
      name = "catppuccin",
      version = "1.x", -- v2 introduces some poor highlighting -- https://github.com/catppuccin/nvim/discussions/903#discussioncomment-13981361
      lazy = false, -- load main colorscheme during startup
      priority = 1000, -- load before other plugins change highlights
      config = function()
         ---@type CatppuccinOptions -- how did the lsp load this by default?
         require("catppuccin").setup({
            flavour = "frappe", -- default to use on startup
            background = {
               light = "latte",
               dark = "frappe",
            },
            transparent_background = true,
            float = {
               transparent = true, -- enables transparency on floating windows
               solid = false,
            },
            styles = {
               keywords = { "italic" },
               operators = { "italic" },
            },
            -- enabled by default: cmp, gitsigns, nvimtree, treesitter, mini
            integrations = {},
         })
         vim.cmd.colorscheme("catppuccin")
      end,
   },

   {
      -- green, blues, purples. Reminds me of the ocean
      "navarasu/onedark.nvim",
      -- lazy = true,
      config = function()
         require("onedark").setup({
            style = "cool", -- https://github.com/navarasu/onedark.nvim#themes
            -- toggle_style_key = "<leader>ts", -- cycle through all styles
            transparent = true, -- remove background
            code_style = {
               keywords = "italic",
            },
            lualine = {
               transparent = true,
            },
            diagnostics = {
               darker = true,
               background = false,
            },
         })
         -- vim.cmd.colorscheme("onedark")
      end,
   },

   {
      -- colorscheme
      -- the light version of this is tokyonight-day
      "folke/tokyonight.nvim",
      -- lazy = true,
      config = function()
         ---@diagnostic disable-next-line: missing-fields
         require("tokyonight").setup({
            -- transparent = true, -- don't set a background color
         })
         -- local tokyonight = require("tokyonight.colors").setup()
         -- local util = require("tokyonight.util")
         -- color = util.darken(tokyonight.orange, 0.5),
         -- color = util.darken(tokyonight.black, 0.5),

         -- vim.cmd.colorscheme("tokyonight-night")
      end,
   },

   {
      -- bold and contrasty dark theme with pinks, blues, and purples
      "nyoom-engineering/oxocarbon.nvim",
   },

   {
      -- removes backgrounds with highlight groups
      "xiyaowong/transparent.nvim",
      enabled = false, -- disable for light mode
      config = function()
         require("transparent").setup({})
      end,
   },

   {
      -- automatic light/dark mode based on OS settings
      "f-person/auto-dark-mode.nvim",
      opts = {
         set_light_mode = function()
            vim.api.nvim_set_option_value("background", "light", {})
            require("catppuccin").setup({
               transparent_background = true,
            })
            vim.cmd.colorscheme("catppuccin-latte")
         end,
      },
   },
}
