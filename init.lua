-- ~/.hammerspoon/init.lua

-- Hammerspoon notification
hs.hotkey.bind({"cmd", "ctrl"}, "W", function()
  hs.alert.show("Hello World!")
end)

-- Native notification
hs.hotkey.bind({"cmd", "ctrl"}, "W", function()
  hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end)

-- Hotkey to reload configuration
-- NOTE: hs.reload() destroys current Lua interpreter so anything after it is
--  ignored
hs.hotkey.bind({"cmd", "ctrl"}, "R", function()
  hs.reload()
end)
hs.alert.show("Config loaded")

-- Move window over
-- hs.hotkey.bind({"cmd", "ctrl"}, "B", function()
--   local win = hs.window.focusedWindow()
--   local f = win:frame()

--   f.x = f.x - 100
--   win:setFrame(f)
-- end)

-- Move window to right half
hs.hotkey.bind({"cmd", "ctrl"}, "L", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screenMax = win:screen():frame()

  f.x = screenMax.x + (screenMax.w / 2)
  f.y = screenMax.y
  f.w = screenMax.w / 2
  f.h = screenMax.h
  win:setFrame(f)
end)

-- Move window to left half
hs.hotkey.bind({"cmd", "ctrl"}, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screenMax = win:screen():frame()

  f.x = screenMax.x
  f.y = screenMax.y
  f.w = screenMax.w / 2
  f.h = screenMax.h
  win:setFrame(f)
end)

-- Move window to top half
hs.hotkey.bind({"cmd", "ctrl"}, "K", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screenMax = win:screen():frame()

  f.x = screenMax.x
  f.y = screenMax.y
  f.w = screenMax.w
  f.h = screenMax.h /2
  win:setFrame(f)
end)

-- Move window to bottom half
hs.hotkey.bind({"cmd", "ctrl"}, "J", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screenMax = win:screen():frame()

  f.x = screenMax.x
  f.y = screenMax.y + (screenMax.h / 2)
  f.w = screenMax.w
  f.h = screenMax.h /2
  win:setFrame(f)
end)

--[[ NOTES

To get the name of screens, use the following in the console
  hs.screen.allScreens()[1]:name()

--]]
