#!/bin/bash

# Read JSON input
input=$(cat)

# Color definitions (ANSI escape codes)
BLUE='\033[34m'
PURPLE='\033[35m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
RESET='\033[0m'

get_cost() {
	local cost_val=$(echo "$1" | jq -r '.cost.total_cost_usd // empty')
	if [ -n "$cost_val" ] && [ "$cost_val" != "null" ]; then
		printf "$%.2f" "$cost_val"
	fi
}

get_duration() {
	local duration_ms=$(echo "$1" | jq -r '.cost.total_duration_ms // empty')
	if [ -n "$duration_ms" ] && [ "$duration_ms" != "null" ]; then
		local duration_s=$((duration_ms / 1000))
		echo "${duration_s}s"
	fi
}

get_project_dir() { echo "$input" | jq -r '.workspace.project_dir'; }
get_version() { echo "$input" | jq -r '.version'; }
get_lines_added() { echo "$input" | jq -r '.cost.total_lines_added'; }
get_lines_removed() { echo "$input" | jq -r '.cost.total_lines_removed'; }

current_dir=$(echo "$input" | jq -r '.workspace.current_dir' | sed "s|$HOME|~|")
model_name=$(echo "$input" | jq -r '.model.display_name')
cost=$(get_cost "$input")
duration=$(get_duration "$input")

status_line=""

# Add current directory
status_line+="${CYAN}${current_dir}${RESET}"

# Add model name
status_line+=" ${GREEN}[${model_name}]${RESET}"

# Add cost
if [ -n "$cost" ]; then
	status_line+=" ${YELLOW}${cost}${RESET}"
fi

# Add duration
# if [ -n "$duration" ]; then
# 	status_line+=" ${PURPLE}${duration}${RESET}"
# fi

# Print the final status line
printf "%b" "$status_line"
