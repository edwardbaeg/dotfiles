#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Configure ZSA ORYX Keyboard Layout
# @raycast.mode compact

# Optional parameters:
# @raycast.icon ⌨️
# @raycast.argument1 { "type": "dropdown", "placeholder": "hardware", "data": [{"title": "Moonlander", "value": "moonlander"}, {"title": "Voyager", "value": "voyager"}] }

# Documentation:
# @raycast.author dwrdbg
# @raycast.authorURL https://raycast.com/dwrdbg

if [ "$1" = "voyager" ]; then
	open -a "Arc" "https://configure.zsa.io/voyager/layouts/Bq47A/latest/0"
elif [ "$1" = "moonlander" ]; then
	open -a "Arc" "https://configure.zsa.io/moonlander/layouts/blnlP/latest/0"
fi
