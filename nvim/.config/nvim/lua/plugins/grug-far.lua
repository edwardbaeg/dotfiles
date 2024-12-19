return {
   -- global search and replace
   --:GrugFar
   "MagicDuck/grug-far.nvim",
   config = function()
      require("grug-far").setup({})

      local grugFar = require("grug-far")
      vim.api.nvim_create_user_command("SearchAndReplaceGrugFar", grugFar.open, {})
   end,
}
