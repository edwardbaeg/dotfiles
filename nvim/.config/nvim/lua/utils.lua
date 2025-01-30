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

return M
