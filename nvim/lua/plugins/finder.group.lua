return {
   {
      -- Open alternate files for current buffer
      -- eg, *.test.ex
      -- TODO: add *.stories.*
      -- TODO: consider Dkendal/nvim-alternate
      "rgroli/other.nvim",
      config = function()
         require("other-nvim").setup({
            mappings = {
               "react",
               "golang"
            }
         })
      end
   },
}
