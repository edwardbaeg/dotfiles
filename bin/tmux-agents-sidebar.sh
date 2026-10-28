#!/bin/bash
# Floating sidebar listing `claude agents`, pinned to the right edge of the current window.
# tmux has no pane that spans windows, so a session-window-changed hook (see .tmux.conf) moves the one
# float along. The server option @agents_sidebar holds its pane id and doubles as the on/off state
#
# usage: tmux-agents-sidebar.sh toggle <window-id> | follow <window-id> | view

set -uo pipefail

WIDTH=42
REFRESH=2
# one file per chat with a reply you haven't read, named by session id; kept by claude-unread.sh
UNREAD_DIR="${XDG_STATE_HOME:-${HOME}/.local/state}/claude-unread"

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

# Prints "<urgency>\t<state>\t<alive>\t<name>\t<id>\t<session>\t<started>\t<cwd>"; urgency ranks what
# needs attention first. --all adds finished sessions like the agents view lists them; those have no
# pid or status. state (done/blocked/working/...) is what the agents view shows, unlike the
# process-level status. started is epoch seconds of the current process, see job_created for the first
agents_tsv() {
	claude agents --json --all 2>/dev/null | jq -r '.[]
		| [({blocked: 0, working: 1, failed: 2, error: 2, crashed: 2}[.state] // 3), (.state // "unknown"),
			(if .pid then 1 else 0 end), .name, .id, .sessionId, ((.startedAt // 0) / 1000 | floor), .cwd] | @tsv'
}

# Prints "<repo-path>\t<worktree>". Worktrees share the main checkout's git dir, so that names the
# repo; the worktree is empty in the main checkout. Outside git, the cwd stands in for the repo
repo_of() {
	local common="" top="" main
	{
		read -r common
		read -r top
	} < <(git -C "$1" rev-parse --path-format=absolute --git-common-dir --show-toplevel 2>/dev/null)
	if [ -z "${common}" ]; then
		printf '%s\t\n' "$1"
		return
	fi
	main="${common%/.git}"
	if [ "${top}" = "${main}" ]; then
		printf '%s\t\n' "${main}"
	else
		printf '%s\t%s\n' "${main}" "${top##*/}"
	fi
}

# Prints "<repo-path>\t<state>\t<alive>\t<name>\t<id>\t<session>\t<started>\t<updated>\t<worktree>".
# Chats are sorted by urgency, then most recently updated, where updated is the transcript's mtime
# (every turn appends to it), or 0 without one. Repos are then ordered by their most urgent chat, so a
# repo with a chat needing input stays near the top, keeping that order within a repo. The often-empty
# worktree goes last because read collapses adjacent tabs, shifting later fields
grouped_agents() {
	local urgency state alive name id sid started cwd repo worktree file updated
	agents_tsv | while IFS=$'\t' read -r urgency state alive name id sid started cwd; do
		IFS=$'\t' read -r repo worktree < <(repo_of "${cwd}")
		file="$(transcript "${sid}")"
		updated=0
		[ -n "${file}" ] && updated="$(stat -f %m "${file}")"
		printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "${urgency}" "${repo}" "${state}" "${alive}" "${name}" \
			"${id}" "${sid}" "${started}" "${updated}" "${worktree}"
	done |
		sort -t $'\t' -k1,1n -k9,9nr | cut -f2- |
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

# Prints "<label>\t<sgr colour>\t<glyph>" for <state> <alive> <frame>, matching the agents view:
# Needs input in yellow, Done in green, Working in the default colour with a spinner (advanced once
# per refresh), and ∙ for a finished session whose process has exited
SPINNER=(✢ ✳ ✶ ✻ ✽)
state_style() {
	local live_glyph='∙'
	[ "$2" = 1 ] && live_glyph='✻'
	case "$1" in
	blocked) printf 'Needs input\t38;5;220\t%s\n' "${live_glyph}" ;;
	working) printf 'Working\t39\t%s\n' "${SPINNER[$(($3 % ${#SPINNER[@]}))]}" ;;
	done) printf 'Done\t38;5;114\t%s\n' "${live_glyph}" ;;
	failed | error | crashed) printf '%s\t38;5;203\t%s\n' "$(tr '[:lower:]' '[:upper:]' <<<"${1:0:1}")${1:1}" "${live_glyph}" ;;
	*) printf '%s\t38;5;246\t%s\n' "$(tr '[:lower:]' '[:upper:]' <<<"${1:0:1}")${1:1}" "${live_glyph}" ;;
	esac
}

# Same counts line as the agents view's header, e.g. "2 awaiting input · 1 working · 7 completed",
# led by the <unread> count, which the agents view doesn't have
summary_line() {
	awk -F'\t' -v unread="$1" '
		function add(key, label) {
			if (n[key]) out = out (out ? " · " : "") n[key] " " label
			delete n[key]
		}
		{ n[$2]++ }
		END {
			if (unread) out = unread " unread"
			add("blocked", "awaiting input"); add("working", "working"); add("done", "completed")
			for (k in n) add(k, k)
			print out
		}'
}

# The agents view's one-line status for an agent. The daemon rewrites it on every state change,
# so unlike the away_summary recap it's current even mid-turn
job_detail() {
	jq -r '.detail // empty | gsub("\\s+"; " ")' "${HOME}/.claude/jobs/$1/state.json" 2>/dev/null
}

