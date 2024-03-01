return {
   -- Hook into mode changes and change cursor, colors
   -- TODO: use catpuccin colors
   -- NOTE: this plugin seems to cause telescope to open files in insert mode. Workaround is to set a winleave autocmd. https://github.com/nvim-telescope/telescope.nvim/issues/2027#issuecomment-1561836585
   "rasulomaroff/reactive.nvim",
   enabled = not vim.g.vscode,
   event = "VeryLazy",
   config = function()
      require("reactive").add_preset({
         name = "custom",
         modes = {
            n = {
               -- highlight CursorLine only in current window
               winhl = {
                  CursorLineNr = { bg = "gray4" },
               },
            },
            no = {
               operators = {
                  -- switch case
                  [{ "gu", "gU", "g~", "~" }] = {
                     winhl = {
                        CursorLine = { bg = "#334155" },
                        CursorLineNr = { fg = "#cbd5e1", bg = "#334155" },
                     },
                  },
                  -- change
                  c = {
                     winhl = {
                        CursorLine = { bg = "#162044" },
                        CursorLineNr = { fg = "#93c5fd", bg = "#162044" },
                     },
                  },
                  -- delete
                  d = {
                     winhl = {
                        CursorLine = { bg = "#350808" },
                        CursorLineNr = { fg = "#eb6f92", bg = "#350808" },
                     },
                  },
                  -- yank
                  y = {
                     winhl = {
                        CursorLine = { bg = "#231e2a" },
                        CursorLineNr = { fg = "#f6c177", bg = "#2b242f" },
                     },
                  },
               },
            },
            -- visual
            [{ "v", "V", "\x16" }] = {
               winhl = {
                  CursorLineNr = { fg = "#c4a7e7", bg = "#2F354D" },
                  -- CursorLineNr = { fg = "#c4a7e7", bg = "#2e2438" },
                  Visual = { bg = "#2F354D" },
               },
            },
         },
      })
   end,
}
