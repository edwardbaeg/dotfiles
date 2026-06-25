#!/bin/bash

set -uo pipefail

# Set ALL displays to true maximum brightness using the Lunar CLI.

if ! command -v lunar &>/dev/null; then
	echo "lunar is not installed or not in PATH" >&2
	exit 1
fi

# Built-in / Apple-native displays: set via the normal brightness property.
lunar displays builtin brightness 100

# External (DDC) displays: Lunar's software brightness 100 maps through a
# non-linear curve and does NOT reach the panel's hardware max (e.g. the LG
# ULTRAWIDE only got raw DDC 79). Send a raw DDC BRIGHTNESS (VCP 0x10) command
# to force every external monitor to its true maximum.
lunar ddc external BRIGHTNESS 100
