# nvim: Replace Codeium Inline Completion

**Status:** parked (2026-10-27). Option 1 (Copilot) is implemented but uncommitted. It's a stash on `codeium-to-copilot`, and master still runs neocodeium. Option 2 (local llama.vim) is still being looked into.

## Problem

Inline ghost-text completion currently comes from `monkoose/neocodeium` (`nvim/lua/plugins/ai.codeium.lua`). The goal is to move off Codeium while keeping the same feel: fast, automatic ghost text, with the same keys.

## Options Considered

```
                 speed    context            cost                  runs where
Copilot          fast     open tabs          ~$10/mo (free ~2k/mo) GitHub cloud    ◄─ option 1
llama.vim local  fast     open files+yanks   free                  this Mac (M5 Pro, 48GB) ◄─ option 2
Codestral+minuet medium   current buffer     free tier / cheap     Mistral cloud
Claude/OpenAI    slow     current buffer     per-token             via minuet-ai.nvim
Supermaven       fast     large              —                     sunset after Cursor acquisition; skip
```

- **Claude/OpenAI via minuet-ai.nvim was rejected.** They're chat models, not fill-in-the-middle models, so suggestions take 0.5–2s+. You pay per request, the model only sees the current buffer, and auto-trigger is off by default. Compared with Codeium that's a downgrade.
- **Neovim 0.12 has built-in `vim.lsp.inline_completion`.** It's only a client, though: it shows suggestions from a language server that supports `textDocument/inlineCompletion`, such as copilot-language-server. It doesn't call LLM APIs itself.

## Option 1: Copilot (implemented, in stash)

```
mason ─► copilot-language-server ─► vim.lsp (built-in, 0.12)
                                     ├─► vim.lsp.inline_completion  → ghost text
                                     └─► sidekick.nvim               → next edit suggestions (NES)
```

### Where It Lives

Stash `WIP on codeium-to-copilot: 3001756` (it was `stash@{1}`; numbers shift, so find it by message in `git stash list`). The branch itself has no nvim commits.

```
git switch codeium-to-copilot && git stash apply <stash ref>
```

### Changes

- **`plugins/lsp.group.lua`:** adds `copilot = {}` to `language_servers`. mason-lspconfig maps that to the `copilot-language-server` package and enables it automatically.
- **`plugins/ai.copilot.lua`:**
  - Adds `folke/sidekick.nvim` (VeryLazy). Its `config` calls `vim.lsp.inline_completion.enable()` globally and sets the keymaps.
  - Turns inline completion and NES (`vim.b.sidekick_nes`) off per buffer for `help`, `gitcommit` and `gitrebase`, from the `FileType` autocmd plus a loop over buffers already open. The loop matters when nvim was launched as `$EDITOR` for a commit.
  - Sets `copilot.lua` to `enabled = false` and removes it from CopilotChat's dependencies; CopilotChat's README no longer requires it.
- **`plugins/ai.codeium.lua`:** neocodeium is set to `enabled = false`.
- **`plugins/cmp.blink-cmp.lua`:** removes the `blink-cmp-copilot` source and its dependency. That source requires copilot.lua's `copilot.api` and threw an error on every `InsertEnter` once copilot.lua was disabled. Ghost text replaces the menu source anyway.
- **`config/options.lua`:** `ComplHint` (the built-in ghost-text highlight group) set to `fg = #bbbbbb`, matching the old `CodeiumSuggestion`.
- **`lazy-lock.json`:** `Lazy! install` also bumped other plugins' pins. Revert those if unwanted.

### Keymaps

| Key | Mode | Action |
|---|---|---|
| `<Right>` | i | Accept, or fall back to `<Right>` |
| `<a-l>` | i | Accept |
| `<c-j>` / `<c-k>` | i | `inline_completion.select({count = ±1})` |
| `<A-w>` | i | Accept next word (custom) |
| `<A-f>` | i | Accept rest of line (custom) |
| `<M-l>` | n | sidekick `nes_jump_or_apply()`. Upstream default is `<Tab>`, but dart.nvim owns normal-mode `<tab>`. |

Partial accept is custom code. `get()` only accepts whole items, so `accept_partial()` uses the `on_accept` hook. It strips the already-typed prefix (Copilot's range usually starts at the beginning of the line), takes the next word or line of what's left, inserts that with `nvim_buf_set_text`, then returns `nil` so the full item isn't applied.

### Verified (headless)

- copilot client attaches and supports `textDocument/inlineCompletion`
- inline completion is on in normal buffers and off in gitcommit, with NES off there too
- keymaps are set, and no errors when typing in insert mode after the blink fix
- headless gotcha: lazy.nvim's `VeryLazy` doesn't fire, so force it with `require("lazy").load({ plugins = { "sidekick.nvim" } })`

### TODO

- [ ] `:LspCopilotSignIn`: the server reported `NotSignedIn`
- [ ] test `<A-w>` / `<A-f>` partial accepts against a live suggestion
- [ ] try NES with `<M-l>` and decide whether the key works
- [ ] lualine: `"codeium#GetStatusString"` in `ui.lualine.lua` is dead (codeium.vim was already disabled). Replace it with sidekick's `require("sidekick.status").get()` component or remove it.
- [ ] decide whether to keep the `lazy-lock.json` bumps
- [ ] commit on `codeium-to-copilot`, then merge
- [ ] `:Lazy clean` to drop blink-cmp-copilot and copilot.lua

## Option 2: Local llama.vim (being looked into)

- `ggml-org/llama.vim`, backed by a local `llama-server` running a fill-in-the-middle coder model, e.g. Qwen2.5-Coder 7B or Qwen3 FIM 7B (`brew install llama.cpp`, then `llama-server --fim-qwen-7b-default`).
- Pros: free, unlimited, private, latency close to Codeium on Apple Silicon. For context it keeps chunks from open files and yanks.
- Cons:
  - Suggestions are somewhat weaker than Copilot's.
  - The server has to stay running (launchd or `brew services`).
  - The plugin is Vimscript with Tab/S-Tab default keys, so it needs remapping to the keymaps above.
- Not supported by the built-in `vim.lsp.inline_completion`: llama.vim draws its own ghost text.

## References

- `:help lsp-inline_completion` (Neovim 0.12)
- https://github.com/folke/sidekick.nvim
- https://www.lazyvim.org/extras/ai/copilot-native
- https://github.com/ggml-org/llama.vim
- https://github.com/milanglacier/minuet-ai.nvim (the rejected Claude/OpenAI route)
