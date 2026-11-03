#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Configure ZSA ORYX Keyboard Layout: Voyager, Moonlander
# @raycast.mode compact

# Optional parameters:
# @raycast.icon ⌨️
# @raycast.argument1 { "type": "dropdown", "placeholder": "hardware (default: voyager)", "optional": true, "data": [{"title": "Voyager", "value": "voyager"}, {"title": "Moonlander", "value": "moonlander"}] }

# Documentation:
# @raycast.author dwrdbg
# @raycast.authorURL https://raycast.com/dwrdbg

open_browser() {
	if open -Ra "Arc" 2>/dev/null; then
		open -a "Arc" "$1"
	else
		open "$1"
	fi
}

hardware="${1:-voyager}"

if [ "$hardware" = "voyager" ]; then
	open_browser "https://configure.zsa.io/voyager/layouts/lBaWa/latest/0"
elif [ "$hardware" = "moonlander" ]; then
	open_browser "https://configure.zsa.io/moonlander/layouts/blnlP/latest/0"
fi
