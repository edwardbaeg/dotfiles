#!/bin/bash
# M-g floating pane toggle, run with the active pane:
# - In an M-g float: close it if its shell is idle. If the shell has work running or suspended
#   (e.g. lazygit mid-push, or Ctrl-Z'd), hide it instead, since closing would SIGHUP that work
# - Elsewhere: bring back this window's hidden float, or open a new one
#
# Hidden floats live in the _floats session; the window option @mg_hidden holds the pane id.
# Inside `claude agents`, the pane's own cwd is the agents-view launch dir, so a new float uses the
# attached chat's cwd instead: attaching retitles the pane to the chat's name, which
# `claude agents --json` maps to its cwd

set -uo pipefail

PANE="${1:?usage: tmux-mg-float.sh <pane-id>}"
STASH=_floats
# Unlike tab, a non-whitespace IFS keeps empty fields (unset @mg_float, blank titles) in place
SEP=$'\x1f'

# `display -t` on a dead pane id still succeeds, so look it up instead
pane_exists() {
	tmux list-panes -a -F '#{pane_id}' | grep -qxF "$1"
}

# Prints the new pane's id. -A keeps it visible over a zoomed pane
new_float() {
	local target="$1" float
	shift
	float="$(tmux new-pane -A -P -F '#{pane_id}' -t "${target}" -x80% -y80% "$@")" || return 1
	tmux set -p -t "${float}" @mg_float 1 \; move-pane -t "${float}" -P centre
	echo "${float}"
}

start_dir() {
	local command title cwd name chat_cwd
	IFS="${SEP}" read -r command title cwd < <(tmux display -p -t "${PANE}" "#{pane_current_command}${SEP}#{pane_title}${SEP}#{pane_current_path}")
	# Claude's process title is its version, e.g. 2.1.311
	if [[ "${command}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ && "${title}" != *"claude agents"* ]]; then
		# A busy chat's title is prefixed with a spinner glyph
		name="$(sed -E 's/^[^[:alnum:]]+ //' <<<"${title}")"
		chat_cwd="$(claude agents --json 2>/dev/null |
			jq -r --arg n "${name}" '[.[] | select(.name == $n or .id == $n)] | sort_by(.startedAt) | last | .cwd // empty')"
		[ -d "${chat_cwd}" ] && cwd="${chat_cwd}"
	fi
	echo "${cwd}"
}

hide() {
	local window zoomed
	IFS="${SEP}" read -r window zoomed < <(tmux display -p -t "${PANE}" "#{window_id}${SEP}#{window_zoomed_flag}")
	if ! tmux has-session -t "=${STASH}" 2>/dev/null; then
		tmux new-session -d -s "${STASH}" -n placeholder
	fi
	# break-pane leaves the tiled layout alone, unlike join-pane, but it drops zoom and has no -Z
	tmux break-pane -d -s "${PANE}" -t "=${STASH}:" \; set -w -t "${window}" @mg_hidden "${PANE}"
	[ "${zoomed}" = 1 ] && tmux resize-pane -Z -t "${window}"
	tmux kill-window -t "=${STASH}:=placeholder" 2>/dev/null
	tmux display -d 1500 "Float hidden; M-g brings it back"
}

# Moving it back with join-pane reflows the tiled layout, so swap it into a placeholder float instead;
# the shell and its jobs survive with the same pane id
restore() {
	local hidden="$1" window="$2" tmp
	tmp="$(new_float "${window}")" || return 1
	tmux swap-pane -Z -s "${hidden}" -t "${tmp}" \; kill-pane -t "${tmp}" \; select-pane -t "${hidden}" \; \
		set -wu -t "${window}" @mg_hidden
}

IFS="${SEP}" read -r IS_FLOAT SHELL_PID WINDOW < <(tmux display -p -t "${PANE}" "#{@mg_float}${SEP}#{pane_pid}${SEP}#{window_id}")

if [ -n "${IS_FLOAT}" ]; then
	if pgrep -P "${SHELL_PID}" >/dev/null; then
		hide
	else
		tmux kill-pane -t "${PANE}"
	fi
	exit 0
fi

HIDDEN="$(tmux show -wqv -t "${WINDOW}" @mg_hidden)"
if [ -n "${HIDDEN}" ] && pane_exists "${HIDDEN}"; then
	restore "${HIDDEN}" "${WINDOW}"
else
	# Its shell exited while hidden
	[ -n "${HIDDEN}" ] && tmux set -wu -t "${WINDOW}" @mg_hidden
	new_float "${PANE}" -c "$(start_dir)" >/dev/null
fi
