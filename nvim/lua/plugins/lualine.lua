return {
   {
      -- statusline
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      config = function()
         local git_blame = require("gitblame")
         vim.g.gitblame_display_virtual_text = 0 -- don't show virtual text

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
               -- lualine_b = { "branch", "diff", "diagnostics" },
               -- lualine_c = { { "filename", path = 1 }, "searchcount" },
               lualine_c = { { "filename", path = 1 }, "searchcount", "codeium#GetStatusString" }, -- FIXME: the codeium portion makes vim enter insert mode when opening a new cile...
               -- lualine_c = {
               --    { "filename", path = 1 },
               --    "searchcount",
               --    "codeium#GetStatusString", -- FIXME: the codeium portion makes vim enter insert mode when opening a new file...
               --    { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
               -- },
               lualine_x = { "filetype" },
               -- lualine_x = { "encoding", "fileformat", "filetype" },
               lualine_y = { "progress" },
               lualine_z = { "location" },
            },
         })
      end,
   },
}
