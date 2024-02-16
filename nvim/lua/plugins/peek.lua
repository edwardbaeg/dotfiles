return {
   {
      -- markdown preview
      "toppair/peek.nvim",
      event = { "VeryLazy" },
      build = "deno task --quiet build:fast",
      config = function()
         require("peek").setup({
            auto_load = true,
         })
         vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
         vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
      end,
   },
}
