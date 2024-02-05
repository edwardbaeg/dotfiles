return {
   "f-person/git-blame.nvim",
   config = function()
      require("gitblame").setup({})
      -- vim.g.gitblame_message_template = "<author> • <summary> • <date>"
      vim.g.gitblame_message_template = "<author> ▸ <summary> ▸ <date>"
      vim.g.gitblame_date_format = "%r"
      vim.g.gitblame_message_when_not_committed = "Not committed"
   end,
}
