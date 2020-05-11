# ~/.zshrc

# -- NOTES ---------------------------------------------------------------------

# Run the following to benchmark shell boot times
# for i in $(seq 1 10); do /usr/bin/time $SHELL -i -c exit; done

# -- Core ----------------------------------------------------------------------

# Improve colors
export TERM="xterm-256color"

# Share history
setopt inc_append_history
setopt hist_ignore_dups
setopt share_history

# This is pretty slow?
# Configure thefuck alias
# eval $(thefuck --alias)
# alias f="fuck"

# Use nvim as default editor (eg, ranger)
export EDITOR=nvim

# Add custom programs
export PATH=~/bin:$PATH

# Key bindings
set -o ignoreeof # disable ctr-d from exiting shell, used with tmux

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEhist=100000
setopt appendhistory

# fix ctrlp issues with zinit + tmux?
# bindkey -e

# -- Plugins -------------------------------------------------------------------

# https://github.com/tarjoilija/zgen | git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# NOTE: After adding plugins, run `zgen reset` and then source
# load zgen
source "${HOME}/.zgen/zgen.zsh"

# If the init script doesn't exist
if ! zgen saved; then

  # load oh-my-zsh first
  zgen oh-my-zsh

  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/z
  zgen oh-my-zsh plugins/vi-mode
  zgen oh-my-zsh plugins/colored-man-pages
  zgen oh-my-zsh plugins/tmux

  # zgen load Aloxaf/fzf-tab # doesn't appear to work with zgen
  zgen load changyuheng/fz
  zgen load zdharma/fast-syntax-highlighting
  zgen load zsh-users/zsh-autosuggestions

  # zgen oh-my-zsh themes/sorin
  zgen load romkatv/powerlevel10k powerlevel10k
  zgen load paulirish/git-open

  # generate the init script from plugins above
  zgen save
fi

# -- Aliases -------------------------------------------------------------------

# -- vim
alias vim="nvim"
alias v="nvim"
alias oldvim="/usr/bin/vim"
alias ovim="oldvim"

alias vz="vim ~/.zshrc"
alias vv="vim ~/.vimrc"
alias nv="nvim ~/.config/nvim/init.vim"
alias vt="nvim ~/.tmux.conf"
alias vh="nvim ~/.hammerspoon/init.lua"

alias vm="nvim -c \"Startify | MRU\""
alias vp="nvim -c \"Startify | GFiles\""
alias vg="nvim -c \"Startify | Rg\""

# -- Sourcing
alias st="tmux source-file ~/.tmux.conf"
alias sz="source ~/.zshrc"

# -- git
alias gdt="git difftool"
alias ghist="git hist"
alias ghista="git hista"
alias ghistb="git histb"
alias gpo="git push && git open"
alias gmm="git merge master"
alias gfl="git fetch && git pull"
alias gdm="git diff master"
alias gd1="git diff HEAD~1"
alias gd2="git diff HEAD~2"
alias gd3="git diff HEAD~3"
alias ogh="open https://github.com/edwardbaeg"

# from zsh git-open plugin
alias go="git open"

alias glmm="git checkout master && git pull && git checkout - && git merge master"
alias grpo="git remote prune origin"
alias gbdm="git branch --merged master | grep -v '\* master' | xargs -n 1 git branch -d"
alias gblr="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"

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
alias ll="ls -al"

alias serv="python3 -m http.server"

#-- pi
alias sshpi="ssh pi@192.168.1.100"
alias sshpirate="ssh pi@raspberrypirate"
alias sshpiw="ssh pi@192.168.1.101"
alias sshpiz="ssh pi@192.168.1.102"
alias sshpizw="ssh pi@192.168.1.103"

# alias sshbb="ssh pi@192.168.1.4"

# -- Functions -----------------------------------------------------------------

function sshbb () {
  ssh pi@192.168.1.4 "$@"
}

function cs () {
  cd "$1" && exa;
}

function mkcd () {
  mkdir -p -- "$1" &&
    cd -P -- "$1"
}

# fuzzy search git branches
function gcof() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# No args: `git status`; with args: `git `
# function g () {
#   if [[ $# > 0 ]]; then
#     git "$@"
#   else
#     git status
#   fi
# }

# -- Grain ---------------------------------------------------------------------

# Source asdf
source /usr/local/opt/asdf/asdf.sh
. /usr/local/opt/asdf/asdf.sh
. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash

# -- Aliases
alias mixx="mix deps.get && mix ecto.migrate && mix phx.server"
alias ngrokk="ngrok http 3000 --subdomain grain-edward --bind-tls true -host-header=\"localhost:3000\""
alias ngrokn="ngrok http 7777 --subdomain grain-edward --bind-tls true"
alias yarnl="yarn lint-full && gd"
alias iexx="iex -S mix phx.server"
alias ys="yarn start"
alias grain="/Applications/Grain.app/Contents/MacOS/Grain"

# direnv
eval "$(direnv hook zsh)"

# -- Post install --------------------------------------------------------------

# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use rg for fzf
# FZF_DEFAULT_COMMAND='rg -g ""'
export FZF_DEFAULT_COMMAND='rg --files --ignore'

# for mysql
# export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"


# p10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

