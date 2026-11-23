---@type Constants
local constants = require("common/constants")
local hyperkey, allkey = constants.hyperkey, constants.allkey
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

---@param path string
---@return hs.application?
local function findAppByPath(path)
   for _, app in ipairs(hs.application.runningApplications()) do
      -- path() throws for processes without a bundle
      local ok, appPath = pcall(app.path, app)
      if ok and appPath == path then
         return app
      end
   end
end

-- For apps that share a name and bundle ID with another running app, so only the path tells them apart
---@param modifiers table
---@param key string
---@param appName string
---@param path string bundle path of the running app
---@param openPath? string what to open when it isn't running (defaults to path)
local function assignAppPathHotKey(modifiers, key, appName, path, openPath)
   hs.hotkey.bind(modifiers, key, function()
      local app = findAppByPath(path)
      if app and #app:allWindows() > 0 then
         app:activate()
         return
      end
      if not app then
         hs.alert("Launching " .. appName)
      end
      -- `open` also reopens a window when the app is running with none
      hs.task.new("/usr/bin/open", nil, { "-a", openPath or path }):start()
   end)
end

local home = os.getenv("HOME")

-- { key, appName, modifiers?, path?, openPath? }; modifiers defaults to hyperkey
local mappings = {
   -- { "0", "Ghostty" },
   { "return", "Ghostty" },
   -- { "'", "Ghostty" },
   -- { "8", "Slack" },
   -- Both Claude profiles run as "Claude" with the same bundle ID
   { "P", "Claude", path = "/Applications/Claude.app" },
   {
      "P",
      "Claude Personal",
      allkey,
      path = home .. "/Library/Application Support/claude-multiprofile/apps/Claude personal.app",
      -- claude-multiprofile's launcher starts that copy on the personal profile
      openPath = home .. "/Applications/Claude Personal.app",
   },
   -- { "P", "Perplexity" },
}

function Main()
   for _, mapping in ipairs(mappings) do
      local key, appName, modifiers = mapping[1], mapping[2], mapping[3] or hyperkey
      if mapping.path then
         assignAppPathHotKey(modifiers, key, appName, mapping.path, mapping.openPath)
      else
         assignAppHotKey(modifiers, key, appName)
      end
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
