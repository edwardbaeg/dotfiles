-- usage: hammerspoon://alert?title=Server%20restarted!!&duration=5
hs.urlevent.bind("alert", function(_, params)
   local title = params.title or "Alert"
   local duration = tonumber(params.duration) or 2
   hs.alert.show(title, {
      strokeColor = { white = 1, alpha = 0.5 }, -- Optional border color
      fillColor = require('common.constants').colors.purple,
      textColor = { white = 1 },
      textFont = "Helvetica",
      radius = 8,
   }, duration)
end)

-- usage: hammerspoon://alert-claudecode?title=ClaudeCode%20alert!&duration=5
-- TODO: abstract canvas logic to function
hs.urlevent.bind("alert-claudecode", function(_, params)
   local title = params.title or "Alert"
   local duration = tonumber(params.duration) or 5

   local screen = hs.screen.mainScreen():fullFrame()
   local screenPadding = 48
   local width = 300
   local height = 60
   local textPadding = 10
   local textOffsetY = 15

   local canvas = hs.canvas.new({
      x = screen.w - width - screenPadding,
      y = screenPadding,
      w = width,
      h = height,
   })

   if canvas == nil then
      return
   end

   canvas[1] = {
      type = "rectangle",
      action = "fill",
      fillColor = require('common.constants').colors.navy,
      strokeColor = { white = 1, alpha = 0.5 },
      strokeWidth = 1,
      roundedRectRadii = { xRadius = 8, yRadius = 8 },
   }

   canvas[2] = {
      type = "text",
      text = title,
      textColor = { white = 1 },
      textFont = "Helvetica",
      textSize = 20,
      textAlignment = "center",
      frame = {
         x = textPadding,
         y = textOffsetY,
         w = width - (textPadding * 2),
         h = height - (textOffsetY * 2),
      },
   }

   canvas:show()

   hs.timer.doAfter(duration, function()
      canvas:delete()
   end)
end)

hs.urlevent.bind("alertRaycast", function()
   local raycastUrl =
      "raycast://extensions/maxnyby/raycast-notification/index?arguments=%7B%22title%22%3A%22Server%20restarted%21%22%2C%22message%22%3A%22%22%2C%22type%22%3A%22%22%7D"
   hs.execute("open -g '" .. raycastUrl .. "'")
end)
