#!/usr/bin/env bash

# -- Aliases
alias lop="linear issue view -a"
alias linear-open="linear issue view -a"
alias back="cd ~/dev/oneadvisory/backend/"
alias front="cd ~/dev/oneadvisory/frontend/"
alias gcm2="git checkout master2 && git reset --hard origin/master"
alias grom="git reset --hard origin/master"
alias vip='osascript ~/dev/dotfiles/applescripts/vip-access-copy.applescript'
alias work="cd ~/dev/oneadvisory/worktrees/worktree1/"

alias run_frontend="npm ci && npm run dev"                     # for frontend
alias run_build_frontend="npm ci && npm run build:packages && npm run dev"             # for frontend

alias run_fe_interview="npm ci && npm run start"               # for fe interviews
alias run_fs_interview="npm ci && npm run seed && npm run dev" # for fs interviews

# -- Functions

# checkout the worktree's branch and reset it to origin/master
alias gcmw="git_checkout_master_worktree"
git_checkout_master_worktree() {
	local worktrees_dir=~/dev/oneadvisory/worktrees
	if [[ "$(dirname "$PWD")" != "$worktrees_dir" ]]; then
		echo "gcmw: must be run from a worktree root under $worktrees_dir"
		return 1
	fi
	local branch
	branch=$(basename "$PWD")
	if ! git diff --quiet || ! git diff --cached --quiet; then
		echo "gcmw: working tree is dirty. Continue? (y/N) "
		read -r -k 1 REPLY
		echo
		[[ $REPLY =~ ^[Yy]$ ]] || return 1
	fi
	git fetch origin master || return 1
	git checkout -B "$branch" || return 1
	git reset --hard origin/master
}

# checkout each release branch and fetch/pull the latest
git_pull_release_branches() {
	local branches=(release/staging release/demo release/prod)
	local branch
	for branch in "${branches[@]}"; do
		echo "-- $branch"
		git checkout "$branch" || return 1
		git fetch || return 1
		git pull || return 1
	done
}

# check whether merging release/demo or release/prod into release/staging
# would change staging, without touching the working tree
git_test_release_branches() {
	local target="master"
	local sources=(release/staging release/demo release/prod)
	git fetch origin "$target" "${sources[@]}" || return 1

	local base_tree
	base_tree=$(git rev-parse "origin/$target^{tree}") || return 1

	local src merged rc merged_tree
	for src in "${sources[@]}"; do
		echo "-- origin/$src -> origin/$target"
		merged=$(git merge-tree --write-tree "origin/$target" "origin/$src")
		rc=$?
		if [[ $rc -gt 1 ]]; then
			echo "   error: merge-tree failed"
			continue
		fi
		[[ $rc -eq 1 ]] && echo "   ⚠️  merge would CONFLICT"
		merged_tree=${merged%%$'\n'*}
		if [[ "$merged_tree" == "$base_tree" ]]; then
			echo "   no changes to $target"
		else
			echo "   would change $target:"
			git diff --stat "$base_tree" "$merged_tree"
		fi
	done
}

# pull the latest release branches, then test the merges into staging
git_pull_and_test_release_branches() {
	git_pull_release_branches || return 1
	git_test_release_branches
}

# fuzzy select *.test.* files and run them with npm run test:unit
alias tuf="test_unit_fuzzy"
test_unit_fuzzy() {
	local selected
	selected=$(fd --type f --glob "*.test.*" | fzf --prompt="test: " --multi)
	if [[ -n "$selected" ]]; then
		local files=("${(@f)selected}")
		local command="npm run test:unit -- ${files[@]}"
		print "$command"
		print -s "$command"
		eval "$command"
	fi
}

# cd to git worktree directories
alias workf="fuzzy_worktree_cd"
alias fwork="fuzzy_worktree_cd"
fuzzy_worktree_cd() {
	local dir=~/dev/oneadvisory/worktrees
	[[ -d "$dir" ]] || {
		echo "worktrees directory not found: $dir"
		return 1
	}
	local selected
	selected=$(fd --type d --max-depth 1 . "$dir" | fzf --prompt="worktree: ")
	[[ -n "$selected" ]] && cd "$selected" || exit
}

