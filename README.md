# dotfiles

This is my neovim and terminal based development setup: Neovim in Tmux in Wezterm in MacOSX. Always a work progress!

![screenshot](assets/main.png)

# Neovim

Configuration: [init.lua](nvim/init.lua)

- **Plugin Manager**: lazy.nvim
- **Colorscheme**: onedark/catppuccin
- **Smart stuff**: Treesitter, LSP, completion, snippets, fuzzy finder
- **Visuals**: statusline, tabline, scrollbar, whichkey, startpage
- **Motions/operators/jump**: textobjects, comments, surrounds, sorting
- **Terminal Integrations**: lazygit, ranger

Set up [below](#neovim-setup).

# Terminal

**Shell + Framework**: `zsh` + `oh-my-zsh`

- autocompletions, vi-mode, syntax highlighting, fzf, z jumping

## Terminal Apps

#### Tools

- `bat` better cat (syntax highlighting and pager)
- `eza` better ls
- `fd` better find
- `fzf` fuzzy finder
- `git-delta` better diff
- `ripgrep` better grep (and faster than ag)
- `zoxide` directory jumper
- `ncdu` ncurses disk usage viewer
- `tldr` community written short man pages

#### TUI

- `lazygit` git interface
- `neovim` better vim (async, community developed)
- `ranger` file manager (install with `pip install ranger-fm`)
- `tmux` terminal multiplexer
- `yazi` file manager, seemingly faster than ranger
- `nchat` telegram

#### Less common

- `hyperfine` commandline benchmarking
<!-- TODO: replace with fastfetch -->
- `neofetch` display system info
- `qrcp` qr code generator for wifi transfer

#### Dependencies

- `unar` for yazi, archive preview
- `poppler` for yazi, pdf preview
- `gnu-sed` for vim-spectre
- `zsh-completions` for zsh, command line autocompletions

**Terminal Multiplexer**: `tmux`

- Configuration: [tmux.conf](.tmux.conf)
  - keymaps, session keybing toggle

# MacOSX Setup

Install brew (this will also install x-code command line tools if you don't have them yet)

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Disable mouse acceleration

```
defaults write .GlobalPreferences com.apple.mouse.scaling -1
```

Enable key repeat

```
defaults write -g ApplePressAndHoldEnabled -bool false
```

- Settings -> Keyboard -> Key repeat rate & Delay until repeat

## Applications:

- `Raycast`: launcher, see ./raycast
- `Karabiner Elements`: remap keys; RShift -> Backspace; Fn -> Fn on external keyboards (maintain for builtin)
- `Mac Mouse Fix`: invert mouse scrolling, fancy remaps, add smooth scrolling
- `Shortcat`: keyboard shortcuts everywhere
- `Bartender`: keep menubar tidier
- `Choosy`: browser launcher
- `Shottr`: screenshot tool
- `Arc`: brower
- `Hammerspoon`: mac scripting
- `Stats`: menubar system monitoring
- `Dato`: menubar calendar and meetings
- `Monitor Control`: menubar monitor brightness
- `BetterTouchTool`: add shortcuts; 3 finger tap -> middle click

## oh-my-zsh

Install zsh framework

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

Install zsh plugin manager

```
https://github.com/tarjoilija/zgen | git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
```

Set up fzf

```
$(brew --prefix)/opt/fzf/install
```

## Neovim setup

Install neovim and pynvim (to support python plugins in nvim)

```
brew install neovim
pip3 install --upgrade pynvim
```

Ensure python is working with :checkhealth

### Dependencies

- `deno` - for peek.nvim
- `fzf`

## Hammerspoon

Configuration: [init.lua](hammerspoon/init.lua)

- window management, sleep toggle, toggle apps

## Keyboard

Keyboard layers (0-index), global keyboard bindings are managed through ZSA Oryx firmware, Hammerspoon

- Symbols, numbers
  - `Layer 1`
- System control, arrow keys
  - `Layer 2` + `,./`: media
  - `shift` + `ctrl` + `,./`: media
  - `Layer 2` + `hjkl`: arrow keys
  - `shift` + `ctrl` + `hjkl`: arrow keys
- Window movement
  - `cmd` + `ctrl` + `hjkl mnbv`: move, resize
  - `cmd` + `ctrl` + `shift` + `hjkl`, change display

## Configure git for github

- Create ssh key for git (press enter for default file location)
- https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

```
ssh-keygen -t rsa -b 4096 -C "youremail@domain.com"
```

- Start ssh-agent in background

```
eval "$(ssh-agent -s)"
```

- Add SSH key

```
ssh-add ~/.ssh/id_rsa
```

- Set config file to automatically load key

```
echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_rsa" > ~/.ssh/config
```

- Add key to GH account at https://github.com/settings/keys, using this command to copy key to clipboard:

```
pbcopy < ~/.ssh/id_rsa.pub
```

- Copy over or symlink `.gitconfig`. Example:

```
ln -s ~/dev/dotfiles/.gitconfig ~/.gitconfig
```
## Mods

- Spicetify: theme spotify
  - install cli tool, install marketplace, restart app
    ```
    spicetify --config
    spicetify backup apply
    spicetify update
    ```

# RaspberryPi Setup

See detailed instructions in the [raspberrypi directory](raspberrypi/README.md)

- fish (shell) + fisher (plugin manager) + tmux (terminal multiplexer)
