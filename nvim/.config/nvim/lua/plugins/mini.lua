return {
   {
      -- a collection of mini 'submodules'
      "echasnovski/mini.nvim",
      dependencies = {
         "folke/snacks.nvim", -- for mini.files lsp rename
      },
      enabled = not vim.g.vscode,
      config = function()
         -- adds ability to move text around with <m-h/j/k/l>
         -- FIXME: this is broken for up and down motions
         -- require("mini.move").setup({}) -- replaced with nvim-gomove

         -- highlights/underlines the word under the cursor
         require("mini.cursorword").setup({
            delay = 200, -- in ms
         })

         -- file explorer as a buffer
         -- TODO: disable flash F when in this mode?
         -- TODO: add mapping for scrolling the preview
         require("mini.files").setup({
            windows = {
               preview = true,
               max_number = 3,
               width_focus = 50,
               width_nofocus = 50,
               width_preview = 50,
            },
            options = {
               use_as_default_explorer = false, -- using oil.nvim
            },
         })
         -- open with focus on the current file
         vim.api.nvim_create_user_command("MiniFiles", "lua MiniFiles.open(vim.api.nvim_buf_get_name(0))", {})
         vim.keymap.set("n", "<leader>ra", function()
            vim.notify("Use <leader>mf instead")
         end, {}) -- stop bad habits
         vim.keymap.set("n", "<leader>mf", "<cmd>MiniFiles<cr>", {})

         -- FIXME: this doesn't work...
         local map_split = function(buf_id, lhs, direction)
            local rhs = function()
               -- Make new window and set it as target
               local cur_target = MiniFiles.get_explorer_state().target_window
               local new_target = vim.api.nvim_win_call(cur_target, function()
                  vim.cmd(direction .. " split")
                  return vim.api.nvim_get_current_win()
               end)

               MiniFiles.set_target_window(new_target)
            end

            -- Adding `desc` will result into `show_help` entries
            local desc = "Split " .. direction
            vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
         end

         vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesBufferCreate",
            callback = function(args)
               local buf_id = args.data.buf_id
               -- Tweak keys to your liking
               map_split(buf_id, "<C-s>", "belowright horizontal")
               map_split(buf_id, "<C-v>", "belowright vertical")
            end,
         })

         -- LSP support for file renames
         local Snacks = require("snacks")
         vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesActionRename",
            callback = function(event)
               Snacks.rename.on_rename_file(event.data.from, event.data.to)
            end,
         })
         -- END mini.files

         -- Add various operators
         require("mini.operators").setup({
            -- Default mappings:
            -- - g= -> evaluate
            -- - gx -> exchange -- default is used for opening
            -- - gm -> multiply/duplicate
            -- - gr -> replace -- default is used for lspsaga
            -- - gs -> sort
            exchange = {
               prefix = "gX",
            },
            replace = {
               prefix = "gR",
            },
         })

         -- smooth scrolling
         -- NOTE: this breaks `gi`
         -- vim.g.minianimate_disable = true
         local animate = require("mini.animate")
         if not vim.g.neovide then
            animate.setup({
               scroll = {
                  enable = not vim.g.vscode,
                  timing = animate.gen_timing.linear({
                     easing = "out",
                     duration = 60,
                     unit = "total",
                  }),
               },
               cursor = { enable = false }, -- cursor path
               resize = { enable = false }, -- window resize
               open = { enable = false }, -- window opening
               close = { enable = false }, -- window closing
            })
         end

         -- track and reuse system visits
         require("mini.visits").setup({})
         vim.keymap.set("n", "<leader>fv", ":lua MiniVisits.select_path()<cr>")

         -- extend a/i text objects
         -- q: ", ', `
         -- b: {, [, (, <
         require("mini.ai").setup({
            custom_textobjects = {
               -- this adds <> to the defaults
               b = require("mini.ai").gen_spec.argument({ brackets = { "%b()", "%b[]", "%b{}", "%b<>" } }),
            },
         })

         -- icon provider
         -- require("mini.icons").setup() -- seems little buggy

         -- local miniclue = require("mini.clue")
         -- miniclue.setup({
         --    window = {
         --       delay = 500,
         --    },
         --    triggers = {
         --       -- Leader triggers
         --       { mode = "n", keys = "<Leader>" },
         --       { mode = "x", keys = "<Leader>" },
         --
         --       -- Built-in completion
         --       { mode = "i", keys = "<C-x>" },
         --
         --       -- `g` key
         --       { mode = "n", keys = "g" },
         --       { mode = "x", keys = "g" },
         --
         --       -- Marks
         --       { mode = "n", keys = "'" },
         --       { mode = "n", keys = "`" },
         --       { mode = "x", keys = "'" },
         --       { mode = "x", keys = "`" },
         --
         --       -- Registers
         --       { mode = "n", keys = '"' },
         --       { mode = "x", keys = '"' },
         --       { mode = "i", keys = "<C-r>" },
         --       { mode = "c", keys = "<C-r>" },
         --
         --       -- Window commands
         --       { mode = "n", keys = "<C-w>" },
         --
         --       -- `z` key
         --       { mode = "n", keys = "z" },
         --       { mode = "x", keys = "z" },
         --    },
         --
         --    clues = {
         --       -- Enhance this by adding descriptions for <Leader> mapping groups
         --       miniclue.gen_clues.builtin_completion(),
         --       miniclue.gen_clues.g(),
         --       miniclue.gen_clues.marks(),
         --       miniclue.gen_clues.registers(),
         --       miniclue.gen_clues.windows(),
         --       miniclue.gen_clues.z(),
         --    },
         -- })
      end,
   },
}
