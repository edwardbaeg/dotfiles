local altCtrl = { "alt", "ctrl" }

hs.window.highlight.ui.overlayColor = { 0, 0, 0, 0.01 } -- overlay color
hs.window.highlight.ui.overlay = false
hs.window.highlight.ui.frameWidth = 8 -- draw a frame around the focused window in overlay mode; 0 to disable
hs.window.highlight.start()

hs.window.highlight.ui.overlay = true

-- Toggle window highlighting

hs.hotkey.bind(altCtrl, "H", function()
   if hs.window.highlight.ui.overlay then
      hs.alert("Disabling window highlighting")
   else
      hs.alert("Enabling window highlighting")
   end
   hs.window.highlight.ui.overlay = not hs.window.highlight.ui.overlay
end)

-- Focused window listener for highlighting
hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(window)
   local isFullScreen = window:isFullScreen()

   -- Disable when focusing full screen app
   if isFullScreen and hs.window.highlight.ui.overlay then
      hs.window.highlight.ui.overlay = false
   end

   -- force highlighting to fix some bugs when focusing windows in a different screen
   if not isFullScreen and hs.window.highlight.ui.overlay then
      hs.timer.doAfter(0.1, function()
         hs.window.highlight.ui.overlay = true
      end)
   end

   -- Enable when leaving full screen app focus
   if not isFullScreen and not hs.window.highlight.ui.overlay then
      hs.window.highlight.ui.overlay = true
   end
end)

ApplicationWatcher = hs.application.watcher
   .new(function(appName, eventType, _appObject)
      -- When focusing an application that has no windows
      if eventType == hs.application.watcher.activated then
         -- hs.alert("[" .. appName .. "]" .. " focused")
         local win = hs.window.focusedWindow()
         if win == nil then
            hs.alert("[" .. appName .. "]" .. " has no windows")
         end
      end

      -- highlight when unhiding an application
      if eventType == hs.application.watcher.unhidden then
         hs.window.highlight.ui.overlay = true
      end
   end)
   :start()

-- Toggle on fullscreen toggle
hs.window.filter.default:subscribe(hs.window.filter.windowFullscreened, function(window, _appName)
   hs.window.highlight.ui.overlay = false
end)
hs.window.filter.default:subscribe(hs.window.filter.windowUnfullscreened, function(window, _appName)
   hs.window.highlight.ui.overlay = true
end)

hs.window.filter.default:subscribe(hs.window.filter.hasNoWindows, function(window, appName)
   -- hs.alert("hasNoWindows")
   -- hs.window.highlight.ui.overlay = false
end)

