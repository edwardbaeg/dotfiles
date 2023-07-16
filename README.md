# dotfiles

This is my neovim based terminal development setup. Always a work progress!
![screenshot](assets/main.png)

# Neovim

Configuration: [init.lua](nvim/init.lua)

- **Plugin Manager**: lazy.nvim
- **Colorscheme**: onedark/catppuccin
- **Smart stuff**: Treesitter, LSP, completion, snippets, fuzzy finder
- **Visuals**: statusline, tabline, scrollbar, whichkey, startpage
- **Motions/operators/jump**: textobjects, comments, surrounds, sorting
- **Terminal Integrations**: lazygit, ranger

# Terminal

**Shell + Framework**: `zsh` + `oh-my-zsh`

- autocompletions, vi-mode, syntax highlighting, fzf, z jumping

**Apps used by config**:

- `bat` better cat (syntax highlighting and pager)
- `git-delta` better diff
- `fzf` fuzzy finder
- `lazygit` tui for git
- `neofetch` display system info
- `neovim` better vim (async, community developed)
- `ranger` visual file manager (install with `pip install ranger-fm`)
- `ripgrep` better grep (and faster than ag)
- `tmux` terminal multiplexer
- `zoxide` directory jumper
- `zsh-completions` command line autocompletions

**Multiplexer**: `tmux`

- Configuration: [tmux.conf](.tmux.conf)
  - keymaps, session keybing toggle

**App**: iTerm2

- Load Preferences: `General -> Preferences -> [x] Load preferences from a custom folder or URL -> ./iterm2`
  - Some changes made:
    - `margins`: 8px
    - `key bindings`: ignore `cmd k`
- Load Profile: `Profiles -> Other Actions -> Import JSON profiles`
  - Some changes made:
    - `text`:
      - Operator Mono Book (main font, has cursive for italics)
      - MesloLGS NF (non-ASCII font)
    - `window style`: no title bar
    - `keys`: Left / Right option key -> Esc+ (tmux compatibility)

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

#### oh-my-zsh

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

#### Neovim

Install neovim and pynvim (to support python plugins in nvim)

```
brew install neovim
pip3 install --upgrade pynvim
```

**Homebrew formulae** (`brew leaves`):

- `ncdu` ncurses disk usage viewer
- `tldr` community written short man pages
- `hyperfine` commandline benchmarking

### Hammerspoon

Configuration: [init.lua](hammerspoon/init.lua)

- window management, sleep toggle, toggle apps

### Configure git for github

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

# RaspberryPi Setup

See detailed instructions in the [raspberrypi directory](raspberrypi/README.md)

- fish (shell) + fisher (plugin manager) + tmux (terminal multiplexer)
