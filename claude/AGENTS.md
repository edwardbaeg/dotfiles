# Agent Instructions

Global instructions for any coding agent.

## Secrets
- Never read files named exactly `.env` (e.g. `~/.env`, a project's `.env`): no reading, printing, or grepping them, and no running commands or scripts that source or load them, since that exposes the values too
- Variants like `.env.example` are fine to read
- If a value from a `.env` is needed, ask the user, or have them run the command themselves

## Testing worktree changes in the main checkout
- When asked to let the user test a worktree's uncommitted changes in their main checkout, snapshot them as a detached commit; this creates no branch, moves no ref, and leaves the worktree untouched:
  ```sh
  cd <worktree>
  tmp=$(mktemp); cp "$(git rev-parse --git-path index)" "$tmp"
  GIT_INDEX_FILE=$tmp git add -A            # tracked + new files, respects .gitignore
  tree=$(GIT_INDEX_FILE=$tmp git write-tree); rm "$tmp"
  sha=$(git commit-tree "$tree" -p HEAD -m "snapshot: $(git branch --show-current) (uncommitted worktree changes)")
  git -C <main checkout> checkout --detach "$sha"   # only if `git -C <main checkout> status --short` is empty
  ```
- Check that the main checkout is clean first; if it isn't, stop and ask. Re-run after the worktree changes to refresh the snapshot. Return with `git -C <main checkout> checkout master` (or the branch it was on)
- The main checkout may need `npm ci` / `npm run build:packages` if the snapshot's base differs from what it last built

## Herdr
- When delegating to helpers of any kind (Herdr agents, in-process subagents, a Codex run), rename yourself as lead and label your tab: `herdr agent rename <my-pane> lead-<topic>`, then `herdr tab rename <my-tab> "lead: lead-<topic>"`
- Give each Herdr helper its own tab in the current workspace instead of splitting your pane: `herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd "$PWD" --label "<role>: <name>" --no-focus`, then `herdr agent start <name> --kind <kind> --pane <root_pane_id>`
- Label a helper's tab `<role>: <agent-name>`, where the role says what the helper is for, e.g. `ticket: import-api-action` (implements a ticket) or `discuss: spreadsheet-import` (talks a topic through with the user). Agent names can't hold `:` or spaces, so the prefix goes only on the tab label
- When an agent (lead or helper) belongs to a Linear ticket, put the lowercase ticket ID in its name, right after any `lead-` prefix: `lead-eng-5063-api-only-forms`, `eng-5128-channel-rules`, tab `ticket: eng-5128-channel-rules`. Agent names are capped at 32 characters, so keep the topic short. When renaming an agent, tell any lead that addresses it by name
- When starting an agent in a workspace you set up (e.g. a new worktree), make the first instruction in its brief to rename itself `lead-<topic>` and label its tab `"lead: lead-<topic>"`; it won't do this unprompted
- Moving a pane that hosts an agent (`herdr pane move`) breaks any running `herdr agent wait` on it (`agent_not_running`); restart the wait
