return {
   -- IDE style winbar with breadcrumbs
   -- drop in; doesn't require any configuration
   "Bekaboo/dropbar.nvim",
   -- config = function()
   --    local dropbar_api = require("dropbar.api")
   --    vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
   --    vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
   --    vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
   -- end,
   -- config = true,
   opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.path = {
         filter = function(_filename)
            return true
         end,
      }
      -- Remove 'table' to prevent comment text inside tables from appearing as crumb names
      -- (mostly affects lua-family languages and toml; safe to remove for js/ts/py/go etc.)
      local defaults = require("dropbar.configs").opts.sources.treesitter.valid_types
      opts.sources.treesitter = vim.tbl_extend("force", opts.sources.treesitter or {}, {
         valid_types = vim.tbl_filter(function(t)
            return t ~= "table"
         end, defaults),
      })
      return opts
   end,
}
