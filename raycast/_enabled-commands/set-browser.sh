#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Set Browser
# @raycast.mode compact
# @raycast.argument1 { "type": "dropdown", "placeholder": "Browser", "data": [{ "title": "Zen", "value": "zen" }, { "title": "Arc Personal", "value": "arcPersonal" }, { "title": "Arc Work", "value": "arcWork" }, { "title": "Arc #5", "value": "arc5" }, { "title": "Default", "value": "default" }] }

# Optional parameters:
# @raycast.icon 🌐

# Documentation:
# @raycast.description Sets the browser for the Hammerspoon browser hotkey (until Hammerspoon restarts) and Choosy's default
# @raycast.author dwrdbg
# @raycast.authorURL https://raycast.com/dwrdbg

open -g "hammerspoon://browser?name=$1"
