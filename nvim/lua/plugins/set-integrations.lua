-- plugins that connect to external programs
return {
   {
      -- Adds git commands
      -- This is mostly used for :Git blame, TODO find replacement for it
      "tpope/vim-fugitive",
      -- dependencies = { "tpope/vim-rhubarb" }, -- this is required for :Gbrowse
      init = function()
         vim.g.fugitive_no_maps = true -- disable default mappings (specifically y<c-g>)

         vim.keymap.set("n", "<leader>gb", ":Git blame<cr>")
      end,
   },

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
         -- vim.keymap.set("n", "gh", ":Gitsigns next_hunk<cr>")
         -- vim.keymap.set("n", "gH", ":Gitsigns prev_hunk<cr>")

         -- these highlight groups need to be loaded async?
         -- vim.defer_fn(function ()
         vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#009900" })
         vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#bbbb00" })
         vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#626880" })
         vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff2222" })
         -- end, 0)

         vim.keymap.set("n", "gh", ":Gitsigns next_hunk<cr>")
         vim.keymap.set("n", "gH", ":Gitsigns prev_hunk<cr>")
      end,
   },

   {
      -- ranger integration, opens files in current nvim instance
      -- NOTE: have to install ranger with pip (not brew)
      "kevinhwang91/rnvimr",
      -- enabled = false, -- have to install ranger with python
      config = function()
         vim.api.nvim_create_user_command("RangerToggle", ":RnvimrToggle", {})
         vim.keymap.set("n", "<leader>ra", ":RnvimrToggle<cr>", {})
      end,
   },

   {
      -- connect with ghosttext brwoser extension
      "subnut/nvim-ghost.nvim",
      enabled = false,
      config = function()
         vim.cmd([[
            let g:nvim_ghost_use_script = 1
            let g:nvim_ghost_python_executable = '/usr/bin/python3'
         ]])
      end,
   },

   {
      -- live scratchpad
      -- doesn't seem to work?
      "metakirby5/codi.vim",
      -- enabled = false,
      init = function()
         vim.cmd([[ let g:codi#rightalign=1 ]])
      end,
   },

   {
      -- live lua scratchpad
      'rafcamlet/nvim-luapad',
      config = function ()
         require('luapad').setup ({})
      end
   },

   {
      -- toggle persistent terminal
      "akinsho/toggleterm.nvim",
      lazy = false, -- don't lazy load to set up the mapping
      keys = { [[<c-\>]] },
      config = function()
         require("toggleterm").setup({
            open_mapping = [[<c-\>]], -- FIXME: this only seems to work sometimes
            -- open_mapping = [[<c-m>]],
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

         -- TODO: figure out a way to toggle this pane without exiting lazygit, it would need to be a keymap that isn't mapped to anything in lazygit
         vim.keymap.set("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<cr>", { noremap = true, silent = true })
         -- vim.keymap.set("n", "<c-\\>", "<cmd>lua _lazygit_toggle()<cr>", { noremap = true, silent = true })

         -- set up ranger
         -- local ranger = Terminal:new({
         --    cmd = "ranger", --[[ hidden = true ]]
         -- }) -- hidden terminals won't resize
         -- function _G._ranger_toggle()
         --    ranger:toggle()
         -- end
         --
         -- vim.keymap.set("n", "<leader>ra", "<cmd>lua _ranger_toggle()<cr>", { noremap = true, silent = true })
         -- vim.api.nvim_create_user_command("RangerToggle", "lua _G._ranger_toggle()<cr>", {})
      end,
   },

   {
      -- Render svg in browser with :PreviewSvg
      "nmassardot/nvim-preview-svg",
      config = function()
         require("nvim-preview-svg").setup({
            browser = "safari",
            args = false,
         })
      end,
   },
}
