-- Boostrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: set leader before lazy.nvim so mappings are correct
vim.g.mapleader = " " -- Set <space> as the leader key
vim.g.maplocalleader = " "
vim.o.termguicolors = true -- needs to be set before colorizer plugins

require("lazy").setup({ -- lazystart
   {
      -- colorscheme
      "catppuccin/nvim",
      name = "catppuccin",
      lazy = false, -- load main colorscheme during startup
      priority = 1000, -- load before other plugins change highlights
      config = function()
         require("catppuccin").setup({
            flavour = "frappe",
            transparent_background = true,
            styles = {
               keywords = { "italic" },
               operators = { "italic" },
            },
         })
         vim.cmd.colorscheme("catppuccin")
      end,
   },

   {
      -- colorscheme
      "navarasu/onedark.nvim",
      lazy = true,
      config = function()
         require("onedark").setup({
            style = "cool", -- https://github.com/navarasu/onedark.nvim#themes
            toggle_style_key = "<leader>ts", -- cycle through all styles
            transparent = true, -- remove background
            code_style = {
               keywords = "italic",
            },
            lualine = {
               transparent = true,
            },
            diagnostics = {
               darker = true,
               background = false,
            },
         })
         -- vim.cmd[[colorscheme onedark]]
      end,
   },

   {
      -- colorscheme
      "folke/tokyonight.nvim",
      lazy = true,
      config = function()
         require("tokyonight").setup({
            transparent = true, -- don't set a background color
         })
         -- vim.cmd[[colorscheme tokyonight-night]]
      end,
   },

   {
      -- LSP, formatter, and linter config and plugins
      "neovim/nvim-lspconfig",
      dependencies = {
         "williamboman/mason.nvim", -- package manager for external editor tools (LSP, DAP, linters, formatters)
         "williamboman/mason-lspconfig.nvim", -- Automatically install LSPs
         "glepnir/lspsaga.nvim", -- pretty lsp ui
         "j-hui/fidget.nvim", -- small nvim-lsp progress ui
         "folke/neodev.nvim", -- automatically configures lua-language-server for vim/neovim

         "jose-elias-alvarez/null-ls.nvim", -- set up formatters and linters
         "jay-babu/mason-null-ls.nvim", -- automatically install linters and formatters
         "nvim-tree/nvim-web-devicons",
      },
      config = function()
         require("fidget").setup()
         require("neodev").setup() -- IMPORTANT: setup BEFORE lspconfig. NOTE: this does not work if it's a symlink!

         require("lspsaga").setup({
            lightbulb = {
               sign = false, -- don't show in sign column
               enable_in_insert = false, -- don't show to fix ocnflict with codeium
            },
            symbol_in_winbar = {
               enable = false,
               color_mode = false,
               separator = "  ",
            },
            ui = {
               -- expand = "", collapse = "", diagnostic = "🐞", incoming = " ", outgoing = " ",
               preview = " ",
               code_action = "⚡", -- "💡",
               hover = " ",
            },
         })

         local keymap = vim.keymap.set
         -- keymap("n", "gh", "<cmd>Lspsaga lsp_finder<cr>")
         keymap("n", "ch", "<cmd>Lspsaga lsp_finder<cr>")
         keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>")
         keymap("n", "cr", "<cmd>Lspsaga rename<cr>")
         keymap("n", "<leader>cr", "<cmd>Lspsaga rename<cr>")
         keymap("n", "gd", "<cmd>Lspsaga peek_definition<cr>")
         keymap("n", "gD", "<cmd>Lspsaga goto_definition<cr>")
         keymap("n", "sl", "<cmd>Lspsaga show_line_diagnostics<cr>")
         keymap("n", "sc", "<cmd>Lspsaga show_cursor_diagnostics<cr>")
         keymap("n", "sb", "<cmd>Lspsaga show_buf_diagnostics<cr>")
         keymap("n", "ge", "<cmd>Lspsaga diagnostic_jump_next<cr>")
         keymap("n", "gE", "<cmd>Lspsaga diagnostic_jump_prev<cr>")
         -- keymap('n', 'so', '<cmd>Lspsaga outline<cr>', { desc = '[LSP] [S]how [O]utline'})
         keymap("n", "K", "<cmd>Lspsaga hover_doc<cr>", { desc = "" })

         -- [[ LSP Settings ]]
         --  This function gets run when an LSP connects to a particular buffer.
         -- TODO
         -- - remove code action to switch parameters?
         -- - remove hunk / blame code actions, from gitsigns?
         local on_attach = function(_, bufnr)
            local nmap = function(keys, func, desc)
               if desc then
                  desc = "LSP: " .. desc
               end

               vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
            end

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
            -- nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
            nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

            -- Lesser used LSP functionality
            -- nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
            nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
            nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
            nmap("<leader>wl", function()
               print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, "[W]orkspace [L]ist Folders")

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
               vim.lsp.buf.format()
            end, { desc = "Format current buffer with LSP" })
         end

         -- Set up LSP servers
         require("mason").setup()
         local mason_lspconfig = require("mason-lspconfig")
         local language_servers = {
            tsserver = {},
            lua_ls = {
               Lua = {
                  workspace = { checkThirdParty = false },
                  telemetry = { enable = false },
               },
            },
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
            ensure_installed = { "prettier", "stylua", "beautysh" },
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
         }

         local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
         end

         cmp.setup({
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
               ["<C-d>"] = cmp.mapping.scroll_docs(-4),
               ["<C-f>"] = cmp.mapping.scroll_docs(4),
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
            sources = { -- this also sets priority
               { name = "luasnip", max_item_count = 5 },
               { name = "nvim_lsp", max_item_count = 5 },
               { name = "cmp_tabnine", max_item_count = 5 },
            },
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
         luasnip.add_snippets("javascript", {
            luasnip.snippet("cl", {
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
      -- Highlight, edit, and navigate code
      "nvim-treesitter/nvim-treesitter",
      dependencies = {
         "nvim-treesitter/nvim-treesitter-textobjects", -- adds more text objects for treesitter
         "windwp/nvim-ts-autotag", -- autoclose html tags using treesitter
      },
      build = function()
         pcall(require("nvim-treesitter.install").update({ with_sync = true }))
      end,
      config = function()
         require("nvim-ts-autotag").setup({}) -- don't forget to run :TSInstall tsx
         require("nvim-treesitter.configs").setup({
            autotag = {
               enable = true,
            },
            ensure_installed = {
               "c",
               "cpp",
               "css",
               "go",
               "help",
               "html",
               "javascript",
               "lua",
               "markdown",
               "markdown_inline",
               "python",
               "rust",
               "typescript",
               "vim",
            },
            highlight = {
               enable = true, --[[ additional_vim_regex_highlighting = true ]]
            }, -- regex highlighting helps with jsx indenting, but otherwise its bad
            indent = { enable = true, disable = { "python" } },
            incremental_selection = {
               enable = true,
               keymaps = {
                  init_selection = "<c-space>",
                  node_incremental = "<c-space>",
                  scope_incremental = "<c-s>",
                  node_decremental = "<c-backspace>",
               },
            },
            textobjects = {
               select = {
                  enable = true,
                  lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                  keymaps = {
                     -- You can use the capture groups defined in textobjects.scm
                     -- ['aa'] = '@parameter.outer',
                     -- ['ia'] = '@parameter.inner',
                     ["af"] = "@function.outer",
                     -- ['if'] = '@function.inner',
                     -- ['ac'] = '@class.outer',
                     -- ['ic'] = '@class.inner',
                  },
               },
               move = {
                  enable = true,
                  set_jumps = true, -- whether to set jumps in the jumplist
                  goto_next_start = {
                     -- [']m'] = '@function.outer',
                     -- [']]'] = '@class.outer',
                  },
                  goto_next_end = {
                     -- [']M'] = '@function.outer',
                     -- [']['] = '@class.outer',
                     ["sfb"] = "@punctuation.bracket", -- doesn't work :(
                  },
                  goto_previous_start = {
                     -- ['[m'] = '@function.outer',
                     -- ['[['] = '@class.outer',
                  },
                  goto_previous_end = {
                     -- ['[M'] = '@function.outer',
                     -- ['[]'] = '@class.outer',
                  },
               },
               swap = {
                  enable = true,
                  swap_next = {
                     ["<leader>a"] = "@parameter.inner",
                  },
                  swap_previous = {
                     ["<leader>A"] = "@parameter.inner",
                  },
               },
            },
         })
      end,
   },

   "tpope/vim-fugitive", -- add git commands
   "tpope/vim-rhubarb", -- add GBrowse
   {
      -- git actions and visual git signs
      "lewis6991/gitsigns.nvim",
      config = function()
         require("gitsigns").setup({
            signs = {
               add = { text = "•" },
               change = { text = "•" },
               delete = { text = "•" },
               untracked = { text = "·" },
            },
         })

         -- test!
         vim.keymap.set("n", "gh", ":Gitsigns next_hunk<cr>")
         vim.keymap.set("n", "gH", ":Gitsigns prev_hunk<cr>")

         -- these highlight groups need to be loaded async?
         -- vim.defer_fn(function ()
         vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#009900" })
         vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#bbbb00" })
         vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#626880" })
         -- vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#ff2222' })
         -- end, 0)
      end,
   },

   {
      -- Fancy statusline
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
               "toggleterm", -- doesn't do anything?
               "symbols-outline",
               "mundo",
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
         })
      end,
   },

   {
      -- comment
      "numToStr/Comment.nvim",
      config = function()
         require("Comment").setup()
         -- comment line in insert mode
         vim.keymap.set(
            "i",
            "<c-g>c",
            "<esc><Plug>(comment_toggle_linewise_current)",
            { noremap = false, silent = true }
         )
      end,
   },

   "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

   {
      -- Fuzzy Finder (files, lsp, etc)
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      cmd = "Telescope",
      dependencies = {
         "nvim-lua/plenary.nvim", -- library of async functons
         "nvim-telescope/telescope-ui-select.nvim", -- replace nvim's ui select with telescope
         "debugloop/telescope-undo.nvim", -- visually shows undo history
         "nvim-telescope/telescope-fzf-native.nvim", -- c port of fzf
         "tsakirist/telescope-lazy.nvim", -- for navigating plugins installed by lazy.nvim
         {
            "aaronhallaert/ts-advanced-git-search.nvim", -- look through git history
            dependencies = "tpope/vim-fugitive",
         },
      },
      init = function()
         vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>")

         vim.keymap.set("n", "<c-p>", "<cmd>Telescope find_files<cr>")
         vim.keymap.set("n", "<c-b>", "<cmd>Telescope buffers<cr>")
         vim.keymap.set("n", "<leader>bi", "<cmd>Telescope buffers<cr>")
         vim.keymap.set("n", "<c-l>", "<cmd>Telescope current_buffer_fuzzy_find<cr>")
         vim.keymap.set("n", "<c-h>", "<cmd>Telescope help_tags<cr>")
         vim.keymap.set("n", "<c-g>", '<cmd>Telescope grep_string search=""<cr>') -- set search="" to prevent searching the word under the cursor
         vim.keymap.set("n", "<c-t>", "<cmd>Telescope<cr>")

         vim.keymap.set("n", "<leader>fd", "<cmd>Telescope<cr>", { desc = "[f]uzzy [f]ind" })
         vim.keymap.set("n", "<leader>ff", "<cmd>Telescope<cr>", { desc = "[f]uzzy [f]ind" })
         vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "[f]uzzy [h]help" })
         vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "[f]uzzy [k]eymaps" })
         vim.keymap.set("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "[f]uzzy [c]ommands" })
         vim.keymap.set("n", "<leader>fi", "<cmd>Telescope highlights<cr>", { desc = "[f]uzzy h[i]ghlights" })
         vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "[f]uzzy [o]ldfiles" })
         vim.keymap.set("n", "<leader>fs", "<cmd>Telescope spell_suggest<cr>", { desc = "[f]uzzy [s]pell_suggest" })
         vim.keymap.set("n", "<leader>ss", "<cmd>Telescope spell_suggest<cr>", { desc = "fuzzy [s]pell_[s]uggest" })
      end,
      config = function()
         -- local actions = require("telescope.actions")
         require("telescope").setup({
            defaults = {
               mappings = {
                  i = {
                     ["<C-u>"] = false,
                     ["<C-d>"] = false,
                     -- ["<C-cr>"] = actions.select_tab, -- cannot map to <c-cr>
                  },
               },
               layout_strategy = "flex",
               layout_config = {
                  -- prompt_position = 'bottom',
                  width = 0.9,
                  height = 0.9,
               },
               dynamic_preview_title = true,
            },
            pickers = {
               buffers = {
                  theme = "dropdown",
                  sort_lastused = true,
                  -- previewer = true,
               },
               find_files = {
                  hidden = true,
               },
            },
            extensions = {
               ["ui-select"] = {
                  require("telescope.themes").get_dropdown({}),
               },
               undo = {
                  use_delta = true,
                  diff_context_lines = 6, -- defaults to scroll
               },
            },
         })
         require("telescope").load_extension("ui-select")
         require("telescope").load_extension("undo")
         require("telescope").load_extension("lazy")
         require("telescope").load_extension("advanced_git_search")

         -- custom picker that greps the word under the cursor (cword)
         -- https://github.com/nvim-telescope/telescope.nvim/issues/1766#issuecomment-1150437074
         vim.keymap.set("n", "<leader>*", "<cmd>lua live_grep_cword()<cr>")
         _G.live_grep_cword = function()
            local cword = vim.fn.expand("<cword>")
            require("telescope.builtin").live_grep({
               default_text = cword,
               on_complete = cword ~= ""
                     and {
                        function(picker)
                           local mode = vim.fn.mode()
                           local keys = mode ~= "n" and "<ESC>" or ""
                           vim.api.nvim_feedkeys(
                              vim.api.nvim_replace_termcodes(keys .. [[^v$<C-g>]], true, false, true),
                              "n",
                              true
                           )
                           table.remove(picker._completion_callbacks, 1)
                           vim.tbl_map(function(mapping)
                              vim.api.nvim_buf_set_keymap(0, "s", mapping.lhs, mapping.rhs, {})
                           end, vim.api.nvim_buf_get_keymap(0, "i"))
                        end,
                     }
                  or nil,
            })
         end
      end,
   },

   -- { -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
   --   'nvim-telescope/telescope-fzf-native.nvim',
   --   build = 'make',
   --   cond = vim.fn.executable 'make' == 1,
   --   -- config = function ()
   --   --   require('telescope').load_extension('fzf')
   --   -- end
   -- },

   {
      -- visually shows treesitter data
      "nvim-treesitter/playground",
      cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
      config = function()
         require("nvim-treesitter.configs").setup({})
      end,
      init = function()
         vim.keymap.set(
            "n",
            "<leader>ph",
            ":TSHighlightCapturesUnderCursor<CR>",
            { desc = "[P]layground[H]ighlightCapturesunderCursor" }
         )
         vim.keymap.set("n", "<leader>pt", ":TSPlaygroundToggle<CR>", { desc = "[P]layground[T]oggle" })
      end,
   },

   {
      -- automatically adds closing brackts
      -- note: doesn't automatically pad brackets... sometimes doesn't move closing {} when opening
      "windwp/nvim-autopairs",
      config = function()
         require("nvim-autopairs").setup({
            map_cr = true,
         })
      end,
   },

   "arp242/undofile_warn.vim", -- warn when access undofile before current open
   {
      -- visual undotree
      "simnalamburt/vim-mundo",
      -- enabled = false,
      config = function()
         vim.g.mundo_width = 40
         vim.g.mundo_preview_bottom = 1
         vim.keymap.set("n", "<leader>u", ":MundoToggle<cr>")
      end,
   },

   {
      -- persist cursor location
      "ethanholz/nvim-lastplace",
      config = function()
         require("nvim-lastplace").setup({})
      end,
   },

   {
      -- shows possible key bindings
      "folke/which-key.nvim",
      config = function()
         vim.o.timeout = true
         vim.o.timeoutlen = 200
         require("which-key").setup({
            plugins = {
               spelling = {
                  enabled = true,
               },
            },
            operators = {
               gc = "Comments",
               sa = "Surround",
            },
            window = {
               border = "single",
               margin = { 0, 0, 0, 0 },
               padding = { 1, 0, 1, 0 },
            },
         })
      end,
   },

   {
      -- fancier tabline
      "akinsho/bufferline.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
         local background_color = "#0a0a0a"
         require("bufferline").setup({
            options = {
               numbers = function(opts)
                  return opts.raise(opts.id)
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

   "christoomey/vim-sort-motion", -- add sort operator

   {
      -- add motions for substituting text
      "gbprod/substitute.nvim",
      config = function()
         require("substitute").setup({})

         -- add substitute operator, replaces with register
         vim.keymap.set("n", "ss", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
         vim.keymap.set("n", "S", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
         vim.keymap.set("x", "s", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })

         -- add exchange operator, invoke twice, cancle with <esc>
         vim.keymap.set("n", "sx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
         vim.keymap.set("n", "sxx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
         vim.keymap.set("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })
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
      -- start page for nvim
      "goolord/alpha-nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      config = function()
         require("alpha").setup(require("alpha.themes.startify").config)
      end,
   },

   {
      -- adds motions for surrounding
      "kylechui/nvim-surround", -- I would like to use mini.surround, because it has the find motion, but it does not have a preview highlight
      config = function()
         -- add operator maps for [r]ight angle braces and [a]ngle brances
         vim.keymap.set("o", "ir", "i[")
         vim.keymap.set("o", "ar", "a[")
         vim.keymap.set("o", "ia", "i<")
         vim.keymap.set("o", "aa", "a<")

         require("nvim-surround").setup({
            keymaps = {
               insert = false,
               insert_line = false,
               normal = "sa", -- default is ys
               normal_cur = false,
               normal_line = false,
               normal_cur_line = false,
               visual = "sa", -- default is ys
               visual_line = false,
            },
            aliases = {
               ["b"] = { ")", "}", "]" }, -- adds the other brackets
            },
         })
      end,
   },

   {
      -- this adds surround motions, but disable those and just use the ib / ab operators
      "machakann/vim-sandwich",
      init = function()
         vim.cmd([[
        let g:sandwich_no_default_key_mappings = 1 " disable vim-sandwich bindings, we just want the textobjects
        omap ib <Plug>(textobj-sandwich-auto-i)
        xmap ib <Plug>(textobj-sandwich-auto-i)
        omap ab <Plug>(textobj-sandwich-auto-a)
        xmap ab <Plug>(textobj-sandwich-auto-a)

        omap is <Plug>(textobj-sandwich-query-i)
        xmap is <Plug>(textobj-sandwich-query-i)
        omap as <Plug>(textobj-sandwich-query-a)
        xmap as <Plug>(textobj-sandwich-query-a)
        ]])
      end,
   },

   {
      -- a collection of mini 'submodules'
      "echasnovski/mini.nvim",
      config = function()
         require("mini.move").setup({}) -- adds ability to move text around with <m-h//k/l>
         require("mini.cursorword").setup({ -- highlighs the word under the cursor
            delay = 500, -- in ms
         })
      end,
   },

   {
      -- show outline of symbols
      "simrat39/symbols-outline.nvim", -- previews are broken??
      config = function()
         require("symbols-outline").setup({
            -- auto_preview = true,
         })
         vim.keymap.set("n", "so", "<cmd>SymbolsOutline<cr>")
      end,
   },

   {
      -- show search information in virtual text
      "kevinhwang91/nvim-hlslens",
      config = function()
         -- require('scrollbar.handlers.search').setup({}) -- integrate with scrollbar... this doesn't work!!!
         require("hlslens").setup({
            calm_down = true, -- this doesn't work? clear highlights wen cursor leaves
            nearest_only = true,
         })

         local kopts = { noremap = true, silent = true }

         -- NOTE this is the old keymap api
         vim.api.nvim_set_keymap(
            "n",
            "n",
            [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
            kopts
         )
         vim.api.nvim_set_keymap(
            "n",
            "N",
            [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
            kopts
         )
         vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
         vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
         vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
         vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
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
         require("scrollbar").setup({})
      end,
   },

   {
      -- wrapper for session commands
      "Shatur/neovim-session-manager",
      config = function()
         require("session_manager").setup({
            -- autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir
            autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
         })

         vim.api.nvim_set_keymap(
            "n",
            "<leader>sc",
            ":SessionManager load_current_dir_session<CR>",
            { desc = "[S]essionManager load_[c]urrent_dir_session" }
         )
         vim.api.nvim_set_keymap(
            "n",
            "<leader>sl",
            ":SessionManager load_session<CR>",
            { desc = "[S]essionManager [l]oad_session" }
         )
         vim.api.nvim_set_keymap(
            "n",
            "<leader>sd",
            ":SessionManager delete_session<CR>",
            { desc = "[S]essionManager [d]elete_session" }
         )
      end,
   },

   {
      -- colorizer and color picker
      "uga-rosa/ccc.nvim",
      config = function()
         require("ccc").setup({
            highlighter = {
               auto_enable = true,
            },
         })
      end,
   },

   {
      -- toggle persistent terminal
      "akinsho/toggleterm.nvim",
      config = function()
         require("toggleterm").setup({
            open_mapping = [[<c-\>]],
            direction = "float",
            float_opts = {
               border = "curved",
            },
         })

         local Terminal = require("toggleterm.terminal").Terminal

         -- Set up lazygit
         local lazygit = Terminal:new({
            cmd = "lazygit", --[[ hidden = true ]]
         }) -- hidden terminals won't resize
         function _G._lazygit_toggle()
            lazygit:toggle()
         end

         vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<cr>", { noremap = true, silent = true })

         -- set up ranger
         -- TODO: fix opening files
         -- local ranger = Terminal:new({
         --    cmd = "ranger", --[[ hidden = true ]]
         -- }) -- hidden terminals won't resize
         -- function _G._ranger_toggle()
         --    ranger:toggle()
         -- end
         --
         -- vim.api.nvim_set_keymap("n", "<leader>ra", "<cmd>lua _ranger_toggle()<cr>", { noremap = true, silent = true })
         -- vim.api.nvim_create_user_command("RangerToggle", "lua _G._ranger_toggle()<cr>", {})
      end,
   },

   {
      -- ranger integration, opens files in current nvim instance
      -- NOTE: have to install ranger with pip (not brew)
      "kevinhwang91/rnvimr",
      -- enabled = false, -- have to install ranger with python
      config = function()
         vim.api.nvim_create_user_command("RangerToggle", ":RnvimrToggle", {})
         vim.api.nvim_set_keymap("n", "<leader>ra", ":RnvimrToggle<cr>", {})
      end,
   },

   {
      -- preview markdown
      "iamcco/markdown-preview.nvim",
      build = "cd app && npm install",
      init = function()
         vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" }, -- lazy load on file type
   },

   {
      -- only show cursorline on active window
      "Tummetott/reticle.nvim",
      enabled = false, -- messes up toggleterm for lazy git
      config = true,
      opts = {
         never = {
            cursorline = { "terminal" },
         },
      },
   },

   {
      -- adds some visuals to folds
      "anuvyklack/pretty-fold.nvim",
      enabled = false, -- idk folds
      config = function()
         require("pretty-fold").setup({
            fill_char = "-",
         })
      end,
   },

   {
      -- better folding visuals
      "kevinhwang91/nvim-ufo",
      dependencies = { "kevinhwang91/promise-async" },
      enabled = false, -- idk folds
      config = function()
         require("ufo").setup()
         -- vim.o.foldcolumn = '2'
         -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
         -- vim.o.fillchars = [[eob: ,fold: ,foldopen:▼,foldsep: ,foldclose:►]]
      end,
   },

   {
      -- use multiple virtual lines to show diagnostics
      "Maan2003/lsp_lines.nvim",
      enabled = false, -- it's a bit noisy
   },

   "tpope/vim-eunuch", -- adds unix shell commands to vim, eg :Move, :Mkdir
   {
      -- adds icons to netrw
      "prichrd/netrw.nvim",
      config = true,
   },

   {
      -- color f/t targets
      "unblevable/quick-scope",
      init = function()
         vim.cmd([[ let g:qs_highlight_on_keys = ['f', 'F', 't', 'T'] ]]) -- only show after f/t
      end,
   },

   {
      -- live scratchpad
      "metakirby5/codi.vim",
      init = function()
         vim.cmd([[ let g:codi#rightalign=1 ]])
      end,
   },

   {
      -- align text by delimiters
      "junegunn/vim-easy-align",
      init = function()
         vim.keymap.set("n", "ga", "<Plug>(EasyAlign)")
         vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")
      end,
   },

   {
      -- AI code autocompletion
      "Exafunction/codeium.vim",
      init = function()
         vim.g.codeium_disable_bindings = 1 -- turn off tab and defualts
         vim.g.codeium_enabled = false -- disable by default
         vim.keymap.set("i", "<C-l>", function()
            return vim.fn["codeium#Accept"]()
         end, { expr = true }) -- there isn't a plug command for this yet
         vim.keymap.set("i", "<C-j>", "<Plug>(codeium-next)")
         vim.keymap.set("i", "<C-k>", "<Plug>(codeium-previous)")
         -- vim.keymap.set({ "i", "n" }, "<c-h>", "<Plug>(codeium-dismiss)")
         vim.keymap.set("i", "<c-h>", "<Plug>(codeium-dismiss)")
      end,
   },

   "gabebw/vim-github-link-opener", -- opens 'foo/bar' in github

   {
      -- split or join blocks of code using treesitter
      "Wansmer/treesj",
      cmd = "TSJToggle",
      config = function()
         require("treesj").setup({
            use_default_keymaps = false,
         })
      end,
      init = function()
         vim.keymap.set("n", "<leader>sj", ":TSJToggle<CR>", { desc = "[S]plit/[J]oin" })
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

   { -- shows relative line numbers for active window in normal mode
      "sitiom/nvim-numbertoggle",
   },

   { -- better support for react
      "peitalin/vim-jsx-typescript",
   },

   {
      -- file explorer as nvim buffer
      "stevearc/oil.nvim",
      config = function()
         require("oil").setup({})
      end,
   },
}) -- lazyend

-- [[Vim Options]]
vim.o.lazyredrew = true -- improve performance
vim.o.hlsearch = false -- Set highlight on search
vim.o.number = true -- Make line numbers default
vim.o.relativenumber = true -- show relative line numbers
vim.o.wrap = false -- Don't wrap lines
vim.o.breakindent = true -- wrapped lines will have consistent indents
vim.o.updatetime = 250 -- Decrease update time
vim.o.signcolumn = "yes" -- always show sign column
vim.o.completeopt = "menuone,noselect" -- better completion experience
vim.o.mouse = "a" -- Enable mouse moedwardbaeg9@gmail.com@de
vim.wo.cursorline = true -- highlight line with cursor, window scoped for use with reticle.nvim

vim.o.ignorecase = true -- case insensitive searching
vim.o.smartcase = true -- ...uness /C or capital in search

vim.o.undofile = true -- Save undo history
vim.o.undodir = vim.fn.expand("~/.vim/undo") -- set save directory. This must exist first... I think

vim.o.list = true -- show types of whitespace
vim.o.listchars = "tab:‣ ,trail:•,precedes:«,extends:»"

vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.api.nvim_create_autocmd("FileType", {
   pattern = "sh",
   callback = function()
      vim.api.nvim_buf_set_option(0, "tabstop", 4)
      vim.api.nvim_buf_set_option(0, "tabstop", 4)
   end,
})
vim.api.nvim_create_autocmd("FileType", {
   pattern = "lua",
   callback = function()
      vim.api.nvim_buf_set_option(0, "tabstop", 3)
      vim.api.nvim_buf_set_option(0, "tabstop", 3)
   end,
})

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.foldcolumn = '2' -- show fold nesting
-- vim.cmd([[set foldopen-=block]]) -- don't open folds with block {} motions

-- vim.cmd([[
-- augroup remember_folds
--   autocmd!
--   au BufWinLeave ?* mkview 1
--   au BufWinEnter ?* silent! loadview 1
-- augroup END
-- ]])

-- [[ Smart clipboard ]]
vim.cmd([[
  if has("win32")
    echo "is this windows?"
    set clipboard=unnamed " integrate with windows
  else
    if has("unix")
      let s:uname = system("uname")
      if s:uname == "Darwin\n"
        set clipboard=unnamedplus " integrate with mac
      endif
    endif
  endif
]])

-- [[ Keymaps ]]
vim.keymap.set("i", "jk", "<Esc>") -- leave insert mode

vim.keymap.set("n", "<leader>+", "<c-a>") -- increment and decrement
vim.keymap.set("n", "<leader>-", "<c-x>")
vim.keymap.set("n", "<leader>ex", ":ex .<cr>", { desc = "open netrw in directory :ex ." }) -- open netrw
vim.keymap.set("n", "_", '"_') -- empty register shortcut
vim.keymap.set("n", "<leader>q", "") -- close whichkey / cancel leader without starting macro

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true }) -- Remaps for dealing with word wrap
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "<leader>yy", "ggyG''") -- yank whole file

-- vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev) -- Diagnostic keymaps
-- vim.keymap.set('n', 'ge', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.keymap.set("n", "<c-f>", "za") -- toggle folds

-- emacs style
vim.keymap.set("n", "<leader>bn", ":bn<cr>")
vim.keymap.set("n", "<leader>bp", ":bp<cr>")
vim.keymap.set("n", "<leader>bd", ":bd<cr>")

-- remap netrw keymaps
vim.api.nvim_create_autocmd("filetype", {
   pattern = "netrw",
   desc = "Better mappings for netrw",
   callback = function()
      local bind = function(lhs, rhs)
         vim.keymap.set("n", lhs, rhs, { remap = true, buffer = true })
      end

      bind("n", "%") -- edit new file
      bind("r", "R") -- rename file
      bind("R", "<c-I>") -- refresh
      -- bind('h', '-^') -- go up directory -- this breaks netrw...
      -- bind('l', '<cr>') -- enter -- this breaks netrw...
   end,
})

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
   callback = function()
      vim.highlight.on_yank({ timeout = 500 }) -- timeout default is 150
   end,
   group = highlight_group,
   pattern = "*",
})

-- [[ Highlights ]]
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1c1c1c" }) -- set background color of floating windows; plugins: telescope, which-key
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#546178", bg = "#1c1c1c" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#101010" }) -- darker cursorline
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffffff" }) -- make matching parens easier to see

vim.api.nvim_set_hl(0, "@operator", { italic = false, fg = "#99d1db" }) -- eg +, =, || only do for js?
vim.api.nvim_set_hl(0, "@variable.builtin", { italic = true, fg = "#e78284" }) -- eg +, =, || only do for js?
-- vim.api.nvim_set_hl(0, '@keyword.function', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, 'Keyword', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, '@method.call', { italic = false }) -- highlights the keyword 'Instance.method'

-- [[ Legacy config syntax ]]
vim.cmd([[
set showmatch
set matchtime=2 " multiple of 100ms
highlight Whitespace ctermbg=white " make whitespace easier to see
set scrolloff=24 " buffer top and bottom
set linebreak " don't break in the middle of a word

set incsearch " search realtime
set hlsearch
nnoremap <silent> <Leader><Space> :nohlsearch<Bar>:echo<CR>
set ignorecase
set smartcase
set inccommand=nosplit " live substitutions

" Center after jumps
nnoremap g; g;zz
" nnoremap gi gi<esc>zzi

" center after search
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Remap move cursor to ends of lines H / L
noremap <S-h> ^
noremap <S-l> $

" Quick edit configs
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>et :edit ~/.tmux.conf<cr>
nnoremap <leader>ez :edit ~/.zshrc<cr>
nnoremap <leader>eh :edit ~/.hammerspoon/init.lua<cr>

" Split into two lines
" nnoremap K i<CR><ESC>
nnoremap <leader><cr> i<CR><ESC>

" Make Y consistent with C and D, until EOL
nnoremap Y y$

" Visual select previously pasted text
nnoremap gp `[v`]

" View output from running in terminal
noremap <A-b> :call Build() <cr>
function! Build()
  if &filetype == "javascript"
    exec "! node %"
  elseif &filetype == 'typescript'
    exec "!ts-node %"
  elseif &filetype == 'lua'
    exec "!lua %"
  elseif &filetype == "python"
  elseif &filetype == "sh"
  elseif &filetype == "sh"
    exec "!bash %"
  endif
endfunction

set spelllang=en
set spellsuggest=best,9

set splitright " open splits on the right
set splitbelow " open splits on the bottom
]])

-- [[ TODO ]]
-- - set up nvim treesitter context
-- - customize the lualine
-- - rewrite all vimscript stuff to lua?
-- - fix showing git stuff (lua line and vim fugitive) for lua line (but it works for gitsigns?)

-- Usability Notes
-- Buffers/Splits/Windows
--  - move window: `<c-w>HJKL`
--  - move buffer to split where # is the buffer id, :buffers: :vert sb#
-- Find and replace
--  - when in a visual block, omit the `%`: <'>'/s
-- Motions
--  - % - jump to matching bracket
--  - {} - jump to empty lines
-- Files
--  - do :e to reload a file from external changes
-- commands
--  - set showmatch? <- add ? to check its setting
--  Telescope
--  - open [help] in new tab -> <c-t>
