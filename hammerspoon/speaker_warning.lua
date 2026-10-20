-- Speaker warning -------------------------------------------------------
--------------------------------------------------------------------------
-- Notify after wake on work Wi-Fi where audio is going: whether the built-in
-- speakers are the output (and if they're muted), otherwise which device is,
-- so sound doesn't unexpectedly play out loud in the office
--
-- The SSID is kept in hs.settings instead of this repo since it's public:
--   hs -c 'hs.settings.set("workWifiSSID", "<ssid>")'
-- Manually run the check:
--   hs -c 'require("speaker_warning").check()'

local SSID_SETTINGS_KEY = "workWifiSSID"

-- Wi-Fi takes a few seconds to reassociate after wake, so poll for it
local WIFI_POLL_INTERVAL = 2
local WIFI_POLL_TIMEOUT = 10

local M = {}

local pollTimer

-- macOS only exposes the SSID to apps with Location Services permission
function M.isOnWorkWifi()
   local workSSID = hs.settings.get(SSID_SETTINGS_KEY)
   return workSSID ~= nil and hs.wifi.currentNetwork() == workSSID
end

function M.isOutputToSpeakers()
   local device = hs.audiodevice.defaultOutputDevice()
   return device ~= nil and device:transportType() == "Built-in"
end

local function notify(title, text)
   hs.notify
      .new({
         title = title,
         informativeText = text,
         withdrawAfter = 0, -- keep it in Notification Center
      })
      :send()
end

local function notifyAudioOutput()
   local device = hs.audiodevice.defaultOutputDevice()

   if M.isOutputToSpeakers() then
      local muteStatus = device:muted() and "muted" or "NOT muted"
      notify("Sound is on the speakers", "You're on work Wi-Fi and the built-in speakers are " .. muteStatus)
      return
   end

   local name = device and device:name() or "no output device"
   notify("Sound is not on the speakers", "Audio output: " .. name)
end

function M.check()
   if M.isOnWorkWifi() then
      notifyAudioOutput()
   end
end

local function checkAfterWake()
   if pollTimer then
      pollTimer:stop()
   end

   local elapsed = 0
   pollTimer = hs.timer.doEvery(WIFI_POLL_INTERVAL, function()
      elapsed = elapsed + WIFI_POLL_INTERVAL
      if M.isOnWorkWifi() then
         pollTimer:stop()
         -- TODO: Bluetooth devices (e.g. AirPods) can reconnect a few seconds after Wi-Fi,
         -- so this may falsely report the built-in speakers. If the output is the speakers,
         -- wait a grace period (~10s) and re-check before notifying; otherwise notify now
         notifyAudioOutput()
      elseif elapsed >= WIFI_POLL_TIMEOUT then
         pollTimer:stop()
      end
   end)
end

-- NOTE: do not create watcher as local variable or it will be garbage collected
SpeakerWarningWatcher = hs.caffeinate.watcher.new(function(event)
   if event == hs.caffeinate.watcher.systemDidWake then
      checkAfterWake()
   end
end)
SpeakerWarningWatcher:start()

-- Prompts for Location Services permission the first time, needed to read the SSID
if hs.location.authorizationStatus() == "undefined" then
   hs.location.get()
end

return M
