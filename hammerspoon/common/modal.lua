---@class Modal
---@field modal hs.hotkey.modal The Hammerspoon modal instance
---@field alertId string? The current alert ID for cleanup
---@field entries ModalEntry[] The modal entries to display
---@field fillColor table The background color for the modal
local Modal = {}
Modal.__index = Modal

---@alias ModalEntry string | ModalEntryTable

---@class ModalEntryTable
---@field key string The key to bind for this entry
---@field label string | function The label to display (can be a function that returns a string)
---@field callback function The function to call when the key is pressed

---@class ModalConfig
---@field entries ModalEntry[] The entries to display in the modal
---@field fillColor table The background color for the modal
---@field hotkey table? Optional hotkey configuration {modifiers, key}

---Create a new Modal instance
---@param config ModalConfig Configuration for the modal
---@return Modal
function Modal.new(config)
   local self = setmetatable({}, Modal)

   -- Create modal with optional hotkey binding
   if config.hotkey then
      self.modal = hs.hotkey.modal.new(config.hotkey.modifiers, config.hotkey.key)
   else
      self.modal = hs.hotkey.modal.new()
   end

   self.alertId = nil
   self.entries = config.entries
   self.fillColor = config.fillColor

   -- Set up modal lifecycle callbacks
   self.modal.entered = function()
      self:_onEntered()
   end

   self.modal.exited = function()
      self:_onExited()
   end

   -- Bind keys for entries
   self:_bindKeys()

   -- Bind exit keys
   self:_bindExitKeys()

   return self
end

---Show the modal alert with formatted entries
---@return string alertId The alert ID for closing later
function Modal:_showModalAlert()
   local mappedEntries = {}
   for _, entry in ipairs(self.entries) do
      if type(entry) == "string" then
         table.insert(mappedEntries, entry)
      elseif type(entry) == "table" and entry.key and entry.label then
         local label = type(entry.label) == "function" and entry.label() or entry.label
         table.insert(mappedEntries, "[" .. entry.key .. "] " .. label)
      end
   end

   local modalContent = table.concat(mappedEntries, "\n")
   modalContent = modalContent .. "\n\n" .. "Esc/q: Exit"

   ---@diagnostic disable-next-line: return-type-mismatch
   return hs.alert.show(modalContent, {
      fillColor = self.fillColor,
      textFont = "0xProto",
      textSize = 20,
      radius = 16,
   }, "indefinite")
end

---Internal callback for when modal is entered
function Modal:_onEntered()
   self.alertId = self:_showModalAlert()
end

---Internal callback for when modal is exited
function Modal:_onExited()
   if self.alertId then
      hs.alert.closeSpecific(self.alertId, 0.1)
      self.alertId = nil
   end
end

---Bind keys for modal entries
function Modal:_bindKeys()
   for _, entry in ipairs(self.entries) do
      if type(entry) == "table" and entry.key and entry.callback then
         self.modal:bind("", entry.key, entry.callback)
      end
   end
end

---Bind exit keys (Escape and Q)
function Modal:_bindExitKeys()
   local exitFunction = function()
      self:exit()
   end
   self.modal:bind("", "escape", exitFunction)
   self.modal:bind("", "q", exitFunction)
end

---Enter the modal
function Modal:enter()
   self.modal:enter()
end

---Exit the modal
function Modal:exit()
   self.modal:exit()
end

---Update modal entries (useful for dynamic labels)
---@param entries ModalEntry[] New entries to display
function Modal:updateEntries(entries)
   self.entries = entries
   -- If modal is currently shown, refresh the alert
   if self.alertId then
      self:_onExited() -- Close current alert
      self:_onEntered() -- Show new alert
   end
end

---Get the underlying Hammerspoon modal for advanced usage
---@return hs.hotkey.modal
function Modal:getModal()
   return self.modal
end

return Modal
