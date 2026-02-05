return {
   "dmtrKovalenko/fff.nvim",
   lazy = false, -- plugin automatically lazy loads
   -- if build fails, navigate to plugin dir and run `cargo build --release` ($HOME/.local/share/nvim/lazy/fff.nvim)
   -- build = "cargo build --release",
   build = function()
      -- this will download prebuild binary or try to use existing rustup toolchain to build from source
      -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
      require("fff.download").download_or_build_binary()
   end,
   opts = {
      debug = {
         enabled = true,     -- we expect your collaboration at least during the beta
         show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
      },
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
         "<c-p>",
         function()
            require("fff").find_files()
         end,
         desc = "Toggle FFF",
      },
   },
}
