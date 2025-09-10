return {
   "dmtrKovalenko/fff.nvim",
   build = "cargo build --release",
   opts = {
      prompt = " ▶ ", -- Input prompt symbol
      keymaps = {
         close = { "<Esc>", "<c-c>" },
      },
      layout = {
         prompt_position = "top",
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
