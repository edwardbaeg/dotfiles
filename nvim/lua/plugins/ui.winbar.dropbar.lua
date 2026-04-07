return {
   -- IDE style winbar with breadcrumbs
   -- drop in; doesn't require any configuration
   "Bekaboo/dropbar.nvim",
   opts = function(_, opts)
      opts.sources = opts.sources or {}

      -- Remove 'table' to prevent comment text inside tables from appearing as crumb names
      -- (mostly affects lua-family languages and toml; safe to remove for js/ts/py/go etc.)
      local defaults = require("dropbar.configs").opts.sources.treesitter.valid_types
      opts.sources.treesitter = vim.tbl_extend("force", opts.sources.treesitter or {}, {
         valid_types = vim.tbl_filter(function(t)
            return t ~= "table"
         end, defaults),
      })
      -- Disable click/menu functionality for performance
      opts.bar = vim.tbl_extend("force", opts.bar or {}, { hover = false })
      opts.symbol = vim.tbl_extend("force", opts.symbol or {}, { on_click = false })
      return opts
   end,
}
