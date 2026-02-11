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
         enabled = true,
         show_scores = true,
      },
      prompt = " ▶ ", -- Input prompt symbol
      keymaps = {
         close = { "<Esc>", "<c-c>" }, -- default is "<Esc>"
         -- send_to_quickfix = { "<C-q>", "<CR>" }, -- default is "<C-q>"
      },
      layout = {
         prompt_position = "top",
      },
   },
   keys = {
      {
         "<c-p>",
         function()
            require("fff").find_files()
         end,
         desc = "Toggle FFF",
      },
      {
         "<leader>ff",
         function()
            require("fff").find_files()
         end,
         desc = "Toggle FFF",
      },
   },
}
