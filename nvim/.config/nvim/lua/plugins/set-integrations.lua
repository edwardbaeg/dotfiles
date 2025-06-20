-- plugins that connect to external programs
return {
   {
      -- ranger integration, opens files in current nvim instance
      -- NOTE: have to install ranger with pip (not brew)
      "kevinhwang91/rnvimr",
      -- enabled = false,
      config = function()
         vim.api.nvim_create_user_command("RangerToggle", ":RnvimrToggle", {})
         -- vim.keymap.set("n", "<leader>ra", ":RnvimrToggle<cr>", {}) -- trying out with Mini.Files
      end,
   },

   {
      -- connect with ghosttext browser extension
      -- this defaults to http://localhost:4001
      "subnut/nvim-ghost.nvim",
      enabled = false, -- this sets NVIM_LISTEN_ADDRESS, which errors on 0.11
      config = function()
         vim.cmd([[
            " let g:nvim_ghost_use_script = 1
            " let g:nvim_ghost_python_executable = '/usr/bin/python3'

            " let g:nvim_ghost_autostart = 0 " disable autostart, use :GhostTextStart
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
      "rafcamlet/nvim-luapad",
      config = function()
         require("luapad").setup({})
      end,
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

         -- Set up lazygit --NOTE replaced with snacks.lazy_git
         local lazygit = Terminal:new({
            cmd = "lazygit",
            -- hidden = true -- hidden terminals won't resize
         })
         function _G._lazygit_toggle()
            lazygit:toggle()
         end

         vim.keymap.set("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<cr>", { noremap = true, silent = true })
         vim.keymap.set("n", "<c-\\>", "<cmd>ToggleTerm<cr>", { noremap = true, silent = true })
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

   {
      -- Run tests from within neovim
      -- TODO: set up consumers for status and diagnostics
      -- FIXME: watch mode doesn't seem to work?
      "nvim-neotest/neotest",
      dependencies = {
         "nvim-neotest/nvim-nio", -- async library
         "nvim-lua/plenary.nvim", -- utility functions
         "antoinemadec/FixCursorHold.nvim", -- recommended, "allows detaching updatetime from the frequency of the CursorHold event"
         "nvim-treesitter/nvim-treesitter",

         -- adapters
         "marilari88/neotest-vitest", -- vitest
         "thenbe/neotest-playwright", -- playwright
      },
      cmd = { "NeoTestSummaryToggle", "NeoTestOutputToggle", "NeoTestToggle" },
      config = function()
         ---@diagnostic disable-next-line: missing-fields required fields are not required
         require("neotest").setup({
            status = {
               enabled = true,
               virtual_text = true,
               signs = true,
            },
            adapters = {
               require("neotest-vitest")({ -- note: this cannot use the opts syntax
                  -- Filter directories when searching for test files. Useful in large projects (see Filter directories notes).
                  filter_dir = function(name, rel_path, root)
                     return name ~= "node_modules"
                  end,
               }),
               require("neotest-playwright").adapter({
                  options = {
                     persist_project_selection = true,
                     enable_dynamic_test_discovery = true,
                     is_test_file = function(file_path)
                        -- By default, only returns true if a file contains one of several file
                        -- extension patterns. See default implementation here: https://github.com/thenbe/neotest-playwright/blob/53c7c9ad8724a6ee7d708c1224f9ea25fa071b61/src/discover.ts#L25-L47
                        -- local result = file_path:find("%.test%.[tj]sx?$") ~= nil
                        --    or file_path:find("%.spec%.[tj]sx?$") ~= nil

                        -- Alternative example: Match only files that end in `test.ts`
                        -- local result = file_path:find("%.test%.ts$") ~= nil
                        local result = file_path:find("%.play%.ts$") ~= nil

                        -- Alternative example: Match only files that end in `test.ts`, but only if it has ancestor directory `e2e/tests`
                        -- local result = file_path:find("e2e/tests/.*%.test%.ts$") ~= nil
                        return result
                     end,
                  },
               }),
            },
         })

         vim.api.nvim_create_user_command("NeoTestSummaryToggle", require("neotest").summary.toggle, {})
         vim.api.nvim_create_user_command("NeoTestOutputToggle", require("neotest").output_panel.toggle, {})

         vim.api.nvim_create_user_command("NeoTestToggle", function()
            local Neotest = require("neotest")
            Neotest.summary.toggle()
            Neotest.output_panel.toggle()
         end, {})
      end,
   },
}
