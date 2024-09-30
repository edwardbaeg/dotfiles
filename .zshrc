# ~/.zshrc

# setup direnv
emulate zsh -c "$(direnv export zsh)"
eval "$(direnv hook zsh)"

# -- Instant prompt ------------------------------------------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -- Core ----------------------------------------------------------------------
GITSTATUS_LOG_LEVEL=DEBUG

# Improve colors
export TERM="xterm-256color"

# Share history
setopt inc_append_history
setopt hist_ignore_dups
setopt share_history

# Use nvim as default editor (eg, ranger)
export EDITOR=nvim
export VISUAL=nvim

# In normal mode, use `v` to open command in editor
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Add custom programs
export PATH=~/bin:$PATH
export PATH=~/.local/bin:$PATH

export PATH="$HOME/.emacs.d/bin:$PATH"

# Add go packages to path
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Add homebrew's sbin to path
# export PATH="/usr/local/sbin:$PATH"
export PATH=$HOME/bin:/opt/homebrew/bin:/usr/local/bin:$PATH

# Don't automatically load ranger rc to prevent loading it twice
# TODO: make conditional for if the rc already exists
export RANGER_LOAD_DEFAULT_RC=FALSE

# Add python to path
export PATH=$PATH:/$HOME/Library/Python/3.9/bin

# Add deno to path
export DENO_INSTALL="/Users/edwardbaeg/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Key bindings
set -o ignoreeof # disable ctr-d from exiting shell, used with tmux

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEhist=100000
setopt appendhistory

# Configure completions with zsh from `brew zsh-completions`
# This must be called before compinit and oh-my-zsh.sh
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

    autoload -Uz compinit
    # compinit
fi

# Improve less
export LESS="$LESS -FRXK"

# change default config directory for MacOS
export XDG_CONFIG_HOME="$HOME/.config"

# -- OneAdvisory, Dispatch -------------------------------------------------------
alias gcm2="git checkout master2 && git reset --hard origin/master"
alias front="cd ~/dev/oneadvisory/frontend"
alias work="cd ~/dev/oneadvisory/frontend-worktree"
alias back="cd ~/dev/oneadvisory/backend"
export AWS_PROFILE=oa-dev
export AWS_REGION=us-east-1
export ECR_AWS_PROFILE=oa-dev

# -- Plugins -----------------------------------------------------------

# Load zgen
# https://github.com/tarjoilija/zgen | git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
# NOTE: After adding plugins, run `zgen reset` and then source
source "${HOME}/.zgen/zgen.zsh"

# If the init script doesn't exist
if ! zgen saved; then

    # load oh-my-zsh first
    zgen oh-my-zsh

    zgen oh-my-zsh plugins/git
    # zgen oh-my-zsh plugins/vi-mode
    zgen oh-my-zsh plugins/colored-man-pages
    # zgen oh-my-zsh plugins/tmux

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

