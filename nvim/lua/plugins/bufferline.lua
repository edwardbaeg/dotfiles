return {
   -- fancier tabline
   "akinsho/bufferline.nvim",
   dependencies = "nvim-tree/nvim-web-devicons",
   enabled = not vim.g.vscode,
   config = function()
      -- local background_color = "#151515" -- dark gray
      local tab_background = "#000000" -- dark gray
      local dim_color = "#1a1a1a" -- dark gray
      local modified_color = "yellow" -- #FFFF00

      local white = "white" -- #ffffff

      require("bufferline").setup({
         options = {
            name_formatter = function(buf)
               if buf.name:find("^index") then
                  local parentDirName = buf.path:match("(.*)/(.*)$")
                  parentDirName = parentDirName:gsub(".*/", "")
                  return parentDirName .. "/" .. buf.name
               end
               return buf.name
            end,
            -- numbers = function(opts)
            --    return string.format("%s·%s", opts.raise(opts.ordinal), opts.lower(opts.id))
            --    return opts.raise(opts.ordinal)
            -- end,
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
            fill = { bg = tab_background },

            -- active buffer
            buffer_selected = {
               bold = true,
               italic = false,
               fg = white,
            },
            -- inactive buffer
            background = {
               bg = dim_color,
            },
            -- for visible tabs, but inactive
            buffer_visible = {
               bold = false,
               italic = false,
               fg = "#b1b1b1",
            },

            -- separator for active buffer tab
            separator_selected = {
               fg = tab_background,
            },
            -- separator for inactive tabs
            separator = {
               fg = tab_background,
               bg = dim_color,
            },
            -- separtor for visible tabs, but not active
            separator_visible = {
               fg = tab_background,
            },

            -- numbers in backgrund background buffers
            numbers = {
               bg = dim_color,
            },

            -- tab pages
            tab = {
               fg = white,
               -- bg = background_color,
            },
            tab_selected = {
               -- fg = '<colour-value-here>',
               -- bg = background_color,
            },
            tab_separator = {
               --   fg = '<colour-value-here>',
               fg = tab_background,
            },
            tab_separator_selected = {
               --   fg = '<colour-value-here>',
               fg = tab_background,
               --   sp = '<colour-value-here>',
               --   underline = '<colour-value-here>',
            },

            -- modified icon for active tab
            modified_selected = {
               fg = modified_color,
            },
            -- modified icon for inactive tabs
            modified = {
               fg = modified_color,
            },
            -- modified icon for inactive but visible tabs
            modified_visible = {
               fg = modified_color,
            },
         },
      })
   end,
}
