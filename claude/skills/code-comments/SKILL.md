---
name: code-comments
description: Rules for writing as few inline code comments as possible, short and for human readers, with nothing that goes stale (no ticket numbers, dates, change history, or references to the current task). Use whenever writing, editing, or reviewing code in any language — adding a comment, refactoring commented code, or cleaning up comments.
---

## Default: don't write the comment

Most code needs no comment. Before adding one, try in this order:

1. **Rename** the variable, function, or parameter so the code says it.
2. **Extract** a well-named variable, constant, or function (`const ONE_DAY_MS = 24 * 60 * 60 * 1000` instead of `// 86400000 = 1 day`).
3. **Use types** to carry the meaning (a union, a branded type, a narrower signature).

Only if the code still can't say it, write a comment. If you can't write a clear one-liner, the code is probably the problem — simplify it instead.

## What a comment is for

Comments explain **why**, never **what** or **how**. Good reasons to comment:

- **Code that looks wrong but isn't** — so nobody "simplifies" it: `// Read before the await; the cache clears on resolve.`
- **Non-obvious constraints or invariants** — ordering, timing, units, thread-safety, "must stay in sync with X".
- **Why this approach over the obvious one**: `// Linear scan: n is always < 10 and this runs once.`
- **Workarounds** for an external bug or quirk — describe the behavior being worked around, in words.
- **Attribution** for copied code (a stable public URL, e.g. the original docs or Stack Overflow answer).

## Write for humans

- **One line**, two at most. Plain sentence-case prose; no period needed for a fragment.
- Say it the way you'd tell a teammate — no buzzwords, no hedging, no emoji, no `NOTE:`/`IMPORTANT:` shouting.
- Doc comments (JSDoc/TSDoc/docstrings) only on public APIs whose behavior isn't obvious from the signature, and never repeat the types.

## Never put in a comment (it goes stale)

| Don't | Why | Instead |
|---|---|---|
| Ticket / issue / PR numbers (`ENG-4561`, `#8776`, `JIRA-892`) | Trackers move, links rot, readers can't see them | State the actual reason; the ticket belongs in the commit/PR, where `git blame` finds it |
| Change history: `// updated to…`, `// removed X`, `// moved from Y`, `// new:`, `// fixed:`, `// previously…` | Describes a diff, not the code; meaningless after merge | Nothing — that's what git is for |
| The current task or conversation: `// as requested`, `// per the plan`, `// step 3`, `// added for the new feature` | Only makes sense today | Nothing, or the lasting *why* |
| Dates, versions, names: `// as of Oct 2026`, `// v2 behavior`, `// Alex's fix` | Rots silently | The condition that matters (`// until the API returns ids`) |
| File paths and line numbers: `// see foo.ts:120` | Breaks on the next edit | A symbol name (`see parseRow`) if a pointer is truly needed |
| Counts and lists that mirror the code: `// handles the 3 cases below` | Wrong as soon as a case is added | Nothing |
| Narration: `// loop over users`, `// return the result`, `// call the API` | Restates the code | Nothing |
| Section banners and dividers: `// ===== Helpers =====` | Noise; use structure (files, functions) | Nothing |
| Commented-out code | Dead weight; git has it | Delete it |
| Vague TODOs: `// TODO: fix later` | Never actionable | Fix it now, or a TODO that names the missing behavior and the condition to remove it — no ticket number |

## Editing existing code

- **Don't add comments to code you're only touching incidentally.**
- When you change code, **fix or delete the comments on those lines** so they stay true. A wrong comment is worse than none.
- **Keep** existing comments that explain a non-obvious why, a gotcha, or a workaround — even while refactoring. Rewrite them if your change alters the reason.
- Don't sweep-delete comments in unrelated code unless asked; if asked to clean up comments, apply these rules file-wide.

## Quick check before finishing

For every comment you added or changed:

1. Could a rename or extraction make it unnecessary? → do that, delete the comment.
2. Is it *why*, not *what*? → if not, delete it.
3. Will it still be true and meaningful in a year, to someone who never saw this task? → if not, rewrite or delete.
4. Is it one or two short lines of plain language? → if not, tighten it.
