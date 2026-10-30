---@type Constants
local constants = require("common/constants")
local hyperkey, allkey = constants.hyperkey, constants.allkey

local M = {}

local BROWSER_KEY = ";"
-- local BROWSER_KEY = "9"

local PERSONAL_PROFILE = "2"
local WORK_PROFILE = "4"
local PROFILE_5 = "5"

---@type fun(modifiers: table, key: string, appName: string, callback?: function)
local assignAppHotKey

---@param profileIndex string
local function setArcProfile(profileIndex)
   hs.eventtap.keyStroke({ "ctrl" }, profileIndex)
   hs.timer.doAfter(0.05, function()
      hs.eventtap.keyStroke({ "ctrl" }, profileIndex)
   end)
   -- hs.timer.doAfter(0.1, function()
   --    hs.eventtap.keyStroke({ "ctrl" }, profileIndex)
   -- end)
end

---@alias Browser "zen"|"arcPersonal"|"arcWork"|"arc5"

---@type table<Browser, string>
local BROWSER_LABELS = {
   zen = "Zen",
   arcPersonal = "Arc Personal",
   arcWork = "Arc Work",
   arc5 = "Arc #5",
}
local BROWSER_ORDER = { "zen", "arcPersonal", "arcWork", "arc5" }

-- Stored with the PID so the override survives config reloads but not a Hammerspoon restart
local SETTINGS_KEY = "browserOverride"

---@return Browser|nil
local function getOverride()
   local saved = hs.settings.get(SETTINGS_KEY)
   if type(saved) == "table" and saved.pid == hs.processInfo.processID and BROWSER_LABELS[saved.browser] then
      return saved.browser
   end
   return nil
end

---@return Browser
function M.getBrowser()
   return getOverride() or (constants.isPersonal and "zen" or "arcWork")
end

local menubar = hs.menubar.new()

local function updateMenubar()
   if not menubar then
      return
   end
   local override = getOverride()
   local current = M.getBrowser()
   menubar:setTitle("BR:" .. BROWSER_LABELS[current] .. (override and "*" or ""))

   local menu = {
      {
         title = "Default",
         checked = override == nil,
         fn = function()
            M.setBrowser(nil)
         end,
      },
   }
   for _, browser in ipairs(BROWSER_ORDER) do
      table.insert(menu, {
         title = BROWSER_LABELS[browser],
         checked = override == browser,
         fn = function()
            M.setBrowser(browser)
         end,
      })
   end
   menubar:setMenu(menu)
end

local function setupArcHotkeys()
   -- Changing the browser can fire before setup() has received the hotkey binder
   if not assignAppHotKey then
      return
   end

   -- Clear existing Arc hotkeys
   hs.hotkey.disableAll(hyperkey, BROWSER_KEY)
   hs.hotkey.disableAll(allkey, BROWSER_KEY)

   local setPersonal = function()
      setArcProfile(PERSONAL_PROFILE)
   end
   local setWork = function()
      setArcProfile(WORK_PROFILE)
   end
   local setProfile5 = function()
      setArcProfile(PROFILE_5)
   end

   local browser = M.getBrowser()
   if browser == "zen" then
      assignAppHotKey(hyperkey, BROWSER_KEY, "Zen")
      assignAppHotKey(allkey, BROWSER_KEY, "Zen")
   elseif browser == "arc5" then
      assignAppHotKey(hyperkey, BROWSER_KEY, "Arc", setProfile5)
      assignAppHotKey(allkey, BROWSER_KEY, "Arc", setWork)
   elseif browser == "arcPersonal" then
      assignAppHotKey(hyperkey, BROWSER_KEY, "Arc", setPersonal)
      assignAppHotKey(allkey, BROWSER_KEY, "Arc", setWork)
   else
      assignAppHotKey(hyperkey, BROWSER_KEY, "Arc", setWork)
      assignAppHotKey(allkey, BROWSER_KEY, "Arc", setPersonal)
   end
end

---@param browser Browser|nil nil falls back to the machine default
function M.setBrowser(browser)
   if browser == nil then
      hs.settings.clear(SETTINGS_KEY)
   else
      hs.settings.set(SETTINGS_KEY, { browser = browser, pid = hs.processInfo.processID })
   end
   updateMenubar()
   setupArcHotkeys()
   hs.alert("Browser: " .. BROWSER_LABELS[M.getBrowser()] .. (browser == nil and " (default)" or ""))
end

-- Steps through default -> each browser -> default
function M.cycleBrowser()
   local override = getOverride()
   if override == nil then
      M.setBrowser(BROWSER_ORDER[1])
      return
   end
   for i, browser in ipairs(BROWSER_ORDER) do
      if browser == override then
         M.setBrowser(BROWSER_ORDER[i + 1])
         return
      end
   end
end

---@param browser Browser
---@return string
function M.getBrowserLabel(browser)
   return BROWSER_LABELS[browser]
end

-- Passed in rather than required to avoid a circular require with application_launcher
---@param hotKeyBinder fun(modifiers: table, key: string, appName: string, callback?: function)
function M.setup(hotKeyBinder)
   assignAppHotKey = hotKeyBinder

   updateMenubar()
   setupArcHotkeys()

   -- usage: hammerspoon://browser?name=zen|arcPersonal|arcWork|arc5|default
   hs.urlevent.bind("browser", function(_name, params)
      local name = params and params.name
      if name == "default" then
         M.setBrowser(nil)
      elseif BROWSER_LABELS[name] then
         M.setBrowser(name)
      else
         hs.alert("Unknown browser: " .. tostring(name))
      end
   end)

   -- usage: hammerspoon://arcPersonal
   hs.urlevent.bind("arcPersonal", function()
      local success = hs.application.launchOrFocus("Arc")
      if success then
         setArcProfile(PERSONAL_PROFILE)
      end
   end)

   -- usage: hammerspoon://arcWork
   hs.urlevent.bind("arcWork", function()
      local success = hs.application.launchOrFocus("Arc")
      if success then
         setArcProfile(WORK_PROFILE)
      end
   end)

   hs.urlevent.bind("arc", function(_name, params)
      local success = hs.application.launchOrFocus("Arc")
      if success and params.profile ~= nil and params.profile ~= "" then
         setArcProfile(params.profile)
      end
   end)
end

return M
