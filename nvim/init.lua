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

-- Set <space> as the leader key
-- NOTE: set this before lazy so mappings are correct
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('lazy').setup({
  { -- colorscheme
    'folke/tokyonight.nvim',
    lazy = false, -- load main colorscheme during startup
    priority = 1000, -- load before other start plugins
    config = function ()
      require("tokyonight").setup({
        -- transparent = true -- don't set a background color
      })
      vim.cmd[[colorscheme tokyonight-night]]
    end
  },

  {
    'navarasu/onedark.nvim',
    config = function ()
      require('onedark').setup {
        lazy = false, -- load main colorscheme during startup
        priority = 1000, -- load before other start plugins
        style = 'cool',
        toggle_style_key = '<leader>ts',
        transparent = true,
        code_style = {
          keywords = 'italic'
        },
        lualine = {
          -- transparent = true
        },
        diagnostics = {
          darker = true,
          background = false,
        },
      }
      vim.cmd[[colorscheme onedark]]
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
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets' },
    -- cmd = 'InsertEnter',
    config = function ()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

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
        mapping = cmp.mapping.preset.insert {
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          -- ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-l>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            -- if cmp.visible() then
            --   cmp.select_next_item()
            -- elseif luasnip.expand_or_jumpable() then
            --   luasnip.expand_or_jump()
            -- else
            --   fallback()
            -- end
            if cmp.visible() then
              cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
              -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
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

      -- also use javascript sipets in typescript
      luasnip.filetype_extend("typescript", { "javascript" })

      require('luasnip.loaders.from_vscode').lazy_load()
    end
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    config = function ()
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'javascript', 'help', 'vim', 'html', 'css' },
        -- regex highlighting helps with jsx indenting
        highlight = { enable = true, additional_vim_regex_highlighting = true },
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
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
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

      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })

      -- vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
      -- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
      -- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
      -- vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
      -- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
    end
  },

  { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter' },
  },

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {
    'lewis6991/gitsigns.nvim'
  },

  {
    'nvim-lualine/lualine.nvim', -- Fancier statusline
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

  {
    'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
    config = function ()
      require('indent_blankline').setup {
        -- char = '┊',
        show_trailing_blankline_indent = false,
      }
    end
  },

  {
    'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
    config = function ()
      require('Comment').setup()
    end
  },

  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim' },
    config = function ()
      -- local actions = require "telescope.actions"
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              -- ["<C-k>"] = actions.move_selection_previous,
              -- ["<C-j>"] = actions.move_selection_next,
            },
          },
          layout_strategy = "flex",
          layout_config = {
            prompt_position = 'bottom',
            width = 0.9,
            height = 0.9
          },
          dynamic_preview_title = true
        },
        pickers = {
          buffers = {
            -- theme = 'dropdown',
            sort_lastused = true,
          },
        },
      }

      -- set background color of floating windows
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg='black' })

      -- load telescope extensions
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('ui-select')

      vim.keymap.set('n', '<c-p>', '<cmd>Telescope find_files<cr>')
      vim.keymap.set('n', '<c-b>', '<cmd>Telescope buffers<cr>')
      vim.keymap.set('n', '<c-l>', '<cmd>Telescope current_buffer_fuzzy_find<cr>')
      vim.keymap.set('n', '<c-h>', '<cmd>Telescope help_tags<cr>')
      -- vim.keymap.set('n', '<c-g>', '<cmd>Telescope live_grep<cr>') -- this is not fuzzy!
      vim.keymap.set('n', '<c-g>', '<cmd>Telescope grep_string search=""<cr>') -- set search="" to prevent searching the word under the cursor
      vim.keymap.set('n', '<c-t>', '<cmd>Telescope<cr>')

      vim.keymap.set('n', '<leader>ft', '<cmd>Telescope<cr>')
      vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
    end
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = vim.fn.executable 'make' == 1
  },

  {
    'nvim-treesitter/playground',
    -- cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' }, -- don't load until this command is called
    config = function ()
      vim.keymap.set('n', '<leader>ph', ':TSHighlightCapturesUnderCursor<CR>', { desc= '[P]layground[H]ighlightCapturesunderCursor' })
      vim.keymap.set('n', '<leader>pt', ':TSPlaygroundToggle<CR>', { desc= '[P]layground[T]oggle' })
    end
  },

  { -- note: doesn't automatically pad brackets
    "windwp/nvim-autopairs",
    config = true
  },

  {
    "simnalamburt/vim-mundo", -- visual undotree
    config = function ()
      vim.g.mundo_width=40
      vim.g.mundo_preview_bottom=1
    end,
    cmd = 'MundoToggle'
  },

  { -- keep track of cursor location
    'ethanholz/nvim-lastplace',
    config = function()
      require('nvim-lastplace').setup {}
    end
  },

  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
        plugins = {
          spelling = {
            enabled = true
          }
        },
        operators = {
          gc = "Comments",
        },
        window = {
          border = 'single',
          margin = { 0, 0, 0, 0 },
          padding = { 1, 0, 1, 0 }
        }
      }
    end
  },

  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function ()
      require('bufferline').setup {
       options = {
         numbers = function (opts)
            return opts.raise(opts.id)
          end,
         show_buffer_close_icons = false,
         show_close_icon = false,
       }
      }
    end
  },

  'christoomey/vim-sort-motion', -- note: in vimscript

  { -- add motions for substituting text
    'gbprod/substitute.nvim',
    config = function ()
      require("substitute").setup { }

      -- add substitute operator
      -- vim.keymap.set("n", "s", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
      -- vim.keymap.set("n", "ss", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
      -- vim.keymap.set("n", "S", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })

      -- add exchange operator
      vim.keymap.set("n", "sx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
      vim.keymap.set("n", "sxx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
      vim.keymap.set("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })
      -- vim.keymap.set("n", "sxc", "<cmd>lua require('substitute.exchange').cancel()<cr>", { noremap = true })
    end
  },

  'arp242/undofile_warn.vim', -- warn when access undofile before current open

  { -- lists of diagnostics, references, telescopes, quickfix, and location lists
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = true,
    cmd = 'Trouble'
  },

  { -- start page for nvim
    "goolord/alpha-nvim",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function ()
      require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  },

  { -- adds motions for surrounding
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = false,
          insert_line = false,
          normal = 'sa',
          normal_cur = false,
          normal_line = false,
          normal_cur_line = false,
          visual = 'sa',
          visual_line = false,
          -- delete = "sd",
          -- change = 'sc',
        },
      })
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
    dependencies = {
      "MunifTanim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    enabled = false,
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
    config = function ()
      require('leap').setup {}

      vim.keymap.set('n', '<leader>j', "<Plug>(leap-forward-to)")
      vim.keymap.set('n', '<leader>J', "<Plug>(leap-backward-to)")
      vim.keymap.set('n', '<leader>l', "<Plug>(leap-forward-to)")
      vim.keymap.set('n', '<leader>L', "<Plug>(leap-backward-to)")
    end
  },

  { -- show search information in virtual text
    'kevinhwang91/nvim-hlslens',
    config = function ()
      require('hlslens').setup()

      local kopts = {noremap = true, silent = true}

      vim.api.nvim_set_keymap('n', 'n',
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      vim.api.nvim_set_keymap('n', 'N',
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end
  },

  { -- smooth scrolling
    'karb94/neoscroll.nvim',
    config = function ()
      require('neoscroll').setup({
        mappings = {}, -- do not set default mappings
        easing_function = 'sine'
      })

      -- sped up the animation time.
      -- https://github.com/karb94/neoscroll.nvim/pull/68
      local t = {}
      -- Syntax: t[keys] = {function, {function arguments}}
      t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '80'}}
      t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '80'}}

      require('neoscroll.config').set_mappings(t)
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

  {
    'norcalli/nvim-colorizer.lua',
    config = function ()
      require('colorizer').setup()
    end,
  },
})

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.o.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true
-- vim.o.undodir = '~/.vim/undo' -- NOTE: this directory must exist first

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic keymaps
vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev)
vim.keymap.set('n', 'ge', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
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

-- PERSONAL
vim.keymap.set('i', 'jk', '<Esc>')

vim.keymap.set('n', '<leader>+', '<c-a>')
vim.keymap.set('n', '<leader>-', '<c-x>')

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

-- vim.keymap.set('n', '<leader>so', ':so $MYVIMRC<cr>')
vim.keymap.set('n', '<leader>u', ':MundoToggle<cr>')

vim.cmd([[
set showmatch
set matchtime=2 " multiple of 100ms
highlight whitespace ctermbg=white " make whitespace easier to see
set scrolloff=24 " buffer top and bottom
set cursorline
set linebreak " don't break in the middle of a word

" hi Visual guibg=#FFFFFF

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
  elseif &filetype == "python"
  elseif &filetpe == "sh"
  elseif &filetype == "sh"
    exec "!bash %"
  endif
endfunction

set spelllang=en
set spellsuggest=best,9
" set spell

set splitright
set splitbelow
]])

-- highlights
-- vim.api.nvim_set_hl(0, '@keyword.function', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, 'Keyword', { italic = true }) -- highlights the keyword 'function'
-- vim.api.nvim_set_hl(0, '@method.call', { italic = false }) -- highlights the keyword 'Instance.method'

-- Usability Notes
-- Buffers/Splits:
--  - move window: `<c-w>HJKL`
--  - move buffer to split (where # is the buffer id, :buffers): :vert sb#
-- Find and replace
--  - when in a visual bloc, omit the `%`:<'>'/s
--  Motions
--  - % - jump to matching bracket
--  - {} - jump to empty lines(?)
