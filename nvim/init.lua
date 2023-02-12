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
vim.g.mapleader = ' ' -- Set <space> as the leader key
vim.g.maplocalleader = ' '
vim.o.termguicolors = true -- needs to be set before colorizer plugin

require('lazy').setup({ -- lazystart
  { -- colorscheme
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function ()
      require('catppuccin').setup({
        flavour = 'frappe',
        transparent_background = true,
        styles = {
          keywords = { 'italic' },
          operators = { 'italic' },
        },
      })
      vim.cmd.colorscheme 'catppuccin'
    end
  },

  { -- colorscheme
    'navarasu/onedark.nvim',
    config = function ()
      require('onedark').setup {
        lazy = false, -- load main colorscheme during startup
        priority = 1000, -- load before other start plugins
        style = 'cool', -- https://github.com/navarasu/onedark.nvim#themes
        toggle_style_key = '<leader>ts', -- cycle through all styles
        transparent = true, -- remove background
        code_style = {
          keywords = 'italic'
        },
        lualine = {
          transparent = true
        },
        diagnostics = {
          darker = true,
          background = false,
        },
      }
      -- vim.cmd[[colorscheme onedark]]
    end
  },

  { -- colorscheme
    'folke/tokyonight.nvim',
    config = function ()
      require("tokyonight").setup({
        transparent = true -- don't set a background color
      })
      -- vim.cmd[[colorscheme tokyonight-night]]
    end
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- Useful status updates for LSP
      'j-hui/fidget.nvim',
      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
    config = function ()
      require('neodev').setup()
      require('fidget').setup()
    end
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip', -- snippet engine
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets', -- vscode like snippets
      'onsails/lspkind.nvim', -- pictograms for lsp
    },
    -- cmd = 'InsertEnter',
    config = function ()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require('lspkind')
      local source_mapping = {
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        cmp_tabnine = "[TN9]",
        path = "[Path]",
        luasnip = "[SNIP]",
      }

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup {
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
          format = function(entry, vim_item)
            vim_item.kind = lspkind.symbolic(vim_item.kind, {mode = "symbol"})
            vim_item.menu = source_mapping[entry.source.name]
            if entry.source.name == "cmp_tabnine" then
              local detail = (entry.completion_item.data or {}).detail
              -- vim_item.kind = "tabnine"
              vim_item.kind = ""
              if detail and detail:find('.*%%.*') then
                vim_item.kind = vim_item.kind .. ' ' .. detail
              end

              if (entry.completion_item.data or {}).multiline then
                vim_item.kind = vim_item.kind .. ' ' .. '[ML]'
              end
            end
            local maxwidth = 80
            vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)
            return vim_item
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          -- ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-l>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true, -- selects the first item
            -- select = false, -- only if explicitly selected
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            -- TODO: if currently in a luasnip, hitting tab jumps instead of selecting the next item...
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback) -- shift tab for reverse of above
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'cmp_tabnine' },
        },
      }

      luasnip.add_snippets("all", {
        luasnip.snippet("ternary", {
          -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
          luasnip.insert_node(1, "cond"), luasnip.text_node(" ? "), luasnip.insert_node(2, "then"), luasnip.text_node(" : "), luasnip.insert_node(3, "else")
        })
      })
      luasnip.add_snippets("javascript", {
        luasnip.snippet('cl', {
          luasnip.text_node("console.log("), luasnip.insert_node(1, "val"), luasnip.text_node(");")
        })
      })
      luasnip.filetype_extend("typescript", { "javascript" }) -- also use javascript snippets in typescript

      require('luasnip.loaders.from_vscode').lazy_load() -- add vscode like snippets, from friendly snippets?
    end
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    config = function ()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'javascript', 'help', 'vim', 'html', 'css' },
        highlight = { enable = true, additional_vim_regex_highlighting = true }, -- regex highlighting helps with jsx indenting
        indent = { enable = true, disable = { 'python' } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<c-backspace>',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = { -- You can use the capture groups defined in textobjects.scm
              -- ['aa'] = '@parameter.outer',
              -- ['ia'] = '@parameter.inner',
              -- ['af'] = '@function.outer',
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
              ['sfb'] = '@punctuation.bracket' -- doesn't work :(
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
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }
    end
  },

  { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter' },
  },

  'tpope/vim-fugitive', -- add git commands
  'tpope/vim-rhubarb', -- add GBrowse
  { -- visual git indicators
    'lewis6991/gitsigns.nvim',
    config = function ()
      require('gitsigns').setup {
        signs = {
          add = { text = '•'},
          change = { text = '•'},
          delete = { text = '•'},
        }
      }

      -- these highlight groups need to be loaded async?
      vim.defer_fn(function ()
        vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#009900' })
        vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#bbbb00' })
        -- vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#ff2222' })
      end, 0)
    end
  },

  { -- Fancy statusline
    'nvim-lualine/lualine.nvim',
    -- enabled = false,
    config = function ()
      -- local custom_tokyonight = require('lualine.themes.tokyonight')
      -- custom_tokyonight.normal.c.bg = '#c1c1c1' -- change background to match terminal emulator
      require('lualine').setup {
        options = {
          icons_enabled = false,
          theme = 'onedark',
          component_separators = '|',
          section_separators = '',
        },
      }
    end
  },

  { -- Add indentation guides
    'lukas-reineke/indent-blankline.nvim',
    config = function ()
      require('indent_blankline').setup {
        -- char = '┊',
        show_trailing_blankline_indent = false,
      }
    end
  },

  { -- comment
    'numToStr/Comment.nvim',
    config = function ()
      require('Comment').setup()
      -- comment line in insert mode
      vim.keymap.set('i', '<c-g>c', '<esc><Plug>(comment_toggle_linewise_current)', { noremap = false, silent = true })
    end
  },

  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim', -- library of async functons
      'nvim-telescope/telescope-ui-select.nvim', -- replace nvim's ui select with telescope
      'debugloop/telescope-undo.nvim', -- visually shows undo history
    },
    config = function ()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
          layout_strategy = "flex",
          layout_config = {
            -- prompt_position = 'bottom',
            width = 0.9,
            height = 0.9
          },
          dynamic_preview_title = true
        },
        pickers = {
          buffers = {
            theme = 'dropdown',
            sort_lastused = true,
            -- previewer = true,
          },
          find_files = {
            hidden = true,
          },
        },
        extensions = {
          ['ui-select'] = {
            require("telescope.themes").get_dropdown({})
          },
          undo = {
            use_delta = true,
            diff_context_lines = 6, -- defaults to scroll
          },
        },
      }
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('ui-select')
      require('telescope').load_extension('undo')

      vim.keymap.set('n', '<leader>fu', '<cmd>Telescope undo<cr>')

      -- custom picker that greps the word under the cursor
      -- https://github.com/nvim-telescope/telescope.nvim/issues/1766#issuecomment-1150437074
      _G.live_grep_cword = function()
        local cword = vim.fn.expand("<cword>")
        require("telescope.builtin").live_grep({
          default_text = cword,
          on_complete = cword ~= "" and {
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
          } or nil,
        })
      end
      vim.keymap.set('n', '<leader>*', '<cmd>lua live_grep_cword()<cr>')

      vim.keymap.set('n', '<c-p>', '<cmd>Telescope find_files<cr>')
      vim.keymap.set('n', '<c-b>', '<cmd>Telescope buffers<cr>')
      vim.keymap.set('n', '<c-l>', '<cmd>Telescope current_buffer_fuzzy_find<cr>')
      vim.keymap.set('n', '<c-h>', '<cmd>Telescope help_tags<cr>')
      vim.keymap.set('n', '<c-g>', '<cmd>Telescope grep_string search=""<cr>') -- set search="" to prevent searching the word under the cursor
      vim.keymap.set('n', '<c-t>', '<cmd>Telescope<cr>')

      vim.keymap.set('n', '<leader>ff', '<cmd>Telescope<cr>', { desc = '[f]uzzy [f]ind'})
      vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = '[f]uzzy [h]help'})
      vim.keymap.set('n', '<leader>fk', '<cmd>Telescope keymaps<cr>', { desc = '[f]uzzy [k]eymaps'})
      vim.keymap.set('n', '<leader>fc', '<cmd>Telescope commands<cr>', { desc = '[f]uzzy [c]ommands'})
      vim.keymap.set('n', '<leader>fi', '<cmd>Telescope highlights<cr>', { desc = '[f]uzzy h[i]ghlights'})
      vim.keymap.set('n', '<leader>fo', '<cmd>Telescope oldfiles<cr>', { desc = '[f]uzzy [o]ldfiles'})
      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader>fs', '<cmd>Telescope spell_suggest<cr>', { desc = '[f]uzzy [s]pell_suggest' })
    end
  },

  { -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = vim.fn.executable 'make' == 1
  },

  { -- visually shows treesitter data
    'nvim-treesitter/playground',
    config = function ()
      vim.keymap.set('n', '<leader>ph', ':TSHighlightCapturesUnderCursor<CR>', { desc= '[P]layground[H]ighlightCapturesunderCursor' })
      vim.keymap.set('n', '<leader>pt', ':TSPlaygroundToggle<CR>', { desc= '[P]layground[T]oggle' })
    end
  },

  { -- note: doesn't automatically pad brackets
    "windwp/nvim-autopairs",
    config = true
  },

  'arp242/undofile_warn.vim', -- warn when access undofile before current open
  { -- visual undotree
    "simnalamburt/vim-mundo",
    -- enabled = false,
    config = function ()
      vim.g.mundo_width=40
      vim.g.mundo_preview_bottom=1
      vim.keymap.set('n', '<leader>u', ':MundoToggle<cr>')
    end,
  },

  { -- persist cursor location
    'ethanholz/nvim-lastplace',
    config = function()
      require('nvim-lastplace').setup {}
    end
  },

  { -- shows possible key bindings
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 200
      require("which-key").setup {
        plugins = {
          spelling = {
            enabled = true
          }
        },
        operators = {
          gc = "Comments",
          sa = 'Surround',
        },
        window = {
          border = 'single',
          margin = { 0, 0, 0, 0 },
          padding = { 1, 0, 1, 0 }
        }
      }
    end
  },

  { -- fancier tabline
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function ()
      local background_color = '#151515'
      require('bufferline').setup {
        options = {
          numbers = function (opts)
            return opts.raise(opts.id)
          end,
          show_buffer_close_icons = false,
          show_close_icon = false,
          separator_style = { '', '' }, -- no separators
          modified_icon = '+',
        },
        highlights = {
          fill = { -- the backgruond of the whole bar
            bg = background_color,
          },
          background = { -- for background "tabs"
            bg = background_color,
          },
          buffer_selected = { -- active buffer
            bold = true,
            italic = false,
            fg = 'white',
          },
          numbers = { -- background
            bg = background_color,
          },
          modified_selected = { -- current
            fg = 'yellow',
          },
          modified = { -- background
            fg = 'yellow',
          },
        }
      }
    end
  },

  'christoomey/vim-sort-motion', -- add sort operator
  { -- add motions for substituting text
    'gbprod/substitute.nvim',
    config = function ()
      require("substitute").setup { }

      -- add substitute operator, replaces with register
      vim.keymap.set("n", "ss", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
      vim.keymap.set("n", "S", "<cmd>lua require('substitute').line()<cr>", { noremap = true })

      -- add exchange operator, invoke twice, cancle with <esc>
      vim.keymap.set("n", "sx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
      vim.keymap.set("n", "sxx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
      vim.keymap.set("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })
    end
  },

  { -- lists of diagnostics, references, telescopes, quickfix, and location lists
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = true,
    cmd = 'Trouble' -- lazy load
  },

  { -- start page for nvim
    "goolord/alpha-nvim",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function ()
      require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  },

  { -- adds motions for surrounding 
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
          normal = 'sa', -- default is ys
          normal_cur = false,
          normal_line = false,
          normal_cur_line = false,
          visual = 'sa', -- default is ys
          visual_line = false,
        },
        aliases = {
          ['b'] = { ")", "}", "]" }, -- adds the other brackets
        },
      })
    end
  },

  { -- adds surround motion, but I just want the operator ib / ab
    'machakann/vim-sandwich',
    -- enabled = false,
    init = function ()
      vim.cmd[[
        let g:sandwich_no_default_key_mappings = 1 " disable vim-sandwich bindings, we just want the textobjects
        omap ib <Plug>(textobj-sandwich-auto-i)
        xmap ib <Plug>(textobj-sandwich-auto-i)
        omap ab <Plug>(textobj-sandwich-auto-a)
        xmap ab <Plug>(textobj-sandwich-auto-a)

        omap is <Plug>(textobj-sandwich-query-i)
        xmap is <Plug>(textobj-sandwich-query-i)
        omap as <Plug>(textobj-sandwich-query-a)
        xmap as <Plug>(textobj-sandwich-query-a)
        ]]
    end
  },
  { -- a collection of mini 'submodules'
    'echasnovski/mini.nvim',
    config = function ()
      require("mini.move").setup { } -- adds ability to move text around with <m-h//k/l>
      require("mini.cursorword").setup { -- highlighs the word under the cursor
        delay = 500 -- in ms
      }
    end
  },

  { -- show outline of symbols
    'simrat39/symbols-outline.nvim',
    config = true
  },

  { -- adds a bunch of ui elements. I only like the search overlay...
    'folke/noice.nvim',
    enabled = false,
    dependencies = {
      "MunifTanim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function ()
      require("noice").setup({
        -- lsp = {
        --   -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        --   override = {
        --     ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        --     ["vim.lsp.util.stylize_markdown"] = true,
        --     ["cmp.entry.get_documentation"] = true,
        --   },
        -- },
        -- -- you can enable a preset for easier configuration
        -- presets = {
        --   bottom_search = true, -- use a classic bottom cmdline for search
        --   -- command_palette = true, -- position the cmdline and popupmenu together
        --   -- long_message_to_split = true, -- long messages will be sent to a split
        --   -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
        --   -- lsp_doc_border = false, -- add a border to hover docs and signature help
        -- },
        cmdline = {
          enabled = false,
          view = 'cmdline'
        }
      })
      require('notify').setup {
        background_colour = '#000000'
      }
    end,
  },

  { -- jump targets
    'ggandor/leap.nvim',
    enabled = false,
    config = function ()
      require('leap').setup {}
      vim.keymap.set('n', '<leader>j', "<Plug>(leap-forward-to)")
      vim.keymap.set('n', '<leader>k', "<Plug>(leap-backward-to)")
    end
  },

  { -- show search information in virtual text
    'kevinhwang91/nvim-hlslens',
    -- enabled = false,
    config = function ()
      -- require('scrollbar.handlers.search').setup({}) -- integrate with scrollbar... this doesn't work!!!
      require('hlslens').setup({
        calm_down = true, -- this doesn't work? clear highlights wen cursor leaves
        nearest_only = true,
      })

      local kopts = {noremap = true, silent = true}

      -- NOTE this is the old keymap api
      vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end
  },

  { -- smooth scrolling
    'karb94/neoscroll.nvim',
    -- enabled = false,
    config = function ()
      require('neoscroll').setup({
        mappings = {}, -- do not set default mappings
        easing_function = 'sine',
        -- pre_hook = function()
        --   vim.opt.eventignore:append({
        --     'WinScrolled',
        --     'CursorMoved',
        --   })
        -- end,
        -- post_hook = function()
        --   vim.opt.eventignore:remove({
        --     'WinScrolled',
        --     'CursorMoved',
        --   })
        -- end,
      })

      -- sped up the animation time.
      -- https://github.com/karb94/neoscroll.nvim/pull/68
      local t = {}
      -- Syntax: t[keys] = {function, {function arguments}}
      t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '100'}}
      t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '100'}}

      require('neoscroll.config').set_mappings(t)
    end
  },

  { -- add visual scrollbar
    'petertriho/nvim-scrollbar',
    -- enabled = false,
    config = function ()
      require('scrollbar').setup({})
    end
  },

  { -- wrapper for session commands
    'Shatur/neovim-session-manager',
    config = function ()
      require('session_manager').setup({
        -- autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir
        autoload_mode = require('session_manager.config').AutoloadMode.Disabled
      })

      vim.api.nvim_set_keymap('n', '<leader>sc', ':SessionManager load_current_dir_session<CR>', { desc = '[S]essionManager load_[c]urrent_dir_session' })
      vim.api.nvim_set_keymap('n', '<leader>sl', ':SessionManager load_session<CR>', { desc = '[S]essionManager [l]oad_session' })
      vim.api.nvim_set_keymap('n', '<leader>sd', ':SessionManager delete_session<CR>', { desc = '[S]essionManager [d]elete_session' })
    end
  },

  { -- this is a little laggy??
    'norcalli/nvim-colorizer.lua',
    -- enabled = false,
    config = function ()
      require('colorizer').setup()
    end,
  },

  { -- show/hide persistent terminal
    'akinsho/toggleterm.nvim',
    config = function ()
      require('toggleterm').setup {
        open_mapping = [[<c-\>]],
        direction = 'float',
        float_opts = {
          border = 'curved'
        }
      }

      -- lazygit terminal
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new({ cmd = 'lazygit', --[[ hidden = true ]] }) -- hidden terminals won't resize
      function _G._lazygit_toggle() lazygit:toggle() end
      vim.api.nvim_set_keymap('n', '<leader>lg', '<cmd>lua _lazygit_toggle()<cr>', { noremap = true, silent = true })
    end
  },

  { -- ranger integration
    'kevinhwang91/rnvimr',
    config = function ()
      vim.api.nvim_create_user_command('RangerToggle', ':RnvimrToggle', {})
      vim.api.nvim_set_keymap('n', '<leader>ra', ':RnvimrToggle<cr>', {})
    end
  },

  { -- preview markdown
    'iamcco/markdown-preview.nvim',
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" }, -- lazy load on file type
  },

  -- 'mg979/vim-visual-multi', -- multiple cursor support

  { -- only show cursorline on active window
    'Tummetott/reticle.nvim',
    enabled = false, -- messes up toggleterm for lazy git
    config = true,
    opts = {
      never = {
        cursorline = { 'terminal' }
      }
    }
  },

  { -- adds some visuals to folds
    'anuvyklack/pretty-fold.nvim',
    enabled = false,
    config = function ()
      require('pretty-fold').setup({
        fill_char = '-'
      })
    end
  },

  { -- prettier folding
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    enabled = false,
    config = function ()
      require('ufo').setup()
      -- vim.o.foldcolumn = '2'
      -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      -- vim.o.fillchars = [[eob: ,fold: ,foldopen:▼,foldsep: ,foldclose:►]]
    end
  },

  { -- ai powered autocompletion
    'tzachar/cmp-tabnine',
    build = './install.sh',
    dependencies = { 'hrsh7th/nvim-cmp' },
    config = function ()
      local tabnine = require('cmp_tabnine.config')
      tabnine:setup({
        show_prediction_strength = true,
      })
    end
  }
}) -- lazyend

