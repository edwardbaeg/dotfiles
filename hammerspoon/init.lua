-- ~/.hammerspoon/init.lua

hyperkey = { "cmd", "ctrl" }

-- Auto reload config
---------------------
-- Automatically reload config on file changes
-- NOTE: this does not work with symlinked files, point to source
-- TODO: refactor to check for symlinks and to reload linked file
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

-- Hotkey to reload configuration
-- NOTE: hs.reload() destroys current Lua interpreter so anything after it is ignored
hs.hotkey.bind(hyperkey, "R", function()
  hs.reload()
end)


-- Helpers ---------------------------------------------------------------
--------------------------------------------------------------------------
function within(a, b, margin)
  print (math.abs(a - b))
  return math.abs(a - b) <= margin
end

-- Windows grids ---------------------------------------------------------
--------------------------------------------------------------------------
function moveAndResizeFocused(callback)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screenMax = win:screen():frame()
  local prevW = f.w
  local prevH = f.h

  callback(f, screenMax)
  local needsResize = not (within(f.h, prevH, 1) and within(f.w, prevW, 1))
  win:setFrame(f, needsResize and 0 or 0.1)
end

-- Right half
hs.hotkey.bind(hyperkey, "L", function()
  moveAndResizeFocused(function (frame, screen)
    frame.x = screen.x + (screen.w / 2)
    frame.y = screen.y
    frame.w = screen.w / 2
    frame.h = screen.h
  end)
end)

-- Left half
hs.hotkey.bind(hyperkey, "H", function()
  moveAndResizeFocused(function (frame, screen)
    frame.x = screen.x
    frame.y = screen.y
    frame.w = screen.w / 2
    frame.h = screen.h
  end)
end)

-- Top half
hs.hotkey.bind(hyperkey, "K", function()
  moveAndResizeFocused(function (frame, screen)
    frame.x = screen.x
    frame.y = screen.y
    frame.w = screen.w
    frame.h = screen.h / 2
  end)
end)

-- Bottom half
hs.hotkey.bind(hyperkey, "J", function()
  moveAndResizeFocused(function (frame, screen)
    frame.x = screen.x
    frame.y = screen.y + (screen.h / 2)
    frame.w = screen.w
    frame.h = screen.h / 2
  end)
end)

quadKey = { "cmd", "ctrl", "shift" }

-- Top left quadrant
hs.hotkey.bind(quadKey, "J", function()
  moveAndResizeFocused(function (frame, screen)
    frame.x = screen.x
    frame.y = screen.y
    frame.w = screen.w / 2
    frame.h = screen.h / 2
  end)
end)

-- Top right quadrant
hs.hotkey.bind(quadKey, "K", function()
  moveAndResizeFocused(function (frame, screen)
    frame.x = screen.x + (screen.w / 2)
    frame.y = screen.y
    frame.w = screen.w / 2
    frame.h = screen.h / 2
  end)
end)

-- Bottom left quadrant
hs.hotkey.bind(quadKey, "N", function()
  moveAndResizeFocused(function (frame, screen)
    frame.x = screen.x
    frame.y = screen.y + (screen.h / 2)
    frame.w = screen.w / 2
    frame.h = screen.h / 2
  end)
end)

-- Bottom right quadrant
hs.hotkey.bind(quadKey, "M", function()
  moveAndResizeFocused(function (frame, screen)
    frame.x = screen.x + (screen.w / 2)
    frame.y = screen.y + (screen.h / 2)
    frame.w = screen.w / 2
    frame.h = screen.h / 2
  end)
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

--  Media remaps ---------------------------------------------------------
--------------------------------------------------------------------------

-- DOESNT WORK
-- Mute
-- hs.hotkey.bind(hyperkey, "/", function()
--   hs.eventtap.event.newSystemKeyEvent("MUTE", true)
-- end);

-- Notes -----------------------------------------------------------------
--------------------------------------------------------------------------
--[[

To get the name of screens, use the following in the console
  hs.screen.allScreens()[1]:name()

--]]

-- Native notification example
-- hs.hotkey.bind(hyperkey, "W", function()
--   hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
-- end)

