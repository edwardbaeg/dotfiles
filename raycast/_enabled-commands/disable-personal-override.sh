#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Disable Personal Override
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author dwrdbg
# @raycast.authorURL https://raycast.com/dwrdbg

open "hammerspoon://disablePersonalOverride" # call the url handler
# hs -c "disablePersonalOverride()" # directly call the function
