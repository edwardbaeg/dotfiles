# Neovim 0.12 Upgrade: Required Config Changes

## Context
Neovim 0.12 introduces new deprecations and removes some previously-deprecated APIs. Your config is already mostly targeting 0.11+ (uses `vim.lsp.config()`, `vim.uv or vim.loop` guards, etc.), so the upgrade impact is relatively small.

---

## Changes Required in YOUR Config

### 1. `vim.keymap.set` `buffer` option renamed to `buf` (deprecated in 0.12)

In 0.12, the `buffer` key in the opts table for `vim.keymap.set`/`vim.keymap.del` is deprecated in favor of `buf`. These will emit deprecation warnings and eventually break.

**Files to update:**
- `lua/config/autocommands.lua:7` — `{ remap = true, buffer = true }` -> `{ remap = true, buf = true }`
- `lua/config/autocommands.lua:70` — `{ buffer = event.buf, silent = true }` -> `{ buf = event.buf, silent = true }`
- `lua/config/autocommands.lua:78` — `{ buffer = event.buf }` -> `{ buf = event.buf }`
- `lua/plugins/collection.mini.lua:61` — `{ buffer = buf_id, desc = desc }` -> `{ buf = buf_id, desc = desc }`

### 2. `vim.lsp.util.stylize_markdown` deprecated (0.12)

- `lua/plugins/noice.lua:43-44` — Noice overrides `vim.lsp.util.convert_input_to_markdown_lines` and `vim.lsp.util.stylize_markdown`
- **Action: No code change needed from you.** This is Noice's responsibility. Monitor noice.nvim for an update. You may see deprecation warnings until Folke updates the plugin.

### 3. `vim.lsp.config.eslint.on_attach` access (potentially fragile in 0.12)

- `lua/plugins/lsp.group.lua:153` — `local base_on_attach = vim.lsp.config.eslint.on_attach`
- This reads the default eslint `on_attach` from nvim-lspconfig's config files. The `vim.lsp.config` table access pattern may change. **Monitor for breakage** — if eslint's default config structure changes, this line will error.

---

## Things to Watch (plugin-level, not your config)

### 4. nvim-treesitter `master` branch

- `lua/plugins/treesitter.group.lua:19` — `branch = "master"`
- `lua/plugins/treesitter.group.lua:13` — `nvim-treesitter-textobjects` also on `branch = "master"`
- The `master` branch is the legacy branch; `main` is the active one. It still works on 0.12 but will increasingly lag. Migration to `main` would require dropping `incremental_selection` from the configs module (use a separate plugin or native alternative).

### 5. Duplicate commenting plugins

- Both `folke/ts-comments.nvim` (line 152) and `numToStr/Comment.nvim` (line 160) are loaded
- Neovim 0.10+ has native commenting (`gc`/`gcc`), and `ts-comments.nvim` enhances it with treesitter context awareness. `Comment.nvim` may be redundant now. Not a 0.12 breakage, but worth cleaning up.

---

## NOT affected (already correct)

- `vim.uv or vim.loop` guards — already compatible
- `vim.diagnostic.goto_prev/next` — only in commented-out code
- `vim.lsp.buf.hover()` / `signature_help()` with options table — modern 0.11+ API
- `vim.diagnostic.config()` with `virtual_text` — explicitly set
- No use of `vim.lsp.get_active_clients()`, `vim.lsp.buf.formatting()`, or other removed APIs

---

## Summary

| Priority | Change | File(s) |
|----------|--------|---------|
| **Do now** | Rename `buffer` -> `buf` in `vim.keymap.set` opts | autocommands.lua, collection.mini.lua |
| **Watch** | Noice `stylize_markdown` deprecation | noice.lua (plugin update needed) |
| **Watch** | `vim.lsp.config.eslint.on_attach` access | lsp.group.lua:153 |
| **Consider** | Migrate nvim-treesitter to `main` branch | treesitter.group.lua |
| **Consider** | Remove redundant `Comment.nvim` | treesitter.group.lua |
