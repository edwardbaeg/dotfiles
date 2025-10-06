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

local function openRaycastURL(url, modal)
   hs.urlevent.openURL(url)
   modal:exit()
end
M.openRaycastURL = openRaycastURL

local function executeRaycastURL(url, modal)
   hs.execute("open -g " .. url)
   modal:exit()
end
M.executeRaycastURL = executeRaycastURL

local function launchApp(appName, modal)
   hs.application.launchOrFocus(appName)
   modal:exit()
end
M.launchApp = launchApp

return M
