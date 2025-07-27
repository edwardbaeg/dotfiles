# -- fzf functions

# fuzzy search git branches
# checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
# https://github.com/junegunn/fzf/wiki/examples#git
alias gcof="git_checkout_fuzzy"
alias bf="git_checkout_fuzzy"
function git_checkout_fuzzy() {
	local branches branch
	branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
		branch=$(echo "$branches" |
			fzf -d $((2 + $(wc -l <<<"$branches"))) +m --query="$1") &&
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
	local results=$(command rg --hidden --color=always --line-number --no-heading --smart-case "${*:-}" |
		command fzf -d':' --ansi \
			--preview "command bat -p --color=always {1} --highlight-line {2}" \
			--preview-window ~8,+{2}-5 |
		awk -F':' '{print $1 " +" $2}')

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
	file=$(find ~/dev/dotfiles/tmuxp -type f -name '*.yaml' |
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
	if cat package.json >/dev/null 2>&1; then
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
		if [[ $(git cherry master "$(git commit-tree "$(git rev-parse "$branch^{tree}")" -p "$mergeBase" -m _)") == "-"* ]]; then
			git branch -D "$branch"
		fi
	done
}

# -- other functions

# alias for npm leaves to list globally installed packages
function npm() {
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
