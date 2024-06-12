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
         -- TODO: figure out a way to allow searching in the pathname direction
         -- eg matching "hooks/init" by searching "hooks init" instead of "init hooks"
         files = {
            formatter = "path.filename_first",
         },
         grep = {
            -- split results into multiple lines for narrow widths
            -- this requires fzf-lua >= 0.53
            multiline = 1,
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
      vim.keymap.set("n", "<leader>*", "<cmd>lua require('fzf-lua').grep_cword()<cr>", { silent = true })
      vim.keymap.set("n", "<c-g>", "<cmd>lua require('fzf-lua').grep_project()<cr>", { silent = true })
      vim.keymap.set("n", "<c-b>", "<cmd>lua require('fzf-lua').buffers()<cr>", { silent = true })
      vim.keymap.set("n", "<c-p>", "<cmd>lua require('fzf-lua').files()<cr>", { silent = true })
      vim.keymap.set("n", "<leader>fb", "<cmd>lua require('fzf-lua').git_bcommits()<cr>", { silent = true })
      vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').builtin()<cr>", { silent = true })
      vim.keymap.set("n", "<leader>fj", "<cmd>lua require('fzf-lua').jumps()<cr>", { silent = true })
   end,
}
