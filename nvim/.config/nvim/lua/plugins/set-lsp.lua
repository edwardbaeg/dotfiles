---@diagnostic disable: missing-fields
-- LSP, completion, snippets
return {
   {
      -- LSP, formatter, and linter config and plugins
      -- NOTE: do not lazy load
      "neovim/nvim-lspconfig",
      enabled = not vim.g.vscode,
      dependencies = {
         "williamboman/mason.nvim", -- package manager for external editor tools (LSP, DAP, linters, formatters)
         "williamboman/mason-lspconfig.nvim", -- Automatically install LSPs
         "nvimtools/none-ls.nvim", -- set up formatters and linters (null-ls replacement)
         "jay-babu/mason-null-ls.nvim", -- automatically install linters and formatters

         -- "pmizio/typescript-tools.nvim", -- native lua typescript support

         "nvimdev/lspsaga.nvim", -- pretty lsp ui
         -- "j-hui/fidget.nvim", -- small nvim-lsp progress ui -- replaced with noice.lsp
         "nvim-tree/nvim-web-devicons", -- adds icons
         "saghen/blink.cmp", -- completion engine
      },
      config = function()
         local keymap = vim.keymap.set

         -- backup keymaps
         keymap("n", "gK", vim.lsp.buf.hover, { desc = "Hover Documentation" })

         -- START LSP CONFIG
         -------------------
         --  This function gets run when an LSP connects to a particular buffer.
         local on_attach = function(_, bufnr)
            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
               vim.lsp.buf.format()
            end, { desc = "Format current buffer with LSP" })
         end

         -- Automatically install these servers
         local default_language_servers = {
            -- START TYPESCRIPT
            -- ----------------
            -- Options for typescript:
            -- - ts_ls: tsserver wrapper
            -- - typescript-tools: (plugin) drop in lua replacement
            -- - vtsls: wrapper for vscode extension for typescript

            -- ts_ls = {},
            vtsls = {},
            -- END TYPESCRIPT
            -- ----------------

            -- other web stuff
            cssls = {},
            eslint = {},

            -- lua
            lua_ls = { -- aka lua-language-server
               Lua = {
                  workspace = {
                     checkThirdParty = false,
                     library = {
                        string.format("%s/.hammerspoon/Spoons/EmmyLua.spoon/annotations", os.getenv("HOME")),
                     },
                  },
                  telemetry = { enable = false },
               },
            },

            -- shell
            bashls = {
               filetypes = { "sh", "zsh" }, -- this doesn't seem to work for zsh files?
            },

            terraformls = {},
            jsonls = {},
            yamlls = {},
            -- grammar (not just spell check)
            -- harper_ls = {
            --    ["harper-ls"] = {
            --       linters = {
            --          spell_check = false,
            --          sentence_capitalization = false,
            --       },
            --    },
            -- },
         }

         require("mason").setup()
         local mason_lspconfig = require("mason-lspconfig")

         mason_lspconfig.setup({
            ensure_installed = vim.tbl_keys(default_language_servers),
         })

         -- require("typescript-tools").setup({
         --    on_attach = on_attach,
         --    settings = {
         --       tsserver_file_preferences = {
         --          -- enable inlay hints (vim.lsp.inlay_hint.enable())
         --          includeInlayParameterNameHints = "all",
         --          includeInlayEnumMemberValueHints = true,
         --          includeInlayFunctionLikeReturnTypeHints = true,
         --          includeInlayFunctionParameterTypeHints = true,
         --          includeInlayPropertyDeclarationTypeHints = true,
         --          includeInlayVariableTypeHints = true,
         --       },
         --    },
         -- })

         -- NOTE: these are specific to typescript-tools
         -- FIXME: this doesn't work
         -- vim.api.nvim_create_user_command(
         --    "TSToolsLSP",
         --    ":TSToolsAddMissingImports <bar> TSToolsSortImports",
         --    { desc = "" }
         -- )
         -- vim.keymap.set("n", "<leader>tsm", ":TSToolsAddMissingImports<cr>")
         -- vim.keymap.set("n", "<leader>tsr", ":TSToolsRemoveUnusedImports<cr>")

         -- set up each server, add cmp
         local capabilities = require("blink.cmp").get_lsp_capabilities()
         mason_lspconfig.setup_handlers({
            function(server_name)
               require("lspconfig")[server_name].setup({
                  capabilities = capabilities,
                  on_attach = on_attach,
                  settings = default_language_servers[server_name],
               })
            end,
         })
         -- END LSP CONFIG
         -----------------

         -- Set up formatting
         require("mason-null-ls").setup({
            ensure_installed = {
               "stylua", -- check to see if this is aligning comments...
               "shfmt",
               "eslint",
            },
         })

         local null_ls = require("null-ls")
         -- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
         -- TODO: check why it seems that there are multiple formatters running for :Format
         -- example: long chain of multiline foo && bar && baz
         require("null-ls").setup({
            sources = {
               null_ls.builtins.formatting.prettier,
               null_ls.builtins.formatting.stylua,
               null_ls.builtins.formatting.shfmt,
            },
            -- on_attach = function(client, bufnr) -- format on save
            --    if client.supports_method("textDocument/formatting") then
            --       vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            --       vim.api.nvim_create_autocmd("BufWritePre", {
            --          group = augroup,
            --          buffer = bufnr,
            --          callback = function()
            --             vim.lsp.buf.format()
            --          end,
            --       })
            --    end
            -- end,
         })

         -- Show warnings as virtual text, errors as virtual lines
         -- https://www.reddit.com/r/neovim/comments/1jo9oe9/i_set_up_my_config_to_use_virtual_lines_for/
         -- TODO: consider conditionally showing virtual_lines (https://www.reddit.com/r/neovim/comments/1jpbc7s/disable_virtual_text_if_there_is_diagnostic_in/)
         local diagnostic_config = {
            virtual_text = {
               severity = {
                  -- max = vim.diagnostic.severity.WARN,
                  min = vim.diagnostic.severity.ERROR,
               },
            },
            -- virtual_lines = {
            --    current_line = true,
            --    severity = {
            --       min = vim.diagnostic.severity.ERROR,
            --    },
            -- },
         }

         vim.diagnostic.config(diagnostic_config)

         -- -- Hide diagnostics when in insert mode
         vim.api.nvim_create_autocmd("InsertEnter", {
            pattern = "*",
            callback = function()
               vim.diagnostic.config({ virtual_lines = false, virtual_text = false })
            end,
         })
         vim.api.nvim_create_autocmd("InsertLeave", {
            pattern = "*",
            callback = function()
               vim.diagnostic.config(diagnostic_config)
            end,
         })

         -- toggle virtual lines
         vim.keymap.set("n", "<leader>gK", function()
            local new_config = not vim.diagnostic.config().virtual_lines
            vim.diagnostic.config({ virtual_lines = new_config and diagnostic_config.virtual_lines or false })
         end, { desc = "Toggle diagnostic virtual_lines" })
      end,
   },

   {
      -- pretty lsp ui
      -- TODO: replace some with builtins. See :help lsp-defaults
      --   - for example, grn for lsp.buf.rename()
      "nvimdev/lspsaga.nvim",
      dependencies = {
         "neovim/nvim-lspconfig",
         "nvim-tree/nvim-web-devicons", -- adds icons
      },
      config = function()
         require("lspsaga").setup({
            lightbulb = {
               sign = false, -- don't show in sign column
               enable_in_insert = false, -- don't show to fix conflict with codeium
            },
            -- LSP breadcrumb view
            symbol_in_winbar = {
               -- enable = true,
               enable = false,
               separator = "  ",
               -- show_file = false, -- don't show filename before symbols
               color_mode = true, -- symbol name and icon have the same color
            },
            ui = {
               -- expand = "", collapse = "", diagnostic = "🐞", incoming = " ", outgoing = " ",
               preview = " ",
               code_action = "",
               -- code_action = "⚡", -- "💡",
               hover = " ",
            },
            finder = {
               keys = {
                  vsplit = "v", -- open in vertical split
               },
            },
            callhierarchy = {
               keys = {
                  -- toggle_or_req = "<cr>",
                  toggle_or_req = "<cr>",
                  edit = "o", -- open file
               },
            },
            definition = {
               width = 0.7,
               height = 0.7,
            },
            diagnostic = {
               -- max_width = 1, -- default is 0.8
               -- max_height = 1, -- default is 0.6

               -- settings for floats
               -- max_show_width = 1, -- default is 0.9
               max_show_height = 0.9, -- default is 0.6

               -- jump_num_shortcut = false,
            },
         })
         local keymap = vim.keymap.set

         -- lsp saga keymaps
         keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>")
         keymap("n", "<leader>cr", "<cmd>Lspsaga rename<cr>")
         keymap("n", "gd", "<cmd>Lspsaga peek_definition<cr>") -- replace with <ctrl-]>
         -- keymap("n", "gD", "<cmd>Lspsaga goto_definition<cr>")
         -- keymap("n", "gr", "<cmd>Lspsaga finder<cr>") -- conflicts with builtin gr* mappings
         -- keymap("n", "gh", "<cmd>Lspsaga incoming_calls<cr>", { desc = "Lspsaga [h]ierarchy" })
         keymap("n", "sl", "<cmd>Lspsaga show_line_diagnostics<cr>")
         keymap("n", "sc", "<cmd>Lspsaga show_cursor_diagnostics<cr>")
         keymap("n", "sb", "<cmd>Lspsaga show_buf_diagnostics<cr>")
         keymap("n", "ge", "<cmd>Lspsaga diagnostic_jump_next<cr>")
         keymap("n", "gE", "<cmd>Lspsaga diagnostic_jump_prev<cr>")
         -- keymap('n', 'so', '<cmd>Lspsaga outline<cr>', { desc = '[LSP] [S]how [O]utline'})
         keymap("n", "K", "<cmd>Lspsaga hover_doc<cr>", { desc = "" })
      end,
   },

   {
      -- display usage counts for document symbols
      "Wansmer/symbol-usage.nvim",
      enabled = false,
      event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
      config = function()
         local SymbolKind = vim.lsp.protocol.SymbolKind

         require("symbol-usage").setup({
            vt_position = "end_of_line",
            -- kinds = { SymbolKind.Function, SymbolKind.Method },
            kinds = { SymbolKind.Function },
            references = {
               -- enabled = false,
            },
            filetypes = {
               "typescriptreact",
            },
         })
      end,
   },

   {
      -- debug with AI
      "piersolenski/wtf.nvim",
      enabled = false, -- this requires env var OPENAI_API_KEY (paid)
      dependencies = {
         "MunifTanjim/nui.nvim",
      },
      opts = {},
      keys = {
         {
            "gw",
            mode = { "n", "x" },
            function()
               require("wtf").ai()
            end,
            desc = "Debug diagnostic with AI",
         },
         {
            mode = { "n" },
            "gW",
            function()
               require("wtf").search()
            end,
            desc = "Search diagnostic with Google",
         },
      },
   },

   {
      -- Popup with quick, interactive lsp navigation
      "SmiteshP/nvim-navbuddy",
      event = "VeryLazy",
      dependencies = {
         "neovim/nvim-lspconfig",
         "SmiteshP/nvim-navic",
         "MunifTanjim/nui.nvim", -- ui library
         "nvim-telescope/telescope.nvim", -- Optional
      },
      config = function()
         require("nvim-navbuddy").setup({
            lsp = {
               auto_attach = true,
            },
            window = {
               size = { height = "50%", width = "60%" },
            },
         })

         vim.keymap.set("n", "<leader>gn", "<cmd>Navbuddy<CR>", { desc = "[N]avbuddy" })
      end,
   },

   {
      -- lua port of 'ts-error-translator' for vscode
      "dmmulroy/ts-error-translator.nvim",
      -- enabled = false,
      config = function()
         require("ts-error-translator").setup({})
      end,
   },

   -- {
   --    -- preview lsp actions
   --    "aznhe21/actions-preview.nvim",
   --    config = function()
   --       require("actions-preview").setup({})
   --    end,
   -- },

   {
      -- Configures lua-ls for nvim config by lazily updating workspace libraries, replaced neodev.nvim
      "folke/lazydev.nvim",
      dependencies = {
         { "gonstoll/wezterm-types", lazy = true }, -- adds wezterm types
      },
      ft = "lua", -- only load on lua files
      opts = {
         library = {
            "luvit-meta/library",
            { path = "wezterm-types", mods = { "wezterm" } },

            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            { path = "snacks.nvim", words = { "Snacks" } }, -- add Snacks global
            { path = "lazy.nvim", words = { "LazyVim" } }, -- add LazyVim global
         },
      },
   },

   {
      -- show lsp signature while typing in 1) floating window and 2) virtual text
      -- NOTE: this might be covered by the completion plugin
      "ray-x/lsp_signature.nvim",
      event = "VeryLazy",
      opts = {
         floating_window = false, -- disable floating window, replaced with blink.cmp
         hint_enable = true,
         hint_prefix = {
            above = "↙ ", -- when the hint is on the line above the current line
            current = "← ", -- when the hint is on the same line
            below = "↖ ", -- when the hint is on the line below the current line
         },
         hi_parameter = "LspSignatureActiveParameter",
         hint_scheme = "Comment", -- TODO: see what other schemes are there
      },
   },

   {
      -- lsp garbage collector; stop inactive LSP clients to save RAM
      "zeioth/garbage-day.nvim",
      enabled = false, -- this might be breaking copilot?
      dependencies = "neovim/nvim-lspconfig",
      event = "VeryLazy",
      opts = {},
   },
}
