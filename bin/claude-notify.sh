#!/bin/bash
# Claude Code hook (Stop / Notification): push a card onto the Hammerspoon notification stack
# (hammerspoon/claude_notify.lua), one card per chat.
#
# Context is gathered here rather than in Hammerspoon because $TMUX_PANE only exists in the
# hook's env, and the transcript path / session id only arrive on the hook's stdin

set -uo pipefail

send() {
  open -g "hammerspoon://claude-notify?p=$(jq -rn --arg p "$1" '$p | @uri')"
}

# --demo: push sample cards without a real chat. Three chats stack, then demo-1 fires again
# and should replace its card and jump to the top
if [ "${1:-}" = "--demo" ]; then
  send '{"session":"demo-1","title":"tmux persistent side pane","where":"dotfiles ⎇ master · main:1","kind":"done","detail":"Fixed the hook; tac is missing on macOS so the title was always empty."}'
  sleep 0.3
  send '{"session":"demo-2","title":"ENG-4453 fix error code","where":"api ⎇ edward/eng-4453-fix-error-code · work:2","kind":"permission_prompt","detail":"Claude needs your permission to use Bash"}'
  sleep 0.3
  send '{"session":"demo-3","title":"","where":"scratch","kind":"idle_prompt","detail":"Claude is waiting for your input"}'
  sleep 2
  send '{"session":"demo-1","title":"tmux persistent side pane","where":"dotfiles ⎇ master · main:1","kind":"elicitation_dialog","detail":"Which stacking style do you want? This line is deliberately long so it shows the truncation ellipsis at the end of the card."}'
  exit 0
fi

# Newest aiTitle in <transcript>; it's rewritten as the chat goes on
title_of() {
  [ -f "$1" ] || return
  tail -r "$1" | grep -m1 '"type":"ai-title"' | jq -r '.aiTitle // empty'
}

# "<repo> ⎇ <branch>" for <cwd>, plus the tmux session:window this hook runs in
where_of() {
  local where="" common branch loc
  if [ -n "$1" ]; then
    # the common git dir names the main repo even from inside a worktree, where the toplevel
    # would only give the worktree dir name
    if common=$(git -C "$1" rev-parse --path-format=absolute --git-common-dir 2>/dev/null); then
      where=$(basename "$(dirname "$common")")
      branch=$(git -C "$1" branch --show-current 2>/dev/null)
      [ -n "$branch" ] && where+=" ⎇ $branch"
    else
      where=$(basename "$1")
    fi
  fi
  if [ -n "${TMUX_PANE:-}" ] && loc=$(tmux display-message -p -t "$TMUX_PANE" '#S:#W' 2>/dev/null); then
    where+="${where:+ · }$loc"
  fi
  printf '%s' "$where"
}

input=$(cat)

# Agent view raises its own notifications for background chats, with agent view's session id
# rather than the chat's and only a message naming the chat: "<name> finished", "<name> failed"
# or "<name> needs your input: <question>". Look the name up so the card replaces that chat's own
# card. A finished chat sends no detail, so the card keeps the reply its Stop hook already showed
type=$(jq -r '.notification_type // empty' <<<"$input")
if [ "$type" = agent_completed ] || [ "$type" = agent_needs_input ]; then
  message=$(jq -r '.message // empty' <<<"$input")
  detail=""
  case "$message" in
  *" needs your input"*)
    name=${message%%" needs your input"*} kind=agent_needs_input
    detail=${message#*" needs your input"}
    detail=${detail#": "}
    ;;
  *" failed") name=${message%" failed"} kind=failed ;;
  *) name=${message%" finished"} kind=done ;;
  esac
  agent=$(claude agents --json --all 2>/dev/null | jq -c --arg n "$name" 'first(.[] | select(.name == $n)) // {}')
  sid=$(jq -r '.sessionId // empty' <<<"$agent")
  cwd=$(jq -r '.cwd // empty' <<<"$agent")
  transcripts=("$HOME"/.claude/projects/*/"$sid".jsonl)
  title=""
  [ -n "$sid" ] && title=$(title_of "${transcripts[0]}")
  send "$(jq -nc --arg session "${sid:-agent:$name}" --arg title "${title:-$name}" \
    --arg where "$(where_of "$cwd")" --arg kind "$kind" --arg detail "$detail" \
    '{session: $session, title: $title, where: $where, kind: $kind, detail: $detail}')"
  exit 0
fi

cwd=$(jq -r '.cwd // empty' <<<"$input")
transcript=$(jq -r '.transcript_path // empty' <<<"$input")
title=$(title_of "${transcript/#\~/$HOME}")

# detail: first non-blank line of the reply (Stop) or Claude's message (Notification);
# jq slices by codepoint so multibyte text isn't cut mid-character
payload=$(jq -c --arg title "$title" --arg where "$(where_of "$cwd")" '{
  session: .session_id,
  title: $title,
  where: $where,
  kind: (if .hook_event_name == "Stop" then "done" else (.notification_type // "notification") end),
  detail: ((if .hook_event_name == "Stop" then .last_assistant_message else .message end) // ""
    | split("\n") | map(select(test("\\S"))) | (first // "")
    | sub("^[#>*\\s-]+"; "") | gsub("\\*\\*|`"; "") | .[0:300])
}' <<<"$input")

send "$payload"
exit 0
