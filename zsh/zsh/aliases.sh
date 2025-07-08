# -- [neo]vim aliases
alias vim="nvim"
alias v="nvim"
alias oldvim="/usr/bin/vim"
alias ovim="oldvim"

# -- configuration files
# TODO: choose one pattern and maintain; v* for shell, e* for within nvim
# TODO: change working dir for each?
alias vz="vim ~/.zshrc"
alias vzw="vim ~/zsh/work.sh"
alias vza="vim ~/zsh/aliases.sh"
# alias ez="vim ~/.zshrc"
# alias vv="vim ~/.vimrc"
alias ev="vim ~/.config/nvim/init.lua -c \":cd %:h\""
alias vt="vim ~/.tmux.conf"
# alias et="vim ~/.tmux.conf"
# alias vh="vim ~/.hammerspoon/init.lua -c \":cd %:h\""
alias vh="vim ~/.hammerspoon/init.lua -c \":cd ~/dev/dotfiles/hammerspoon\""
alias vhm="vim ~/.hammerspoon/modal.lua -c \":cd ~/dev/dotfiles/hammerspoon\""
# alias eh="vim ~/.hammerspoon/init.lua -c \":cd %:h\""
alias vw="vim ~/.wezterm.lua"
# alias ew="vim ~/.wezterm.lua"
alias vk="vim ~/.config/kitty/kitty.conf"
# alias ek="vim ~/.config/kitty/kitty.conf"
alias vo="vim ~/Sync/Obsidian\ Vault/"

# -- other files
alias vhist="vim ~/.zsh_history"

# -- sourcing
alias st="tmux source-file ~/.tmux.conf"
alias sz="exec zsh" # do not source .zshrc

# -- git
alias gdt="git difftool"
alias ghist="git hist"
alias ghista="git hista"
alias ghistb="git histb"
alias gmm="git merge master"
alias gmo="git merge origin/master"
alias gfl="git fetch && git pull"
# alias gdm="git diff master" # this is not as useful if master is no longer at the fork point of the branch
alias gdm="git diff --merge-base master"
alias gdo="git diff origin"
alias gd1="git diff HEAD~1"
alias gd2="git diff HEAD~2"
alias gd3="git diff HEAD~3"
alias grpo="git remote prune origin"
alias gblr="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"
# https://stackoverflow.com/questions/43489303/how-can-i-delete-all-git-branches-which-have-been-squash-and-merge-via-github

# git_diff_fork_point() {
#   # git diff "$(git merge-base --fork-point master)"
#   # git diff master...HEAD
#   git diff --merge-base master
# }

# from zsh git-open plugin
alias gop="git open"

#-- commands
alias py="python3"
alias vtop="vtop --theme brew"
# alias ra="ranger"
# alias ra="yazi"
alias ya="yazi"
alias ff="yazi" # for [f]ind [f]iles
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
alias cl="clear"
alias tel="nchat"

#-- Jumping
alias dot="cd ~/dev/dotfiles"
alias dots="cd ~/dev/dotfiles"

#-- SSH
alias whatbox='ssh "$WHATBOX_USER"@"$WHATBOX_HOST"'

# conditional command aliases
if command -v eza &>/dev/null; then
	alias ls="eza --group-directories-first"
fi

if command -v bat &>/dev/null; then
	alias cat="bat"
fi

# if command -v zoxide &> /dev/null; then
#     alias cd="z"
# fi

#-- pi
alias sshpi="ssh pi@192.168.1.100"
alias sshpirate="ssh pi@raspberrypirate"
alias sshpiw="ssh pi@192.168.1.101"
alias sshpiz="ssh pi@192.168.1.102"
alias sshpizw="ssh pi@192.168.1.103"

alias hsr="hs -c \"hs.reload()\""
