local M = {}

---@alias SimpleModalEntryType "app" | "submodal" | "custom" | "url" | "url_bg"

---@class SimpleModalEntry
---@field type SimpleModalEntryType
---@field [1] string  -- key
---@field [2] string | function  -- label (static string or dynamic function)
---@field [3] string | function  -- app name, submodal key, URL, or callback

---@alias SimpleModalItem string | SimpleModalEntry

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

---Process a simple modal entry into a full ModalEntry
---@param entry SimpleModalEntry
---@param modal Modal
---@param submodals table<string, Modal>
---@return ModalEntry
local function processSimpleEntry(entry, modal, submodals)
   local key = entry[1]
   local label = entry[2]
   local value = entry[3]

   if entry.type == "app" then
      return createModalEntry(key, label, function()
         launchAppAndExit(value, modal)
      end)
   elseif entry.type == "submodal" then
      return createModalEntry(key, label, function()
         modal:exit()
         submodals[value]:enter()
      end)
   elseif entry.type == "url" then
      return createModalEntry(key, label, function()
         hs.urlevent.openURL(value)
         modal:exit()
      end)
   elseif entry.type == "url_bg" then
      return createModalEntry(key, label, function()
         hs.execute("open -g " .. value)
         modal:exit()
      end)
   elseif entry.type == "custom" then
      return createModalEntry(key, label, function()
         value()
         modal:exit()
      end)
   end
end
M.processSimpleEntry = processSimpleEntry

---Process a list of simple modal items into full ModalEntry array
---@param entries SimpleModalItem[]
---@param modal Modal
---@param submodals table<string, Modal>
---@return ModalEntry[]
local function processSimpleEntries(entries, modal, submodals)
   local result = {}
   for _, entry in ipairs(entries) do
      if type(entry) == "string" then
         table.insert(result, entry)
      else
         table.insert(result, processSimpleEntry(entry, modal, submodals))
      end
   end
   return result
end
M.processSimpleEntries = processSimpleEntries

return M
