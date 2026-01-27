#!/bin/bash
# install.sh - Symlinks Claude Code configuration to ~/.claude
#
# Run from the repo directory:
#   ./install.sh

set -e

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Setting up Claude Code configuration..."

# Create ~/.claude if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Directories and files to symlink
items=(commands hooks skills .agent_docs settings.json)

for item in "${items[@]}"; do
  source="$SCRIPT_DIR/$item"
  target="$CLAUDE_DIR/$item"

  if [ ! -e "$source" ]; then
    echo "Skipping $item (not found)"
    continue
  fi

  if [ -L "$target" ]; then
    echo "Updating symlink: $item"
    rm "$target"
  elif [ -e "$target" ]; then
    echo "Backing up existing $item to $item.bak"
    mv "$target" "$target.bak"
  fi

  ln -s "$source" "$target"
  echo "Linked: $item"
done

echo ""
echo "Done! Symlinks created in $CLAUDE_DIR"
