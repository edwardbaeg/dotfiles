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
alias vz="vim ~/.zshrc"
alias sz="source ~/.zshrc"
alias vv="vim ~/.vimrc"
alias nv="nvim ~/.config/nvim/init.vim"
alias v="nvim"
alias oldvim="/usr/bin/vim"
alias ovim="oldvim"
alias vt="vim ~/.tmux.conf"
alias vm="vim -c \"MRU\""
alias vp="vim -c \"FZF\""
alias vg="vim -c \"Rg\""

#-- tmux
alias st="tmux source-file ~/.tmux.conf"

#-- git
alias gdt="git difftool"
alias ghist="git hist"
alias ghistb="git histb"
alias go="git open"
alias ogh="open https://github.com/edwardbaeg"
alias grp="git remote prune origin"
alias gbdm="git branch -d $(git branch --merged=master | grep -v master)"
alias gmm="git merge master"

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

alias serv="python3 -m http.server"

#-- functions
function cs () {
  cd "$1" && exa;
}

function mkcd () {
  mkdir -p -- "$1" &&
    cd -P -- "$1"
}

# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# for mysql
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# Grain
# source asdf
# source /usr/local/opt/asdf/asdf/sh

# for asdf
. /usr/local/opt/asdf/asdf.sh
. /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash

# for direnv
eval "$(direnv hook zsh)"
