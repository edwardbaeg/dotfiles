return {
   -- add tabpage interface for cycling through diffs
   -- :DiffView*
   "sindrets/diffview.nvim",
   event = "VeryLazy",
   config = function()
      require("diffview").setup({
         -- try to make it more similar to vscode
         -- hooks = {
         --    diff_buf_win_enter = function(bufnr, winid, ctx)
         --       if ctx.layout_name:match("^diff2") then
         --          if ctx.symbol == "a" then
         --             vim.opt_local.winhl = table.concat({
         --                "DiffAdd:DiffviewDiffAddAsDelete",
         --                "DiffDelete:DiffviewDiffDelete",
         --             }, ",")
         --          elseif ctx.symbol == "b" then
         --             vim.opt_local.winhl = table.concat({
         --                "DiffDelete:DiffviewDiffDelete",
         --             }, ",")
         --          end
         --       end
         --    end,
         -- },
      })

      vim.keymap.set("n", "<leader>do", "<cmd>DiffviewOpen<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>dq", "<cmd>DiffviewClose<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>gdq", "<cmd>DiffviewClose<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>df", "<cmd>DiffviewFileHistory %<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>dm", "<cmd>DiffviewOpen master..HEAD<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>gdm", "<cmd>DiffviewOpen master..HEAD<cr>", { noremap = true })

      local actions = require("diffview.actions")
      vim.keymap.set("n", "<leader>dn", actions.next_conflict, { noremap = true, desc = "[n]ext conflict" })
      vim.keymap.set("n", "<leader>gdn", actions.next_conflict, { noremap = true, desc = "[n]ext conflict" })
      vim.keymap.set("n", "<leader>dp", actions.prev_conflict, { noremap = true, desc = "[p]revious conflict" })
      vim.keymap.set("n", "<leader>gdp", actions.prev_conflict, { noremap = true, desc = "[p]revious conflict" })

      -- prettier highlights
      vim.api.nvim_set_hl(0, "DiffAdd", {bg = "#20303b"})
      vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#191010" })
      vim.api.nvim_set_hl(0, "DiffChange", {bg = "#1f2231"})
      vim.api.nvim_set_hl(0, "DiffText", {bg = "#394b70"})

      vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', { fg = "#4a2d3a" })

      local function diff_open_with_input()
         -- local user_input = vim.fn.input("Revision to Open: ")
         -- TODO replace with some ui plugin like snacks
         vim.ui.input({ prompt = "Revision to Open: " }, function(input)
            vim.cmd("DiffviewOpen " .. input)
         end)
      end

      -- internal: use internal diff library
      -- fillter: add filler lines for side by side diffs
      -- linematch: try to match same lines
      -- iwhite: ignore changes in the amount of whitespace
      vim.o.diffopt = "internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:histogram,iwhite"

      vim.keymap.set("n", "<leader>di", diff_open_with_input, { desc = "Diffview [I]nput" })
   end,
}
