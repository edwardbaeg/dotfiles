return {
   {
      -- a collection of mini 'submodules'
      "echasnovski/mini.nvim",
      config = function()
         -- adds ability to move text around with <m-h/j/k/l>
         require("mini.move").setup({})

         -- highlights/underlines the word under the cursor
         require("mini.cursorword").setup({
            delay = 500, -- in ms
         })

         -- file explorer as a buffer
         require("mini.files").setup({
            windows = {
               preview = true,
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
         local animate = require("mini.animate")
         animate.setup({
            scroll = {
               timing = animate.gen_timing.linear({
                  easing = "out",
                  duration = 100,
                  unit = "total",
               }),
            },
            cursor = { enable = false },
            resize = { enable = false },
            open = { enable = false },
            close = { enable = false },
         })
      end,
   },
}
