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

# Use Neovim as manpager # TODO: open this without loading plugins to speed up
export MANPAGER='nvim +Man!'

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

# -- Aliases -------------------------------------------------------------------
if [[ -f "$HOME/zsh/aliases.sh" ]]; then
    source "$HOME/zsh/aliases.sh"
fi

# -- Functions -----------------------------------------------------------------
# TODO: abstract to separate file

# -- fzf functions

# fuzzy search git branches
# checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
# https://github.com/junegunn/fzf/wiki/examples#git
alias gcof="git_checkout_fuzzy"
alias bf="git_checkout_fuzzy"
function git_checkout_fuzzy () {
    local branches branch
    branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
        branch=$(echo "$branches" |
        fzf -d $(( 2 + $(wc -l <<< "$branches") )) +m --query="$1") &&
        local target_branch=$(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
    local command="git checkout $target_branch"
    print "$command"
    print -s "$command"
    eval $command
}

# [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
#   https://github.com/junegunn/fzf/wiki/Examples#opening-files
alias vp="vim_files"
function vim_files() {
    IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0 --preview 'bat --color=always {}' --preview-window '~3'))
    [[ -n "$files" ]] && {
        local command="${EDITOR:-nvim} ${files[@]}"
            print "$command"
            print -s "$command"
            eval $command
        }
}

# NOTE: this doesn't support <tab> selection
# https://github.com/junegunn/fzf/issues/2789#issuecomment-2196524694
alias vg="vim_grep"
function vim_grep {
    local results=$(command rg --hidden --color=always --line-number --no-heading --smart-case "${*:-}" \
        | command fzf -d':' --ansi \
        --preview "command bat -p --color=always {1} --highlight-line {2}" \
        --preview-window ~8,+{2}-5 \
        | awk -F':' '{print $1 " +" $2}')

    if [[ -n "$results" ]]; then
        local command="${EDITOR:-nvim} $results"
        print "$command"
        print -s "$command"
        eval $command
    fi
}

# List tmux sessions, filter with fzf, and attach to the selected session
# TODO: add the ability to create a session if there is no match in fzf
# TODO: switch sessions if already in one
alias ta="tmux_attach"
function tmux_attach() {
    if [[ -n "$TMUX" ]]; then
        echo "Error: Already in tmux session."
        return
    fi

    selected_session=$(tmux ls | fzf --height 40% --reverse --border --header "Select a tmux session")

    # Check if a session was selected
    if [[ -n "$selected_session" ]]; then
        # Extract the session name (the first part of the line)
        session_name=$(echo "$selected_session" | cut -d: -f1)
        # Create and execute the command
        local command="tmux attach-session -t $session_name"
        print "$command"
        print -s "$command"
        eval $command
    else
        echo "Exit: No session selected."
    fi
}

# Fuzzy picker for tmuxp files
alias tp="tmuxp_picker"
alias tmuxpf="tmuxp_picker"

function tmuxp_picker() {
    local file
    file=$(find ~/dev/dotfiles/tmux -type f -name '*.yaml' | \
        fzf --prompt="tmuxp > " --height=40% --border \
            --preview="head -40 {}" --preview-window=right:40%)
    if [[ -n "$file" ]]; then
        local command="tmuxp load \"$file\""
        print "$command"
        print -s "$command"
        eval $command
    else
        echo "Exit: No file selected."
    fi
}

alias nf="npm_run_fuzzy"
alias npmf="npm_run_fuzzy"
function npm_run_fuzzy() {
    if cat package.json > /dev/null 2>&1; then
        scripts=$(cat package.json | jq .scripts | sed '1d;$d' | fzf --height 40%)

        if [[ -n $scripts ]]; then
            # Extract script name and remove all whitespace and quotes
            script_name=$(echo $scripts | awk -F ': ' '{gsub(/[" ]/, "", $1); print $1}' | tr -d '[:space:]')
            command="npm run $script_name"
            print "$command"
            # Add command to history and execute it
            print -s "$command"
            eval $command
        else
            echo "Exit: No script selected."
        fi
    else
        echo "Error: No package.json."
    fi
}

# -- fzf ui demo
alias fui="fzf_demo_ui"
function fzf_demo_ui() {
    git ls-files | fzf --style full --scheme path \
        --border --padding 1,2 \
        --ghost 'Type in your query' \
        --border-label ' Demo ' --input-label ' Input ' --header-label ' File Type ' \
        --footer-label ' MD5 Hash ' \
        --preview 'BAT_THEME=gruvbox-dark fzf-preview.sh {}' \
        --bind 'result:bg-transform-list-label:
    if [[ -z $FZF_QUERY ]]; then
        echo " $FZF_MATCH_COUNT items "
    else
        echo " $FZF_MATCH_COUNT matches for [$FZF_QUERY] "
    fi
    ' \
        --bind 'focus:bg-transform-preview-label:[[ -n {} ]] && printf " Previewing [%s] " {}' \
        --bind 'focus:+bg-transform-header:[[ -n {} ]] && file --brief {}' \
        --bind 'focus:+bg-transform-footer:if [[ -n {} ]]; then
    echo "MD5:    $(md5sum < {})"
    echo "SHA1:   $(sha1sum < {})"
    echo "SHA256: $(sha256sum < {})"
    fi' \
        --bind 'ctrl-r:change-list-label( Reloading the list )+reload(sleep 2; git ls-files)' \
        --color 'border:#aaaaaa,label:#cccccc' \
        --color 'preview-border:#9999cc,preview-label:#ccccff' \
        --color 'list-border:#669966,list-label:#99cc99' \
        --color 'input-border:#996666,input-label:#ffcccc' \
        --color 'header-border:#6699cc,header-label:#99ccff' \
        --color 'footer:#ccbbaa,footer-border:#cc9966,footer-label:#cc9966'
    }

# -- git
function gbdm() {
    git checkout -q master
    git for-each-ref refs/heads/ "--format=%(refname:short)" | while read -r branch; do
    mergeBase=$(git merge-base master "$branch")
    if [[ $(git cherry master "$(git commit-tree "$(git rev-parse "$branch^{tree}")" -p "$mergeBase" -m _ )") == "-"* ]]; then
        git branch -D "$branch"
    fi
done
}

# -- other functions

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

# -- Neovim stuffs -------------------------------------------------

# -- Aliases to immediately run commands
alias vpp="nvim -c \"lua require('snacks').picker.git_files()\""
alias vgg="nvim -c \"lua require('fzf-lua').grep_project()\""
alias vsr="nvim -c \"lua require('persistence').load()\""
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
