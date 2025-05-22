#!/usr/bin/env bash

# -- Aliases
alias gcm2="git checkout master2 && git reset --hard origin/master"
alias front="cd ~/dev/oneadvisory/frontend"
alias work="cd ~/dev/oneadvisory/frontend-worktree"
alias back="cd ~/dev/oneadvisory/backend"
alias decrypt="cd ~/dev/oneadvisory/backend/ && ./bin/dispatch crypto decrypt" # TODO?: create a function for this to add quotes and return to previous directory

# -- TODO?: migrate to .env and setup direnv?
export AWS_PROFILE=aws-dispatch-dev01 # use this for forms building
# export AWS_PROFILE=oa-prod # use this for forms building
# export AWS_PROFILE=dispatch-dev01  # use this for development
# export AWS_PROFILE=oa-dev
# export AWS_PROFILE=duplo
export AWS_REGION=us-east-1
export ECR_AWS_PROFILE=oa-dev

# to run dc locally
# AWS_PROFILE=dispatch-dev01 CHAMBER_TENANT=develop/ npx yarn dev:services
