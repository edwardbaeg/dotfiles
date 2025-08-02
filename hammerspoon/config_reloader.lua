-- Reload Config ---------------------------------------------------------
--------------------------------------------------------------------------
local hyperkey = { "cmd", "ctrl" }

-- Automatically reload config on file changes
ReloadWatcher = hs.pathwatcher
   .new(os.getenv("HOME") .. "/dev/dotfiles/hammerspoon/", function(files)
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
   :start()

function reloadConfig()
   -- NOTE: hs.reload() destroys current Lua interpreter so anything after it is ignored
   hs.alert("Reloading config...")
   hs.timer.doAfter(0.1, function() -- put reload async so alert executes
      hs.reload()
   end)
end

hs.hotkey.bind(hyperkey, "R", function()
   reloadConfig()
end)

-- hammerspoon://reloadConfig
hs.urlevent.bind("reloadConfig", function()
   reloadConfig()
end)
