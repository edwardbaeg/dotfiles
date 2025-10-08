-- Reload Config ---------------------------------------------------------
--------------------------------------------------------------------------
local hyperkey = { "cmd", "ctrl" }
local toggleFeature = require("common/toggle_feature")

-- Pathwatcher for file changes
ReloadWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/dev/dotfiles/hammerspoon/", function(files)
   local doReload = false
   for _, file in pairs(files) do
      if file:sub(-4) == ".lua" then
         doReload = true
      end
   end

   if doReload then
      hs.alert("Autoreloading...")
      hs.timer.doAfter(0.1, function()
         hs.reload()
      end)
   end
end)

-- Create auto-reload toggle feature using the common abstraction
local autoreload = toggleFeature.new({
   name = "autoreload",
   abbreviation = "AR",
   settingsKey = "autoreloadEnabled",
   onEnable = function()
      ReloadWatcher:start()
      -- Force immediate reload when enabling
      hs.alert("Auto-reload enabled - reloading...")
      hs.timer.doAfter(0.1, function()
         hs.reload()
      end)
   end,
   onDisable = function()
      ReloadWatcher:stop()
      hs.alert("Auto-reload disabled")
   end,
   defaultState = true,
   registryName = "autoreload",
})

-- Manual reload function (separate from auto-reload)
local function reloadConfig()
   -- NOTE: hs.reload() destroys current Lua interpreter so anything after it is ignored
   hs.alert("Reloading config...")
   hs.timer.doAfter(0.1, function() -- put reload async so alert executes
      hs.reload()
   end)
end

-- Hotkey for manual reload
hs.hotkey.bind(hyperkey, "R", function()
   reloadConfig()
end)

-- URL event for manual reload
-- hammerspoon://reloadConfig
hs.urlevent.bind("reloadConfig", function()
   reloadConfig()
end)

-- Initialize auto-reload state from settings
local savedState = autoreload.isEnabled()
if savedState then
   ReloadWatcher:start()
else
   ReloadWatcher:stop()
end
