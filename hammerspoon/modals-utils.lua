local M = {}

---@param key string
---@param label string | function
---@param callback function
---@return ModalEntry
local function createModalEntry(key, label, callback)
   return {
      key = key,
      label = label,
      callback = callback,
   }
end
M.createModalEntry = createModalEntry

---@param url string
local function openRaycastURL(url)
   hs.urlevent.openURL(url)
end
M.openRaycastURL = openRaycastURL

---@param url string
local function executeRaycastURL(url)
   hs.execute("open -g " .. url)
end
M.executeRaycastURL = executeRaycastURL

---@param appName string
---@param modal Modal
local function launchAppAndExit(appName, modal)
   hs.application.launchOrFocus(appName)
   modal:exit()
end
M.launchAppAndExit = launchAppAndExit

return M
