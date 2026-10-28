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

input=$(cat)
cwd=$(jq -r '.cwd // empty' <<<"$input")
transcript=$(jq -r '.transcript_path // empty' <<<"$input")
transcript=${transcript/#\~/$HOME}

# aiTitle is rewritten as the chat goes on, so take the newest one
title=""
if [ -f "$transcript" ]; then
  title=$(tail -r "$transcript" | grep -m1 '"type":"ai-title"' | jq -r '.aiTitle // empty')
fi

where=""
if [ -n "$cwd" ]; then
  # the common git dir names the main repo even from inside a worktree, where the toplevel
  # would only give the worktree dir name
  if common=$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir 2>/dev/null); then
    where=$(basename "$(dirname "$common")")
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
    [ -n "$branch" ] && where+=" ⎇ $branch"
  else
    where=$(basename "$cwd")
  fi
fi
if [ -n "${TMUX_PANE:-}" ] && loc=$(tmux display-message -p -t "$TMUX_PANE" '#S:#W' 2>/dev/null); then
  where+="${where:+ · }$loc"
fi

# detail: first non-blank line of the reply (Stop) or Claude's message (Notification);
# jq slices by codepoint so multibyte text isn't cut mid-character
payload=$(jq -c --arg title "$title" --arg where "$where" '{
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
