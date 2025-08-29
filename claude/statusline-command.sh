#!/bin/bash

# Read JSON input
input=$(cat)

# Color definitions (ANSI escape codes)
# Using standard colors
BLUE='\033[34m'        # Directory path (blue)
PURPLE='\033[35m'      # Model name (purple)
GREEN='\033[32m'       # Cost (green)
YELLOW='\033[33m'      # Duration (yellow)
CYAN='\033[36m'        # Additional info (cyan)
RESET='\033[0m'        # Reset to default

# Helper function to get cost
get_cost() {
	local cost_val=$(echo "$1" | jq -r '.cost.total_cost_usd // empty')
	if [ -n "$cost_val" ] && [ "$cost_val" != "null" ]; then
		printf "$%.2f" "$cost_val"
	fi
}

# Helper function to get duration
get_duration() {
	local duration_ms=$(echo "$1" | jq -r '.cost.total_duration_ms // empty')
	if [ -n "$duration_ms" ] && [ "$duration_ms" != "null" ]; then
		local duration_s=$((duration_ms / 1000))
		echo "${duration_s}s"
	fi
}

# Helper functions for common extractions
get_project_dir() { echo "$input" | jq -r '.workspace.project_dir'; }
get_version() { echo "$input" | jq -r '.version'; }
get_lines_added() { echo "$input" | jq -r '.cost.total_lines_added'; }
get_lines_removed() { echo "$input" | jq -r '.cost.total_lines_removed'; }

# Extract values
current_dir=$(echo "$input" | jq -r '.workspace.current_dir' | sed "s|$HOME|~|")
model_name=$(echo "$input" | jq -r '.model.display_name')
cost=$(get_cost "$input")
duration=$(get_duration "$input")

# Build colored status line
status_line=""

# Add current directory with cyan color
status_line+="${CYAN}${current_dir}${RESET}"

# Add model name with green color and brackets
status_line+=" ${GREEN}[${model_name}]${RESET}"

# Add cost with yellow color if available
if [ -n "$cost" ]; then
	status_line+=" ${YELLOW}${cost}${RESET}"
fi

# Add duration with purple color if available
# if [ -n "$duration" ]; then
# 	status_line+=" ${PURPLE}${duration}${RESET}"
# fi

# Print the final status line
printf "%b" "$status_line"
