local M = {}

local function getToggleLabel(value, label)
   return (value and "●" or "○") .. " Toggle " .. label .. " " .. (value and "off" or "on") .. ""
end
M.getToggleLabel = getToggleLabel

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

---@param key string
---@param label string
---@param appName string
---@return ModalEntry
local function launchModalEntry(key, label, appName)
   return createModalEntry(key, label, function()
      launchApp(appName, mainModal)
   end)
end

M.launchModalEntry = launchModalEntry

---@param key string
---@param label string
---@param url string
---@return ModalEntry
local function openRaycastModalEntry(key, label, url)
   return createModalEntry(key, label, function()
      openRaycastURL(url, raycastModal)
   end)
end

M.openRaycastModalEntry = openRaycastModalEntry

---@param key string
---@param label string
---@param url string
---@return ModalEntry
local function executeRaycastModalEntry(key, label, url)
   return createModalEntry(key, label, function()
      executeRaycastURL(url, raycastModal)
   end)
end

M.executeRaycastModalEntry = executeRaycastModalEntry

return M
