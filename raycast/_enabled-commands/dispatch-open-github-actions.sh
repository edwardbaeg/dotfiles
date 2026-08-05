#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title [Dispatch] Open GitHub Actions
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🐙
# @raycast.argument1 { "type": "dropdown", "placeholder": "select view...", "data": [{"title": "all (root)", "value": "all"}, {"title": "workflow: release dev → staging", "value": "release-stage"}, {"title": "branch: release/prod", "value": "branch-prod"}, {"title": "workflow: rebuild forms", "value": "build-forms"}] }

# Documentation:
# @raycast.description Opens a GitHub Actions view for oneadvisory/frontend
# @raycast.author dwrdbg
# @raycast.authorURL https://raycast.com/dwrdbg

ACTIONS_URL="https://github.com/oneadvisory/frontend/actions"

# Prefer Arc, since work accounts live in its Spaces; fall back to the default browser
open_browser() {
	if open -Ra "Arc" 2>/dev/null; then # -Ra probes for Arc without launching it
		open -a "Arc" "$1"
	else
		open "$1"
	fi
}

case "$1" in
release-stage)
	open_browser "$ACTIONS_URL/workflows/release-to-stage.yaml"
	;;
branch-prod)
	open_browser "$ACTIONS_URL?query=branch%3Arelease%2Fprod"
	;;
build-forms)
	open_browser "$ACTIONS_URL/workflows/build-forms.yaml"
	;;
all)
	open_browser "$ACTIONS_URL"
	;;
esac
