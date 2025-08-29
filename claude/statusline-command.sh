#!/bin/bash

# Read JSON input
input=$(cat)

# Color definitions (ANSI escape codes)
# Using dimmed/muted colors that are easier on the eyes
BLUE='\033[2;34m'        # Directory path (dim blue)
PURPLE='\033[2;35m'      # Model name (dim purple)
GREEN='\033[2;32m'       # Cost (dim green)
YELLOW='\033[2;33m'      # Duration (dim yellow)
CYAN='\033[2;36m'        # Additional info (dim cyan)
RESET='\033[0m'          # Reset to default

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

# Add current directory with blue color
status_line+="${BLUE}${current_dir}${RESET}"

# Add model name with green color and brackets
status_line+=" ${GREEN}[${model_name}]${RESET}"

# Add cost with purple color if available
if [ -n "$cost" ]; then
	status_line+=" ${PURPLE}${cost}${RESET}"
fi

# Add duration with yellow color if available
if [ -n "$duration" ]; then
	status_line+=" ${YELLOW}${duration}${RESET}"
fi

# Print the final status line
printf "%b" "$status_line"
