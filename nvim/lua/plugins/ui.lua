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
               gx = "Exchange",
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
      -- statusline
      "nvim-lualine/lualine.nvim",
      config = function()
         require("lualine").setup({
            options = {
               icons_enabled = false,
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
               -- lualine_c = { { "filename", path = 1 }, "searchcount", "codeium#GetStatusString" }, -- FIXME: the codeium portion makes vim enter insert mode when opening a new file...
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
      -- fancier tabline
      "akinsho/bufferline.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
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
                  fg = "#cccccc",
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
                  fg = "yellow",
               },
               -- modified icon for inactive tabs
               modified = {
                  fg = "yellow",
               },
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
      event = "VeryLazy",
      config = function()
         require("scrollbar").setup({
            handle = {
               color = "black",
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
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
         require("alpha").setup(require("alpha.themes.startify").config)
      end,
   },

   {
      -- color the line separating windows
      "nvim-zh/colorful-winsep.nvim",
      config = function()
         require("colorful-winsep").setup({
            highlight = {
               bg = "none",
               fg = "#00667c",
            },
            interval = 1000,
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
      -- different cursor colors for different modes
      -- TODO: change visual mode colors
      -- NOTE: this plugin seems to cause telescope to open files in insert mode. Workaround is to set a winleave autocmd. https://github.com/nvim-telescope/telescope.nvim/issues/2027#issuecomment-1561836585
      "rasulomaroff/reactive.nvim",
      -- enabled = false,
      config = function()
         require("reactive").setup({
            builtin = {
               cursorline = true,
               -- cursor = true,
               modemsg = true,
            },
         })
      end,
   },
}
