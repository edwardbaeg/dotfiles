#!/bin/bash
# Opens the M-g floating pane over the given pane. Inside `claude agents`, the pane's own cwd is the
# agents-view launch dir, so resolve the attached chat's cwd instead: attaching retitles the pane to
# the chat's name, which `claude agents --json` maps to its cwd

set -uo pipefail

PANE="${1:?usage: tmux-mg-float.sh <pane-id>}"

IFS=$'\t' read -r COMMAND TITLE CWD < <(tmux display-message -p -t "${PANE}" '#{pane_current_command}	#{pane_title}	#{pane_current_path}')

# Claude's process title is its version, e.g. 2.1.311
if [[ "${COMMAND}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ && "${TITLE}" != *"claude agents"* ]]; then
	# A busy chat's title is prefixed with a spinner glyph
	NAME="$(sed -E 's/^[^[:alnum:]]+ //' <<<"${TITLE}")"
	CHAT_CWD="$(claude agents --json 2>/dev/null |
		jq -r --arg n "${NAME}" '[.[] | select(.name == $n or .id == $n)] | sort_by(.startedAt) | last | .cwd // empty')"
	[ -d "${CHAT_CWD}" ] && CWD="${CHAT_CWD}"
fi

FLOAT="$(tmux new-pane -t "${PANE}" -c "${CWD}" -A -x80% -y80% -P -F '#{pane_id}')"
tmux set -p -t "${FLOAT}" @mg_float 1 \; move-pane -t "${FLOAT}" -P centre
