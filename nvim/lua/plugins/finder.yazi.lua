---@module "lazy"
---@type LazySpec
return {
   -- yazi file manager
   -- keymaps: <c-\\> to cwd
   "mikavilpas/yazi.nvim",
   event = "VeryLazy",
   dependencies = {
      -- check the installation instructions at
      -- https://github.com/folke/snacks.nvim
      "folke/snacks.nvim",
   },
   keys = {
      -- 👇 in this section, choose your own keymappings!
      -- {
      --    "<leader>-",
      --    mode = { "n", "v" },
      --    "<cmd>Yazi<cr>",
      --    desc = "Open yazi at the current file",
      -- },
      -- {
      --    -- Open in the current working directory
      --    "<leader>cw",
      --    "<cmd>Yazi cwd<cr>",
      --    desc = "Open the file manager in nvim's working directory",
      -- },
      -- {
      --    "<c-up>",
      --    "<cmd>Yazi toggle<cr>",
      --    desc = "Resume the last yazi session",
      -- },
   },
   ---@module "yazi"
   ---@type YaziConfig | {}
   opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      keymaps = {
         -- show_help = "<f1>",
         show_help = "?",
      },
   },
   -- 👇 if you use `open_for_directories=true`, this is recommended
   init = function()
      vim.keymap.set("n", "<leader>ya", "<cmd>Yazi<cr>", { desc = "[ya]zi" })
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      -- vim.g.loaded_netrw = 1
      -- vim.g.loaded_netrwPlugin = 1
   end,
}