# cd to the frontend repo's claude code worktree directories
alias cf="fuzzy_frontend_claude_worktree_cd"
alias cwf="fuzzy_frontend_claude_worktree_cd"
alias claude_workflow_fuzzy="fuzzy_frontend_claude_worktree_cd"
fuzzy_frontend_claude_worktree_cd() {
	local dir=~/dev/oneadvisory/frontend/.claude/worktrees
	[[ -d "$dir" ]] || {
		echo "worktrees directory not found: $dir"
		return 1
	}
	local selected
	selected=$(fd --type d --max-depth 1 . "$dir" | fzf --prompt="frontend worktree: ")
	[[ -n "$selected" ]] && cd "$selected" || return 1
}

# decrypts argument or clipboard, outputs result and copies to clipboard
decrypt-prod() {
	pushd ~/dev/oneadvisory/backend/ || return 1
	export AWS_PROFILE=oa-prod # aws profile with `prod` acccess
	ensure_sso
	CRYPTO_PRIMARY_KEY_SECRET=$(chamber read -q prod/auth CRYPTO_PRIMARY_KEY_SECRET)
	export CRYPTO_PRIMARY_KEY_SECRET
	CRYPTO_PRIMARY_KEY_ID=$(chamber read -q prod/auth CRYPTO_PRIMARY_KEY_ID)
	export CRYPTO_PRIMARY_KEY_ID
	if [ $# -eq 0 ]; then
		./bin/dispatch --profile prod crypto decrypt "$(pbpaste)" | jq | tee >(pbcopy)
	else
		./bin/dispatch --profile prod crypto decrypt "$@" | jq | tee >(pbcopy)
	fi
	popd || return
}

decrypt-default() {
	pushd ~/dev/oneadvisory/backend/ || return 1
	ensure_sso
	if [ $# -eq 0 ]; then
		dispatch -p prod crypto decrypt "$(pbpaste)" | jq | tee >(pbcopy)
	else
		dispatch -p prod crypto decrypt "$@" | jq | tee >(pbcopy)
	fi
	popd || return
}

# copied from frontend repo scripts
ensure_sso() {
	echo ${AWS_PROFILE}
	aws sts get-caller-identity --profile ${AWS_PROFILE} &>/dev/null

	EXIT_CODE="$?" # $? is the exit code of the last statement
	if [ "$EXIT_CODE" -ne 0 ]; then
		aws sso login --profile ${AWS_PROFILE}
	fi
}

# -- TODO?: migrate to .env and setup direnv?
# export AWS_PROFILE=aws-dispatch-dev01 # use this for forms building
# export AWS_PROFILE=oa-prod # use this for forms building # use this for decrypt
export AWS_PROFILE=dispatch-dev01 # use this for development
# export AWS_PROFILE=oa-dev
# export AWS_PROFILE=duplo
export AWS_REGION=us-east-1
export ECR_AWS_PROFILE=oa-dev

# to run dc locally
# AWS_PROFILE=dispatch-dev01 CHAMBER_TENANT=develop/ npx yarn dev:services

# Override tsc command to warn when running in frontend directory
tsc() {
	# Check if current directory contains /frontend and first arg is -b
	if [[ "$PWD" == *"/frontend"* ]] && [[ "$1" == "-b" ]]; then
		echo "⚠️  Warning: You're running 'tsc -b' in a frontend directory."
		echo "Did you mean to run 'npx tsc -b' instead?"
		echo -n "Continue with 'tsc -b'? (y/N/Esc to cancel): "
		read -r -k 1 REPLY
		echo

		# Check if ESC was pressed (character code 27)
		if [[ $REPLY == $'\e' ]]; then
			echo "Cancelled."
			return 0
		elif [[ $REPLY =~ ^[Yy]$ ]]; then
			# User pressed 'y', run the actual tsc command
			command tsc "$@"
		else
			# User pressed anything else, run npx tsc
			echo "Running 'npx tsc $*' instead..."
			command npx tsc "$@"
		fi
		return $?
	fi

	# Run the actual tsc command
	command tsc "$@"
}
