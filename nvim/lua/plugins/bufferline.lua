return {
   -- fancier tabline
   "akinsho/bufferline.nvim",
   dependencies = "nvim-tree/nvim-web-devicons",
   enabled = not vim.g.vscode,
   config = function()
      local background_color = "#151515" -- dark gray
      local dim_color = "#1a1a1a" -- dark gray
      -- local teal = "#00ffff"

      require("bufferline").setup({
         options = {
            numbers = function(opts)
               -- return string.format("%s·%s", opts.raise(opts.ordinal), opts.lower(opts.id))
               return opts.raise(opts.ordinal)
            end,
            show_buffer_close_icons = false,
            show_close_icon = false,
            modified_icon = "•",
            -- separator_style = { "", "" }, -- no separators
            separator_style = "slant",
            indicator = {
               -- style = "underline",
            },
            offsets = {
               {
                  filetype = "neo-tree",
                  text = "",
                  highlight = "Directory",
                  separator = true, -- use a "true" to enable the default, or set your own character
               },
               {
                  filetype = "NvimTree",
                  text = "",
                  highlight = "Directory",
                  separator = true, -- use a "true" to enable the default, or set your own character
               },
            },
         },
         highlights = {
            -- the background of the whole bar
            fill = {
               bg = background_color,
            },

            -- active buffer
            buffer_selected = {
               bold = true,
               italic = false,
               fg = "#ffffff",
            },
            -- for inactive tabs
            background = {
               bg = dim_color,
            },
            -- for visible tabs, but inactive
            buffer_visible = {
               bold = false,
               italic = false,
               fg = "#b1b1b1",
            },

            -- separator for active tab
            separator_selected = {
               fg = background_color,
            },
            -- separator for inactive tabs
            separator = {
               fg = background_color,
               bg = dim_color,
            },
            -- separtor for visible tabs, but not active
            separator_visible = {
               fg = background_color,
            },

            -- numbers in backgrund background buffers
            numbers = {
               bg = dim_color,
            },

            -- modified icon for active tab
            modified_selected = {
               fg = "#FFFF00",
            },
            -- modified icon for inactive tabs
            modified = {
               fg = "#FFFF00",
            },
            -- modified icon for inactive but visible tabs
            modified_visible = {
               fg = "#FFFF00",
            },
         },
      })
   end,
}
