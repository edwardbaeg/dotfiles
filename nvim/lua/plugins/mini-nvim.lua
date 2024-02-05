return {
   {
      -- a collection of mini 'submodules'
      "echasnovski/mini.nvim",
      config = function()
         require("mini.move").setup({}) -- adds ability to move text around with <m-h/j/k/l>

         require("mini.cursorword").setup({ -- highlights/underlines the word under the cursor
            delay = 500, -- in ms
         })

         require("mini.files").setup({
            -- file explorer
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

         -- require("mini.pairs").setup({}) -- automatic pair closing

         -- Default mappings:
         -- g= -> evaluate
         -- gx -> exchange
         -- gm -> multiply/duplicate
         -- gr -> replace
         -- gs -> sort
         require("mini.operators").setup({
            exchange = {
               prefix = "gX",
            },
            replace = {
               prefix = "gR",
            },
         })

         local animate = require("mini.animate")
         animate.setup({
            cursor = {
               enable = false,
            },
            scroll = {
               -- enable = false,
               -- timing = animate.gen_timing.linear({
               --    duration = 5,
               -- }),
               timing = animate.gen_timing.linear({
                  -- easing = "in",
                  easing = "out",
                  -- duration = 5,
                  duration = 150,
                  unit = "total",
               }),
            },
            resize = {
               enable = false,
            },
            open = {
               enable = false,
            },
            close = {
               enable = false,
            },
         })
      end,
   },
}
