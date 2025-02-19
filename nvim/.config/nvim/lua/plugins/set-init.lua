-- misc plugins
return {
   {
      -- persist cursor location
      "ethanholz/nvim-lastplace",
      enabled = true,
      config = function()
         require("nvim-lastplace").setup({})
      end,
   },

   {
      -- preview markdown
      "iamcco/markdown-preview.nvim",
      enabled = false,
      build = "cd app && npm install",
      init = function()
         vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" }, -- lazy load on file type
   },

   {
      -- Highlight comments, examples:
      -- TODO
      -- FIXME
      -- HACK
      -- BUG
      "folke/todo-comments.nvim",
      config = function()
         require("todo-comments").setup({
            signs = false,
            highlight = {
               keyword = "fg",
               after = "",
               pattern = [[.*<(KEYWORDS)\s*]], -- removed the `:` from the default pattern
            },
         })
         -- This doesn't work... but works if manually called.. maybe needs to be in an autogroup?
         -- vim.api.nvim_set_hl(0, "shTodo", { bg = "NONE" })
         -- vim.cmd("highlight shTodo ctermbg=NONE guibg=NONE")

         -- But this works...
         vim.api.nvim_set_hl(0, "Todo", { bg = "NONE" })
         -- vim.api.nvim_set_hl(0, "shTodo", { bg = "#1c1c1c" })
         -- vim.api.nvim_set_hl(0, "zshTodo", { bg = "#1c1c1c" })
         -- vim.api.nvim_set_hl(0, "luaTodo", { bg = "#1c1c1c" })
      end,
   },

   {
      -- ability to format comments with fancy boxes and lines
      "LudoPinelli/comment-box.nvim",
      config = function()
         require("comment-box").setup({
            -- comment_style = "auto",
            lines = {
               line = "-",
               line_start = "-",
               line_end = "-",
               title_left = "-",
               title_right = "-",
            },
         })

         local keymap = vim.keymap.set
         local opts = { noremap = true, silent = true }

         keymap("n", "<leader>gcsl", "<cmd>CBline<CR>", opts) -- insert a line
         keymap({ "n", "v" }, "<leader>gcll", "<cmd>CBllline<CR>", opts) -- left aligned line with left aligned text
         keymap({ "n", "v" }, "<leader>gcb", "<cmd>CBccbox<CR>", opts) -- centered box with centered text
         keymap({ "n", "v" }, "<leader>gcd", "<cmd>CBd<CR>", opts) -- delete
      end,
   },

   {
      "NStefan002/screenkey.nvim",
      cmd = "Screenkey",
      version = "*",
      config = true,
   },
}
