#!/bin/bash
# Tracks Claude chats with a reply you haven't read, and mirrors that into tmux:
# - pane option @claude_unread on panes showing an unread chat, for the window tab marks
# - global option @claude_unread_count, for the status bar
# bin/tmux-agents-sidebar.sh reads the state dir itself.
#
# A chat turns unread when Claude ends a turn (Stop hook), unless it's on screen right then. It's
# read again once you reply (UserPromptSubmit hook) or look at it (tmux focus and title hooks).
# "On screen" means in the active pane of a client's current window while the terminal has focus.
# A pane shows a chat by running it (the hook's $TMUX_PANE), or by being a `claude agents` pane
# attached to it, since attaching retitles the pane to the chat's name. Background chats have no
# $TMUX_PANE, so they're only ever matched by name
#
# usage: claude-unread.sh mark | read          (hook JSON on stdin)
#        claude-unread.sh seen <pane-id> | sync

set -uo pipefail

# one file per unread chat, named by session id, holding the pane running it (empty if none)
DIR="${XDG_STATE_HOME:-$HOME/.local/state}/claude-unread"
mkdir -p "$DIR"

has_unread() {
  [ -n "$(ls -A "$DIR")" ]
}

# a busy chat's title is prefixed with a spinner glyph
strip_title() {
  sed -E 's/^[^[:alnum:]]+ //'
}

session_id() {
  jq -r '.session_id // empty'
}

# "<session id>\t<name>" per unread chat. Names are looked up fresh each time, since a chat can be
# renamed after it was marked
unread_names() {
  local ids
  ids="$(ls "$DIR")"
  [ -n "$ids" ] || return
  claude agents --json --all 2>/dev/null | jq -r --arg ids "$ids" '
    ($ids | split("\n")) as $unread
    | .[] | select(.sessionId as $s | $unread | index($s)) | [.sessionId, .name] | @tsv'
}

# Current pane of each client whose terminal has focus (needs focus-events on)
on_screen_panes() {
  tmux list-clients -F '#{?#{m:*focused*,#{client_flags}},#{pane_id},}' 2>/dev/null | grep .
}

pane_title() {
  tmux display -p -t "$1" '#{pane_title}' 2>/dev/null | strip_title
}

# true if chat <session id>, run in <pane> if any, is on screen
on_screen() {
  local sid="$1" pane="$2" panes name p
  panes="$(on_screen_panes)"
  [ -n "$panes" ] || return 1
  [ -n "$pane" ] && grep -Fxq -- "$pane" <<<"$panes" && return 0
  name="$(claude agents --json --all 2>/dev/null |
    jq -r --arg s "$sid" 'first(.[] | select(.sessionId == $s) | .name) // empty')"
  [ -n "$name" ] || return 1
  while read -r p; do
    [ "$(pane_title "$p")" = "$name" ] && return 0
  done <<<"$panes"
  return 1
}

sync() {
  local names unread_panes unread_titles count flag pane title want client
  names="$(unread_names)"
  unread_panes="$(cat "$DIR"/* 2>/dev/null | grep .)"
  unread_titles="$(cut -f2 <<<"$names" | grep .)"
  count="$(ls "$DIR" | wc -l | tr -d ' ')"
  tmux set -g @claude_unread_count "$count"

  # flag goes first and is never empty, since read collapses adjacent tabs
  tmux list-panes -a -F '#{?#{@claude_unread},1,0}	#{pane_id}	#{pane_title}' |
    while IFS=$'\t' read -r flag pane title; do
      want=0
      title="$(strip_title <<<"$title")"
      if grep -Fxq -- "$pane" <<<"$unread_panes" ||
        { [ -n "$title" ] && grep -Fxq -- "$title" <<<"$unread_titles"; }; then
        want=1
      fi
      [ "$flag" = "$want" ] && continue
      if ((want)); then
        tmux set -p -t "$pane" @claude_unread 1
      else
        tmux set -pu -t "$pane" @claude_unread
      fi
    done

  # option changes don't redraw the status bar on their own
  tmux list-clients -F '#{client_name}' 2>/dev/null | while read -r client; do
    tmux refresh-client -S -t "$client"
  done
}

mark() {
  local sid
  sid="$(session_id)"
  [ -n "$sid" ] || return
  on_screen "$sid" "${TMUX_PANE:-}" && return
  printf '%s\n' "${TMUX_PANE:-}" >"$DIR/$sid"
  sync
}

read_chat() {
  local sid
  sid="$(session_id)"
  [ -n "$sid" ] && [ -f "$DIR/$sid" ] || return
  rm -f "$DIR/$sid"
  sync
}

# Clear whatever chat <pane> shows, if the pane is actually on screen
seen() {
  local pane="$1" title cleared=0 f sid name
  # title hooks fire on every spinner frame, so bail before any slow lookups
  has_unread || return
  on_screen_panes | grep -Fxq -- "$pane" || return
  for f in "$DIR"/*; do
    if [ "$(cat "$f")" = "$pane" ]; then
      rm -f "$f"
      cleared=1
    fi
  done
  title="$(pane_title "$pane")"
  if [ -n "$title" ]; then
    while IFS=$'\t' read -r sid name; do
      if [ -n "$sid" ] && [ "$name" = "$title" ]; then
        rm -f "$DIR/$sid"
        cleared=1
      fi
    done < <(unread_names)
  fi
  ((cleared)) && sync
}

case "${1:-}" in
mark) mark ;;
read) read_chat ;;
seen) seen "${2:?pane id}" ;;
sync) sync ;;
*)
  echo "usage: $0 mark | read | seen <pane-id> | sync" >&2
  exit 2
  ;;
esac
exit 0
