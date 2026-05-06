# hammerspoon

## Notes

### Tips

Created objects should be captured in global variables, otherwise they will be garbage collected.
See: https://www.hammerspoon.org/go/ "A quick aside about variable lifecycles"

### Useful console snippets

```lua
-- Get the name of screens
hs.screen.allScreens()[1]:name()

-- Get the name of running apps
hs.fnutils.each(hs.application.runningApplications(), function(app) print(app:title()) end)
```