-- [[ LSP Settings ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Add any additional override configuration in the following tables. They will be passed to the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  tsserver = {},

  sumneko_lua = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        globals = {"vim"}
      }
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- [[Vim Options]]
vim.o.lazyredrew = true -- improve performance
vim.o.hlsearch = false -- Set highlight on search
vim.o.number = true -- Make line numbers default
vim.o.relativenumber = true -- show relative line numbers
vim.o.breakindent = true -- wrapped lines will have consistent indents
vim.o.updatetime = 250 -- Decrease update time
vim.o.signcolumn = 'yes' -- always show sign column
vim.o.completeopt = 'menuone,noselect' -- better completion experience
vim.o.mouse = 'a' -- Enable mouse moedwardbaeg9@gmail.com@de
vim.wo.cursorline = true -- highlight line with cursor, window scoped for use with reticle.nvim

vim.o.ignorecase = true -- case insensitive searching
vim.o.smartcase = true -- ...uness /C or capital in search

vim.o.undofile = true -- Save undo history
vim.o.undodir = vim.fn.expand('~/.vim/undo') -- set save directory. This must exist first... I think

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.foldcolumn = '2' -- show fold nesting
-- vim.cmd([[set foldopen-=block]]) -- don't open folds with block {} motions

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

-- vim.cmd([[
-- augroup remember_folds
--   autocmd!
--   au BufWinLeave ?* mkview 1
--   au BufWinEnter ?* silent! loadview 1
-- augroup END
-- ]])

-- [[ Keymaps ]]
vim.keymap.set('i', 'jk', '<Esc>') -- leave insert mode

vim.keymap.set('n', '<leader>+', '<c-a>') -- increment and decrement
vim.keymap.set('n', '<leader>-', '<c-x>')
vim.keymap.set('n', '<leader>ex', ':ex .<cr>', { desc = 'open netrw in directory :ex .' }) -- open netrw
vim.keymap.set('n', '_', '"_') -- empty register shortcut
vim.keymap.set('n', '<leader>q', '') -- close whichkey / cancel leader without starting macro

vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true }) -- Remaps for dealing with word wrap
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev) -- Diagnostic keymaps
vim.keymap.set('n', 'ge', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.keymap.set('n', '<c-f>', 'za')

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 300 }) -- timeout default is 150
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Open github shorthand ]]
-- TODO: try to extend to replace `gx` https://github.com/gabebw/vim-github-link-opener/blob/main/plugin/github_link_opener.vim
local function maybeOpenGithub ()
  local word = vim.fn.expand('<cWORD>')
  local pattern = '[%w-]+/[%w-.]+' -- local path = string.match(word, pattern)
  local path = word:match(pattern)

  local valid = path and select(2, word:gsub('/','')) == 1

  if valid then
    vim.fn['netrw#BrowseX']('https://github.com/' .. path, 0)
  else
    print('not a valid github path')
    -- vim.fn['netrw#BrowseX'](word, 0) -- doesn't seem to work
  end
