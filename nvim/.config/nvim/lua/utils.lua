local M = {}

--- Combine two associate tables
---@param t1 table
---@param t2 table
---@return table
function M.object_assign(t1, t2)
   for key, value in pairs(t2) do
      t1[key] = value
   end

   return t1
end

---@param name string
function M.isIndexFile(name)
   return name:find("^index.")
end

---@param path string
function M.getFilenameFromPath(path)
   return path:gsub(".*/", "")
end

---This could be refactored to just use the path of the file...
---@param filename string file name
---@param path string file path
---@param short? boolean whether to display index filename as "index" or "i"
---@return string text shorthand filename that includes the parent directory for index.* files
function M.getDisplayFileName(filename, path, short)
   short = short or false
   if not M.isIndexFile(filename) then
      return filename
   else
      local parentDirName = path:match("(.*)/(.*)$")
      parentDirName = parentDirName:gsub(".*/", "")
      if short then
         return parentDirName .. "/" .. "i"
      end
      return parentDirName .. "/" .. filename
   end
end

return M
