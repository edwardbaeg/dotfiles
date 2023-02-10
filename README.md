# dotfiles
This is my terminal-based development set up! Always a work progress.
![screenshot](assets/main.png)

## Terminal
**App**: iTerm2
- `font`: Operator Mono (main, has cursive for italics) + MesloLGS NF (non-ASCII font)
- `margins` 20px
- `window style` no title bar

**Shell + Framework**: zsh + oh-my-zsh
**Shell + Plugin manager**: fish + fisher

**Homebrew formulae** (`brew leaves`):
- Utilities
  - `bat` better cat (syntax highlighting and pager)
  - `delta` better diff
  - `fzf` fuzzy finder
  - `ncdu` ncurses disk usage viewer
  - `neofetch` display system info
  - `neovim` better vim (async, community developed)
  - `ranger` visual file manager
  - `ripgrep` better grep (and faster than ag)
  - `tldr` community written short man pages
  - `tmux` terminal multiplexer
  - `zsh-completions` command line autocompletions

## (neo)vim
**Plugin Manager**: `vim-plug` minimal and super fast with parallel operations

**Top Plugins**:
- Visual
  - `sjl/badwolf` colorscheme
  - `tpope/vim-airline` lightweight statusbar
  - `airblade/vim-gitgutter` view git diff in gutter
  - `junegunn/goyo.vim` distraction free mode
  - `ryanoasis/vim-devicons` adds file icons to nerdtree and vim-airline
  - `unblevable/quick-scope` highlights `f`/`t` targets
  - `machakann/vim-highlightedyank` highlights yanked text
  - `rrethy/vim-illuminate` underlines matching text
- File Management
  - `/usr/local/opt/fzf`, `junegunn/fzf.vim` fuzzy finder
  - `tpope/vim-fugitive` git wrapper
- Shortcuts
  - `tpope/vim-surround` adds surround motions
  - `tpope/vim-commentary` adds comment motions
  - `SirVer/ultisnips` snippet engine
  - `honza/vim-snippets` default snippets
  - `mattn/emmet-vim` fast html setup
- Utility
  - `w0rp/ale` async linting engine
  - `Shougo/deoplete.nvim` async autocompletions
  - `vimwiki/vimwiki` personal wiki
  - `suan/vim-instant-markdown` live preview markdown
  - `zhimsel/vim-stay` save cursor/folds/bookmarks
  - `simnalamburt/vim-mundo` visual undo tree
  - `Carpetsmoker/undofile_warn.vim` persistent undo warnings

## hammerspoon (init.lua)
OSX automation

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
/usr/local/opt/fzf/install
```

#### Configure git for github
- Create ssh key for git (press enter for default file location)
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

- Add key to GH account at  https://github.com/settings/keys, using this command to copy key to clipboard:
```
pbcopy < ~/.ssh/id_rsa.pub
```
- Copy over or symlink `.gitconfig`. Example:
```
ln -s ~/dev/dotfiles/.gitconfig ~/.gitconfig
```

#### Neovim
Install neovim with python3
```
brew install neovim
python3 -m pip install --user --upgrade pynvim
```

Install plugins (in neovim):
```
:Lazy
```

#### iTerm2 Settings

These are captured in [iterm2](/iterm2)

- Fonts (profile -> text)
  - Operator Mono
  - Hack Nerd Font Complete (use a different font for non-ascii text)
- Colors (profile -> colors)
  - Background: `#1C1C1C` (same as neovim background)
  - Color presets: tango dark; red -> `#ff4949`
- Profile -> window -> style -> no title bar
- Profile -> keys -> Left/Right option key -> Esc+ (for tmux compatibility)
- Margins (Advanced -> search margin)
  - 20 (Height of top and bottom margins in terminal panes)
  - 20 (Height of left and right margins in terminal panes)

# RaspberryPi Setup
See detailed instructions in the [raspberrypi directory](raspberrypi/README.md)
- fish (shell) + fisher (plugin manager) + tmux (terminal multiplexer)
