# Neovim 0.11 → 0.12 Upgrade (Rollback-First)

## Context

Upgrading Neovim 0.11 → 0.12 on macOS. Goal is making rollback to 0.11 trivial (≤2 commands) in case 0.12 breaks plugins or workflows. Current install is Homebrew (`brew install neovim`, not pinned in Brewfile), which has no versioned formulas — so a clean rollback requires a real version manager. **bob** is purpose-built for nvim, switches versions via a single symlink at `~/.local/share/bob/nvim-bin/nvim`, and keeps both binaries side-by-side.

Config already favors clean rollback: `lazy-lock.json` is tracked in git at `nvim/lazy-lock.json` and uses no `has('nvim-0.11')` version gates anywhere.

## Decisions

- Install **stable 0.12.x** via bob (not nightly).
- **Uninstall** Homebrew nvim after bob is verified.
- Test 0.12 in parallel via `NVIM_APPNAME` before switching the real config.
- Tar `~/.local/share/nvim` etc. as a belt-and-suspenders backup (preserves Mason binaries).

## Step 1 — Install bob, keep brew nvim temporarily

```sh
brew install bob
bob install 0.11.x      # pins what you have today
bob install 0.12.x      # new target
bob use 0.11.x          # default still 0.11 for now
```

Ensure `~/.local/share/bob/nvim-bin` is ahead of `/opt/homebrew/bin` in `$PATH`. Verify: `which nvim` → bob's path, `nvim --version` → 0.11.x.

Add `brew "bob"` to `~/dev/dotfiles/brewfile` (low priority — can be done after verification).

## Step 2 — Pre-upgrade snapshot

From `~/dev/dotfiles/nvim/`:

```sh
git add lazy-lock.json
git commit -m "Snapshot: lazy-lock pre-0.12 upgrade"
git tag nvim-0.11-known-good
```

State-dir tarball (captures Mason binaries, plugin clones, shada, sessions):

```sh
tar czf ~/nvim-state-0.11-$(date +%Y%m%d).tgz \
  ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

## Step 3 — Parallel test with NVIM_APPNAME

`make stow-nvim` symlinks files (not directories) into `~/.config/nvim/`. For a real parallel sandbox we need a **copy**, not a stow:

```sh
cp -RL ~/.config/nvim ~/.config/nvim-012-test   # -L follows symlinks → real files
bob use 0.12.x
NVIM_APPNAME=nvim-012-test nvim
```

This isolates state at `~/.local/share/nvim-012-test/`, `~/.local/state/nvim-012-test/`, `~/.cache/nvim-012-test/` — your 0.11 plugin state stays untouched.

Inside the sandbox:
1. `:Lazy sync`
2. `:Mason` (re-install LSPs/formatters into the sandbox state dir, or skip and use system tools)
3. `:checkhealth`
4. `:help news` then `:help news-0.12`
5. Exercise daily workflows: LSP completion (blink.cmp), telescope/fzf-lua, codecompanion, treesitter highlights.

## Step 4 — Promote to primary

Once sandbox feels good:

```sh
bob use 0.12.x          # switches the global symlink
nvim                    # opens real config under 0.12
:Lazy sync
:Mason                  # in case any registry entries shifted
:TSUpdate
```

Commit any updated lock file:

```sh
cd ~/dev/dotfiles/nvim
git add lazy-lock.json
git commit -m "Chore: bump lazy-lock for nvim 0.12"
```

## Step 5 — Clean up

After ~1 week of stable use on 0.12:

```sh
brew uninstall neovim
rm -rf ~/.config/nvim-012-test ~/.local/share/nvim-012-test \
       ~/.local/state/nvim-012-test ~/.cache/nvim-012-test
# keep ~/nvim-state-0.11-*.tgz for a while longer
```

Update `~/dev/dotfiles/README.md` to reference bob instead of `brew install neovim`.

## Rollback

If 0.12 misbehaves:

```sh
bob use 0.11.x
cd ~/dev/dotfiles/nvim && \
  git checkout nvim-0.11-known-good -- lazy-lock.json && \
  nvim --headless "+Lazy! restore" +qa
```

That's it. If plugins are still wrong:

```sh
rm -rf ~/.local/share/nvim/lazy && nvim --headless "+Lazy! sync" +qa
```

Nuclear option (restores Mason + everything):

```sh
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
tar xzf ~/nvim-state-0.11-*.tgz -C /
```

## Plugins to watch

From `lazy-lock.json`, these track recent nvim APIs closely:

- **blink.cmp** — check CHANGELOG before `:Lazy sync`.
- **snacks.nvim**, **mini.nvim** — track HEAD; usually bumped within days of an nvim release.
- **nvim-lspconfig** — 0.12 continues the `vim.lsp.config()` migration; legacy paths may have been removed.
- **nvim-cmp** + **blink.cmp** — both lock entries present. Consider picking one as primary to reduce surface area (optional, separate task).
- **treesitter** — full `master` → `main` branch migration (breaking rewrite). See `nvim/lua/plugins/treesitter.group.lua`. Prereq: `brew install tree-sitter` (CLI ≥ 0.26.1). Run `:TSUpdate` after switching.
- **noice.nvim**, **image.nvim** — touch internals, smoke-test.

## Verification

After Step 4 promotion:

1. `nvim --version` reports 0.12.x
2. `:checkhealth` shows no new errors vs the 0.11 baseline
3. Open a TS/Lua file: LSP attaches, blink.cmp completes, conform formats on save
4. `:Telescope find_files` / fzf-lua works
5. Daily-use plugins (codecompanion, claudecode, yazi, diffview) open without errors
6. `:Lazy` — all plugins green, no build failures
