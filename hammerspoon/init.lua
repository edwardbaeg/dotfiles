-- ~/.hammerspoon/init.lua

hyperkey = { "cmd", "ctrl" }

-- Hammerspoon notification
hs.hotkey.bind(hyperkey, "W", function()
  hs.alert.show("Hello World!")
end)

-- Native notification
hs.hotkey.bind(hyperkey, "W", function()
  hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end)

-- Hotkey to reload configuration
-- NOTE: hs.reload() destroys current Lua interpreter so anything after it is ignored
hs.hotkey.bind(hyperkey, "R", function()
  hs.reload()
end)

-- DOESNT WORK
-- Control media
-- hs.hotkey.bind(hyperkey, "/", function()
--   hs.eventtap.event.newSystemKeyEvent("MUTE", true)
-- end);

-- Automatically reload config on changes
-- NOTE: this does not work with symlinked files
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/dev/dotfiles/", function(files)
  doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end

  if doReload then
    hs.reload()
  end
end):start()
hs.alert.show("Config loaded")

-- Move window to right half
hs.hotkey.bind(hyperkey, "L", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screenMax = win:screen():frame()
  local needsResize = not (f.w == screenMax.w / 2 and f.h == screenMax.h)

  f.x = screenMax.x + (screenMax.w / 2)
  f.y = screenMax.y
  f.w = screenMax.w / 2
  f.h = screenMax.h
  win:setFrame(f, needsResize and 0 or 0.1)
end)

-- Move window to left half
hs.hotkey.bind(hyperkey, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screenMax = win:screen():frame()
  local needsResize = not (f.w == screenMax.w / 2 and f.h == screenMax.h)

  f.x = screenMax.x
  f.y = screenMax.y
  f.w = screenMax.w / 2
  f.h = screenMax.h
  win:setFrame(f, needsResize and 0 or 0.1)
end)

-- Move window to top half
hs.hotkey.bind(hyperkey, "K", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screenMax = win:screen():frame()
  local needsResize = not (f.w == screenMax.w and f.h == screenMax.h / 2)

  f.x = screenMax.x
  f.y = screenMax.y
  f.w = screenMax.w
  f.h = screenMax.h /2
  win:setFrame(f, needsResize and 0 or 0.1)
end)

-- Move window to bottom half
hs.hotkey.bind(hyperkey, "J", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screenMax = win:screen():frame()
  local needsResize = not (f.w == screenMax.w and f.h == screenMax.h / 2)

  f.x = screenMax.x
  f.y = screenMax.y + (screenMax.h / 2)
  f.w = screenMax.w
  f.h = screenMax.h /2
  win:setFrame(f, needsResize and 0 or 0.1)
end)

-- Resize and center windows ---------------------------------------------
--------------------------------------------------------------------------
function resizeAndCenter(frac)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screenMax = win:screen():frame()

  f.w = screenMax.w * frac
  f.h = screenMax.h * frac
  f.x = screenMax.x + (screenMax.w - f.w) / 2
  f.y = screenMax.y + (screenMax.h - f.h) / 2
  win:setFrame(f, 0)
end

-- Maximize window
hs.hotkey.bind(hyperkey, "M", function()
  resizeAndCenter(0.98)
end)

-- Resize window
hs.hotkey.bind(hyperkey, "N", function()
  resizeAndCenter(0.81)
end)

-- Resize window
hs.hotkey.bind(hyperkey, "B", function()
  resizeAndCenter(0.64)
end)

-- Resize window
hs.hotkey.bind(hyperkey, "V", function()
  resizeAndCenter(0.49)
end)

-- Arrow key remaps ------------------------------------------------------
--------------------------------------------------------------------------
function pressAndHoldKey(key)
  return function()
    hs.eventtap.keyStroke({}, key, 1000)
  end
end

function simpleKeyRemap(modMap, keyMap, sendKey)
  hs.hotkey.bind(modMap, keyMap, pressAndHoldKey(sendKey), nil, pressAndHoldKey(sendKey))
end

simpleKeyRemap({ "ctrl", "alt" }, "J", "DOWN")
simpleKeyRemap({ "ctrl", "alt" }, "K", "UP")
simpleKeyRemap({ "ctrl", "alt" }, "H", "LEFT")
simpleKeyRemap({ "ctrl", "alt" }, "L", "RIGHT")


-- Notes -----------------------------------------------------------------
--------------------------------------------------------------------------
--[[

To get the name of screens, use the following in the console
  hs.screen.allScreens()[1]:name()

--]]
