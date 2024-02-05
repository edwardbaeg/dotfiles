return {
   -- statusline
   "nvim-lualine/lualine.nvim",
   config = function()
      require("lualine").setup({
         options = {
            icons_enabled = false,
            component_separators = "|",
            section_separators = "",
         },
         extensions = {
            "lazy", -- doesn't seem to do anything?
            "mundo",
            "trouble",
         },
         sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            -- lualine_c = { { "filename", path = 1 }, "searchcount", "codeium#GetStatusString" }, -- FIXME: the codeium portion makes vim enter insert mode when opening a new file...
            lualine_c = { { "filename", path = 1 }, "searchcount" },
            -- lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_x = { "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
         },
      })
   end,
}
