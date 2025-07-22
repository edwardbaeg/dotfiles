---@module "lazy"
---@type LazySpec
return {
   -- configurable UI views
   -- cmdline, lsp progress
   -- NOTE: this breaks vim.lsp.buf.hover, need to use noice.hover instead! https://github.com/neovim/nvim-lspconfig/issues/3036#issuecomment-1968518789
   -- this appears to set cmdheight=0 under the hood...
   "folke/noice.nvim",
   -- enabled = false,
   event = "VeryLazy",
   opts = {
      -- add any options here
   },
   dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
   },
   config = function()
      require("noice").setup({
         -- shows messages (in cmdheight area) in different view, uses notify if available, oherwise fallback to Noice.mini
         messages = {
            enabled = true,
            -- view = "notify",
            -- view_error = "notify",
            -- view_warn = "notify",
            -- view_history = "messages",
            -- view_search = "virtualtext",
         },
         cmdline = {
            -- view = "cmdline" -- native bottom location of command input -- replaced with presets.command_palette
         },
         -- show lsp progress messages
         lsp = {
            signature = {
               enabled = false,
            },
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
               ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
               ["vim.lsp.util.stylize_markdown"] = true,
               ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
         },
         -- you can enable a preset for easier configuration
         presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together at the top
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
         },
         ---@type NoiceConfigViews
         views = {
            ---@type NoiceViewOptions
            hover = {
               scrollbar = true,
               size = {
                  max_height = 25, -- default is 20
               }
            },
         },
      })

      -- these aren't sticking
      vim.o.cmdheight = 1
   end,
   init = function()
      -- these aren't sticking
      vim.o.cmdheight = 1
   end,
}