# Epoch seconds the chat was first created. --json's startedAt resets whenever the daemon respawns the
# process, so a days-old chat can look minutes old; the job's createdAt doesn't
job_created() {
	jq -r '.createdAt // empty | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601' "${HOME}/.claude/jobs/$1/state.json" 2>/dev/null
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
	local cols="$1" highlight="$2" frame="$3" now focused rows repo header state alive name id sid worktree prev_repo=""
	local label colour glyph name_colour text_colour faint_colour file age detail lines line first bg divider="" i
	local unread unread_count name_width started created times
	now="$(date +%s)"
	focused="$(focused_chat)"
	rows="$(grouped_agents)"
	for ((i = 0; i < cols; i++)); do divider+="┈"; done
	unread_count="$(cut -f6 <<<"${rows}" | while read -r sid; do [ -n "${sid}" ] && [ -f "${UNREAD_DIR}/${sid}" ] && echo; done | wc -l | tr -d ' ')"
	printf '\e[1mclaude agents\e[0m\e[K\n'
	summary_line "${unread_count}" <<<"${rows}" | fold -s -w "${cols}" | while IFS= read -r line; do
		printf '\e[38;5;246m%s\e[0m\e[K\n' "${line%"${line##*[! ]}"}"
	done
	while IFS=$'\t' read -r repo state alive name id sid started updated worktree; do
		[ -n "${name}" ] || continue
		if [ "${repo}" != "${prev_repo}" ]; then
			prev_repo="${repo}"
			header="${repo/#${HOME}/~}"
			# Claude's accent (the agents view's logo colour), kept clear of the state colours
			printf '\e[K\n\e[1;38;5;174m%s\e[0m\e[K\n' "${header:0:${cols}}"
		else
			# Between chats in the same repo only; a repo header already separates the first one
			printf '\e[38;5;238m%s\e[0m\e[K\n' "${divider}"
		fi
		IFS=$'\t' read -r label colour glyph < <(state_style "${state}" "${alive}" "${frame}")
		# Lines below reset only the foreground (39) so this background runs to the \e[K at line end.
		# Like the agents view's selected row, the focused chat's name turns white; its greys lighten
		# too, since the dim ones vanish against the lavender highlight
		bg="" name_colour='38;5;246' text_colour='38;5;246' faint_colour='38;5;244'
		[ "${name}" = "${focused}" ] && bg="${highlight}" name_colour='38;5;231' text_colour='38;5;253' faint_colour='38;5;250'
		age=""
		((updated > 0)) && age="$(ago $((now - updated)))"
		created="$(job_created "${id}")"
		[ -z "${created}" ] && ((started > 0)) && created="${started}"
		# "<updated> · <started>", e.g. "5m · 2d"; the start time is fainter as the less urgent one
		times="${age}"
		[ -n "${created}" ] && times="${age:+${age} · }$(ago $((now - created)))"
		# The name gets whatever the glyph, unread mark and times leave, plus a space before the times
		unread="" name_width=$((cols - 3 - ${#times}))
		# A reply you haven't read: the same aqua ● as the tmux window marks, and a bold name
		[ -f "${UNREAD_DIR}/${sid}" ] && unread=$'\e[38;5;14m● ' name_colour="1;${name_colour}" name_width=$((name_width - 2))
		detail="$(job_detail "${id}")"
		if [ -z "${detail}" ]; then
			file="$(transcript "${sid}")"
			[ -n "${file}" ] && detail="$(recap "${file}")"
		fi
		# Jump to a column for the times, since printf pads by bytes and names can hold multibyte chars.
		# Clear before the jump, or the skipped gap keeps the previous frame's text
		printf '%s\e[%sm%s %s\e[%sm%s\e[22m\e[K\e[%sG\e[%sm%s\e[%sm%s\e[39m\e[K\e[0m\n' "${bg}" "${colour}" "${glyph}" "${unread}" \
			"${name_colour}" "${name:0:${name_width}}" "$((cols - ${#times} + 1))" \
			"${text_colour}" "${age}" "${faint_colour}" "${times#"${age}"}"
		[ -n "${worktree}" ] && printf '%s  \e[%sm⎇ %s\e[39m\e[K\e[0m\n' "${bg}" "${faint_colour}" "${worktree:0:$((cols - 4))}"
		# "<Label> · <detail>" as in the agents view, wrapped to 3 lines with only the label coloured
		lines="$(fold -s -w $((cols - 3)) <<<"${label}${detail:+ · ${detail}}")"
		[ "$(wc -l <<<"${lines}")" -gt 3 ] && lines="$(head -n 3 <<<"${lines}")…"
		first=1
		while IFS= read -r line; do
			# fold -s keeps the space it broke at
			line="${line%"${line##*[! ]}"}"
			if ((first)); then
				printf '%s  \e[%sm%s\e[%sm%s\e[39m\e[K\e[0m\n' "${bg}" "${colour}" "${label}" "${text_colour}" "${line#"${label}"}"
				first=0
			else
				printf '%s  \e[%sm%s\e[39m\e[K\e[0m\n' "${bg}" "${text_colour}" "${line}"
			fi
		done <<<"${lines}"
	done <<<"${rows}"
}

view() {
	# Only clear the option if it's still ours, since a quick toggle may have started a new sidebar
	trap '[ "$(tmux show -gv @agents_sidebar 2>/dev/null)" = "${TMUX_PANE}" ] && tmux set -gu @agents_sidebar' EXIT
	tput civis
	local cols rows frame highlight tick=0
	highlight="$(highlight_bg)"
	while :; do
		tick=$((tick + 1))
		# tput can't see the terminal from inside $(...), so ask tmux
		read -r cols rows < <(tmux display -p -t "${TMUX_PANE}" '#{pane_width} #{pane_height}')
		# Render off-screen first so a slow `claude agents --json` doesn't blank the list, and cap it
		# at the pane height, since printing past the bottom scrolls and breaks the redraw from home
		frame="$(render "${cols}" "${highlight}" "${tick}" | head -n "${rows}")"
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