# fix setting fzf keymaps after zsh-vi-mode
# https://github.com/jeffreytse/zsh-vi-mode/issues/4#issuecomment-757234569
function zvm_after_init() {
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -- Aliases -------------------------------------------------------------------

# -- vim
alias vim="nvim"
alias v="nvim"
alias oldvim="/usr/bin/vim"
alias ovim="oldvim"
# alias vp="nvim -c \"Telescope find_files\""
alias vp="nvim -c \"lua require('fzf-lua').files()\""
alias vg="nvim -c \"lua require('fzf-lua').grep_project()\""
alias vsr="nvim -c \"SessionRestore\""
alias ve="nvim -c \"enew\"" # open empty buffer
alias leet="nvim leetcode.nvim"

# open files in vim
alias vz="vim ~/.zshrc"
alias ez="vim ~/.zshrc"
# alias vv="vim ~/.vimrc"
# alias nv="nvim ~/.config/nvim/init.lua"
alias ev="nvim ~/.config/nvim/init.lua -c \":cd %:h\""
alias vt="nvim ~/.tmux.conf"
alias et="nvim ~/.tmux.conf"
alias vh="nvim ~/.hammerspoon/init.lua"
alias eh="nvim ~/.hammerspoon/init.lua"
alias vw="nvim ~/.wezterm.lua"
alias ew="nvim ~/.wezterm.lua"
alias vhist="nvim ~/.zsh_history"

# -- sourcing
alias st="tmux source-file ~/.tmux.conf"
alias sz="exec zsh" # do not source .zshrc

# -- git
alias gdt="git difftool"
alias ghist="git hist"
alias ghista="git hista"
alias ghistb="git histb"
alias gmm="git merge master"
alias gfl="git fetch && git pull"
alias gdm="git diff master"
alias gdo="git diff origin"
alias gd1="git diff HEAD~1"
alias gd2="git diff HEAD~2"
alias gd3="git diff HEAD~3"
# alias glmm="git checkout master && git pull && git checkout - && git merge master"
alias grpo="git remote prune origin"
alias gblr="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
# https://stackoverflow.com/questions/43489303/how-can-i-delete-all-git-branches-which-have-been-squash-and-merge-via-github
alias gbdm='git checkout -q master && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base master $branch) && [[ $(git cherry master $(git commit-tree $(git rev-parse "$branch^{tree}") -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'

# from zsh git-open plugin
alias gop="git open"

#-- commands
alias py="python3"
alias nf="neofetch"
alias vtop="vtop --theme brew"
# alias ra="ranger"
alias ra="yazi"
alias ya="yazi"
alias hdi="howdoi -c -n 3"
alias npml="npm -g ls --depth=0"
alias s="spotify"
alias sp="spotify play"
alias ss="spotify status"
alias sn="spotify next"
alias spp="spotify pause"
alias gcal="gcalcli"
alias gcalt="gcalcli agenda 12am 11pm --detail_location --color_reader 'blue'"
alias end="cowsay 'Thats it! Thank you for listening!!' | nms -c -a"
alias ns="npm start"
alias oldcat="/bin/cat"
# alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"
alias oldls="/bin/ls"
alias lg="lazygit"
alias ..="cd .."
alias ll="ls -al"
alias nvpostinstall='python3 -m pip install --user --upgrade pynvim'

#-- Jumping
alias dot="cd ~/dev/dotfiles"
alias dots="cd ~/dev/dotfiles"

#-- SSH
alias whatbox="ssh dwrdbg@proteus.whatbox.ca"

# conditional command aliases
if command -v eza &> /dev/null
then
    alias ls="eza --group-directories-first"
fi

if command -v bat &> /dev/null
then
    alias cat="bat"
fi

# if command -v zoxide &> /dev/null
# then
#     alias cd="z"
# fi

#-- pi
alias sshpi="ssh pi@192.168.1.100"
alias sshpirate="ssh pi@raspberrypirate"
alias sshpiw="ssh pi@192.168.1.101"
alias sshpiz="ssh pi@192.168.1.102"
alias sshpizw="ssh pi@192.168.1.103"

alias hsr="hs -c \"hs.reload()\""

# -- Functions -----------------------------------------------------------------

# fuzzy search git branches
# checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
# https://github.com/junegunn/fzf/wiki/examples#git
function gcof () {
    local branches branch
    branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
    branch=$(echo "$branches" |
    fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
    # local branches branch
    # branches=$(git --no-pager branch -vv) &&
    # branch=$(echo "$branches" | fzf +m) &&
    # git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fe() {
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# alias for npm leaves to list globally installed packages
function npm () {
    if [[ $@ == "leaves" ]] || [[ $@ == "ls" ]]; then
        command npm -g ls --depth=0
    else
        command npm "$@"
    fi
}

# to create cht.sh curl commands
function cht() {
    local query

    if [[ $# -eq 1 ]]; then
        query=$1

        echo "cht.sh/${query}"
        curl "cht.sh/${query}"
    else
        local token=$(echo "$1" | cut -d' ' -f1)
        query=$(echo "$*" | cut -d' ' -f2- | sed 's/ /+/g')

        echo "cht.sh/$token/$query"
        curl "cht.sh/$token/$query"
    fi
}

function wttr() {
    if [[ $# -eq 0 ]]; then
        curl "v2d.wttr.in/"
    else
        local location=$(echo "$@" | tr ' ' '+')
        curl -s "v2d.wttr.in/$location"
    fi
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

# -- NOTES ---------------------------------------------------------------
# Run the following to benchmark shell boot times
# for i in $(seq 1 10); do /usr/bin/time $SHELL -i -c exit; done

export PATH=$PATH:/Users/edwardbaeg/.spicetify
