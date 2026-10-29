# Agent Instructions

Global instructions for any coding agent.

## Secrets
- Never read files named exactly `.env` (e.g. `~/.env`, a project's `.env`): no reading, printing, or grepping them, and no running commands or scripts that source or load them, since that exposes the values too
- Variants like `.env.example` are fine to read
- If a value from a `.env` is needed, ask the user, or have them run the command themselves
