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
		local target_branch
	target_branch=$(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
	local command="git checkout $target_branch"
	print "$command"
	print -s "$command"
	eval "$command"
}

# [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
#   https://github.com/junegunn/fzf/wiki/Examples#opening-files
alias vp="vim_files"
function vim_files() {
	local IFS=$'\n'
	files=($(fzf --query="$1" --multi --select-1 --exit-0 --preview 'bat --color=always {}' --preview-window '~3'))
	IFS=' '
	[[ -n "$files" ]] && {
		local command="${EDITOR:-nvim} ${files[*]}"
		print "$command"
		print -s "$command"
		eval "$command"
	}
}

# https://github.com/junegunn/fzf/issues/2789#issuecomment-2196524694
alias vg="vim_grep"
function vim_grep {
	local IFS=$'\n'
	local results
	results=($(command rg --hidden --color=always --line-number --no-heading --smart-case "${*:-}" |
		command fzf -d':' --ansi --multi \
			--preview "command bat -p --color=always {1} --highlight-line {2}" \
			--preview-window "~8,+{2}-5" |
		awk -F':' '{print $1 " +" $2}'))
	IFS=' '

	if [[ ${#results[@]} -gt 0 ]]; then
		local command="${EDITOR:-nvim} ${results[*]}"
		print "$command"
		print -s "$command"
		eval "$command"
	fi
}

# List tmux sessions, filter with fzf, and attach to the selected session
# TODO: add the ability to create a session if there is no match in fzf
alias ta="tmux_attach"
function tmux_attach() {
	selected_session=$(tmux ls | fzf --height 40% --reverse --border --header "Select a tmux session")

	if [[ -n "$selected_session" ]]; then
		session_name=$(echo "$selected_session" | cut -d: -f1)

		if [[ -n "$TMUX" ]]; then
			local command="tmux switch-client -t $session_name"
		else
			local command="tmux attach-session -t $session_name"
		fi

		print "$command"
		print -s "$command"
		eval "$command"
	else
		echo "Exit: No session selected."
	fi
}

# Fuzzy picker for tmuxp files
alias tp="tmuxp_picker"
alias tmuxpf="tmuxp_picker"

function tmuxp_picker() {
	local IFS=$'\n'
	local files
	files=($(find ~/dev/dotfiles/tmux/tmuxp -type f -name '*.yaml' |
		fzf --prompt="tmuxp > " --height=40% --border --multi \
			--preview="head -40 {}" --preview-window=right:40%))
	IFS=' '
	
	if [[ ${#files[@]} -gt 0 ]]; then
		for file in "${files[@]}"; do
			local command="tmuxp load \"$file\""
			print "$command"
			print -s "$command"
			eval "$command"
		done
	else
		echo "Exit: No file selected."
	fi
}

alias nf="npm_run_fuzzy"
alias npmf="npm_run_fuzzy"
function npm_run_fuzzy() {
	if cat package.json >/dev/null 2>&1; then
		scripts=$(jq .scripts package.json | sed '1d;$d' | fzf --height 40%)

		if [[ -n $scripts ]]; then
			# Extract script name and remove all whitespace and quotes
			script_name=$(echo "$scripts" | awk -F ': ' '{gsub(/[" ]/, "", $1); print $1}' | tr -d '[:space:]')
			command="npm run $script_name"
			print "$command"
			# Add command to history and execute it
			print -s "$command"
			eval "$command"
		else
			echo "Exit: No script selected."
		fi
	else
		echo "Error: No package.json."
	fi
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
	if [[ "$*" == "leaves" ]] || [[ "$*" == "ls" ]]; then
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
		local token
		token=$(echo "$1" | cut -d' ' -f1)
		query=$(echo "$*" | cut -d' ' -f2- | sed 's/ /+/g')

		echo "cht.sh/$token/$query"
		curl "cht.sh/$token/$query"
	fi
}

function wttr() {
	if [[ $# -eq 0 ]]; then
		curl "v2d.wttr.in/"
	else
		local location
		location=$(echo "$@" | tr ' ' '+')
		curl -s "v2d.wttr.in/$location"
	fi
}

# always pipe brew leaves to fzf
function brew() {
	if [[ "$*" == "leaves" ]]; then
		command brew leaves | fzf
	else
		command brew "$@"
	fi
}
