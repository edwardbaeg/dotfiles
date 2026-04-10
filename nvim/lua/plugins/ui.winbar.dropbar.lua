return {
   -- IDE style winbar with breadcrumbs
   -- drop in; doesn't require any configuration
   "Bekaboo/dropbar.nvim",
   opts = {
      bar = {
         hover = false,
      },
      symbol = {
         on_click = false,
      },
   },
   config = function(_, opts)
      -- Remove 'table' to prevent comment text inside tables from appearing as crumb names
      -- (mostly affects lua-family languages and toml; safe to remove for js/ts/py/go etc.)
      local defaults = require("dropbar.configs").opts.sources.treesitter.valid_types
      opts.sources = {
         treesitter = {
            valid_types = vim.tbl_filter(function(t)
               return t ~= "table"
            end, defaults),
         },
      }
      require("dropbar").setup(opts)
   end,
}
