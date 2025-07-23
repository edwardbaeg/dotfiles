return {
   -- preview markdown
   "iamcco/markdown-preview.nvim",
   enabled = false,
   build = "cd app && npm install",
   init = function()
      vim.g.mkdp_filetypes = { "markdown" }
   end,
   ft = { "markdown" }, -- lazy load on file type
}
