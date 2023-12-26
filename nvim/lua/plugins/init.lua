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
      build = "cd app && npm install",
      init = function()
         vim.g.mkdp_filetypes = { "markdown" }
      end,
      ft = { "markdown" }, -- lazy load on file type
   },

   {
      -- project wide search and replace
      -- NOTE: does not support undo
      "nvim-pack/nvim-spectre",
      config = function()
         require("spectre").setup({})
      end,
   },

   {
      -- Highlight TODO, HACK, BUG, FIXME etc
      -- TODO
      -- FIXME
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
         vim.api.nvim_set_hl(0, "shTodo", { bg = "#1c1c1c" })
         vim.api.nvim_set_hl(0, "zshTodo", { bg = "#1c1c1c" })
      end,
   },

   {
      -- interactive marks
      "theprimeagen/harpoon",
      enabled = false,
      config = function()
         require("harpoon").setup({})

         vim.api.nvim_create_user_command("HarpoonAddFile", "lua require('harpoon.mark').add_file()", {})
         vim.api.nvim_create_user_command("HarpoonUI", "lua require('harpoon.ui').toggle_quick_menu()", {})

         vim.keymap.set("n", "<leader>ha", "<cmd>HarpoonAddFile<cr>", {})
         vim.keymap.set("n", "<leader>hu", "<cmd>HarpoonUI<cr>", {})
      end,
   },
}
