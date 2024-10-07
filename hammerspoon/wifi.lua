-- Wifi switcher ---------------------------------------------------------
--------------------------------------------------------------------------
local homeSSID = "!wifi"
local lastSSID = hs.wifi.currentNetwork()

function _G.ssidChangedCallback()
   local newSSID = hs.wifi.currentNetwork()

   if newSSID == homeSSID and lastSSID ~= homeSSID then
      -- We just joined our home WiFi network
      hs.audiodevice.defaultOutputDevice():setVolume(25)
      hs.alert("Home network: setting volume.")
   elseif newSSID ~= homeSSID and lastSSID == homeSSID then
      -- We just departed our home WiFi network
      hs.alert("External network: muting volume.")
      hs.audiodevice.defaultOutputDevice():setVolume(0)
   end

   lastSSID = newSSID
end

-- WifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
-- WifiWatcher:start()

