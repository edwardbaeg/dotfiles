return {
   -- IDE style winbar with breadcrumbs
   -- drop in; doesn't require any configuration
   "Bekaboo/dropbar.nvim",
   -- optional, but required for fuzzy finder support
   -- dependencies = {
   --    "nvim-telescope/telescope-fzf-native.nvim",
   --    build = "make",
   -- },
   config = function()
      local sources = require("dropbar.sources")
      local utils = require("dropbar.utils")

      local custom_path = {
         get_symbols = function(_buf, _win, _cursor)
            return {} -- Remove all path symbols to show only code breadcrumbs
         end,
      }

      require("dropbar").setup({
         bar = {
            sources = function(buf, _)
               if vim.bo[buf].ft == "markdown" then
                  return { custom_path, sources.markdown }
               end
               if vim.bo[buf].buftype == "terminal" then
                  return { sources.terminal }
               end
               return {
                  custom_path,
                  utils.source.fallback({ sources.lsp, sources.treesitter }),
               }
            end,
         },
      })
end,
}
