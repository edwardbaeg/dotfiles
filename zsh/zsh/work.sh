#!/usr/bin/env bash

# -- Aliases
alias gcm2="git checkout master2 && git reset --hard origin/master"
alias front="cd ~/dev/oneadvisory/frontend"
alias work="cd ~/dev/oneadvisory/frontend-worktree"
alias back="cd ~/dev/oneadvisory/backend"

# decrypts argument or clipboard, outputs result and copies to clipboard
decrypt() {
	pushd ~/dev/oneadvisory/backend/ || return 1
	export AWS_PROFILE=oa-prod # aws profile with `prod` acccess
	ensure_sso
	CRYPTO_PRIMARY_KEY_SECRET=$(chamber read -q prod/auth CRYPTO_PRIMARY_KEY_SECRET)
	export CRYPTO_PRIMARY_KEY_SECRET
	CRYPTO_PRIMARY_KEY_ID=$(chamber read -q prod/auth CRYPTO_PRIMARY_KEY_ID)
	export CRYPTO_PRIMARY_KEY_ID
	if [ $# -eq 0 ]; then
		./bin/dispatch crypto decrypt "$(pbpaste)" | jq | tee >(pbcopy)
	else
		./bin/dispatch crypto decrypt "$@" | jq | tee >(pbcopy)
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
export AWS_PROFILE=aws-dispatch-dev01 # use this for forms building
# export AWS_PROFILE=oa-prod # use this for forms building # use this for decrypt
# export AWS_PROFILE=dispatch-dev01  # use this for development
# export AWS_PROFILE=oa-dev
# export AWS_PROFILE=duplo
export AWS_REGION=us-east-1
export ECR_AWS_PROFILE=oa-dev

# to run dc locally
# AWS_PROFILE=dispatch-dev01 CHAMBER_TENANT=develop/ npx yarn dev:services
