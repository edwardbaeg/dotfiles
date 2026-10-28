#!/bin/bash
# Floating sidebar listing `claude agents`, pinned to the right edge of the current window.
# tmux has no pane that spans windows, so a session-window-changed hook (see .tmux.conf) moves the one
# float along. The server option @agents_sidebar holds its pane id and doubles as the on/off state
#
# usage: tmux-agents-sidebar.sh toggle <window-id> | follow <window-id> | view

set -uo pipefail

WIDTH=42
REFRESH=2

sidebar_pane() {
	local pane
	pane="$(tmux show -gv @agents_sidebar 2>/dev/null)"
	# Closed some other way (exit, kill-pane), so it's off
	if [ -n "${pane}" ] && ! tmux display -p -t "${pane}" '' >/dev/null 2>&1; then
		tmux set -gu @agents_sidebar
		pane=""
	fi
	echo "${pane}"
}

# Prints the new pane's id. -A keeps it visible over a zoomed pane; -d leaves focus where it was
new_float() {
	local window="$1" width height
	shift
	read -r width height < <(tmux display -p -t "${window}" '#{window_width} #{window_height}')
	tmux new-pane -d -A -P -F '#{pane_id}' -t "${window}" -T 'claude agents' \
		-x "${WIDTH}" -y "${height}" -X "$((width - WIDTH))" -Y 0 "$@"
}

toggle() {
	local window="$1" pane
	pane="$(sidebar_pane)"
	if [ -n "${pane}" ]; then
		tmux kill-pane -t "${pane}" \; set -gu @agents_sidebar
	else
		pane="$(new_float "${window}" "$0" view)"
		[ -n "${pane}" ] && tmux set -g @agents_sidebar "${pane}"
	fi
}

# Moving with join-pane/move-pane reflows tiled layouts, so swap with a placeholder float instead;
# the sidebar keeps its process and pane id. -Z stops the swap unzooming both windows
follow() {
	local window="$1" pane tmp
	pane="$(sidebar_pane)"
	[ -n "${pane}" ] || return 0
	[ "$(tmux display -p -t "${pane}" '#{window_id}')" = "${window}" ] && return 0
	tmp="$(new_float "${window}")"
	[ -n "${tmp}" ] || return 1
	tmux swap-pane -d -Z -s "${pane}" -t "${tmp}" \; kill-pane -t "${tmp}"
}

