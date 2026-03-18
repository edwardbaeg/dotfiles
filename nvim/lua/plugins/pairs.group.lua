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
            { "(", ")", nft = { "snacks_picker_input" } },
            { "[", "]", nft = { "snacks_picker_input" } },
            { "{", "}", nft = { "snacks_picker_input" } },
            { "'", "'", nft = { "snacks_picker_input" } },
            { '"', '"', nft = { "snacks_picker_input" } },
            { "`", "`", nft = { "snacks_picker_input" } },
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

         vim.g.nvim_surround_no_mappings = true
         vim.keymap.set("n", "sa", "<Plug>(nvim-surround-normal)", { desc = "Add surrounding pair around motion" })
         vim.keymap.set("x", "s", "<Plug>(nvim-surround-visual)", { desc = "Add surrounding pair around selection" })
         vim.keymap.set("n", "ds", "<Plug>(nvim-surround-delete)", { desc = "Delete surrounding pair" }) -- default is ds, alt: sd
         vim.keymap.set("n", "cs", "<Plug>(nvim-surround-change)", { desc = "Change surrounding pair" }) -- default is cs, alt: sc

         require("nvim-surround").setup({
            aliases = {
               ["b"] = { ")", "}", "]" }, -- adds the other brackets
            },
         })
      end,
   },
}
