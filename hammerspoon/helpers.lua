local module = {}

-- FIXME: this doesn't seem to work with window-management, "cannot get focused window"
-- openRaycastDeeplink("raycast://extensions/raycast/window-management/move-right")
-- openRaycastDeeplink("raycast://extensions/raycast/raycast/confetti")
function module.openDeeplink(deeplink)
    hs.execute("open '" .. deeplink .. "'")
end

return module
