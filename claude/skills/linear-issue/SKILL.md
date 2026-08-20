---
name: linear-issue
description: Create or fill in a Linear issue using the user's fixed, lean issue template. Trigger when asked to write, create, or fill in a Linear issue (e.g. "fill in ENG-2254", "create an issue for X", "let's do the next issue").
---

## When to use

The user wants a Linear issue written — either filling an existing issue (given a URL or `ENG-####`) or creating a new one. One issue at a time.

## Guiding rules

- **"As short as possible, but not shorter."** Lean by default; every line earns its place.
- **Never write an issue with unresolved questions.** If anything is ambiguous or undecided, ask the user and keep prompting until every open point is resolved. Do not park questions in the issue body — the issue that gets saved is fully decided.
- **Prefer high-level direction over prescription.** Issues often sit for 2+ weeks before anyone picks them up, so exact file paths and line-coupled instructions go stale. Naming a file or an area of the codebase as a pointer is fine; spelling out precise edits is not.
- **Title says what the work is.** Someone outside the project should be able to tell what the issue tackles from the title alone. The user's starting title is just that — a starting point; the finished body often reveals a sharper one.

## Template

Fixed structure (Notes optional):

- **Summary** — 1–2 sentences: what this delivers and why. No background.
- **Scope** — checklist of concrete deliverables (the _in_). Add one `Out of scope:` line only when there's a real boundary worth naming.
- **Notes** _(optional)_ — guidance and callouts. Skip when scope is self-evident.
- **Acceptance criteria** — checklist of observable done-conditions, phrased as outcomes not steps.
- **Refs** — pointers to source material (doc sections, related issues) and, loosely, the areas of the codebase involved.

**Callout convention** (inside Notes; Linear renders `>` blockquotes):

- `> ⚠️ **Gotcha:** …` — non-obvious trap worth flagging

Do NOT write issue dependencies ("depends on / blocks / blocked by") into the body — those are Linear's native relation feature, set via the relation fields, not prose.

## Handling existing content

When filling an issue that already has content:

1. **Understand it** — read the current description and work out what it is actually asking.
2. **Judge useful vs slop** — decide whether it was thoughtfully added or carelessly dumped. If useful, preserve every key detail in the result; never drop signal. If slop, discard it freely.
3. **Detect prior skill output** — if the existing issue looks like it was written by this skill (the template structure above), switch to **editing mode**: refine and tighten the existing issue in place rather than rewriting from scratch.

## When the issue lacks detail

If the issue isn't already fleshed out (empty, a one-liner, or vague), don't guess — do discovery first:

1. **Turn effort up** — operate at high or ultra-high reasoning effort for the rest of the flow, and spawn the exploration subagent at high effort too.
2. **Enough to explore on?** If the issue doesn't point at a concrete feature or area of code, stop and ask the user for a few clarifying pieces (which surface/flow, the rough goal, any constraints) before going further.
3. **Spawn a subagent to explore** the relevant part of the codebase. Task it to:
   - Understand the code as-is.
   - Surface confusing parts, gaps, and rough edges.
   - Propose a pragmatic scope that walks the line between "leave the campsite cleaner than you found it" and "done in reasonable time at reasonable risk."
   - Report back a clear, concise summary of what the issue is about — not a file dump.
4. **Synthesize** — take the subagent's summary, apply your own judgment, and craft (or refine) the issue in the template.

## Workflow

1. **Read/gather.** Existing issue → `get_issue` for title, milestone/project, and current description, then apply "Handling existing content." New issue → gather title/team/project from the user.
2. **Gauge detail.** If the issue is already well-specified, source any extra context from what the user provides (reference doc, title, conversation) and lightly search the codebase to sharpen understanding — write accurate high-level direction, don't transcribe exact paths and line numbers. If it's sparse or vague, run "When the issue lacks detail" first.
3. **Resolve every open question with the user first.** Only draft the description once nothing is unresolved.
4. **Preview the draft in chat and wait for approval.** Do not write to Linear unsupervised.
5. On approval, `save_issue` to create (needs `title` + `team`) or update (by `id`). Set `estimate` / `milestone` / `blockedBy` / `blocks` only if the user asks.
6. **Refine the title.** With the body final, reassess whether an outsider could tell what the work is from the title alone. If not, update it — a follow-up edit after saving the body is fine, since the finished issue usually points at a clearer title than the one you started with.

## Notes

- Code snippets should be the minimum that removes ambiguity — a signature or a type, not full implementations.
- If a source doc and the issue title disagree on scope, surface it before drafting rather than guessing.
- Keep acceptance criteria observable (runs clean, returns X, gated by flag) — not "implement Y."
