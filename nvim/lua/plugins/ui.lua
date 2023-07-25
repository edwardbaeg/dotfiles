return {
   {
      -- statusline
      "nvim-lualine/lualine.nvim",
      config = function()
         require("lualine").setup({
            options = {
               icons_enabled = false,
               theme = "onedark",
               component_separators = "|",
               section_separators = "",
            },
            extensions = {
               "lazy", -- doesn't seem to do anything?
               "mundo",
               "trouble",
            },
            sections = {
               lualine_a = { "mode" },
               lualine_b = { "branch", "diff", "diagnostics" },
               lualine_c = { { "filename", path = 1 }, "searchcount" },
               -- lualine_x = { "encoding", "fileformat", "filetype" },
               lualine_x = { "filetype" },
               lualine_y = { "progress" },
               lualine_z = { "location" },
            },
         })
      end,
   },
   {
      -- Add indentation guides
      "lukas-reineke/indent-blankline.nvim",
      config = function()
         require("indent_blankline").setup({
            char = "┊",
            show_trailing_blankline_indent = false,
            show_current_context = true,
         })
      end,
   },
   {
      -- fancier tabline
      "akinsho/bufferline.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      enabled = not vim.g.started_by_firenvim,
      config = function()
         local background_color = "#0a0a0a"
         require("bufferline").setup({
            options = {
               numbers = function(opts)
                  -- return string.format("%s·%s", opts.raise(opts.ordinal), opts.lower(opts.id))
                  return opts.raise(opts.ordinal)
               end,
               show_buffer_close_icons = false,
               show_close_icon = false,
               separator_style = { "", "" }, -- no separators
               modified_icon = "+",
            },
            highlights = {
               fill = { -- the backgruond of the whole bar
                  bg = background_color,
               },
               background = { -- for background "tabs"
                  bg = background_color,
               },
               buffer_selected = {
                  -- active buffer
                  bold = true,
                  italic = false,
                  fg = "white",
               },
               numbers = { -- background
                  bg = background_color,
               },
               modified_selected = { -- current
                  fg = "yellow",
               },
               modified = { -- background
                  fg = "yellow",
               },
            },
         })
      end,
   },
   {
      -- smooth scrolling
      "karb94/neoscroll.nvim",
      -- enabled = false,
      config = function()
         require("neoscroll").setup({
            mappings = {}, -- do not set default mappings... only use for <c-d/u>
            easing_function = "sine",
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
      -- enabled = false,
      config = function()
         require("scrollbar").setup({
            handle = {
               color = "black",
            },
         })
      end,
   },
}
