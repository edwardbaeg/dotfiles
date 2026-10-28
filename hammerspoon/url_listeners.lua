-- usage: hammerspoon://alert?title=Server%20restarted!!&duration=5
hs.urlevent.bind("alert", function(_, params)
   local title = params.title or "Alert"
   local duration = tonumber(params.duration) or 2
   hs.alert.show(title, {
      strokeColor = { white = 1, alpha = 0.5 }, -- Optional border color
      fillColor = require("common.constants").colors.purple,
      textColor = { white = 1 },
      textFont = "Helvetica",
      radius = 8,
   }, duration)
end)

hs.urlevent.bind("alertRaycast", function()
   local raycastUrl =
      "raycast://extensions/maxnyby/raycast-notification/index?arguments=%7B%22title%22%3A%22Server%20restarted%21%22%2C%22message%22%3A%22%22%2C%22type%22%3A%22%22%7D"
   hs.execute("open -g '" .. raycastUrl .. "'")
end)
