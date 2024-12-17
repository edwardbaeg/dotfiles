return {
   "anuvyklack/hydra.nvim",
   enabled = false,
   config = function()
      local hydra = require("hydra")
      -- hydra.setup()

      hydra({
         name = "Window navigation",
         hint = [[...]],
         mode = "n",
         body = "<c-w>",
         heads = {
            { "h", "<c-w>h" },
            { "j", "<c-w>j" },
            { "k", "<c-w>k" },
            { "l", "<c-w>l" },
         },
      })
   end,
}
