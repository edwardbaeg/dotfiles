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
      -- Highlight TODO, HACK, BUG, etc
      "folke/todo-comments.nvim",
      opts = {
         signs = false,
         highlight = {
            keyword = "fg",
            after = "",
         },
      },
   },

   {
      -- interactive marks
      "theprimeagen/harpoon",
      config = function()
         require("harpoon").setup({})

         vim.api.nvim_create_user_command("HarpoonAddFile", "lua require('harpoon.mark').add_file()", {})
         vim.api.nvim_create_user_command("HarpoonUI", "lua require('harpoon.ui').toggle_quick_menu()", {})

         vim.keymap.set("n", "<leader>ha", "<cmd>HarpoonAddFile<cr>", {})
         vim.keymap.set("n", "<leader>hu", "<cmd>HarpoonUI<cr>", {})
      end,
   },
} -- lazyend
