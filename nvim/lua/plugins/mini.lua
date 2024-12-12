return {
   {
      -- a collection of mini 'submodules'
      "echasnovski/mini.nvim",
      enabled = not vim.g.vscode,
      config = function()
         -- adds ability to move text around with <m-h/j/k/l>
         require("mini.move").setup({})

         -- highlights/underlines the word under the cursor
         -- TODO: consider separate highlight for the current word, MiniCursorwordCurrent
         require("mini.cursorword").setup({
            delay = 200, -- in ms
         })

         -- file explorer as a buffer
         -- TODO: disable flash F when in this mode?
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
         vim.api.nvim_create_user_command("Files", "lua MiniFiles.open(vim.api.nvim_buf_get_name(0))", {})
         vim.api.nvim_create_user_command("MF", "lua MiniFiles.open(vim.api.nvim_buf_get_name(0))", {})
         vim.keymap.set("n", "<leader>ra", "<cmd>MiniFiles<cr>", {}) -- trying out with Mini.Files

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
         -- local animate = require("mini.animate")
         -- animate.setup({
         --    scroll = {
         --       enable = not vim.g.vscode,
         --       timing = animate.gen_timing.linear({
         --          easing = "out",
         --          -- duration = 100,
         --          -- duration = 50,
         --          duration = 75,
         --          unit = "total",
         --       }),
         --    },
         --    cursor = { enable = false }, -- cursor path
         --    resize = { enable = false }, -- window resize
         --    open = { enable = false }, -- window opening
         --    close = { enable = false }, -- window closing
         -- })

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
      end,
   },
}
