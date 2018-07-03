# .dotfiles
This is my development set up! Always a work progress.
![screenshot](media/main.png)

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
- `command-not-found` suggest package for failed commands
- `zsh-users/zsh-syntax-highlighting` syntax highlighting in terminal
- `zsh-users/zsh-autosuggestions` autocomplete based on command history
- `zsh-users/zsh-history-substring-search` cycle through previous commands
- `changyuheng/fz` fzf tab completion with z

**Homebrew formulae** (`brew leaves`):
- `antigen` plugin manager for zsh
- `exa` better ls, can draw directory trees
- `fzf` fuzzy finder
- `highlight` adds syntax highlighting to ranger previews
- `howdoi` search stackexchange
- `hub` github wrapper
- `neofetch` display system info
- `neovim` better vim (async, community developed)
- `node` for javascript
- `ranger` visual file manager
- `ripgrep` better grep (and faster than ag)
- `rtv` reddit terminal viewer
- `shpotify` control spotify
- `thefuck` quick fix failed commands
- `tmux` terminal multiplexer
- `tty-clock` terminal clock
- `zsh` better shell
- `zsh-completions` command line autocompletions

**npm packages** `(npm -g ls --depth=0)`:
- `eslint` javascript linter
- `git-open` open github repo in browser
- `instant-markdown` live preview markdown with (neo)vim
- `tldr` community written short man pages
- `vtop` visual terminal activity monitor

**pip packages** `(pip list)`
- `mackup` backup MacOS configuration files

**pip2.7 packages** `(pip2.7 list)`
- `gcalcli` view google calendar in calendar

## (neo)vim
**Plugin Manager**: `vim-plug` minimal and super fast with parallel operations

**Custom Syntax Highlighting Rules + Colors**

**Top Plugins**:
- Visual
  - `sjl/badwolf` colorscheme
  - `tpope/vim-airline` lightweight statusbar
  - `airblade/vim-gitgutter` view git diff in gutter
  - `junegunn/goyo.vim` distraction free mode
  - `ryanoasis/vim-devicons` adds file icons to nerdtree and vim-airline
- File Management
  - `/usr/local/opt/fzf`, `junegunn/fzf.vim` fuzzy finder
  - `tpope/vim-fugitive` git wrapper
- Shortcuts
  - `tpope/vim-surround` adds surround motions
  - `tpope/vim-commentary` adds comment motions
  - `SirVer/ultisnips` snippet engine
  - `honza/vim-snippets` default snippets
- Utility
  - `w0rp/ale` async linting engine
  - `Shougo/deoplete.nvim` async autocompletions
  - `vimwiki/vimwiki` personal wiki
  - `suan/vim-instant-markdown` live prewview markdown
  - `zhimsel/vim-stay` save cursor/folds/bookmarks
  - `simnalamburt/vim-mundo` visual undo tree
  - `Carpetsmoker/undofile_warn.vim` persistent undo warnings

## .gitconfig
- `difftool` vimdiff (`nvim -d`)
- `mergetool` meld
