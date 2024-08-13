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
               globalstatus = true,
            },
            extensions = {
               "lazy",
               "mundo",
               "trouble",
            },
            sections = {
               lualine_a = {
                  "mode",
               },

               lualine_b = {
                  "branch",
                  "diff",
                  "diagnostics",
                  "grapple",
               },

               lualine_c = {
                  {
                     "filename",
                     -- path = 1, -- full relative path
                     path = 4, -- parent path
                  },
                  -- "searchcount",
                  "codeium#GetStatusString",
                  {
                     git_blame.get_current_blame_text,
                     cond = git_blame.is_blame_text_available,
                  },
               },

               -- lualine_x = { "filetype" },
               lualine_x = {
                  -- "encoding",
                  -- "fileformat",
                  "filetype",
               },

               lualine_y = { "progress" },
               lualine_z = { "location" },
            },
         })
      end,
   },
}