# Sorted by what needs attention, newest first
agents_tsv() {
	claude agents --json 2>/dev/null | jq -r '
		sort_by(({waiting: 0, busy: 1}[.status] // 2), -.startedAt)[]
		| [.status, .name, .sessionId, .cwd] | @tsv'
}

# Prints "<repo>\t<worktree>". Worktrees share the main checkout's git dir, so that names the repo;
# the worktree is empty in the main checkout. Outside git, the cwd's basename stands in for the repo
repo_of() {
	local common="" top="" main
	{
		read -r common
		read -r top
	} < <(git -C "$1" rev-parse --path-format=absolute --git-common-dir --show-toplevel 2>/dev/null)
	if [ -z "${common}" ]; then
		printf '%s\t\n' "${1##*/}"
		return
	fi
	main="${common%/.git}"
	if [ "${top}" = "${main}" ]; then
		printf '%s\t\n' "${main##*/}"
	else
		printf '%s\t%s\n' "${main##*/}" "${top##*/}"
	fi
}

# Prints "<repo>\t<status>\t<name>\t<session>\t<worktree>". Repos are ordered by their most urgent
# agent, so a waiting chat's repo stays near the top, and agents keep agents_tsv's order within a repo.
# The often-empty worktree goes last because read collapses adjacent tabs, shifting later fields
grouped_agents() {
	local status name sid cwd repo worktree
	agents_tsv | while IFS=$'\t' read -r status name sid cwd; do
		IFS=$'\t' read -r repo worktree < <(repo_of "${cwd}")
		printf '%s\t%s\t%s\t%s\t%s\n' "${repo}" "${status}" "${name}" "${sid}" "${worktree}"
	done |
		awk -F'\t' '!($1 in rank) { rank[$1] = n++ } { print rank[$1] "\t" NR "\t" $0 }' |
		sort -t $'\t' -k1,1n -k2,2n | cut -f3-
}

# Claude Code's own prompt background, from the custom theme in settings, so the focused chat is
# marked the same way your messages are. Anything unparseable falls back to a plain grey.
# The agents view draws in 256 colours even under a truecolor terminal, so the theme's rgb(40, 62, 92)
# shows as colour 60; convert the same way (chalk's rgb -> ansi256) to match what's on screen
highlight_bg() {
	local theme rgb="" r g b re_rgb='^rgb\(([0-9]+), *([0-9]+), *([0-9]+)\)$' re_hex='^#([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})$'
	theme="$(jq -r '.theme // empty' "${HOME}/.claude/settings.json" 2>/dev/null)"
	[[ "${theme}" == custom:* ]] &&
		rgb="$(jq -r '.overrides.userMessageBackground // empty' "${HOME}/.claude/themes/${theme#custom:}.json" 2>/dev/null)"
	if [[ "${rgb}" =~ ${re_rgb} ]]; then
		r="${BASH_REMATCH[1]}" g="${BASH_REMATCH[2]}" b="${BASH_REMATCH[3]}"
	elif [[ "${rgb}" =~ ${re_hex} ]]; then
		r=$((16#${BASH_REMATCH[1]})) g=$((16#${BASH_REMATCH[2]})) b=$((16#${BASH_REMATCH[3]}))
	else
		printf '\e[48;5;237m'
		return
	fi
	# Integer forms of Math.round(c / 255 * 5) and Math.round((c - 8) / 247 * 24)
	if ((r == g && g == b)); then
		if ((r < 8)); then
			printf '\e[48;5;16m'
		elif ((r > 248)); then
			printf '\e[48;5;231m'
		else
			printf '\e[48;5;%dm' $(((((r - 8) * 48 + 247) / 494) + 232))
		fi
	else
		printf '\e[48;5;%dm' $((16 + 36 * ((r * 10 + 255) / 510) + 6 * ((g * 10 + 255) / 510) + (b * 10 + 255) / 510))
	fi
}

rule() {
	local i out=""
	for ((i = 0; i < $1; i++)); do out+="─"; done
	echo "${out}"
}

# Transcripts live under a dir derived from the session's launch cwd, so glob rather than rebuild it
transcript() {
	local files=("${HOME}"/.claude/projects/*/"$1".jsonl)
	[ -f "${files[0]}" ] && echo "${files[0]}"
}

# away_summary is Claude Code's own "while you were away" recap. Transcripts reach tens of MB and
# only the newest recap matters, so scan just the tail. It's only written once the agent goes idle,
# so a busy agent's recap describes its previous turn
recap() {
	tail -c 2000000 "$1" | grep '"subtype":"away_summary"' | tail -1 | jq -r '.content // empty'
}

ago() {
	local secs="$1"
	if ((secs < 60)); then
		echo now
	elif ((secs < 3600)); then
		echo "$((secs / 60))m"
	elif ((secs < 86400)); then
		echo "$((secs / 3600))h"
	else
		echo "$((secs / 86400))d"
	fi
}

# Name of the chat in the pane the user is looking at: the sidebar's window's active pane, or the
# previous one after clicking into the sidebar. Attaching to a chat retitles its pane to the chat's
# name, and a busy chat's title is prefixed with a spinner glyph
focused_chat() {
	tmux list-panes -t "${TMUX_PANE}" -F '#{pane_active}#{pane_last}	#{pane_id}	#{pane_title}' |
		awk -F'\t' -v me="${TMUX_PANE}" '
			$2 == me { next }
			/^1/ { title = $3; exit }
			/^01/ { last = $3 }
			END { print (title != "" ? title : last) }' |
		sed -E 's/^[^[:alnum:]]+ //'
}

render() {
	local cols="$1" highlight="$2" now focused repo worktree status name sid prev_repo="" glyph colour file age summary lines line bg
	now="$(date +%s)"
	focused="$(focused_chat)"
	printf '\e[1mclaude agents\e[0m\e[K\n'
	while IFS=$'\t' read -r repo status name sid worktree; do
		if [ "${repo}" != "${prev_repo}" ]; then
			prev_repo="${repo}"
			printf '\e[K\n\e[1;38;5;245m%s\e[0m \e[38;5;238m%s\e[0m\e[K\n' "${repo:0:$((cols - 2))}" "$(rule $((cols - ${#repo} - 1)))"
		fi
		# Lines below reset only the foreground (39) so this background runs to the \e[K at line end
		bg=""
		[ "${name}" = "${focused}" ] && bg="${highlight}"
		case "${status}" in
		waiting) glyph='◆' colour='38;5;208' ;;
		busy) glyph='●' colour='38;5;39' ;;
		idle) glyph='○' colour='38;5;241' ;;
		*) glyph='?' colour='38;5;241' ;;
		esac
		file="$(transcript "${sid}")"
		age="" summary=""
		if [ -n "${file}" ]; then
			# Every turn appends to the transcript, so its mtime is the last activity
			age="$(ago $((now - $(stat -f %m "${file}"))))"
			summary="$(recap "${file}")"
		fi
		# Jump to a column for the age, since printf pads by bytes and names can hold multibyte chars.
		# Clear before the jump, or the skipped gap keeps the previous frame's text
		printf '%s\e[%sm%s\e[39m %s\e[K\e[%sG\e[38;5;241m%s\e[39m\e[K\e[0m\n' "${bg}" "${colour}" "${glyph}" \
			"${name:0:$((cols - 8))}" "$((cols - ${#age} + 1))" "${age}"
		[ -n "${worktree}" ] && printf '%s  \e[38;5;241m⎇ %s\e[39m\e[K\e[0m\n' "${bg}" "${worktree:0:$((cols - 4))}"
		if [ -n "${summary}" ]; then
			lines="$(fold -s -w $((cols - 3)) <<<"${summary}")"
			[ "$(wc -l <<<"${lines}")" -gt 3 ] && lines="$(head -n 3 <<<"${lines}")…"
			while IFS= read -r line; do
				# fold -s keeps the space it broke at
				printf '%s  \e[38;5;245m%s\e[39m\e[K\e[0m\n' "${bg}" "${line%"${line##*[! ]}"}"
			done <<<"${lines}"
		fi
	done < <(grouped_agents)
}

view() {
	# Only clear the option if it's still ours, since a quick toggle may have started a new sidebar
	trap '[ "$(tmux show -gv @agents_sidebar 2>/dev/null)" = "${TMUX_PANE}" ] && tmux set -gu @agents_sidebar' EXIT
	tput civis
	local cols rows frame highlight
	highlight="$(highlight_bg)"
	while :; do
		# tput can't see the terminal from inside $(...), so ask tmux
		read -r cols rows < <(tmux display -p -t "${TMUX_PANE}" '#{pane_width} #{pane_height}')
		# Render off-screen first so a slow `claude agents --json` doesn't blank the list, and cap it
		# at the pane height, since printing past the bottom scrolls and breaks the redraw from home
		frame="$(render "${cols}" "${highlight}" | head -n "${rows}")"
		printf '\e[H%s\e[J' "${frame}"
		sleep "${REFRESH}"
	done
}

case "${1:-}" in
toggle) toggle "${2:?window id}" ;;
follow) follow "${2:?window id}" ;;
view) view ;;
*)
	echo "usage: $0 toggle <window-id> | follow <window-id> | view" >&2
	exit 2
	;;
esac
