return {
   {
      -- a collection of mini 'submodules'
      "echasnovski/mini.nvim",
      enabled = not vim.g.vscode,
      config = function()
         -- adds ability to move text around with <m-h/j/k/l>
         require("mini.move").setup({})

         -- highlights/underlines the word under the cursor
         require("mini.cursorword").setup({
            delay = 500, -- in ms
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
               use_as_default_explorer = false,
            },
         })
         -- open with focus on the current file
         vim.api.nvim_create_user_command("MiniFiles", "lua MiniFiles.open(vim.api.nvim_buf_get_name(0))", {})
         vim.api.nvim_create_user_command("Files", "lua MiniFiles.open(vim.api.nvim_buf_get_name(0))", {})

         -- Add various operators
         require("mini.operators").setup({
            -- Default mappings:
            -- g= -> evaluate
            -- gx -> exchange
            -- gm -> multiply/duplicate
            -- gr -> replace
            -- gs -> sort
            exchange = {
               prefix = "gX",
            },
            replace = {
               prefix = "gR",
            },
         })

         -- smooth scrolling
         if not vim.g.vscode then
            local animate = require("mini.animate")
            animate.setup({
               scroll = {
                  timing = animate.gen_timing.linear({
                     easing = "out",
                     -- duration = 100,
                     duration = 70,
                     unit = "total",
                  }),
               },
               cursor = { enable = false },
               resize = { enable = false },
               open = { enable = false },
               close = { enable = false },
            })
         end
      end,
   },
}