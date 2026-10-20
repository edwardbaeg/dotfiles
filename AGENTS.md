# Dotfiles

## Stow

- After any filesystem changes (adding files, creating subdirectories, deleting files), symlinks in the target location must be updated
- Run `make stow-<target>` from `~/dev/dotfiles` — e.g. `make stow-hammerspoon` after hammerspoon changes
- The Makefile at `~/dev/dotfiles/Makefile` has a target for each package

## Hammerspoon

### Disable autoreload before editing
`hammerspoon/config_reloader.lua` watches `~/dev/dotfiles/hammerspoon/` and runs `hs.reload()` on any `.lua` change, which reloads half-written config and drops the `hs` IPC port mid-reload.

- Before making changes, disable it:
  `hs -c 'require("common.feature_registry").get("autoreload").disable()'`
- When done, re-enable it so the user can test (enabling also triggers an immediate reload):
  `hs -c 'require("common.feature_registry").get("autoreload").enable()'`
- Check state: `hs -c 'print(require("common.feature_registry").get("autoreload").isEnabled())'`
- Also available as `hammerspoon://autoreload?action=enable|disable|toggle`, or by clicking `AR✓`/`AR✗` in the menubar
