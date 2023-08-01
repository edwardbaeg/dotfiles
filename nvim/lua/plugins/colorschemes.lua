-- collection of colorschemes
return {
   {
      -- colorscheme
      "catppuccin/nvim",
      name = "catppuccin",
      lazy = false, -- load main colorscheme during startup
      priority = 1000, -- load before other plugins change highlights
      config = function()
         require("catppuccin").setup({
            flavour = "frappe",
            transparent_background = true,
            styles = {
               keywords = { "italic" },
               operators = { "italic" },
            },
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
         -- vim.cmd([[colorscheme onedark]])
      end,
   },

   {
      -- colorscheme
      "folke/tokyonight.nvim",
      -- lazy = true,
      config = function()
         require("tokyonight").setup({
            transparent = true, -- don't set a background color
         })
         -- vim.cmd([[colorscheme tokyonight-night]])
      end,
   },

   {
      -- bold and contrasty dark theme with pinks, blues, and purples
      "nyoom-engineering/oxocarbon.nvim",
   },
}
