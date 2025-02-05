return {
   {
      -- for showing virtual text with codeium, faster than codeium.vim
      "monkoose/neocodeium",
      enabled = not vim.g.vscode,
      event = "VeryLazy",
      config = function()
         local neocodeium = require("neocodeium")
         neocodeium.setup({
            silent = true,
            filetypes = {
               -- defaults
               help = false,
               gitcommit = false,
               gitrebase = false,
               ["."] = false,

               sagarename = false, -- the line column label takes up space
               snacks_picker_input = false,
            },
         })
         vim.keymap.set("i", "<Right>", neocodeium.accept)

         -- cycle through suggetions
         vim.keymap.set("i", "<c-j>", function()
            require("neocodeium").cycle()
         end)
         vim.keymap.set("i", "<c-k>", function()
            require("neocodeium").cycle(-1)
         end)

         -- Partial accepts
         vim.keymap.set("i", "<c-w>", function()
            require("neocodeium").accept_word()
         end)
         vim.keymap.set("i", "<A-w>", function()
            require("neocodeium").accept_word()
         end)
         vim.keymap.set("i", "<A-l>", function()
            require("neocodeium").accept_line()
         end)
      end,
   },

   {
      -- AI code autocompletion
      -- This is used to show ghost text for suggestions
      -- NOTE: to fix an issue with the macos language server, delete the ~/.codeium dir
      "Exafunction/codeium.vim",
      -- enabled = not vim.g.vscode,
      enabled = false,
      event = "VeryLazy",
      init = function()
         vim.g.codeium_disable_bindings = 1 -- turn off tab and defaults
         -- vim.g.codeium_enabled = false -- disable by default
         vim.keymap.set("i", "<Right>", function()
            return vim.fn["codeium#Accept"]() -- there isn't a plug command for this yet
         end, { expr = true })
         -- vim.keymap.set("i", "<C-l>", function()
         --    return vim.fn["codeium#Accept"]() -- there isn't a plug command for this yet
         -- end, { expr = true })
         vim.keymap.set("i", "<C-j>", "<Plug>(codeium-next)")
         vim.keymap.set("i", "<C-k>", "<Plug>(codeium-previous)")
         -- vim.keymap.set({ "i", "n" }, "<c-h>", "<Plug>(codeium-dismiss)")
         vim.keymap.set("i", "<c-h>", "<Plug>(codeium-dismiss)")

         -- codeium can cause vim to crash on exit, particularly for git files
         -- eg, gitcommit, gitrebase, etc
         vim.api.nvim_create_autocmd("VimLeavePre", {
            desc = "disable codeium before exiting",
            group = vim.api.nvim_create_augroup("codeium_disable_gitcommit", { clear = false }),
            callback = function(opts)
               -- vim.cmd("CodeiumDisable")
               -- vim.cmd("Neocodeium disable")
            end,
         })
      end,
   },

   {
      -- AI code autocompletion
      -- This is used to show suggestions in the popup menu
      -- NOTE: this can cause nvim to crash on exit
      "Exafunction/codeium.nvim",
      -- enabled = not vim.g.vscode,
      enabled = false,
      event = "VeryLazy",
      dependencies = {
         "nvim-lua/plenary.nvim",
         "hrsh7th/nvim-cmp",
      },
      config = function()
         require("codeium").setup({})
      end,
   },
}
