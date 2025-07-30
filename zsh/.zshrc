#!/usr/bin/env zsh
# TODO: convert most of file to bash, for linter support

# setup direnv
if command -v direnv >/dev/null 2>&1; then
    emulate zsh -c "$(direnv export zsh)"
    eval "$(direnv hook zsh)"
fi

# TODO consider iterating over all files in the dir https://medium.com/codex/how-and-why-you-should-split-your-bashrc-or-zshrc-files-285e5cc3c843
work_zsh_path="$HOME/zsh/work.sh"
if [[ ! -f $work_zsh_path ]]; then
    echo "work.zsh not found in \$HOME/zsh"
fi

# -- Instant prompt ------------------------------------------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -- OneAdvisory, Dispatch -------------------------------------------------------
if [[ -f $work_zsh_path ]]; then
    source "$work_zsh_path"
fi

# -- Core ----------------------------------------------------------------------
GITSTATUS_LOG_LEVEL=DEBUG

# Improve colors
export TERM="xterm-256color"

# Use nvim as default editor
export EDITOR=nvim
export VISUAL=nvim

# -- History
# Share history
setopt inc_append_history
setopt hist_ignore_dups
setopt share_history

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEhist=100000
setopt appendhistory

# -- Path
# Add custom programs
export PATH=~/bin:$PATH
export PATH=~/.local/bin:$PATH

# Emacs
export PATH="$HOME/.emacs.d/bin:$PATH"

# Add go packages to path
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Add homebrew's sbin to path
# export PATH="/usr/local/sbin:$PATH"
export PATH=$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH

# Add python to path
export PATH=$PATH:/$HOME/Library/Python/3.9/bin

# Add deno to path
export DENO_INSTALL="/Users/edwardbaeg/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# -- Zsh specific
# In normal mode, use `v` to open command in editor
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Key bindings
set -o ignoreeof # disable ctr-d from exiting shell, used with tmux

# Configure completions with zsh from `brew zsh-completions`
# This must be called before compinit and oh-my-zsh.sh
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

    autoload -Uz compinit
    # compinit
fi

# -- Pager
# Improve less
export LESS="$LESS -FRXK"

# -- Misc
# Don't automatically load ranger rc to prevent loading it twice
# TODO: make conditional for if the rc already exists
export RANGER_LOAD_DEFAULT_RC=FALSE

# change default config directory for MacOS
export XDG_CONFIG_HOME="$HOME/.config"

# source ~/.env if it exists
[ -f "$HOME/.env" ] && source "$HOME/.env"

# Don't automatically set terminal title, for tmux, required by tmuxp
export DISABLE_AUTO_TITLE='true'

# -- Plugins -----------------------------------------------------------

# Load zgen
# https://github.com/tarjoilija/zgen | git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
# NOTE: After adding plugins, run `zgen reset` and then source
source "${HOME}/.zgen/zgen.zsh"

# If the init script doesn't exist
if ! zgen saved; then

    # load oh-my-zsh first
    zgen oh-my-zsh

    zgen oh-my-zsh plugins/git # adds git aliases
    # zgen oh-my-zsh plugins/vi-mode
    zgen oh-my-zsh plugins/colored-man-pages
    # zgen oh-my-zsh plugins/tmux
    zgen oh-my-zsh plugins/alias-finder # says if command has an alias

    # zgen load Aloxaf/fzf-tab # doesn't appear to work with zgen
    zgen load zdharma-continuum/fast-syntax-highlighting
    zgen load zsh-users/zsh-autosuggestions
    # zgen load agkozak/zsh-z # directory jumper
    # zgen load changyuheng/fz # add fuzzy search for z
    zgen load jeffreytse/zsh-vi-mode # better vi mode

    # zgen oh-my-zsh themes/sorin
    zgen load romkatv/powerlevel10k powerlevel10k
    # zgen load paulirish/git-open

    # generate the init script from plugins above
    zgen save
fi

# Configure zsh-vi-mode
# NOTE: use `vv` to edit in vim
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_USER_DEFAULT
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK # show blinking cursor in normal mode
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT # always start in insert mode (default is ZVM_MODE_LAST)

# Configure alias-finder
zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default

# fix setting fzf keymaps after zsh-vi-mode
# https://github.com/jeffreytse/zsh-vi-mode/issues/4#issuecomment-757234569
function zvm_after_init() {
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

alias sz="exec zsh" # do not source .zshrc
# -- Aliases -------------------------------------------------------------------
if [[ -f "$HOME/zsh/aliases.sh" ]]; then
    source "$HOME/zsh/aliases.sh"
fi

# -- Functions -----------------------------------------------------------------
if [[ -f "$HOME/zsh/functions.sh" ]]; then
    source "$HOME/zsh/functions.sh"
fi

# -- Neovim stuffs -------------------------------------------------

# Use Neovim as manpager
export MANPAGER='nvim +Man!'
# export MANPAGER="nvim --cmd 'let g:disable_plugins=1' +Man!"

alias nvim_no_plugins="nvim +'let g:disable_plugins=1'"

# -- Aliases to immediately run commands
alias vpp="nvim -c \"lua require('snacks').picker.git_files()\""
alias vgg="nvim -c \"lua require('fzf-lua').grep_project()\""
alias vsr="nvim -c \"lua require('persistence').load()\""
alias vsl="nvim -c \"lua require('persistence').load()\""
alias ve="nvim -c \"enew\"" # open empty buffer
alias leet="nvim leetcode.nvim"
# alias vl="nvim -c \"Lazy\"" # this doesnt work, maybe its before the command is loaded?

# -- Alternate nvim configurations
# https://michaeluloth.com/neovim-switch-configs/
alias vlazy='NVIM_APPNAME=nvim-lazyvim nvim' # LazyVim

## fuzzy finder for launching nvim configs
function vv() {
    # Assumes all configs exist in directories named ~/.config/nvim-*
    local config=$(fd --max-depth 1 --glob 'nvim*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)

    # If I exit fzf without selecting a config, don't open nvim
    [[ -z $config ]] && echo "No config selected" && return

    # Open Neovim with the selected config
    NVIM_APPNAME=$(basename $config) nvim $@
}

# -- Post install --------------------------------------------------------------

# fzf
# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use rg for fzf
# FZF_DEFAULT_COMMAND='rg -g ""'
# export FZF_DEFAULT_COMMAND='rg --files --ignore'
export FZF_DEFAULT_COMMAND='rg --hidden -l --files --ignore' # include hidden files

export FZF_DEFAULT_OPTS='
--layout=reverse
--height=50%
'

# mysql
# export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# p10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# setup zoxide completions. must be called after compinit
eval "$(zoxide init zsh)"

# setup thefuck
eval $(thefuck --alias)
alias f=fuck

# To install shell completions, add this to your profile:
if command -v ngrok &>/dev/null; then
    eval "$(ngrok completion)"
fi

# run this command to add awscli autocompletion
# complete -C aws_completer aws

# -- NOTES ---------------------------------------------------------------
# Run the following to benchmark shell boot times
# for i in $(seq 1 10); do /usr/bin/time $SHELL -i -c exit; done

export PATH=$PATH:/Users/edwardbaeg/.spicetify
