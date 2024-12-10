return {
   {
      -- statusline
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      config = function()
         local git_blame = require("gitblame")
         vim.g.gitblame_display_virtual_text = 0 -- don't show virtual text

         local function shorten(text, _, max_length)
            local substring_length = math.floor((max_length or 30) / 2)
            if #text > substring_length then
               return text:sub(1, substring_length) .. "[…]" .. text:sub(-substring_length)
            end
            return text
         end

         require("lualine").setup({
            options = {
               icons_enabled = false, -- disable icons
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
                  { "branch", fmt = shorten },
                  "diff",
                  "diagnostics",
                  "grapple",
               },

               lualine_c = {
                  {
                     "filename",
                     path = 1, -- full relative path
                     -- path = 3, -- absolute path
                     -- path = 4, -- filename with parent path
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
