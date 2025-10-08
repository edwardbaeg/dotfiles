---@class Modal
---@field modal hs.hotkey.modal The Hammerspoon modal instance
---@field canvas hs.canvas? The current canvas for cleanup
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
---@field entries ModalEntry[] | fun(modal: Modal): ModalEntry[] The entries to display in the modal (can be an array or a function that receives the modal instance)
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

   self.canvas = nil
   -- If entries is a function, call it with the modal instance
   self.entries = type(config.entries) == "function" and config.entries(self) or config.entries
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

---Show the modal alert with formatted entries using custom canvas positioning
---@param highlightColor? table Optional color to use for selected item highlighting
---@param fadeOutDuration? number Optional fade out duration (defaults to 0)
---@return hs.canvas canvas The canvas object for closing later
function Modal:_showModalAlert(highlightColor, fadeOutDuration)
   local catppuccin = require("common.external.catpuccin-frappe")
   local styledText = hs.styledtext.new("")

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
         end

         local lineStyle = {
            font = { name = "0xProto", size = 20 },
         }
         if isSelectable and i == self.selectedIndex then
            lineStyle.color = highlightColor or catppuccin.getRgbColor("red")
         else
            lineStyle.color = catppuccin.getRgbColor("text")
         end

         styledText = styledText .. hs.styledtext.new(entryText, lineStyle)
      end
   end

   styledText = styledText
      .. hs.styledtext.new("\n\nEsc/q: Exit | jk/↑↓: Navigate | Enter: Execute", {
         color = catppuccin.getRgbColor("subtext0"),
         font = { name = "0xProto", size = 16 },
      })

   -- Calculate dynamic height based on content
   local lineHeight = 24 -- Approximate line height for font size 20
   local padding = 40 -- Top and bottom padding
   local footerHeight = 48 -- Height for footer text (2 lines)

   -- Count content lines
   local contentLines = 0
   for _i, entry in ipairs(self.entries) do
      if type(entry) == "string" or (type(entry) == "table" and entry.key and entry.label) then
         contentLines = contentLines + 1
      end
   end

   local modalHeight = (contentLines * lineHeight) + footerHeight + padding
   local modalWidth = 600

   -- Calculate screen dimensions and position at top third
   local screen = hs.screen.mainScreen()
   local screenFrame = screen:frame()
   local x = (screenFrame.w - modalWidth) / 2 -- Center horizontally
   local y = screenFrame.h / 2 - modalHeight / 2 -- Center vertically

   -- Create canvas for custom positioning
   local canvas = hs.canvas.new({
      x = x,
      y = y,
      w = modalWidth,
      h = modalHeight,
   })

   -- Add background rectangle
   canvas:appendElements({
      type = "rectangle",
      action = "fill",
      fillColor = self.fillColor,
      roundedRectRadii = { xRadius = 16, yRadius = 16 },
   })

   -- Add text
   canvas:appendElements({
      type = "text",
      text = styledText,
      textAlignment = "left",
      frame = { x = 20, y = 20, w = modalWidth - 40, h = modalHeight - 40 },
   })

   canvas:show(fadeOutDuration or 0)
   return canvas
end

---Internal callback for when modal is entered
function Modal:_onEntered()
   self.canvas = self:_showModalAlert()
end

---Internal callback for when modal is exited
function Modal:_onExited()
   if self.canvas then
      self.canvas:hide(0.2) -- Fade out when exiting
      self.canvas = nil
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

   for _i = 1, totalEntries do
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
   if self.canvas then
      self.canvas:hide(0)
      self.canvas = self:_showModalAlert()
   end
end

---Update canvas highlight color without recreating
---@param highlightColor table Color to use for selected item highlighting
function Modal:_updateCanvasHighlight(highlightColor)
   if not self.canvas then
      return
   end

   local catppuccin = require("common.external.catpuccin-frappe")
   local styledText = hs.styledtext.new("")

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
         end

         local lineStyle = {
            font = { name = "0xProto", size = 20 },
         }
         if isSelectable and i == self.selectedIndex then
            lineStyle.color = highlightColor
         else
            lineStyle.color = catppuccin.getRgbColor("text")
         end

         styledText = styledText .. hs.styledtext.new(entryText, lineStyle)
      end
   end

   styledText = styledText
      .. hs.styledtext.new("\n\nEsc/q: Exit | jk/↑↓: Navigate | Enter: Execute", {
         color = catppuccin.getRgbColor("subtext0"),
         font = { name = "0xProto", size = 16 },
      })

   -- Update the text element (index 2, after background rectangle)
   self.canvas[2] = {
      type = "text",
      text = styledText,
      textAlignment = "left",
      frame = { x = 20, y = 20, w = 560, h = self.canvas:frame().h - 40 },
   }
end

---Execute the currently selected command with flash highlight
function Modal:_executeSelected()
   local selectedEntry = self.entries[self.selectedIndex]
   if type(selectedEntry) == "table" and selectedEntry.callback then
      -- Check if this is a submodal transition by looking for "modal" in the label
      local isSubmodal = selectedEntry.label
         and type(selectedEntry.label) == "string"
         and (selectedEntry.label:lower():find("modal") or selectedEntry.label:lower():find(":"))

      if isSubmodal then
         -- For submodals, show fade out effect and execute
         if self.canvas then
            self.canvas:hide(0.2) -- Fade out over 0.2 seconds
         end
         -- Execute the callback right away (modal transition)
         selectedEntry.callback()
      else
         -- For regular actions, show green flash with fade out
         local catppuccin = require("common.external.catpuccin-frappe")

         -- Update canvas to show green highlight
         self:_updateCanvasHighlight(catppuccin.getRgbColor("green"))

         -- Create a wrapper to prevent callback from exiting modal prematurely
         local originalExit = self.exit
         local exitCalled = false

         -- Temporarily override exit to prevent callback from closing modal
         ---@diagnostic disable-next-line: duplicate-set-field
         self.exit = function()
            exitCalled = true
         end

         -- Execute the callback right away
         selectedEntry.callback()

         -- Restore original exit function
         self.exit = originalExit

         -- Auto-dismiss modal after flash duration with fade
         hs.timer.doAfter(0.2, function()
            if self.canvas then
               self.canvas:hide(0.2) -- Fade out
               self.canvas = nil
            end
            self.modal:exit()
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
   if self.canvas then
      self:_refreshAlert()
   end
end

---Get the underlying Hammerspoon modal for advanced usage
---@return hs.hotkey.modal
function Modal:getModal()
   return self.modal
end

return Modal
