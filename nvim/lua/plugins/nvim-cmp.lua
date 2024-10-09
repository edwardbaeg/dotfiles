return {
   -- Autocomplete menu, snippets, and AI completion
   "hrsh7th/nvim-cmp",
   -- NOTE: do NOT lazy load this
   -- event = "VeryLazy",
   dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline", -- cmdline menu fuzzy
      "hrsh7th/cmp-buffer", -- source for buffer words
      {
         "L3MON4D3/LuaSnip", -- snippet engine
         build = "make install_jsregexp",
      },
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets", -- vscode like snippets
      "onsails/lspkind.nvim", -- pictograms for completion items
      {
         "tzachar/cmp-tabnine", -- AI powered completion
         build = "./install.sh",
      },
      "zbirenbaum/copilot-cmp", -- add copilot as a source
   },
   -- TODO: add a comparator?
   config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      require("copilot_cmp").setup({
         --    fix_pairs = true,
      })

      local sources = {
         { name = "nvim_lsp", max_item_count = 10, priority = 2 },
         { name = "codeium", max_item_count = 5, priority = 1 },
         { name = "copilot", max_item_count = 5, priority = 1 },
         { name = "luasnip", max_item_count = 2, priority = 1 },
         { name = "cmp_tabnine", max_item_count = 5, priority = 1 },
         {
            name = "buffer",
            max_item_count = 5,
            priority = 1,
            options = {
               -- Don't index files that are larger than 1 Megabyte
               get_bufnrs = function()
                  local buf = vim.api.nvim_get_current_buf()
                  local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                  if byte_size > 1024 * 1024 then -- 1 Megabyte max
                     return {}
                  end
                  return { buf }
               end,
            },
         },
         -- { name = "cmdline" },
      }

      local format_source_mapping = {
         buffer = "[Buffer]",
         nvim_lsp = "[LSP]",
         nvim_lua = "[Lua]",
         cmp_tabnine = "[TN9]",
         path = "[Path]",
         luasnip = "[SNIP]",
         cmdline = "[Cmd]",
         copilot = "[Copilot]",
         codeium = "[Codeium]", -- requires codeium.nvim
      }

      -- Don't hide copilot suggestions when nvim-cmp is shown
      cmp.event:on("menu_opened", function()
         vim.b.copilot_suggestion_hidden = false
      end)

      local has_words_before = function()
         local line, col = unpack(vim.api.nvim_win_get_cursor(0))
         return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
         sources = sources,
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
               vim_item.menu = format_source_mapping[entry.source.name] or ""
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
               if entry.source.name == "copilot" then
                  vim_item.kind = "🤖"
               end
               if entry.source.name == "codeium" then
                  vim_item.kind = ""
               end
               local maxwidth = 80 -- TODO: consider changing this for copilot...
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
            ["<C-l>"] = cmp.mapping.abort(), -- this doesn't work, it autocompletes
            ["<c-p>"] = cmp.mapping.close(),
            ["<c-n>"] = cmp.mapping.close(),
         }),
         sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline", max_item_count = 15 } }),
      })

      -- Add suggestions from the current buffer for searches
      cmp.setup.cmdline({ "/", "?" }, {
         mapping = cmp.mapping.preset.cmdline(),
         sources = { { name = "buffer", max_item_count = 5 } },
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

      luasnip.add_snippets("javascript", {
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
}
