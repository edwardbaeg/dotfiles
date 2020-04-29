# dotfiles
This is my terminal-based development set up! Always a work progress.
![screenshot](assets/main.png)

## Terminal
**App**: iterm2
- `font`: Operator Mono + Hack Nerd Font Complete
- `margins` 30px
- `window style` no title bar

**Shell**: zsh

**Framework**: oh-my-zsh

**zsh plugins**:
- `z` autojump, extendible with fzf
- `git` lots of git aliases
- `vi-mode` vi mode for shell commands
- `zsh-users/zsh-syntax-highlighting` syntax highlighting in terminal
- `zsh-users/zsh-autosuggestions` autocomplete based on command history
- `zsh-users/zsh-history-substring-search` cycle through previous commands
- `changyuheng/fz` fzf tab completion with z

**Homebrew formulae** (`brew leaves`):
- Utilities
  - `zplug` plugin manager for zsh
  - `fzf` fuzzy finder
  - `howdoi` search stackexchange
  - `hub` github wrapper
  - `neovim` better vim (async, community developed)
  - `ranger` visual file manager
  - `ripgrep` better grep (and faster than ag)
  - `tmux` terminal multiplexer
  - `zsh` better shell
- Visual
  - `bat` better cat (syntax highlighting and pager)
  - `diff-so-fancy` better diff
  - `exa` better ls, can draw directory trees
  - `highlight` adds syntax highlighting to ranger previews
  - `tty-clock` terminal clock
  - `zsh-completions` command line autocompletions
- Fun
  - `neofetch` display system info
  - `rtv` reddit terminal viewer
  - `thefuck` quick fix failed commands
  - `shpotify` control spotify

**npm packages** `(npm -g ls --depth=0)`:
- `eslint` javascript linter
- `instant-markdown` live preview markdown with (neo)vim
- `tldr` community written short man pages
- `vtop` visual terminal activity monitor

**pip packages** `(pip list)`
- `mackup` backup MacOS configuration files

**pip2.7 packages** `(pip2.7 list)`
- `gcalcli` view google calendar in calendar

## (neo)vim
**Plugin Manager**: `vim-plug` minimal and super fast with parallel operations

**Custom JS Syntax Highlighting Rules + Colors** for minimal visual noise. Based on badwolf

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
  - `suan/vim-instant-markdown` live prewview markdown
  - `zhimsel/vim-stay` save cursor/folds/bookmarks
  - `simnalamburt/vim-mundo` visual undo tree
  - `Carpetsmoker/undofile_warn.vim` persistent undo warnings

## .gitconfig
- `difftool` diff-so-fancy
- `mergetool` meld

# How To Set Up And Configure
### Initial setup from a clean Mac
This includes installing brew, git, python, node, etc

Install brew (this will also install x-code command line tools if you don't have them yet)
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
Install node, python
```
brew install node python3
```
Some brew packagres
```
brew install ranger ripgrep bat exa highlight neofetch thefuck shpotify
```
Some node packages
```
npm i -g git-open instant-markdown vtop
```

#### Install and configure zsh and oh-my-zsh
Install zsh, zsh plugin manager, and fuzzy searching plugin
```
brew install zsh zplug fzf
```
Install oh-my-zsh, a zsh framework
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```
Copy over or symlink `.zshrc` from this repo. Example:
```
ln -s ~/dev/dotfiles/.zshrc ~/.zshrc
```
Install `fzf` shortcuts (ctr-r, ctr-t, etc)
```
/usr/local/opt/fzf/install
```

#### Install and configure git
```
brew install git diff-so-fancy
```
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
pip3 install --user neovim
```
Copy over or symlink `init.vim` file to `~/.config/nvim/init.vim`. Example:
```
ln -s ~/dev/dotfiles/init.vim ~/.config/nvim/init.vim
```
Install vim-plug, a (neo)vim plugin manager
```
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
Install plugin (in neovim):
```
:PlugInstall
```

#### Install and configure tmux
```
brew install tmux
```
Copy over or symlink `.tmux.conf`
```
ln -s ~/dev/dotfiles/.tmux.conf ~/.tmux.conf
```

#### Setup and configure iTerm2
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

#### Install and configure mpv
```
brew install mpv
brew cask install mpv
```
Copy over or symlink `mpv/` to `~/.config/mpv/`
```
ln -s ~/<your_path>/dotfiles/mpv ~/.config/mpv
```
