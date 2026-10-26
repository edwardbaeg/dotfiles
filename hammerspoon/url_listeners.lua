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
      x = screen.x + (screen.w - width) / 2,
      y = screenPadding,
      w = width,
      h = height,
   })

   if canvas == nil then
      return
   end

   local borderWidth = 2
   canvas[1] = {
      type = "rectangle",
      action = "strokeAndFill",
      fillColor = require("common.external.catpuccin-frappe").getRgbColor("surface2", 1),
      strokeColor = { white = 1, alpha = 0.5 },
      strokeWidth = borderWidth,
      roundedRectRadii = { xRadius = 8, yRadius = 8 },
      -- strokes straddle the path, so inset or the canvas edge clips half the border
      frame = {
         x = borderWidth / 2,
         y = borderWidth / 2,
         w = width - borderWidth,
         h = height - borderWidth,
      },
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

   local timer
   local dismissed = false
   local function dismiss()
      -- click and timeout can both fire; deleting a canvas twice errors
      if dismissed then
         return
      end
      dismissed = true
      if timer then
         timer:stop()
      end
      canvas:delete()
   end

   -- canvas-level events so clicks on the text count too
   canvas:canvasMouseEvents(true, false, false, false)
   -- don't pull focus away from the terminal on click
   canvas:clickActivating(false)
   canvas:mouseCallback(dismiss)

   canvas:show()

   timer = hs.timer.doAfter(duration, dismiss)
end)

hs.urlevent.bind("alertRaycast", function()
   local raycastUrl =
      "raycast://extensions/maxnyby/raycast-notification/index?arguments=%7B%22title%22%3A%22Server%20restarted%21%22%2C%22message%22%3A%22%22%2C%22type%22%3A%22%22%7D"
   hs.execute("open -g '" .. raycastUrl .. "'")
end)
