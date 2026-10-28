---
name: commit
description: Create git commits in the user's personal style — short lowercase conventional subjects (`feat: add error code guard`), no body, split into a few focused commits. Use whenever the user asks to commit ("commit this", "commit in a few commits", "commit in my style", "/commit"). Does not push.
---

## When to use

The user asked to commit. Only commit when asked, and never push, open a PR, amend, or force-push unless the user says so in this request.

## Style

Derived from ~350 of the user's own commits (dispatch frontend + dotfiles). Match it exactly:

- **Format:** `type: subject` — one line. Lowercase type, a colon, one space, lowercase subject.
- **No scope** — never `feat(ui): …`.
- **No ticket prefix** in commits. Tickets live in the branch name and PR title (squash merges carry `ENG-1234: …`), not here.
- **No trailing period.** No emoji.
- **Short:** ~3–7 words, ~30 characters on average, hard cap ~60. Terse fragments are fine: `feat: min width for names column`, `feat: darker bg`.
- **No body** by default. Add one only when the *why* isn't obvious from the subject, and keep it to a single short line (e.g. `design feedback`). Never a bullet list or summary of the diff.
- **Trailer:** if the session gives an attribution trailer (e.g. `Co-Authored-By: …`), append it after a blank line. It does not count as a body.

### Types

| Type | Use for | Real examples |
|---|---|---|
| `feat:` | default for most work — new behavior, UI changes, removals of product code, config | `feat: add error code guard`, `feat: remove fastOtp, unused now`, `feat: add stories` |
| `fix:` | correcting broken behavior, review/PR feedback, type or test fixes | `fix: conditionally show skip button`, `fix: debounce race condition`, `fix: pr feedback` |
| `refactor:` | no behavior change — renames, moves, extracting/abstracting, cleanup | `refactor: rename button`, `refactor: abstract component, create stories`, `refactor: fastotp -> LD FF` |
| `tests:` | test-only commits (note: plural) | `tests: add failing test`, `tests: init e2e for channel selector` |
| `docs:` | docs, comments, READMEs only | `docs: quote passwords`, `docs: clarify docusign selector visibility` |
| `chore:` | deps, version pins, tooling, housekeeping (mostly dotfiles) | `chore: pin version`, `chore: rm unused` |
| `perf:` | performance only | `perf: memoization` |

When unsure between `feat` and `chore`, the user leans `feat`.

### Subject wording

- Imperative-ish, but terse beats grammatical: `add …`, `remove …`, `update …`, `move …`, `show …`, `hide … if …`.
- `->` for a rename or replacement: `refactor: fastotp -> LD FF`, `feat: claude -> hammerspoon notifications`.
- Comma-join two closely related changes instead of writing a body: `feat: collapse uploads, column layout`, `refactor: clean up logo lookups and unused shadows`.
- Short reasons can ride along: `feat: remove fastOtp, unused now`.
- Common abbreviations are fine and in character: `rm`, `ds` (design system), `cta`, `FF` (feature flag), `bg`, `pr`.
- Name the thing that changed, not the file: `feat: add unassigned cta in header`, not `feat: update header.tsx`.
- Keep code identifiers in their real casing (`fastOtp`, `CompanyLogo`) — only the rest is lowercase.

## Splitting into commits

The user prefers several small, focused commits over one big one ("commit in a few commits"). Default to splitting when the diff has more than one concern:

1. **By layer/concern**, in dependency order so each commit makes sense on its own — e.g. backend route (+ its tests and dependency wiring) → client hook → UI (+ its tests).
2. **Keep tests with the code they cover**, unless the change is test-only (then `tests:`). A failing test written first gets its own `tests: add failing test` commit.
3. **Separate refactors from features.** A rename or move that the feature relies on goes first as `refactor:`.
4. **Docs/comments that aren't tied to a code change** get their own `docs:` commit (or `update docs, comments` only if that's genuinely all it is — prefer `docs:`).
5. Don't over-split: one logical change is one commit, even if it touches many files. Three to four commits is typical for a feature branch session.

## Workflow

1. `git status` and `git diff` (staged and unstaged) to see everything. Note untracked files.
2. **Leave out what doesn't belong:** build artifacts, local env files, temporary/debug files, screenshots, files from unrelated work. If unsure whether a file belongs, ask.
3. If the current branch is the default branch (`master`/`main`), stop and ask before committing.
4. Plan the commits (which files → which message). For anything non-obvious, show the plan in one short list before committing; for a straightforward split, just proceed.
5. Commit each group by staging **explicit paths** (`git add <paths>`, never `git add -A`/`.`) and passing the message via heredoc so the trailer formats correctly:

   ```bash
   git add path/a path/b && git commit -F - <<'EOF'
   feat: add hook to set advisor login mfa

   Co-Authored-By: <trailer from the session, if any>
   EOF
   ```

6. Let pre-commit hooks run — never `--no-verify`. If a hook fails, fix the cause and make a **new** commit attempt (don't amend a previous commit to fix it). If a hook auto-fixes files, that's expected; confirm the tree is clean afterwards.
7. Never use bare `git stash` (the stash stack is shared across worktrees). Hooks like lint-staged manage their own backup stash.
8. Finish with `git log --oneline <base>..HEAD` and `git status --short`, and report the commits. Mention if the branch has no upstream (first push should be `git push -u origin HEAD`) — but don't push.

## Don't

- Don't write PR-style subjects (`Add X to Y for Z users`), capitalized types (`Fix:` — an old style the user dropped), or scopes.
- Don't describe *how* in the subject (`refactor useFoo to use reducer and memo`) when *what* fits (`refactor: simplify foo state`).
- Don't invent a body to summarize the diff.
- Don't mix unrelated changes into one commit to save steps.
