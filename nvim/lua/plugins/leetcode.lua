local leet_arg = "leetcode.nvim"

return {
   -- leetcode in nvim
   -- launch with nvim leetcode.nvim or :Leet
   "kawre/leetcode.nvim",
   build = ":TSUpdate html",
   lazy = leet_arg ~= vim.fn.argv()[1],
   -- live-command supports semantic versioning via tags
   -- tag = "1.*",
   cmd = "Leet",
   dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      -- "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
   },
   config = function()
      require("leetcode").setup({
         arg = leet_arg,
         lang = "typescript",
         keys8 = {
            toggle = { "q", "<Esc>" }, ---@type string|string[]
            confirm = { "<CR>" }, ---@type string|string[]

            reset_testcases = "r", ---@type string
            use_testcase = "U", ---@type string
            focus_testcases = "H", ---@type string
            focus_result = "L", ---@type string
         },
      })

      vim.keymap.set("n", "<leader>lt", ":Leet test<CR>", { desc = "Leetcode test" })
      vim.keymap.set("n", "<leader>ls", ":Leet submit<CR>", { desc = "Leetcode submit" })
   end,
}