end
vim.keymap.set('n', 'gh', maybeOpenGithub)

-- [[ Highlights ]]
vim.api.nvim_set_hl(0, 'NormalFloat', { bg='#1c1c1c' }) -- set background color of floating windows; plugins: telescope, which-key
vim.api.nvim_set_hl(0, 'FloatBorder', { fg='#546178', bg='#1c1c1c' })
vim.api.nvim_set_hl(0, 'CursorLine', { bg='#101010' }) -- darker cursorline
vim.api.nvim_set_hl(0, 'MatchParen', { fg='#ffffff' }) -- make matching parens easier to see

-- vim.api.nvim_set_hl(0, '@keyword.function', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, 'Keyword', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, '@method.call', { italic = false }) -- highlights the keyword 'Instance.method'

-- [[ Legacy config syntax ]]
vim.cmd([[
set showmatch
set matchtime=2 " multiple of 100ms
highlight whitespace ctermbg=white " make whitespace easier to see
set scrolloff=24 " buffer top and bottom
set linebreak " don't break in the middle of a word

set shiftwidth=2

augroup ShowLines
  autocmd!
  autocmd InsertLeave * set cursorline
  " autocmd InsertLeave * set cursorcolumn
augroup END

augroup HideLines
  autocmd!
  autocmd InsertEnter * set nocursorcolumn
  " autocmd InsertEnter * set nocursorline
augroup END

set incsearch " search realtime
set hlsearch
nnoremap <silent> <Leader><Space> :nohlsearch<Bar>:echo<CR>
set ignorecase
set smartcase
set inccommand=nosplit " live substitutions

" Center after jumps
nnoremap g; g;zz
nnoremap gi gi<esc>zzi

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

" Line wrap navigation
nnoremap j gj
nnoremap k gk

" Quick edit configs
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>et :edit ~/.tmux.conf<cr>
nnoremap <leader>ez :edit ~/.zshrc<cr>
nnoremap <leader>eh :edit ~/.hammerspoon/init.lua<cr>

" Split into two lines
" nnoremap K i<CR><ESC>
nnoremap <enter> i<CR><ESC>

" Make Y consistent with C and D
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

set splitright
set splitbelow
]])

-- [[ TODO ]]
-- - set up lsp saga
-- - install ccc.nvim
-- - set up tabnine
-- - rewrite all vimscript stuff to lua?
-- - setup tmux navigator plugins
-- - learn about nvim treesitter textobjects
-- - set up nvim treesitter context
-- - customize the lualine

-- Usability Notes
-- Buffers/Splits/Windows
--  - move window: `<c-w>HJKL`
--  - move buffer to split where # is the buffer id, :buffers: :vert sb#
-- Find and replace
--  - when in a visual bloc, omit the `%`:<'>'/s
-- Motions
--  - % - jump to matching bracket
--  - {} - jump to empty lines(?)
-- Files
--  - do :e to reload a file from external changes
-- commands
--  - set showmatch? <- add ? to check its setting
