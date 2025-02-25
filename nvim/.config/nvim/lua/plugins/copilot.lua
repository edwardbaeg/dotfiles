return {
   {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "VeryLazy",
      config = function()
         require("copilot").setup({
            panel = {
               enabled = false, -- this can interfere with nvim-cmp
               auto_refresh = true,
            },
            suggestion = {
               enabled = false, -- this can interfere with nvim-cmp
               auto_trigger = true, -- automatically show suggestions in insert mode
               keymap = {
                  -- accept = "<C-l>", -- accept suggestion
                  accept = "<Right>", -- accept suggestion

                  -- these don't interfere with vim-tmux c-j/k keymaps because these are in insert mode
                  next = "<C-j>", -- next suggestion
                  prev = "<C-k>", -- previous suggestion
                  -- dismiss = 'FIXME'
               },
            },
         })

         vim.api.nvim_create_autocmd("VimLeavePre", {
            desc = "disable copilot",
            group = vim.api.nvim_create_augroup("copilot_disable_on_leave", { clear = false }),
            -- pattern = "gitcommit",
            callback = function(opts)
               vim.cmd("Copilot disable")
            end,
         })
      end,
   },

   {
      -- Github Copilot Chat functionality in nvim
      "CopilotC-Nvim/CopilotChat.nvim",
      dependencies = {
         { "zbirenbaum/copilot.lua" },
         { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
      },
      build = "make tiktoken", -- Only on MacOS or Linux
      opts = {},
      cmd = "CopilotChat",
      keys = {
         {
            "<leader>cct",
            function()
               require("CopilotChat").open()
            end,
            desc = "CopilotChat",
         },
         {
            "<leader>ccp",
            function()
               local actions = require("CopilotChat.actions")
               require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
            end,
            desc = "CopilotChat - Prompt actions",
         },
      },
   },
}
