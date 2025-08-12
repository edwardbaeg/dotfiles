#!/bin/bash

# Test script for the remove_lines_from_file function

# Source the utils file
source ./utils.sh

# Create a test file
test_file="test_data.txt"
echo "Creating test file: $test_file"
cat >"$test_file" <<'EOF'
Line 1: First line
Line 2: Second line
Line 3: Third line
Line 4: Fourth line
Line 5: Fifth line
Line 6: Sixth line
Line 7: Seventh line
Line 8: Eighth line
Line 9: Ninth line
Line 10: Tenth line
EOF

echo "Original file contents:"
cat -n "$test_file"
echo

# Test 1: Remove single line (line 5)
echo "Test 1: Removing line 5"
cp "$test_file" "${test_file}.backup1"
remove_lines_from_file "$test_file" 5
echo "Result after removing line 5:"
cat -n "$test_file"
echo

# Restore for next test
cp "${test_file}.backup1" "$test_file"

# Test 2: Remove multiple lines (lines 3, 7, 9)
echo "Test 2: Removing lines 3, 7, and 9"
cp "$test_file" "${test_file}.backup2"
remove_lines_from_file "$test_file" 3 7 9
echo "Result after removing lines 3, 7, and 9:"
cat -n "$test_file"
echo

# Restore for next test
cp "${test_file}.backup2" "$test_file"

# Test 3: Remove lines in random order (lines 10, 2, 6, 1)
echo "Test 3: Removing lines 10, 2, 6, and 1 (random order)"
remove_lines_from_file "$test_file" 10 2 6 1
echo "Result after removing lines 10, 2, 6, and 1:"
cat -n "$test_file"
echo

# Clean up
echo "Cleaning up test files..."
rm -f "$test_file" "${test_file}.backup1" "${test_file}.backup2"

echo "Test completed!"
