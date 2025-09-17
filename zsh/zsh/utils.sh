# Shell utility functions

# Generic fuzzy file finder and editor opener
# Usage: vim_files_in_dir <search_dir> [--patterns "pattern"] [--query "query"] [--ignore "dir1,dir2"]
function vim_files_in_dir() {
	local search_dir="$1"
	shift

	local file_patterns=""
	local query=""
	local ignore_dirs=""

	# Parse flags
	while [[ $# -gt 0 ]]; do
		case $1 in
		--patterns)
			file_patterns="$2"
			shift 2
			;;
		--query)
			query="$2"
			shift 2
			;;
		--ignore)
			ignore_dirs="$2"
			shift 2
			;;
		*)
			echo "Error: Unknown option $1"
			echo "Usage: vim_files_in_dir <search_dir> [--patterns \"pattern\"] [--query \"query\"] [--ignore \"dir1,dir2\"]"
			return 1
			;;
		esac
	done

	if [[ -z "$search_dir" ]]; then
		echo "Error: Directory path required"
		echo "Usage: vim_files_in_dir <search_dir> [--patterns \"pattern\"] [--query \"query\"] [--ignore \"dir1,dir2\"]"
		return 1
	fi

	if [[ ! -d "$search_dir" ]]; then
		echo "Error: Directory '$search_dir' does not exist"
		return 1
	fi

	local IFS=$'\n'
	local files
	local find_cmd="find '$search_dir' -type f"

	# Add ignore directories if provided
	if [[ -n "$ignore_dirs" ]]; then
		# Split ignore_dirs by comma and add -not -path for each
		local IFS_OLD=$IFS
		IFS=','
		local ignore_array=($ignore_dirs)
		IFS=$IFS_OLD

		for ignore_dir in "${ignore_array[@]}"; do
			# Trim whitespace
			ignore_dir=$(echo "$ignore_dir" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
			find_cmd+=" -not -path '*/$ignore_dir/*'"
		done
	fi

	# Add file patterns if provided
	if [[ -n "$file_patterns" ]]; then
		find_cmd+=" $file_patterns"
	fi

	# Execute find command and pipe to fzf
	files=($(eval "$find_cmd" |
		fzf --query="$query" --multi --select-1 --exit-0 --preview 'bat --color=always {}' --preview-window '~3'))

	IFS=' '
	[[ -n "$files" ]] && {
		local command="${EDITOR:-nvim}"
		for file in "${files[@]}"; do
			# Escape spaces in filename for display command
			local escaped_file="${file// /\\ }"
			command+=" $escaped_file"
		done
		print "$command"
		print -s "$command"
		eval "$command"
	}
}

# Remove lines from file by line numbers using sed
function remove_lines_from_file() {
	local file_path="$1"
	shift
	local line_numbers=("$@")

	if [[ ! -f "$file_path" ]]; then
		echo "Error: File '$file_path' does not exist"
		return 1
	fi

	if [[ ${#line_numbers[@]} -eq 0 ]]; then
		echo "Error: No line numbers provided"
		return 1
	fi

	# Sort line numbers in descending order to avoid line number shifts
	local sorted_lines=($(printf '%s\n' "${line_numbers[@]}" | sort -nr))

	# Create a temporary file
	local temp_file=$(mktemp)
	cp "$file_path" "$temp_file"

	# Remove lines one by one (starting from highest line number)
	for line_num in "${sorted_lines[@]}"; do
		if [[ "$line_num" -gt 0 ]]; then
			sed -i '' "${line_num}d" "$temp_file"
		fi
	done

	# Replace original file
	mv "$temp_file" "$file_path"

	echo "Removed ${#line_numbers[@]} line(s) from $file_path"
}
