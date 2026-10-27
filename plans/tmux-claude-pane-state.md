# tmux: Per-Pane Claude Code State

**Status:** punted (2026-10-27). Nothing implemented yet.

## Problem

The ✦ marks in the tmux status bar and choose-tree (`CLAUDE_MARKS` in `tmux/.tmux.conf`) only say a pane is running Claude Code. They don't say whether it's working, blocked on a permission prompt, or finished and unread. The only "needs you" signal is the terminal bell from the `Stop` hook, which looks the same for "done" and "waiting".

## Goal

Colour each ✦ by that pane's Claude state, so a glance at the status bar or `M-s`/`M-d`/`M-f` shows which session needs attention. This also makes a "jump to the waiting Claude" key a one-liner later.

## State Machine

```
                 UserPromptSubmit
   ┌──────┐  ─────────────────────────►  ┌─────────┐
   │ idle │                              │ working │ ◄──┐ PostToolUse /
   └──────┘  ◄── pane focused ──┐        └─────────┘    │ PostToolUseFailure
      ▲                         │          │      │     │ (you answered)
      │ SessionStart        ┌──────┐  Stop │      │ PermissionRequest,
      │                     │ done │ ◄─────┘      │ PreToolUse[AskUserQuestion|ExitPlanMode],
      │                     └──────┘              │ Notification[elicitation_dialog]
                                                  ▼
   SessionEnd ──► option unset             ┌─────────┐
                                           │ waiting │ ───┘
                                           └─────────┘
   colours: idle=grey  working=orange  waiting=red  done=lime  (error=pink, optional)
```

Every event above exists in Claude Code 2.1.309 (checked against the binary), as do `StopFailure` and the `permission_prompt` / `elicitation_dialog` notification types.

## Design

### 1. Hook script: `claude/hooks/tmux-claude-state.sh` (stowed to `~/.claude/hooks/`)

- Arg: a state name, or `clear`
- `$TMUX_PANE` empty → exit 0. Background jobs and non-tmux terminals are no-ops
- Otherwise `tmux set -p -t "$TMUX_PANE" @claude_state <state>`, or `set -pu` for `clear`
- Always exit 0, so a tmux error can never block Claude
- Runs on every tool call: keep it to plain sh plus one `tmux` call (~5ms), no python, don't read stdin

### 2. `claude/settings.json` hooks

Use `$HOME/.claude/hooks/...` paths, not hardcoded ones.

| Event | Matcher | State |
|---|---|---|
| `SessionStart` | add to the existing herdr entry | `idle` |
| `UserPromptSubmit` | — | `working` |
| `PermissionRequest` | — | `waiting` |
| `PreToolUse` | `AskUserQuestion\|ExitPlanMode` | `waiting` |
| `Notification` | `elicitation_dialog` | `waiting` |
| `PostToolUse`, `PostToolUseFailure` | — | `working` (clears `waiting` after you answer) |
| `Stop` | add next to the existing bell and Hammerspoon hooks | `done` |
| `StopFailure` | — | `error` (optional) |
| `SessionEnd` | — | `clear` |

- `PermissionRequest` is used over `Notification[permission_prompt]` because it fires as soon as the prompt appears
- `PreToolUse` can't clear `waiting`, because it fires before the permission check. `PostToolUse` does the clearing

### 3. `tmux/.tmux.conf` rendering

- **The mark stays gated on `IS_CLAUDE` (the version-number regex on `pane_current_command`). Only its colour comes from `@claude_state`.** That makes stale state harmless: if Claude crashes without `SessionEnd`, the pane is back at zsh and no mark shows. Sessions started before the hooks existed still show a grey ✦
- New snippet `CLAUDE_COLOR`: maps `#{@claude_state}` to a `$COLOR_*`, falling back to `$COLOR_DARK_GREY`. Add `COLOR_LIME` usage, and a pink/red entry to PALETTE if needed
- `CLAUDE_MARKS="#{P:#{?$IS_CLAUDE,#[fg=$CLAUDE_COLOR]✦,}}"`. `#{P:}` evaluates each pane's own option, so mixed states show mixed colours
- Drop the blanket `#[fg=$COLOR_ORANGE]` in `CLAUDE_STATUS` and `TREE_FORMAT`, since the marks colour themselves
- A `pane-focus-in` hook turns `done` into `idle` when you visit the pane (like the bell flag clearing). Relies on `focus-events on`, which is already set

### 4. Optional: simplify the Stop bell hook

Find the tty with `tmux display -p -t "$TMUX_PANE" '#{pane_tty}'` instead of `ps -o tty= -p $PPID`. Keep the bell itself: Ghostty's dock "attention" (`bell-features`) depends on it.

## Deploy / Test Order

1. Write the script, then `make stow-claude`. `~/.claude/hooks/` is already a real dir holding herdr's script, so stow links just the new file in
2. tmux rendering: reload, then fake states by hand (`tmux set -p @claude_state waiting`, etc.) in a few panes. Check the status bar and all three choose-tree views
3. Add the `settings.json` hooks. They only apply to Claude sessions started afterwards
4. Real session: prompt → orange; a non-allowlisted command → red; approve → orange; finish → lime; focus the pane → grey; `/exit` → mark gone. Also trigger an `AskUserQuestion` → red

## Risks / Unknowns

- **`pane-focus-in` might only fire on terminal focus changes, not tmux pane switches** [medium]. Fallback is `after-select-pane` + `after-select-window`. Check in step 2
- **Popups:** Claude inside the `M-/` `display-popup` may have no `$TMUX_PANE` of its own, so it gets no state or tags the pane underneath [medium]. The `M-g` float is a real pane and is fine
- **Notification matcher:** assumes `Notification` hook matchers match `notification_type` [medium-high]. If not, the script reads the type from stdin for that event only
- **Overhead:** `PostToolUse` runs on every tool call. A few ms per call should be unnoticeable; confirm it is

## Defaults Chosen (revisit before implementing)

- Colours: grey / orange / red / lime. Orange already means "Claude is here", so working stays orange
- `done` clears to `idle` when you focus the pane (vs. staying lime until the next prompt)
- `StopFailure` gets a pink `error` state
- No red pane border for `waiting` in this pass (overlaps with the pane-title border idea)

## Follow-up This Enables

Jump to whichever Claude needs you:

```tmux
bind -n M-c choose-tree -Z -f "#{==:#{@claude_state},waiting}" -F "$TREE_FORMAT"
```
