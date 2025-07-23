return {
   -- extends <ctrl-a> and <ctrl-x>
   -- Sandbox area: 5 true || and
   -- TODO?: add support for lsp enums https://www.reddit.com/r/neovim/comments/1k95s17/dial_enum_members_with_ca_cx/
   "monaqa/dial.nvim",
   event = "VeryLazy",
   config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
         default = {
            augend.constant.alias.bool,
            augend.integer.alias.decimal_int,
            augend.date.alias["%d.%m.%Y"],
            augend.constant.new({
               elements = { "&&", "||" },
               word = false,
               cyclic = true,
            }),
            augend.constant.new({
               elements = { "==", "!=" },
               word = false,
               cyclic = true,
            }),
            augend.constant.new({
               elements = { "===", "!==" },
               word = false,
               cyclic = true,
            }),
            augend.constant.new({
               elements = { "and", "or" },
               word = false,
               cyclic = true,
            }),
         },
      })

      -- Replace builtin keymaps
      vim.keymap.set("n", "<C-a>", function()
         require("dial.map").manipulate("increment", "normal")
      end)
      vim.keymap.set("n", "<C-x>", function()
         require("dial.map").manipulate("decrement", "normal")
      end)
      vim.keymap.set("n", "g<C-a>", function()
         require("dial.map").manipulate("increment", "gnormal")
      end)
      vim.keymap.set("n", "g<C-x>", function()
         require("dial.map").manipulate("decrement", "gnormal")
      end)
      vim.keymap.set("v", "<C-a>", function()
         require("dial.map").manipulate("increment", "visual")
      end)
      vim.keymap.set("v", "<C-x>", function()
         require("dial.map").manipulate("decrement", "visual")
      end)
      vim.keymap.set("v", "g<C-a>", function()
         require("dial.map").manipulate("increment", "gvisual")
      end)
      vim.keymap.set("v", "g<C-x>", function()
         require("dial.map").manipulate("decrement", "gvisual")
      end)
   end,
}
