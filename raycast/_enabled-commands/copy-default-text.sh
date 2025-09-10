#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Copy Default Text
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Copies to clipboard
# @raycast.author ${RAYCAST_USERNAME:-user}
# @raycast.authorURL https://raycast.com/${RAYCAST_USERNAME:-user}

# Get text from environment variable
if [ -z "$DEFAULT_TEXT" ]; then
    echo "Error: DEFAULT_TEXT environment variable not set"
    exit 1
fi

# Copy the text to the clipboard
echo -n "$DEFAULT_TEXT" | pbcopy

echo "Text copied to clipboard!"
