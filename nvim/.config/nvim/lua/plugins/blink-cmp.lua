return {
   -- Completion engine
   -- NOTE: this uses native nvim snippets, which are loaded from /snippets
   -- TODO: change keymaps for lspsaga rename or use a different plugin for that
   "saghen/blink.cmp",
   dependencies = {
      "rafamadriz/friendly-snippets", -- snippet source
      "giuxtaposition/blink-cmp-copilot", -- copilot source
      "echasnovski/mini.nvim", -- for icons
      "xzbdmw/colorful-menu.nvim", -- for syntax highlighting in menu with treesitter
   },
   version = "*", -- use a release tag to download pre-built binaries
   ---@module 'blink.cmp'
   ---@type blink.cmp.Config
   opts = {
      completion = {
         list = {
            selection = {
               -- preselect = function(ctx)
               --    return ctx.mode == "cmdline"
               -- end,
               -- auto_insert = function(ctx)
               --    return ctx.mode == "cmdline"
               -- end
            },
         },
         documentation = {
            auto_show = true,
            window = {
               border = "single",
            },
         },
         menu = {
            border = "single",
            -- with colorful-menu
            draw = {
               -- We don't need label_description now because label and label_description are already
               -- conbined together in label by colorful-menu.nvim.
               columns = { { "kind_icon" }, { "label", gap = 1 } },
               components = {
                  label = {
                     text = function(ctx)
                        return require("colorful-menu").blink_components_text(ctx)
                     end,
                     highlight = function(ctx)
                        return require("colorful-menu").blink_components_highlight(ctx)
                     end,
                  },
               },
            },
            -- mini.icons
            -- draw = {
            --    components = {
            --       kind_icon = {
            --          ellipsis = false,
            --          text = function(ctx)
            --             local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
            --             return kind_icon
            --          end,
            --          -- Optionally, you may also use the highlights from mini.icons
            --          highlight = function(ctx)
            --             local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
            --             return hl
            --          end,
            --       },
            --    },
            -- },
         },
      },

      appearance = {
         -- Sets the fallback highlight groups to nvim-cmp's highlight groups
         -- Useful for when your theme doesn't support blink.cmp
         -- Will be removed in a future release
         use_nvim_cmp_as_default = true,
         nerd_font_variant = "mono",
      },

      sources = {
         default = { "lsp", "path", "snippets", "buffer", "copilot" },
         providers = {
            copilot = {
               name = "copilot",
               module = "blink-cmp-copilot",
               -- score_offset = 10,
               async = true,
            },
         },
      },

      signature = {
         enabled = true,
         window = {
            border = "single",
         },
      },

      keymap = {
         preset = "none",
         -- TODO: set this up so that the first option is not automatically selected. Pressing tab will then selecdt the first option and type it in.
         cmdline = {
            preset = "super-tab",
         },
         ["<C-y>"] = { "show", "show_documentation", "hide_documentation" }, -- this is made default with completion.documentation.auto_show
         ["<C-l>"] = { "hide", "fallback" },
         ["<CR>"] = { "accept", "fallback" },
         ["<Tab>"] = {
            function(cmp)
               if cmp.snippet_active() then
                  return cmp.accept()
               end
            end,
            "snippet_forward",
            "select_next",
            "fallback",
         },
         ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },

         ["<Up>"] = { "select_prev", "fallback" },
         ["<Down>"] = { "select_next", "fallback" },
         ["<C-p>"] = { "select_prev", "fallback" },
         ["<C-n>"] = { "select_next", "fallback" },

         ["<C-b>"] = { "scroll_documentation_up", "fallback" },
         ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
   },
   opts_extend = { "sources.default" },
}
