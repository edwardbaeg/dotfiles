# Neovim Config

## Overview

Lua-based Neovim config managed with [lazy.nvim](https://github.com/folke/lazy.nvim). Plugins are organized into individual files under `lua/plugins/`, either as single-plugin files or grouped by category (`*.group.lua`). Core config (options, keymaps, autocommands) lives in `lua/config/`. Options are intentionally loaded after plugins so plugin setup runs first.

Config changes are auto-detected and trigger a UI reload without restarting Neovim.

The full plugin list can be disabled by setting `vim.g.disable_plugins = true` before startup, which skips the lazy.nvim setup entirely.

## Directory Structure

```
nvim/
├── init.lua                  # Entry point — bootstraps config and lazy.nvim
├── lua/
│   ├── config/
│   │   ├── lazy.lua          # lazy.nvim bootstrap
│   │   ├── keymaps.lua       # Global keymaps
│   │   ├── autocommands.lua  # Global autocommands
│   │   ├── filetype.lua      # Filetype-specific settings
│   │   └── options.lua       # Vim options (loaded after plugins)
│   ├── plugins/              # One file per plugin, or grouped (*.group.lua)
│   └── utils/                # Shared utility functions
├── snippets/                 # Custom snippets
└── spell/                    # Custom spell files
```

Plugin files follow a naming convention: `plugin-name.lua` for standalone plugins, `category.plugin-name.lua` for categorized ones, and `category.group.lua` when multiple related plugins are configured together.

## Plugin Manager

[lazy.nvim](https://github.com/folke/lazy.nvim) is the plugin manager. It is self-bootstrapping — `lazy.lua` clones it from GitHub on first launch if it isn't already installed.

- Leader is set to `<Space>` and local leader to `,` in `lazy.lua`, before lazy loads, so all plugin keymaps pick up the correct leader.
- The Lazy UI is accessible via `<leader>la` or `:Lazy`.
- All plugins live under `~/.local/share/nvim/lazy/`. Plugin docs are accessible at `~/.local/share/nvim/lazy/<plugin-name>/doc/`.

## LSP

LSP is configured via [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) with [mason.nvim](https://github.com/mason-org/mason.nvim) managing server installation. Capabilities are provided by [blink.cmp](https://github.com/saghen/blink.cmp) and applied globally to all servers via `vim.lsp.config("*", ...)`.

### Servers

| Language | Server |
|---|---|
| TypeScript / JavaScript | typescript-tools.nvim (see below) |
| CSS | cssls |
| Lua | emmylua_ls |
| Shell (sh, zsh) | bashls |
| JSON | jsonls |
| YAML | yamlls |
| TOML | taplo |
| Terraform | terraformls |
| Markdown | marksman |
| Linting | eslint |

### TypeScript

TypeScript uses [typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim) instead of `ts_ls` or `vtsls`. It is a native Lua implementation that communicates directly with the TypeScript language server. Inlay hints are enabled for parameter names, return types, and variable types. TypeScript errors are translated to human-readable messages via [ts-error-translator.nvim](https://github.com/dmmulroy/ts-error-translator.nvim).

### UI

- [lspsaga.nvim](https://github.com/nvimdev/lspsaga.nvim) — diagnostic navigation (`ge`/`gE`), line/cursor/buffer diagnostic floats (`sl`/`sc`/`sb`)
- [tiny-code-action.nvim](https://github.com/rachartier/tiny-code-action.nvim) — code action picker (`<leader>ca`)
- [overlook.nvim](https://github.com/WilliamHsieh/overlook.nvim) — peek definition in a floating window (`gd`)
- [nvim-navbuddy](https://github.com/hasansujon786/nvim-navbuddy) — interactive symbol navigation (`<leader>gn`)
- [lsp_signature.nvim](https://github.com/ray-x/lsp_signature.nvim) — signature hints as virtual text while typing

## Code Formatting

Formatting is handled by [conform.nvim](https://github.com/stevearc/conform.nvim), lazy-loaded on `BufWritePre`. Format-on-save runs automatically with a 500ms timeout. Manual formatting is available via `:Format` or `<C-f>`.

For filetypes without a configured formatter, conform falls back to the attached LSP client (`lsp_format = "fallback"`).

### Formatters by filetype

| Filetype                           | Formatter                                 |
| ---------------------------------- | ----------------------------------------- |
| Lua                                | stylua                                    |
| JS / TS / JSX / TSX / JSON / JSONC | biome, then prettier (`stop_after_first`) |
| CSS / HTML / YAML / Markdown       | prettier                                  |
| sh / zsh                           | shfmt                                     |
| TOML                               | taplo (via LSP fallback)                  |

JS/TS files use `stop_after_first = true` — biome runs if available (i.e. a biome config exists in the project), otherwise prettier is used. They never both run on the same file.

### ESLint

ESLint fix-all (`LspEslintFixAll`) runs as a separate `BufWritePre` autocommand on buffers where the ESLint LSP is attached. This is distinct from formatting and handles lint-fixable issues (import ordering, unused vars, etc.).

### Tool installation

Formatter binaries are installed via mason through `mason-null-ls.nvim`'s `ensure_installed` list. [none-ls](https://github.com/nvimtools/none-ls.nvim) itself is only used for diagnostics (checkmake) — not for formatting.

## Keymaps

Leader is `<Space>`, local leader is `,`. Keymaps are defined in `lua/config/keymaps.lua` with plugin-specific keymaps living alongside their plugin configs. [which-key.nvim](https://github.com/folke/which-key.nvim) provides a popup for discovering keymaps.

### Leader namespace conventions

| Prefix | Purpose |
|---|---|
| `<leader>f` | Fuzzy finders / pickers |
| `<leader>g` | Go-to / git |
| `<leader>e` | Edit config files |
| `<leader>b` | Buffer operations |
| `<leader>t` | Tabs / toggles |
| `<leader>w` | Window (`<C-w>` alias) |
| `<leader>a` | Claude Code (AI) |
| `<leader>ob` | Obsidian |

### Notable global keymaps

| Key | Action |
|---|---|
| `jk` | Exit insert mode |
| `H` / `L` | Start / end of line |
| `<C-f>` | Format buffer |
| `Q` | Record macro (replaces `q`) |
| `<CR>` | `gf` — open file under cursor |
| `gD` | Go to definition via tag stack (`<C-t>` to return) |
| `g>>` / `g>d` | Go to definition in vertical split |
| `<leader><space>` | Clear search highlights |
| `_` | Black hole register shortcut |

## UI

### Colorscheme

[Catppuccin](https://github.com/catppuccin/nvim) Frappé with a transparent background. Loaded at startup with highest priority so it applies before other plugins modify highlights.

### Core UI components

- **Statusline** — [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- **Bufferline** — [dart.nvim](https://github.com/iofq/dart.nvim), navigated with `<Tab>` / `<S-Tab>`
- **Cmdline / notifications** — [noice.nvim](https://github.com/folke/noice.nvim) replaces the default cmdline and notification UI
- **Dashboard** — [alpha-nvim](https://github.com/goolord/alpha-nvim)
- **Indent guides** — [hlchunk.nvim](https://github.com/shellRaining/hlchunk.nvim) shows indent guides and highlights the current indent chunk
- **Scrollbar** — [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar) with gitsigns and search result markers
- **Winbar / breadcrumbs** — [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim)
- **Buffer name in splits** — [incline.nvim](https://github.com/b0o/incline.nvim)

## AI

### Inline completion

[neocodeium](https://github.com/monkoose/neocodeium) (Codeium) provides inline completions as virtual text. Suggestions are surfaced through [blink.cmp](https://github.com/saghen/blink.cmp) rather than the native suggestion UI.

Copilot ([copilot.lua](https://github.com/zbirenbaum/copilot.lua)) is also installed and used as the backend adapter for CodeCompanion chat and inline edits, but its own suggestion UI is disabled in favor of neocodeium.

### Chat / agentic

- **[CodeCompanion](https://github.com/olimorris/codecompanion.nvim)** — AI chat and inline editing within Neovim, using Copilot as the adapter. Open chat with `<leader>cc`, run inline prompts via `:CodeCompanion <prompt>`.
- **[claudecode.nvim](https://github.com/coder/claudecode.nvim)** — IDE integration that connects Neovim to a running Claude Code CLI session. Keymaps are under `<leader>a`: toggle (`<leader>ac`), focus (`<leader>af`), resume (`<leader>ar`), add current buffer (`<leader>ab`), send visual selection (`<leader>as`).
