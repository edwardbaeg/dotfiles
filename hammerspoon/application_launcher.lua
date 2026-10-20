---@type Constants
local constants = require("common/constants")
local hyperkey = constants.hyperkey
local arc = require("utils-arc")

local M = {}

-- TODO?: if the application is already focused, then hide it
---@param modifiers table
---@param key string
---@param appName string
---@param callback? function
local function assignAppHotKey(modifiers, key, appName, callback)
   hs.hotkey.bind(modifiers, key, function()
      local targetApp = hs.application.find(appName)
      print("targetApp", targetApp)
      -- NOTE: this doesnt always work for some applications
      if targetApp == nil then
         hs.alert("Launching " .. appName)
      end
      local success = hs.application.launchOrFocus(appName)
      callback = callback or function() end
      if success then
         callback()
      end
   end)
end

local mappings = {
   -- { "0", "Ghostty" },
   { "return", "Ghostty" },
   -- { "'", "Ghostty" },
   -- { "8", "Slack" },
   { "P", "Claude" },
   -- { "P", "Perplexity" },
}

function Main()
   for _, pair in pairs(mappings) do
      assignAppHotKey(hyperkey, pair[1], pair[2])
   end

   arc.setup(assignAppHotKey)

   hs.hotkey.bind(hyperkey, "0", function()
      hs.alert("Deprecated. Use <enter>")
   end)

   hs.hotkey.bind(hyperkey, "9", function()
      hs.alert("Deprecated. Use ;")
   end)

   -- replaced with iterm2 hotkey window
   -- hs.hotkey.bind(hyperkey, "w", function()
   --    -- NOTE: need to use full paths
   --    -- TODO: consider auto attaching to a tmux session
   --    hs.task
   --       .new("/bin/bash", nil, { "-c", "cd $HOME/dev/dotfiles && /opt/homebrew/bin/kitten quick-access-terminal" })
   --       :start()
   -- end)
end

Main()

return M
