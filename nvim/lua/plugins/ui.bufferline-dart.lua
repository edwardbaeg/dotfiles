local set = require("config.keymaps").set
local catppuccin = require("catppuccin.palettes").get_palette()
local themeGreen = catppuccin.green

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
      -- dir = "~/dev/apps/dart.nvim",
      -- name = "dart",
      "iofq/dart.nvim",
      lazy = false, -- don't lazy load for session stuff
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
            label_fg = "orange",
            label_marked_fg = themeGreen,
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
         local dart = require("dart")
         dart.setup(opts)

         local to_hex = require("utils").to_hex

         set("n", "<tab>", dart.next)
         set("n", "<s-tab>", dart.prev)

         -- TODO: different highlight color for pinned/marked buffers

         -- Get Catppuccin colors
         local catppuccin = require("catppuccin.palettes").get_palette()

         -- this is the default highlight for visible but not current
         local tabLineHighight = vim.api.nvim_get_hl(0, { name = "TabLine" })

         -- Current buffer highlights
         local themeBlue = catppuccin.blue
         vim.api.nvim_set_hl(0, "DartCurrent", { fg = themeBlue, bold = true })
         vim.api.nvim_set_hl(0, "DartCurrentLabel", { fg = "orange", bg = "none", bold = true })
         vim.api.nvim_set_hl(0, "DartMarkedCurrent", { fg = themeBlue, bold = true })
         -- vim.api.nvim_set_hl(0, "DartCurrentLabel", { fg = themeBlue, bold = true })
         --
         -- -- Modified buffer highlights
         local themeYellow = catppuccin.yellow
         vim.api.nvim_set_hl(0, "DartVisibleModified", { fg = themeYellow, bg = to_hex(tabLineHighight.bg) })
         vim.api.nvim_set_hl(0, "DartCurrentModified", { fg = themeYellow, bg = "none" })
         vim.api.nvim_set_hl(0, "DartMarkedModified", { fg = themeYellow, bg = to_hex(tabLineHighight.bg) })
         vim.api.nvim_set_hl(0, "DartMarkedCurrentModified", { fg = themeYellow, bold = true })
         vim.api.nvim_set_hl(0, "DartVisibleLabelModified", { fg = orange, bg = to_hex(tabLineHighight.bg) })
         vim.api.nvim_set_hl(0, "DartCurrentLabelModified", { fg = orange, bg = "none" })
         --
         -- -- Marked buffer highlights
         -- local themeGreen = catppuccin.green
         -- -- vim.api.nvim_set_hl(0, "DartMarkedLabel", { bold = true, fg = themeGreen, bg = to_hex(tabLineHighight.bg) })
         vim.api.nvim_set_hl(0, "DartMarkedCurrentLabel", { fg = themeGreen, bg = "none", bold = true })
         -- vim.api.nvim_set_hl(0, "DartMarkedLabelModified", { fg = themeGreen, bold = true })
         -- -- vim.api.nvim_set_hl(0, "DartMarkedCurrentLabelModified", { fg = themeGreen, bold = true })
         -- -- vim.api.nvim_set_hl(0, "DartMarked", { fg = themeGreen })
      end,
   },
}
