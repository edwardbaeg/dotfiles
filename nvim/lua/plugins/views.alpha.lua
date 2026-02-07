return { -- start page for nvim
   -- TODO: move to a set-views file
   "goolord/alpha-nvim",
   enabled = not vim.g.vscode,
   dependencies = "nvim-tree/nvim-web-devicons",
   config = function()
      local startify = require("alpha.themes.startify")
      local config = vim.deepcopy(startify.config)

      -- "NVIM v0.11.0"
      local version = vim.version()
      local version_string = string.format("NVIM %d.%d.%d", version.major, version.minor, version.patch)

      -- Custom header
      config.layout[2] = {
         type = "text",
         val = { "", version_string },
      }

      table.insert(config.layout, 3, {
         type = "text",
         val = { "", "Nvim is open source and freely distributable" },
         opts = {
            -- position = "center",
            -- hl = "String",
         },
      })

      require("alpha").setup(config)

      -- Change the position for every layout item -- this crashes vim
      -- for _, element in ipairs(config.layout) do
      --    vim.print(element)
      --    element.opts = element.opts or {}
      --    if
      --       element.opts.val ~= nil
      --       and type(element.opts.val) == "table"
      --       and type(element.opts.val.position) == "string"
      --    then
      --       -- element.opts.val.position = "right"
      --    end
      -- end

   end,
}
