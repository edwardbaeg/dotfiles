-- Reload Config ---------------------------------------------------------
--------------------------------------------------------------------------
local hyperkey = { "cmd", "ctrl" }

-- Settings key for persisting auto-reload state
local AUTO_RELOAD_STATE_KEY = "autoReloadEnabled"

-- Create menubar item for auto-reload toggle
local autoReloadMenuBar = hs.menubar.new()

-- Auto-reload state management
local function isAutoReloadEnabled()
   local state = hs.settings.get(AUTO_RELOAD_STATE_KEY)
   return state == nil and true or state -- default to true if not set
end

local function setAutoReloadDisplay(state)
   if autoReloadMenuBar then
      if state then
         autoReloadMenuBar:setTitle("AR") -- for Auto-Reload
      else
         autoReloadMenuBar:setTitle("✕R") -- for disabled
      end
      -- Save state to settings
      hs.settings.set(AUTO_RELOAD_STATE_KEY, state)
   end
end

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

local function reloadConfig()
   -- NOTE: hs.reload() destroys current Lua interpreter so anything after it is ignored
   hs.alert("Reloading config...")
   hs.timer.doAfter(0.1, function() -- put reload async so alert executes
      hs.reload()
   end)
end

local function enableAutoReload()
   ReloadWatcher:start()
   setAutoReloadDisplay(true)
   -- Force immediate reload when enabling
   hs.alert("Auto-reload enabled - reloading...")
   hs.timer.doAfter(0.1, function()
      hs.reload()
   end)
end

local function disableAutoReload()
   ReloadWatcher:stop()
   setAutoReloadDisplay(false)
   hs.alert("Auto-reload disabled")
end

local function toggleAutoReload()
   if isAutoReloadEnabled() then
      disableAutoReload()
   else
      enableAutoReload()
   end
end

-- TODO: create a submodal for this
hs.hotkey.bind(hyperkey, "R", function()
   reloadConfig()
end)

-- hammerspoon://reloadConfig
hs.urlevent.bind("reloadConfig", function()
   reloadConfig()
end)

-- URL event bindings for auto-reload control
-- TODO: abstract all of these
hs.urlevent.bind("toggleAutoReload", function()
   toggleAutoReload()
end)

hs.urlevent.bind("enableAutoReload", function()
   enableAutoReload()
end)

hs.urlevent.bind("disableAutoReload", function()
   disableAutoReload()
end)

-- Initialize menubar and auto-reload state
-- TODO: abstract all of these
if autoReloadMenuBar then
   autoReloadMenuBar:setClickCallback(toggleAutoReload)

   -- Initialize state from settings
   local savedState = isAutoReloadEnabled()
   if savedState then
      ReloadWatcher:start()
      setAutoReloadDisplay(true)
   else
      ReloadWatcher:stop()
      setAutoReloadDisplay(false)
   end
end
