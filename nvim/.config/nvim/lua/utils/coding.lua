local M = {}

function M.get_print_statement(word, filetype)
   if
      filetype == "javascript"
      or filetype == "typescript"
      or filetype == "javascriptreact"
      or filetype == "typescriptreact"
   then
      return "console.log({ " .. word .. " });"
   elseif filetype == "lua" then
      return "print(" .. word .. ")"
   else
      return "console.log({ " .. word .. " });"
   end
end

function M.smart_print_word()
   local word = vim.fn.expand("<cword>")
   vim.cmd("normal! o")

   local filetype = vim.bo.filetype
   local print_statement = M.get_print_statement(word, filetype)

   vim.api.nvim_put({ print_statement }, "c", false, true)
end

return M
