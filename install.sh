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
echo "Symlinks created in $CLAUDE_DIR"

# --- Install plugins from settings.json ---
SETTINGS="$SCRIPT_DIR/settings.json"

if ! command -v claude &>/dev/null; then
  echo "Claude CLI not found — skipping plugin installation."
  exit 0
fi

if ! command -v jq &>/dev/null; then
  echo "jq not found — skipping plugin installation. Install jq to enable."
  exit 0
fi

if [ ! -f "$SETTINGS" ]; then
  echo "No settings.json found — skipping plugin installation."
  exit 0
fi

echo ""
echo "Installing plugins from settings.json..."

# Add extra marketplaces first
for name in $(jq -r '.extraKnownMarketplaces // {} | keys[]' "$SETTINGS"); do
  source_url=$(jq -r ".extraKnownMarketplaces[\"$name\"].source.url" "$SETTINGS")
  existing=$(claude plugin marketplace list 2>/dev/null)
  if echo "$existing" | grep -q "$name"; then
    echo "Marketplace already added: $name"
  else
    echo "Adding marketplace: $name ($source_url)"
    claude plugin marketplace add "$source_url" || echo "  Warning: failed to add marketplace $name"
  fi
done

# Get list of already-installed plugins
installed=$(claude plugin list 2>/dev/null || true)

# Install each enabled plugin
for plugin in $(jq -r '.enabledPlugins // {} | keys[]' "$SETTINGS"); do
  # Extract short name (before @) for checking installed list
  short_name="${plugin%%@*}"
  if echo "$installed" | grep -q "$short_name"; then
    echo "Already installed: $plugin"
  else
    echo "Installing: $plugin"
    claude plugin install "$plugin" || echo "  Warning: failed to install $plugin"
  fi
done

echo ""
echo "Done!"
