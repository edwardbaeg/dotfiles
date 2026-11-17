#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Set Browser Default
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🌐

# Documentation:
# @raycast.description Clears the Hammerspoon browser hotkey override and goes back to the machine default
# @raycast.author dwrdbg
# @raycast.authorURL https://raycast.com/dwrdbg

open -g "hammerspoon://browser?name=default"
