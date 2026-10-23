#!/bin/bash

set -uo pipefail

# Set ALL displays to true maximum brightness using the BetterDisplay CLI.
# Requires the BetterDisplay app to be running.

if ! command -v betterdisplaycli &>/dev/null; then
	echo "betterdisplaycli is not installed or not in PATH" >&2
	exit 1
fi

# Omitting a display identifier applies the setting to every connected display.
# `brightness` lets BetterDisplay pick the control method per display, which
# may be a combined hardware+software curve rather than the panel's real max.
betterdisplaycli set --brightness=100%

# Force hardware (Apple native / DDC VCP 0x10) to max as well, so external
# monitors reach their true peak. Displays without hardware control (e.g.
# Sidecar) are skipped by BetterDisplay.
betterdisplaycli set --hardwareBrightness=100%
