return {
   "dmtrKovalenko/fff.nvim",
   build = "cargo build --release",
   opts = {
      keymaps = {
         close = { "<Esc>", "<c-c>" },
      },
   },
   keys = {
      {
         "<leader>ff", -- try it if you didn't it is a banger keybinding for a picker
         function()
            require("fff").find_files()
         end,
         desc = "Toggle FFF",
      },
      {
         "<c-p>", -- try it if you didn't it is a banger keybinding for a picker
         function()
            require("fff").find_files()
         end,
         desc = "Toggle FFF",
      },
   },
}
