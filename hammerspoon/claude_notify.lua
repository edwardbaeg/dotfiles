-- Stacked Claude Code notification cards, fed by bin/claude-notify.sh from the Stop and
-- Notification hooks. One card per chat: a new event from the same chat replaces its card and
-- moves it to the top, while different chats stack below each other. Click a card to dismiss it.
-- usage: hammerspoon://claude-notify?p=<uri-encoded json {session, title, where, kind, detail}>

local palette = require("common.external.catpuccin-frappe")

local DURATION = 10
local WIDTH = 420
local HEIGHT = 80
local GAP = 8
local SCREEN_PADDING = 48
local BORDER = 2
local ACCENT_WIDTH = 4
local TEXT_X = 16
local FONT = "Helvetica"
local FONT_BOLD = "Helvetica-Bold"

local KINDS = {
   done = { label = "Done", color = "green" },
   permission_prompt = { label = "Needs permission", color = "yellow" },
   idle_prompt = { label = "Waiting for input", color = "blue" },
   elicitation_dialog = { label = "Question", color = "mauve" },
}
local FALLBACK_KIND = { label = "Notification", color = "peach" }

-- newest first
local cards = {}

local function styled(text, font, size, color)
   return hs.styledtext.new(text, {
      font = { name = font, size = size },
      color = palette.getRgbColor(color),
      -- long titles/replies end in an ellipsis instead of wrapping out of the card
      paragraphStyle = { lineBreak = "truncateTail" },
   })
end

local function elements(payload)
   local kind = KINDS[payload.kind] or FALLBACK_KIND
   local textWidth = WIDTH - TEXT_X - 12

   local header = styled(kind.label, FONT_BOLD, 12, kind.color)
   if payload.where and payload.where ~= "" then
      header = header .. styled("  " .. payload.where, FONT, 12, "subtext0")
   end

   local title = payload.title ~= "" and payload.title or "Claude Code"

   return {
      {
         type = "rectangle",
         action = "strokeAndFill",
         fillColor = palette.getRgbColor("surface0", 0.97),
         strokeColor = palette.getRgbColor(kind.color, 0.6),
         strokeWidth = BORDER,
         roundedRectRadii = { xRadius = 8, yRadius = 8 },
         -- strokes straddle the path, so inset or the canvas edge clips half the border
         frame = { x = BORDER / 2, y = BORDER / 2, w = WIDTH - BORDER, h = HEIGHT - BORDER },
      },
      {
         type = "rectangle",
         action = "fill",
         fillColor = palette.getRgbColor(kind.color),
         roundedRectRadii = { xRadius = 2, yRadius = 2 },
         frame = { x = 7, y = 12, w = ACCENT_WIDTH, h = HEIGHT - 24 },
      },
      { type = "text", text = header, frame = { x = TEXT_X, y = 9, w = textWidth, h = 16 } },
      {
         type = "text",
         text = styled(title, FONT_BOLD, 15, "text"),
         frame = { x = TEXT_X, y = 27, w = textWidth, h = 20 },
      },
      {
         type = "text",
         text = styled(payload.detail or "", FONT, 13, "subtext1"),
         frame = { x = TEXT_X, y = 50, w = textWidth, h = 18 },
      },
   }
end

-- position every card from its index, so a dismissed card's gap closes up
local function layout()
   local screen = hs.screen.mainScreen():fullFrame()
   for i, card in ipairs(cards) do
      card.canvas:topLeft({
         x = screen.x + (screen.w - WIDTH) / 2,
         y = screen.y + SCREEN_PADDING + (i - 1) * (HEIGHT + GAP),
      })
   end
end

local function indexOf(card)
   for i, c in ipairs(cards) do
      if c == card then
         return i
      end
   end
end

local function dismiss(card)
   -- click and timeout can both fire; deleting a canvas twice errors
   local i = indexOf(card)
   if not i then
      return
   end
   table.remove(cards, i)
   card.timer:stop()
   card.canvas:delete()
   layout()
end

local function findBySession(session)
   for _, card in ipairs(cards) do
      if session and card.session == session then
         return card
      end
   end
end

local function push(payload)
   local card = findBySession(payload.session)

   if card then
      card.timer:stop()
      table.remove(cards, indexOf(card))
   else
      card = { session = payload.session }
      card.canvas = hs.canvas.new({ x = 0, y = 0, w = WIDTH, h = HEIGHT })
      if card.canvas == nil then
         return
      end
      card.canvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
      -- canvas-level events so clicks on the text count too
      card.canvas:canvasMouseEvents(true, false, false, false)
      -- don't pull focus away from the terminal on click
      card.canvas:clickActivating(false)
      card.canvas:mouseCallback(function()
         dismiss(card)
      end)
   end

   card.canvas:replaceElements(elements(payload))
   card.timer = hs.timer.doAfter(DURATION, function()
      dismiss(card)
   end)
   table.insert(cards, 1, card)
   layout()
   card.canvas:show()
end

hs.urlevent.bind("claude-notify", function(_, params)
   local ok, payload = pcall(hs.json.decode, params.p or "")
   if not ok or type(payload) ~= "table" then
      payload = { kind = "notification", title = "", detail = "(unreadable payload)" }
   end
   push(payload)
end)

return { push = push }
