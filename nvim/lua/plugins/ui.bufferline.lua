local set = require("config.keymaps").set

return {
   {
      -- fancier tabline
      "akinsho/bufferline.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      -- enabled = not vim.g.vscode,
      enabled = false, -- trying out dart.nvim
      config = function()
         -- local background_color = "#151515" -- dark gray
         local tab_background = "#000000" -- dark gray
         local dim_color = "#1a1a1a" -- dark gray
         local modified_color = "yellow" -- #FFFF00

         local white = "white" -- #ffffff

         local utils = require("utils")

         require("bufferline").setup({
            options = {
               name_formatter = function(buf)
                  ---@diagnostic disable-next-line: undefined-field buf type is incorrect
                  return utils.get_filename_display(buf.name, buf.path, true)
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

         -- use theses over :bnext or :bprevious to follow the visual roder set by the plugin
         set("n", "<leader>bn", "<cmd>BufferLineCycleNext<cr>")
         set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<cr>")

         -- https://github.com/neovim/neovim/issues/20126#issuecomment-1296036118
         set("n", "<tab>", "<cmd>BufferLineCycleNext<cr>") -- this breaks <c-i>, seems to send the same terminal code?
         -- set("n", "<tab>", "<cmd>bnext<cr>") -- this breaks <c-i>, seems to send the same terminal code?
         set("n", "<s-tab>", "<cmd>BufferLineCyclePrev<cr>")
      end,
   },

   {
      -- minimal tabline with quick targets and pinning
      -- default usage:
      -- - ;; pin
      -- - ;a jump
      -- - ;p picker
      -- TODO: configure with session management with Dart.read_session(name)/Dart.write_session(name)
      -- dir = "~/dev/apps/dart.nvim",
      -- name = "dart",
      "iofq/dart.nvim",
      lazy = false, -- don't lazy load due to keys
      opts = {
         -- pinned
         marklist = { "a", "s", "d", "f" },
         -- marklist = { "q", "w", "e", "r" },
         -- recent
         buflist = { "q", "w", "e", "r" },
         -- buflist = { "q", "w", "e", "r", "z", "x", "c" },
         -- buflist = { "a", "s", "d", "f", "z", "x", "c" },
         mappings = {
            mark = ",,",
            jump = ",",
            next = "<leader>bn",
            prev = "<leader>bp",
            -- pick = ",p",
         },
         tabline = {
            -- order pinned first
            order = function(config)
               local order = {}
               for i, key in ipairs(vim.list_extend(vim.deepcopy(config.marklist), config.buflist)) do
                  order[key] = i
               end
               return order
            end,
         },
      },
      -- this integrates with which-key, considering doing for all
      keys = {
         {
            ",p",
            function()
               require("dart").pick()
            end,
            desc = "Dart pick",
         },
      },
      config = function(_, opts)
         require("dart").setup(opts)

         local dart = require("dart")

         set("n", "<tab>", dart.next)
         set("n", "<s-tab>", dart.prev)
      end,
   },
}
