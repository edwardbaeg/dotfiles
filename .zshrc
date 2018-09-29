# improve colors
export TERM="xterm-256color"

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
# Load antigen plugin manager
source /usr/local/share/antigen/antigen.zsh

# Load the oh-my-zsh's library
  antigen use oh-my-zsh

# Bundles from the default repo
  antigen bundle git
  # antigen bundle command-not-found
  antigen bundle z
  antigen bundle docker
  antigen bundle vi-mode

# External bundles
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle zsh-users/zsh-autosuggestions
  antigen bundle zsh-users/zsh-history-substring-search
  antigen bundle changyuheng/fz

#-------------------
# Configure POWERLEVEL9K
#-------------------
# Use below to preview colors in console
  # for code ({000..255}) print -P -- "$code: %F{$code}This is how your text would look like%f"

  POWERLEVEL9K_INSTALLATION_PATH=$ANTIGEN_BUNDLES/bhilburn/powerlevel9k
  POWERLEVEL9K_MODE="nerdfont-complete"
  antigen theme bhilburn/powerlevel9k powerlevel9k

  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon vi_mode dir_writable root_indicator dir vcs)
  POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(docker_machine status history time)
  POWERLEVEL9K_PROMPT_ON_NEWLINE=true
  # POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=" "
  # POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=" ► "
  # POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="⌈"
  #POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰─➤➤➤ "
  # POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰─ $ "

  POWERLEVEL9K_HIDE_BRANCH_ICON=true

  POWERLEVEL9K_VI_INSERT_MODE_STRING="I"
  POWERLEVEL9K_VI_COMMAND_MODE_STRING="N"

  POWERLEVEL9K_OS_ICON_FOREGROUND="black"
  POWERLEVEL9K_OS_ICON_BACKGROUND="white"

  POWERLEVEL9K_DIR_HOME_BACKGROUND="237"
  POWERLEVEL9K_DIR_HOME_FOREGROUND="white"
  POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="237"
  POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="white"
  POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="237"
  POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_DELIMITER=".."
  POWERLEVEL9K_SHORTEN_STRATEGY=None

  POWERLEVEL9K_BATTERY_STAGES="▁▂▃▄▅▆▇█"
  POWERLEVEL9K_BATTERY_VERBOSE=false
  POWERLEVEL9K_BATTERY_LOW_BACKGROUND="red"
  POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND="237"
  POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND="237"
  POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND="237"

  POWERLEVEL9K_HISTORY_BACKGROUND="237"
  POWERLEVEL9K_HISTORY_FOREGROUND="white"

  POWERLEVEL9K_TIME_FORMAT="%D{\uF017 %H:%M}"


# Tell antigen that you're done
antigen apply

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
alias st="tmux source-file ~/.tmux.conf"

#-- git
alias ogh="open https://github.com/edwardbaeg"
alias ghist="git hist"
alias ghistb="git histb"
alias gdt="git difftool"

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


#-- functions
function cs () {
  cd "$1" && exa;
}


# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

