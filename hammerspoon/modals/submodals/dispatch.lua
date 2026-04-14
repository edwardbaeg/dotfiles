---@type SimpleModalItem[]
return {
   "--Dispatch--",
   -- { type = "url", "P", "FE PRs", "https://github.com/oneadvisory/frontend/pulls?q=is%3Apr+is%3Aopen+draft%3Afalse+" },
   { type = "custom", "p", "Type phone number", function()
      hs.eventtap.keyStrokes("5555555555")
   end },
   { type = "custom", "s", "Type SSN", function()
      hs.eventtap.keyStrokes("613121212")
   end },
   { type = "custom", "5", "Type 12345", function()
      hs.eventtap.keyStrokes("12345")
   end },
   { type = "custom", "8", "Type 1234578", function()
      hs.eventtap.keyStrokes("1234578")
   end },
}
