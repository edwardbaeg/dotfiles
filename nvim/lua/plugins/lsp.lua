---@diagnostic disable: missing-fields
-- LSP, completion, snippets
return {
   {
      -- LSP, formatter, and linter config and plugins
      "neovim/nvim-lspconfig",
      dependencies = {
         "williamboman/mason.nvim", -- package manager for external editor tools (LSP, DAP, linters, formatters)
         "williamboman/mason-lspconfig.nvim", -- Automatically install LSPs
         "nvimtools/none-ls.nvim", -- set up formatters and linters
         "jay-babu/mason-null-ls.nvim", -- automatically install linters and formatters

         "pmizio/typescript-tools.nvim", -- native lua typescript support

         "nvimdev/lspsaga.nvim", -- pretty lsp ui
         "j-hui/fidget.nvim", -- small nvim-lsp progress ui
         "folke/neodev.nvim", -- adds type annotations for neovim config in lua
         "nvim-tree/nvim-web-devicons", -- adds icons
      },
      config = function()
         require("neodev").setup() -- NOTE: setup BEFORE lspconfig. this does not work if it's a symlink!
         require("fidget").setup({})

         require("lspsaga").setup({
            lightbulb = {
               sign = false, -- don't show in sign column
               enable_in_insert = false, -- don't show to fix conflict with codeium
            },
            symbol_in_winbar = {
               enable = false,
               color_mode = false,
               separator = "  ",
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
            definition = {
               width = 0.7,
               height = 0.7,
            },
         })

         local keymap = vim.keymap.set

         -- lsp saga keymaps
         -- keymap("n", "gh", "<cmd>Lspsaga lsp_finder<cr>")
         keymap("n", "ch", "<cmd>Lspsaga lsp_finder<cr>")
         keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>")
         keymap("n", "cr", "<cmd>Lspsaga rename<cr>")
         keymap("n", "<leader>cr", "<cmd>Lspsaga rename<cr>")
         keymap("n", "gd", "<cmd>Lspsaga peek_definition<cr>")
         keymap("n", "gD", "<cmd>Lspsaga goto_definition<cr>")
         keymap("n", "gr", "<cmd>Lspsaga finder<cr>")
         keymap("n", "sl", "<cmd>Lspsaga show_line_diagnostics<cr>")
         keymap("n", "sc", "<cmd>Lspsaga show_cursor_diagnostics<cr>")
         keymap("n", "sb", "<cmd>Lspsaga show_buf_diagnostics<cr>")
         keymap("n", "ge", "<cmd>Lspsaga diagnostic_jump_next<cr>")
         keymap("n", "gE", "<cmd>Lspsaga diagnostic_jump_prev<cr>")
         -- keymap('n', 'so', '<cmd>Lspsaga outline<cr>', { desc = '[LSP] [S]how [O]utline'})
         keymap("n", "K", "<cmd>Lspsaga hover_doc<cr>", { desc = "" })

         -- backup keymaps
         keymap("n", "gk", vim.lsp.buf.hover, { desc = "Hover Documentation" })

         -- [[ LSP Settings ]]
         --  This function gets run when an LSP connects to a particular buffer.
         -- TODO: remove code action to switch parameters?
         -- TODO: remove hunk / blame code actions, from gitsigns?
         local on_attach = function(_, bufnr)
            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
               vim.lsp.buf.format()
            end, { desc = "Format current buffer with LSP" })

            -- These are built in LSP commands. They have been replaced with lsp-saga
            -- local nmap = function(keys, func, desc)
            --    if desc then
            --       desc = "LSP: " .. desc
            --    end
            --
            --    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
            -- end

            -- nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            -- nmap('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
            -- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

            -- nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
            -- nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            -- nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
            -- nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
            -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
            -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            -- See `:help K` for why this keymap
            -- nmap("K", vim.lsp.buf.hover, "Hover Documentation")
            -- nmap("<c-s>", vim.lsp.buf.signature_help, "Signature Documentation")

            -- Lesser used LSP functionality
            -- nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
            -- nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
            -- nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
            -- nmap("<leader>wl", function()
            --    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            -- end, "[W]orkspace [L]ist Folders")
         end

         -- Set up LSP servers
         require("typescript-tools").setup({
            on_attach = on_attach,
         })

         require("mason").setup()
         local mason_lspconfig = require("mason-lspconfig")
         -- these will be automatically installed
         local language_servers = {
            eslint = {},
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
            cssls = {},
            -- volar = {}, -- vue v3, NOTE: this causes the cursor to move when saving due to conflicts with prettier...
            -- tsserver = {}, -- replaced with typescript-tools
            -- vls = {}, -- vue v2
            -- vtsls = {}, -- wrapper for vscode lsp
         }

         mason_lspconfig.setup({
            ensure_installed = vim.tbl_keys(language_servers),
         })

         -- broadcast nvim-cmp copletion capabilities to servers
         local capabilities = vim.lsp.protocol.make_client_capabilities()
         capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

         mason_lspconfig.setup_handlers({
            function(server_name)
               require("lspconfig")[server_name].setup({
                  capabilities = capabilities,
                  on_attach = on_attach,
                  settings = language_servers[server_name],
               })
            end,
         })

         -- Set up formatting
         require("mason-null-ls").setup({
            ensure_installed = {
               "stylua",
               "beautysh",
               "eslint",
            },
         })

         local null_ls = require("null-ls")
         local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
         require("null-ls").setup({
            sources = {
               null_ls.builtins.formatting.prettier,
               null_ls.builtins.formatting.stylua,
               null_ls.builtins.formatting.beautysh,
            },
            on_attach = function(client, bufnr) -- format on save
               if client.supports_method("textDocument/formatting") then
                  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                  vim.api.nvim_create_autocmd("BufWritePre", {
                     group = augroup,
                     buffer = bufnr,
                     callback = function()
                        vim.lsp.buf.format()
                     end,
                  })
               end
            end,
         })
      end,
   },

   {
      -- Autocomplete menu, snippets, and AI completion
      "hrsh7th/nvim-cmp",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",
         "hrsh7th/cmp-cmdline", -- cmdline menu fuzzy
         "L3MON4D3/LuaSnip", -- snippet engine
         "saadparwaiz1/cmp_luasnip",
         "rafamadriz/friendly-snippets", -- vscode like snippets
         "onsails/lspkind.nvim", -- pictograms for completion items
         {
            "tzachar/cmp-tabnine", -- AI powered completion
            build = "./install.sh",
         },
      },
      config = function()
         local cmp = require("cmp")
         local luasnip = require("luasnip")
         local lspkind = require("lspkind")
         local source_mapping = {
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            nvim_lua = "[Lua]",
            cmp_tabnine = "[TN9]",
            path = "[Path]",
            luasnip = "[SNIP]",
            cmdline = "[Cmd]",
            -- codeium = "[Code]", -- requires codeium.nvim
         }

         local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
         end

         cmp.setup({
            sources = { -- this also sets priority
               { name = "nvim_lsp", max_item_count = 10 },
               -- { name = "codeium", max_item_count = 5 },
               { name = "luasnip", max_item_count = 2 },
               { name = "cmp_tabnine", max_item_count = 5 },
            },
            snippet = {
               expand = function(args)
                  luasnip.lsp_expand(args.body)
               end,
            },
            window = {
               completion = cmp.config.window.bordered(),
               documentation = cmp.config.window.bordered(),
            },
            formatting = {
               -- format the display of the completion menu items
               format = function(entry, vim_item)
                  vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol" })
                  vim_item.menu = source_mapping[entry.source.name] or ""
                  -- vim_item.menu = (entry.source.name or "") .. " " .. (source_mapping[entry.source.name] or "")
                  if entry.source.name == "cmp_tabnine" then
                     local detail = (entry.completion_item.data or {}).detail
                     vim_item.kind = ""
                     if detail and detail:find(".*%%.*") then
                        vim_item.kind = vim_item.kind .. " " .. detail
                     end

                     if (entry.completion_item.data or {}).multiline then
                        vim_item.kind = vim_item.kind .. " " .. "[ML]"
                     end
                  end
                  local maxwidth = 80
                  vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)

                  vim_item.kind = "  " .. vim_item.kind -- add some padding after the word
                  return vim_item
               end,
            },
            mapping = cmp.mapping.preset.insert({
               ["<C-k>"] = cmp.mapping.scroll_docs(-4),
               ["<C-j>"] = cmp.mapping.scroll_docs(4),
               -- ["<C-d>"] = cmp.mapping.scroll_docs(-4),
               -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
               -- ['<C-Space>'] = cmp.mapping.complete(),
               ["<C-l>"] = cmp.mapping.abort(),
               ["<CR>"] = cmp.mapping.confirm({
                  behavior = cmp.ConfirmBehavior.Replace,
                  -- select = true, -- selects the first item automatically
                  select = false, -- only if explicitly selected
               }),
               ["<Tab>"] = cmp.mapping(function(fallback)
                  -- TODO: if currently in a luasnip, make tab jump instead of selecting the next item
                  if cmp.visible() then
                     cmp.select_next_item()
                  elseif luasnip.expand_or_locally_jumpable() then
                     luasnip.expand_or_jump()
                  elseif has_words_before() then
                     cmp.complete()
                  else
                     fallback()
                  end
               end, { "i", "s" }),
               ["<S-Tab>"] = cmp.mapping(function(fallback) -- shift tab for reverse of above
                  if cmp.visible() then
                     cmp.select_prev_item()
                  elseif luasnip.jumpable(-1) then
                     luasnip.jump(-1)
                  else
                     fallback()
                  end
               end, { "i", "s" }),
            }),
         })

         cmp.setup.cmdline(":", {
            completion = { keyword_length = 2 },
            mapping = cmp.mapping.preset.cmdline({
               -- TODO: disable <c-n/p> when nothing is selected
               ["<C-l>"] = cmp.mapping.abort(), -- this doesn't work...
               ["<c-p>"] = cmp.mapping.close(),
               ["<c-n>"] = cmp.mapping.close(),
            }),
            sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline", max_item_count = 10 } }),
         })

         -- idk what this does
         cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = { { name = "buffer" } },
         })

         local ls = luasnip
         local i = ls.insert_node
         local t = ls.text_node
         local s = ls.snippet

         -- TODO: create loaders for custom snippets
         ls.add_snippets("lua", {
            -- {
            --   'github/path',
            --   config = function ()
            --     require('module_name').setup ({})
            --   end
            -- },
            s("lazy", {
               t({ "{", "\t'" }),
               i(1, "github/path"),
               t({ "',", "\tconfig = function ()", "\t\trequire('" }),
               i(2, "module_name"),
               t("').setup ({"),
               i(3),
               t({ "})", "\tend", "}," }),
            }),
         })

         luasnip.add_snippets("all", {
            luasnip.snippet("ternary", {
               -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
               luasnip.insert_node(1, "cond"),
               luasnip.text_node(" ? "),
               luasnip.insert_node(2, "then"),
               luasnip.text_node(" : "),
               luasnip.insert_node(3, "else"),
            }),
         })
         luasnip.add_snippets("all", {
            luasnip.snippet("cll", {
               luasnip.text_node("console.log("),
               luasnip.insert_node(1, "val"),
               luasnip.text_node(");"),
            }),
         })
         luasnip.filetype_extend("typescript", { "javascript" }) -- also use javascript snippets in typescript
         luasnip.filetype_extend("typescriptreact", { "javascript" })

         require("luasnip.loaders.from_vscode").lazy_load() -- add vscode like snippets, from friendly snippets?

         local tabnine = require("cmp_tabnine.config")
         tabnine:setup({
            show_prediction_strength = true,
         })
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
      -- NOTE: this requires env var OPENAI_API_KEY
      "piersolenski/wtf.nvim",
      enabled = false,
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
}
