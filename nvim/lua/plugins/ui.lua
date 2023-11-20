-- plugins that add visual elements to the vim ui
return {
   {
      -- show outline of symbols
      "simrat39/symbols-outline.nvim", -- previews are broken??
      config = function()
         require("symbols-outline").setup({
            -- auto_preview = true,
            autofold_depth = 2,
         })
         vim.keymap.set("n", "so", "<cmd>SymbolsOutline<cr>")
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
      "folke/which-key.nvim",
      config = function()
         vim.o.timeout = true
         vim.o.timeoutlen = 200
         require("which-key").setup({
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
      -- Add indentation guides
      "lukas-reineke/indent-blankline.nvim",
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
      -- fancier tabline
      "akinsho/bufferline.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
         -- local background_color = "#0a0a0a" -- dark gray
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
               fill = { -- the background of the whole bar
                  -- bg = background_color,
               },
               background = { -- for background "tabs"
                  -- bg = background_color,
               },
               buffer_selected = {
                  -- active buffer
                  bold = true,
                  italic = false,
                  fg = "white",
               },
               numbers = { -- background
                  -- bg = background_color,
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
}
