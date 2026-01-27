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
    current_target=$(readlink "$target")
    echo "Updating $item symlink. (original symlink: $current_target)"
    rm "$target"
  elif [ -e "$target" ] || [ -d "$target" ]; then
    timestamp=$(date +%Y%m%d_%H%M%S)
    backup="$target.bak.$timestamp"
    echo "Backing up existing $item to $item.bak.$timestamp"
    mv "$target" "$backup"
  fi

  ln -s "$source" "$target"
  echo "Linked: $item to $target"
done

echo ""
echo "Done! Symlinks created in $CLAUDE_DIR"
