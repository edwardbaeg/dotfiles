-- TODO: create a module for this?
local Utils = {}
--- Combine two associate tables
---@param t1 table
---@param t2 table
---@return table
function Utils.object_assign(t1, t2)
   for key, value in pairs(t2) do
      t1[key] = value
   end

   return t1
end

return {
   -- per window floating statusline
   "b0o/incline.nvim",
   dependencies = "nvim-tree/nvim-web-devicons",
   event = "VeryLazy",
   config = function()
      local frappe = require("catppuccin.palettes").get_palette("frappe")
      require("incline").setup({
         window = {
            padding = 0,
            margin = {
               horizontal = 0,
               vertical = 0, -- overlap window border
            },
         },
         render = function(props)
            local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
            local path = vim.api.nvim_buf_get_name(props.buf)
            local modified = vim.bo[props.buf].modified

            -- TODO: abstract this with bufferline
            if filename:find("^index") then
               local parentDirName = path:match("(.*)/(.*)$")
               parentDirName = parentDirName:gsub(".*/", "")
               -- filename = parentDirName .. "/" .. filename
               filename = parentDirName .. "/i"
            end

            if filename == "" then
               filename = "[No Name]"
            end

            -- filename = filename .. " "

            -- devicon (if available)
            -- TODO consider using mini.icons. web devicons cannot be used to override the icon theme
            local devicon = { " " }
            local success, nvim_web_devicons = pcall(require, "nvim-web-devicons")
            if success then
               local buffullname = vim.api.nvim_buf_get_name(props.buf)
               local bufname_r = vim.fn.fnamemodify(buffullname, ":r")
               local bufname_e = vim.fn.fnamemodify(buffullname, ":e")
               local base = (bufname_r and bufname_r ~= "") and bufname_r or props.buf
               local ext = (bufname_e and bufname_e ~= "") and bufname_e or vim.fn.fnamemodify(base, ":t")
               local ic, hl = nvim_web_devicons.get_icon(base, ext, { default = true })
               devicon = {
                  ic,
                  " ",
                  group = hl,
               }
            end

            local defaultFieldOptions = {
               guifg = frappe.crust,
               guibg = props.focused and frappe.overlay2 or frappe.surface1,
            }

            local invertedFieldOptions = {
               guifg = props.focused and frappe.overlay2 or frappe.surface1,
               guibg = frappe.crust,
            }

            -- example: █▓   incline-nvim.lua ▓█
            return {
               Utils.object_assign({
                  " ░▓█", -- these are unicode block shade characters
               }, invertedFieldOptions),

               Utils.object_assign({
                  devicon,
               }, defaultFieldOptions),

               {
                  filename,
                  -- gui = modified and "bold,italic" or "bold",
                  gui = "bold",
                  guibg = props.focused and frappe.overlay2 or frappe.surface1,
                  guifg = frappe.crust,
               },
               {
                  modified and " • " or " ",
                  guifg = "yellow",
                  guibg = props.focused and frappe.overlay2 or frappe.surface1,
               },
            }
         end,
      })
   end,
}
