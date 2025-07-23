return {
   -- Hook into mode changes and change cursor, colors
   -- TODO?: use catpuccin colors
   "rasulomaroff/reactive.nvim",
   enabled = not vim.g.vscode,
   event = "VeryLazy",
   config = function()
      -- fix issue with opening files in telescope entering insert mode with `reactive.nvim`
      -- https://github.com/nvim-telescope/telescope.nvim/issues/2027#issuecomment-1561836585
      vim.api.nvim_create_autocmd("WinLeave", {
         callback = function()
            if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
               vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
            end
         end,
      })
      require("reactive").add_preset({
         name = "custom",
         modes = {
            n = {
               -- hl is global and winhl is only for the current window
               hl = {
                  -- NOTE: cursorline also needs to be set in settings so it won't be overwritten
                  CursorLine = { bg = "#0A2222" },
                  CursorLineNr = { bg = "black" },
                  -- CursorLineNr = { bg = "gray1" },
                  -- CursorLine = { bg = "gray7" },
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
