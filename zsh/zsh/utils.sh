# Shell utility functions

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
