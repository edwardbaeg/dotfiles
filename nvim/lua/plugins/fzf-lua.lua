return {
   "ibhagwan/fzf-lua",
   dependencies = { "nvim-tree/nvim-web-devicons" },
   event = "VeryLazy",
   config = function()
      require("fzf-lua").setup({
         -- "fzf-tmux",
         "default",
         winopts = {
            height = 0.9, -- default is 0.85
            width = 0.9, -- default is 0.80
            row = 0.35, -- default is 0.35
            col = 0.5, -- default is 0.50
            preview = {
               layout = "flex",
               flip_columns = 150, -- number of columns at which to flip to horizontal, default is 120
               horizontal = "right:50%",
            },
         },
         buffers = {
            winopts = {
               height = 0.7,
               width = 0.5,
               preview = {
                  layout = "vertical",
                  vertical = "down:50%", -- preview takes bottom % of floating window
               },
            },
         },
      })
   end,
   init = function()
      vim.keymap.set("n", "<c-g>", "<cmd>lua require('fzf-lua').grep_project()<cr>", { silent = true })
      vim.keymap.set("n", "<c-b>", "<cmd>lua require('fzf-lua').buffers()<cr>", { silent = true })
      vim.keymap.set("n", "<c-p>", "<cmd>lua require('fzf-lua').files()<cr>", { silent = true })

      vim.keymap.set("n", "<leader>*", "<cmd>lua require('fzf-lua').grep_cword()<cr>", { silent = true })
   end,
}
