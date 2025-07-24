---@diagnostic disable: missing-fields
-- LSP, completion, snippets
return {
   {
      -- LSP, formatter, and linter config and plugins
      -- NOTE: do not lazy load
      -- TODO: consider replacing nonels with conform.nvim
      "neovim/nvim-lspconfig",
      enabled = not vim.g.vscode,
      dependencies = {
         "mason-org/mason.nvim", -- package manager for external editor tools (LSP, DAP, linters, formatters)
         "mason-org/mason-lspconfig.nvim", -- Automatically install LSPs -- TODO: this can be replaced with nvim.lsp.config
         "nvimtools/none-ls.nvim", -- set up formatters and linters (null-ls replacement)
         "jay-babu/mason-null-ls.nvim", -- automatically install linters and formatters

         "pmizio/typescript-tools.nvim", -- native lua typescript support

         "nvimdev/lspsaga.nvim", -- pretty lsp ui
         "nvim-tree/nvim-web-devicons", -- adds icons
         "saghen/blink.cmp", -- completion engine
      },
      config = function()
         local keymap = vim.keymap.set

         -- Floating window signature and hover
         -- NOTE!!: noice will overwrite the hover handler
         keymap("n", "K", function()
            vim.lsp.buf.hover({
               border = "rounded", -- floating window border
            })
         end, { desc = "Hover documentation" })

         vim.keymap.set({ "n" }, "<leader>K", function()
            vim.lsp.buf.signature_help({
               border = "rounded", -- floating window border
            })
         end, { silent = true, noremap = true, desc = "Hover signature" })
         vim.keymap.set({ "n" }, "gK", function()
            vim.lsp.buf.signature_help({
               border = "rounded", -- floating window border
            })
         end, { silent = true, noremap = true, desc = "Hover signature" })

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
         local language_servers = {
            -- START TYPESCRIPT
            -- ----------------
            -- Options for typescript:
            -- - ts_ls: tsserver wrapper
            -- - typescript-tools: (plugin) drop in lua replacement
            -- - vtsls: wrapper for vscode extension for typescript

            -- ts_ls = {},
            -- vtsls = {},
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
            taplo = {}, -- toml

            -- markdown
            -- NOTE: this expects markdown files to have a single #top level header
            marksman = {},

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

         require("mason").setup() -- register commands
         local mason_lspconfig = require("mason-lspconfig")

         mason_lspconfig.setup({
            ensure_installed = vim.tbl_keys(language_servers),
         })

         local capabilities = require("blink.cmp").get_lsp_capabilities()
         vim.lsp.config("*", {
            on_attach = on_attach,
            capabilities = capabilities,
         })

         -- eslint fix all on save?
         local base_on_attach = vim.lsp.config.eslint.on_attach
         vim.lsp.config("eslint", {
            on_attach = function(client, bufnr)
               base_on_attach(client, bufnr)
               vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer = bufnr,
                  command = "LspEslintFixAll",
               })
            end,
         })

         for lsp, settings in pairs(language_servers) do
            vim.lsp.config(lsp, { settings = settings })
         end

         -- START TYPESCRIPT TOOLS
         require("typescript-tools").setup({
            on_attach = on_attach,
            settings = {
               tsserver_file_preferences = {
                  -- enable inlay hints (vim.lsp.inlay_hint.enable())
                  includeInlayParameterNameHints = "all",
                  includeInlayEnumMemberValueHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayVariableTypeHints = true,
               },
            },
         })

         -- NOTE: these are specific to typescript-tools
         vim.keymap.set("n", "<leader>tsm", ":TSToolsAddMissingImports<cr>", { silent = true })
         vim.keymap.set("n", "<leader>tsr", ":TSToolsRemoveUnusedImports<cr>", { silent = true })
         -- END TYPESCRIPT TOOLS

         -- This command comes from the eslint lsp server
         -- FIXME?: this doesnt seem to be attached to typescript files, just typescriptreact?
         -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/eslint.lua#L43
         vim.keymap.set("n", "<leader>es", ":LspEslintFixAll<cr>", { silent = true })

         -- END LSP CONFIG
         -----------------

         -- Set up formatting
         require("mason-null-ls").setup({
            ensure_installed = {
               -- Formatters
               "stylua", -- check to see if this is aligning comments...
               "shfmt",
               "eslint",

               -- Linters
               "shellcheck", -- linter for sh
               "dotenv-linter", -- linter for .env files -- doesn't seem to work...
               "checkmake", -- linter for makefiles
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

               null_ls.builtins.diagnostics.checkmake,
               null_ls.builtins.diagnostics.dotenv_linter,
               -- null_ls.builtins.diagnostics.shellcheck, -- this is throwing errors
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

         -- START visual diagnostics
         --------

         -- Examples:
         -- https://www.reddit.com/r/neovim/comments/1jo9oe9/i_set_up_my_config_to_use_virtual_lines_for/

         -- -- Show all errors
         ---@type vim.diagnostic.Opts
         local diagnostic_config = {
            virtual_text = {
               severity = {
                  -- max = vim.diagnostic.severity.WARN,
                  min = vim.diagnostic.severity.ERROR,
               },
            },
         }

         -- Only show warning, hints, for the current line
         ---@type vim.diagnostic.Opts
         -- local diagnostic_config = {
         --    virtual_text = {
         --       current_line = true,
         --       severity = {
         --          max = vim.diagnostic.severity.WARN,
         --          -- min = vim.diagnostic.severity.ERROR, -- only show errors
         --       },
         --    },
         -- }

         vim.diagnostic.config(diagnostic_config)

         -- Hide diagnostics when in insert mode
         vim.api.nvim_create_autocmd("InsertEnter", {
            pattern = "*",
            callback = function()
               -- vim.diagnostic.config({ virtual_lines = false, virtual_text = false })
            end,
         })
         vim.api.nvim_create_autocmd("InsertLeave", {
            pattern = "*",
            callback = function()
               vim.diagnostic.config(diagnostic_config)
            end,
         })
         -- END visual diagnostics
         --------
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
         -- keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>") -- consider replacing with builtin lsp code action (gra)
         -- keymap("n", "<leader>cr", "<cmd>Lspsaga rename<cr>") -- replaced with builtin, grr
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
         -- keymap("n", "K", "<cmd>Lspsaga hover_doc<cr>", { desc = "" }) -- replaced with builtin lsp signature_help
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
      -- Popup with quick, interactive lsp navigation
      -- "SmiteshP/nvim-navbuddy",
      "hasansujon786/nvim-navbuddy", -- this is the updated fork?
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
               border = "rounded",
               size = { height = "60%", width = "60%" },
               sections = {
                  left = {
                     size = "25%",
                  },
                  mid = {
                     size = "25%",
                  },
               },
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
      -- enabled = false, -- might be breaking borders? https://www.reddit.com/r/neovim/comments/1jmsl3j/comment/mmmhne5/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
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

   {
      -- shows diagnostic messages with wrapping for the current line
      "rachartier/tiny-inline-diagnostic.nvim",
      enabled = false, -- looks to show errors that aren't showing for the other TS lsp server?
      event = "VeryLazy", -- Or `LspAttach`
      priority = 1000, -- needs to be loaded in first
      opts = {
         options = {
            multilines = {
               -- enabled = true, -- show on all lines (not just current)
            },
            -- filter which severity levels to show
            severity = {
               vim.diagnostic.severity.ERROR,
            },
         },
      },
      config = function(_, opts)
         require("tiny-inline-diagnostic").setup(opts)
      end,
   },

   {
      -- show and visualize code actions
      "rachartier/tiny-code-action.nvim",
      dependencies = {
         { "nvim-lua/plenary.nvim" },
      },
      event = "LspAttach",
      opts = {
         picker = {
            "buffer",
            opts = {
               -- winborder = "rounded",
               hotkeys_mode = "text_based",
               position = "center"
            },
         },
      },
      init = function()
         vim.keymap.set({ "n", "x" }, "<leader>ca", function()
            ---@diagnostic disable-next-line: missing-parameter it's correct
            require("tiny-code-action").code_action()
         end, { desc = "[C]ode [A]ction", silent = true, noremap = true })
      end,
   },
}
