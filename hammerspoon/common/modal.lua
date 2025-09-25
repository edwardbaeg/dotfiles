---@class Modal
---@field modal hs.hotkey.modal The Hammerspoon modal instance
---@field alertId string? The current alert ID for cleanup
---@field entries ModalEntry[] The modal entries to display
---@field fillColor table The background color for the modal
---@field selectedIndex number The currently selected entry index
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
   self.selectedIndex = self:_getFirstSelectableIndex()

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

   -- Bind navigation keys
   self:_bindNavigationKeys()

   return self
end

---Show the modal alert with formatted entries
---@param highlightColor? table Optional color to use for selected item highlighting
---@return string alertId The alert ID for closing later
function Modal:_showModalAlert(highlightColor)
   local catppuccin = require("common.external.catpuccin-frappe")
   local styledText = hs.styledtext.new("")
   local currentLine = 1

   for i, entry in ipairs(self.entries) do
      local entryText
      local isSelectable = false

      if type(entry) == "string" then
         entryText = entry
      elseif type(entry) == "table" and entry.key and entry.label then
         local label = type(entry.label) == "function" and entry.label() or entry.label
         entryText = "[" .. entry.key .. "] " .. label
         isSelectable = true
      end

      if entryText then
         if i > 1 then
            styledText = styledText .. hs.styledtext.new("\n")
            currentLine = currentLine + 1
         end

         local lineStyle = {
            font = {name = "0xProto", size = 20}
         }
         if isSelectable and i == self.selectedIndex then
            lineStyle.color = highlightColor or catppuccin.getRgbColor("red") -- Use highlight color or default red
         else
            lineStyle.color = catppuccin.getRgbColor("text") -- Catppuccin text color
         end

         styledText = styledText .. hs.styledtext.new(entryText, lineStyle)
         currentLine = currentLine + 1
      end
   end

   styledText = styledText .. hs.styledtext.new("\n\nEsc/q: Exit | jk/↑↓: Navigate | Enter: Execute", {
      color = catppuccin.getRgbColor("subtext0"),
      font = {name = "0xProto", size = 20}
   })

   ---@diagnostic disable-next-line: return-type-mismatch
   return hs.alert.show(styledText, {
      fillColor = self.fillColor,
      textFont = "0xProto",
      -- textSize = 44,
      radius = 16,
      fadeInDuration = 0,
      fadeOutDuration = 0,
   }, "indefinite")
end

---Internal callback for when modal is entered
function Modal:_onEntered()
   self.alertId = self:_showModalAlert()
end

---Internal callback for when modal is exited
function Modal:_onExited()
   if self.alertId then
      hs.alert.closeSpecific(self.alertId, 0)
      self.alertId = nil
   end
end

---Bind keys for modal entries
function Modal:_bindKeys()
   for i, entry in ipairs(self.entries) do
      if type(entry) == "table" and entry.key and entry.callback then
         self.modal:bind("", entry.key, function()
            -- Set selection to this entry and execute with flash
            self.selectedIndex = i
            self:_executeSelected()
         end)
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

---Bind navigation keys (arrows and enter)
function Modal:_bindNavigationKeys()
   -- Up arrow - navigate up
   self.modal:bind("", "up", function()
      self:_updateSelection(-1)
   end)
   self.modal:bind("", "k", function()
      self:_updateSelection(-1)
   end)

   -- Down arrow - navigate down
   self.modal:bind("", "down", function()
      self:_updateSelection(1)
   end)
   self.modal:bind("", "j", function()
      self:_updateSelection(1)
   end)

   -- Enter - execute selected command
   self.modal:bind("", "return", function()
      self:_executeSelected()
   end)
end

---Find the first selectable entry index
---@return number The index of the first selectable entry
function Modal:_getFirstSelectableIndex()
   for i, entry in ipairs(self.entries) do
      if type(entry) == "table" and entry.key and entry.callback then
         return i
      end
   end
   return 1 -- fallback to first entry
end

---Get the next selectable index after current selection
---@param direction number 1 for down, -1 for up
---@return number The new selected index
function Modal:_getNextSelectableIndex(direction)
   local currentIndex = self.selectedIndex
   local totalEntries = #self.entries

   for i = 1, totalEntries do
      currentIndex = currentIndex + direction

      if currentIndex > totalEntries then
         currentIndex = 1
      elseif currentIndex < 1 then
         currentIndex = totalEntries
      end

      local entry = self.entries[currentIndex]
      if type(entry) == "table" and entry.key and entry.callback then
         return currentIndex
      end
   end

   return self.selectedIndex -- fallback to current if no other selectable found
end

---Update the selection and refresh the alert
---@param direction number 1 for down, -1 for up
function Modal:_updateSelection(direction)
   self.selectedIndex = self:_getNextSelectableIndex(direction)
   self:_refreshAlert()
end

---Refresh the alert display
function Modal:_refreshAlert()
   if self.alertId then
      hs.alert.closeSpecific(self.alertId, 0)
      self.alertId = self:_showModalAlert()
   end
end

---Execute the currently selected command with flash highlight
function Modal:_executeSelected()
   local selectedEntry = self.entries[self.selectedIndex]
   if type(selectedEntry) == "table" and selectedEntry.callback then
      -- Check if this is a submodal transition by looking for "modal" in the label
      local isSubmodal = selectedEntry.label and type(selectedEntry.label) == "string" and
                        (selectedEntry.label:lower():find("modal") or selectedEntry.label:lower():find(":"))

      if isSubmodal then
         -- For submodals, execute directly without flash
         selectedEntry.callback()
      else
         -- For regular actions, show green flash
         local catppuccin = require("common.external.catpuccin-frappe")

         -- Show green flash first
         if self.alertId then
            hs.alert.closeSpecific(self.alertId, 0)
         end
         self.alertId = self:_showModalAlert(catppuccin.getRgbColor("green"))

         -- Create a wrapper to prevent callback from exiting modal prematurely
         local originalExit = self.exit
         local exitCalled = false

         -- Temporarily override exit to prevent callback from closing modal
         self.exit = function()
            exitCalled = true
         end

         -- Execute the callback right away
         selectedEntry.callback()

         -- Restore original exit function
         self.exit = originalExit

         -- Auto-dismiss modal after flash duration
         hs.timer.doAfter(0.5, function()
            self:exit()
         end)
      end
   end
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
   self.selectedIndex = self:_getFirstSelectableIndex()
   -- If modal is currently shown, refresh the alert
   if self.alertId then
      self:_refreshAlert()
   end
end

---Get the underlying Hammerspoon modal for advanced usage
---@return hs.hotkey.modal
function Modal:getModal()
   return self.modal
end

return Modal
