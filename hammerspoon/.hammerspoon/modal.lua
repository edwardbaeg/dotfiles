local appLauncher = require("application_launcher")
local togglePersonalOverride = appLauncher.togglePersonalOverride
local isPersonalOverride = appLauncher.isPersonalOverride
local caffeine = require("caffeine")

local modal = hs.hotkey.modal.new({ "cmd", "ctrl" }, "d")
local id

local function getToggleLabel(value, label)
   return (value and "●" or "○") .. " Toggle " .. label .. " " .. (value and "off" or "on") .. ""
end

local modalEntries = {
   {
      key = "A",
      label = "Personal AI Preset",
      callback = function()
         hs.urlevent.openURL("raycast://extensions/raycast/raycast-ai/ai-chat?context=%7B%22preset%22:%2264DC923F-8179-4BA9-A27E-B8F2A2229FE1%22%7D")
         modal:exit()
      end,
   },
   {
      key = "L",
      label = "Linear",
      callback = function()
         hs.application.launchOrFocus("Linear")
         modal:exit()
      end,
   },
   -- {
   --    key = "S",
   --    label = "Raycast snippets",
   --    callback = function()
   --       hs.urlevent.openURL("raycast://extensions/raycast/snippets/search-snippets")
   --       modal:exit()
   --    end,
   -- },
   {
      key = "T",
      label = "Telegram",
      callback = function()
         hs.application.launchOrFocus("Telegram")
         modal:exit()
      end,
   },
   {
      key = "U",
      label = "Cursor",
      callback = function()
         hs.application.launchOrFocus("Cursor")
         modal:exit()
      end,
   },
   {
      key = "Z",
      label = "Zen",
      callback = function()
         hs.application.launchOrFocus("zen")
         modal:exit()
      end,
   },
   {
      key = "C",
      label = function()
         return getToggleLabel(hs.caffeinate.get("displayIdle"), "C")
      end,
      callback = function()
         caffeine.toggle()
         modal:exit()
      end,
   },
   {
      key = "P",
      label = function()
         return getToggleLabel(isPersonalOverride(), "Arc Personal")
      end,
      callback = function()
         togglePersonalOverride()
         modal:exit()
      end,
   },
}

function modal:entered()
   local modalContent = table.concat(
      ---@diagnostic disable-next-line: param-type-mismatch it's correct
      hs.fnutils.map(modalEntries, function(entry)
         local label = type(entry.label) == "function" and entry.label() or entry.label
         return entry.key .. ": " .. label
      end),
      "\n"
   )
   modalContent = modalContent .. "\n\nEsc: Exit"
   id = hs.alert.show(modalContent, "indefinite")
end

function modal:exited()
   hs.alert.closeSpecific(id, 0.1)
end

-- Create bindings for each entry
for _, entry in ipairs(modalEntries) do
   modal:bind("", entry.key, entry.callback)
end

-- TODO?: create bindings for all other key presses to exit the modal
-- https://github.com/Hammerspoon/hammerspoon/issues/848#issuecomment-930456782

modal:bind("", "escape", function()
   modal:exit()
end)
