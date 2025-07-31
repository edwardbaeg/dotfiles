---@module "lazy"
return {
   ---@type LazyPluginSpec -- NOTE: this doesnt seem to detect unexpected fields?
   {
      -- Adds IDE integration for Claude Code in Nvim
      "coder/claudecode.nvim",
      dependencies = { "folke/snacks.nvim" },
      -- lazy = false, -- register :ClaudeCode commands immediately
      config = true,
      cmd = {
         "ClaudeCode",
         "ClaudeCodeFocus",
         "ClaudeCodeSend",
         "ClaudeCodeAdd",
         -- "ClaudeCodeDiffAccept",
         -- "ClaudeCodeDiffDeny",
      },
      keys = {
         { "<leader>a", nil, desc = "AI/Claude Code" },
         { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
         { "<leader>as", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
         { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
         { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
         { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
         { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
         { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
         { "<leader>ac", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
         {
            "<leader>as",
            "<cmd>ClaudeCodeTreeAdd<cr>",
            desc = "Add file",
            ft = { "NvimTree", "neo-tree", "oil" },
         },
         -- Diff management
         { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
         { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
      },
   },

   {
      -- display Claude Code usage with lualine integration
      -- NOTE: requires `npm i -g ccusage`
     "S1M0N38/ccusage.nvim",
     version = "1.*",
     opts = {},
   }
}
