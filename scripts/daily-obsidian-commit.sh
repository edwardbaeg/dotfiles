#!/bin/bash

# Daily Obsidian auto-commit script
# Checks for uncommitted changes and commits with "Chore: update"

REPO_DIR="$HOME/Sync/Obsidian Vault"

cd "$REPO_DIR" || exit 1

# Check if there are any changes to commit
if git diff --quiet && git diff --cached --quiet; then
    echo "No changes to commit"
    exit 0
fi

# Add all changes and commit
git add .
git commit -m "Chore: update"

echo "Auto-commit completed: $(date)"