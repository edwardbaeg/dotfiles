# ~/.zshrc

# improve colors
export TERM="xterm-256color"

# sharing history
setopt inc_append_history
setopt hist_ignore_dups
setopt share_history

# configure thefuck alias
eval $(thefuck --alias)
alias f="fuck"

# use nvim (for ranger)
export EDITOR=nvim

# add custom programs
export PATH=~/bin:$PATH

#-- key bindings
set -o ignoreeof # disable ctr-d from exiting shell

#-------------------
# history settings
#-------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEhist=100000
setopt appendhistory

#-------------------
# Plugins
#-------------------
# load zplug
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
zplug "plugins/vi-mode", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/tmux", from:oh-my-zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "changyuheng/fz"
zplug "zsh-users/zsh-syntax-highlighting"

zplug "themes/sorin", from:oh-my-zsh, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
# zplug load --verbose
zplug load

#-------------------
# Aliases
#-------------------
#-- vim
alias vim="nvim"
alias v="nvim"
alias oldvim="/usr/bin/vim"
alias ovim="oldvim"

alias vz="vim ~/.zshrc"
alias sz="source ~/.zshrc"
alias vv="vim ~/.vimrc"
alias nv="nvim ~/.config/nvim/init.vim"
alias vt="nvim ~/.tmux.conf"
alias vh="nvim ~/.hammerspoon/init.lua"

alias vm="nvim -c \"Startify | MRU\""
alias vp="nvim -c \"Startify | GFiles\""
alias vg="nvim -c \"Startify | Rg\""

#-- tmux
alias st="tmux source-file ~/.tmux.conf"

#-- git
alias gdt="git difftool"
alias ghist="git hist"
alias ghista="git hista"
alias ghistb="git histb"
alias gpo="git push && git open"
alias ogh="open https://github.com/edwardbaeg"
alias gmm="git merge master"
alias gfl="git fetch && git pull"
alias gdm="git diff master"
alias gd1="git diff HEAD~1"
alias gd2="git diff HEAD~2"
alias gd3="git diff HEAD~3"

alias glmm="git checkout master && git pull && git checkout - && git merge master"
alias grpo="git remote prune origin"
alias gbdm="git branch --merged master | grep -v '\* master' | xargs -n 1 git branch -d"
alias gblr="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"

# alias `git` to use `hub`
# this is currently broken
# eval "$(hub alias -s)"
# alias go="hub browse"

alias go="git open"

#-- commands
alias py="python3"
alias nf="neofetch"
alias vtop="vtop --theme brew"
alias clock="tty-clock -c -C 0 -t -d 10"
alias ra="ranger"
alias hdi="howdoi -c -n 3"
alias npml="npm -g ls --depth=0"
alias s="spotify"
alias sp="spotify play"
alias ss="spotify status"
alias sn="spotify next"
alias spp="spotify pause"
alias gcal="gcalcli"
alias gcalt="gcalcli agenda 12am 11pm --detail_location --color_reader 'blue'"
alias exa1="exa -T -L 1"
alias exa2="exa -T -L 2"
alias end="cowsay 'Thats it! Thank you for listening!!' | nms -c -a"
alias ns="npm start"
alias tree="exa -T"
alias cat="bat"
alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"
alias ls="exa"
alias lg="lazygit"
alias ..="cd .."

alias serv="python3 -m http.server"

#-- pi
alias sshpi="ssh pi@192.168.1.100"
alias sshpirate="ssh pi@raspberrypirate"
alias sshpiw="ssh pi@192.168.1.101"
alias sshpiz="ssh pi@192.168.1.102"
alias sshpizw="ssh pi@192.168.1.103"

# alias sshbb="ssh pi@192.168.1.4"

function sshbb () {
  ssh pi@192.168.1.4 "$@"
}

#-- functions
function cs () {
  cd "$1" && exa;
}

function mkcd () {
  mkdir -p -- "$1" &&
    cd -P -- "$1"
}

# No args: `git status`; with args: `git `
# function g () {
#   if [[ $# > 0 ]]; then
#     git "$@"
#   else
#     git status
#   fi
# }

# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use rg for fzf
# FZF_DEFAULT_COMMAND='rg -g ""'
export FZF_DEFAULT_COMMAND='rg --files --ignore'

# for mysql
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# Grain
# source asdf
source /usr/local/opt/asdf/asdf.sh
alias mixx="mix deps.get && mix ecto.migrate && mix phx.server"
alias ngrokk="ngrok http 3000 --subdomain grain-edward --bind-tls true -host-header=\"localhost:3000\""
alias ngrokn="ngrok http 7777 --subdomain grain-edward --bind-tls true"
alias yarnl="yarn lint-full && gd"
alias iexx="iex -S mix phx.server"
alias ys="yarn start"

# for asdf
. /usr/local/opt/asdf/asdf.sh
. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash

# for direnv
eval "$(direnv hook zsh)"

# what is this??
# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
