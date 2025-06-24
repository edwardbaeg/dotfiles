return {
   {
      -- Automatically add, pad closing brackets
      -- Fastwarp: <A-e> and <A-E>
      "altermo/ultimate-autopair.nvim",
      event = { "InsertEnter", "CmdlineEnter" },
      branch = "v0.6", -- plugin is currently in maintenance mode
      opts = {
         -- move closing bracket
         -- TODO: see if we can add normal mode mapping?
         fastwarp = {
            enable = true,
            faster = true, -- skip over pairs
         },
         -- nft is "not file type"
         config_internal_pairs = {
            { "(", ")",  nft = { "snacks_picker_input" } },
            { "[", "]",  nft = { "snacks_picker_input" } },
            { "{", "}",  nft = { "snacks_picker_input" } },
            { "'", "'",  nft = { "snacks_picker_input" } },
            { '"', '"',  nft = { "snacks_picker_input" } },
            { "`", "`",  nft = { "snacks_picker_input" } },
         },
      },
   },

   {
      -- adds motions for surrounding, has preview highlight
      "kylechui/nvim-surround",
      config = function()
         -- add operator maps for [r]ight angle braces and [a]ngle brances -- replaced with mini.ai
         -- vim.keymap.set("o", "ir", "i[")
         -- vim.keymap.set("o", "ar", "a[")
         -- vim.keymap.set("o", "ia", "i<")
         -- vim.keymap.set("o", "aa", "a<")

         require("nvim-surround").setup({
            keymaps = {
               insert = false,
               insert_line = false,
               normal = "sa", -- default is ys
               normal_cur = false,
               normal_line = false,
               normal_cur_line = false,
               visual = "s", -- default is S
               -- visual = "a", -- default is S
               visual_line = false,
               -- delete = "sd", -- default is ds
               -- change = "sc", -- default is cs
            },
            aliases = {
               ["b"] = { ")", "}", "]" }, -- adds the other brackets
            },
         })
      end,
   },
}
