#!/bin/bash
# Install dxtools-ai-compute skill for Codex / MiMoCode
# Usage: curl -sSL https://raw.githubusercontent.com/modayishujia/view.dxtools.top/main/install-skill.sh | bash

set -e

REPO_URL="https://github.com/modayishujia/view.dxtools.top.git"
SKILL_NAME="dxtools-ai-compute"
TMP_DIR=$(mktemp -d)

echo "📦 Installing $SKILL_NAME skill..."

# Clone repo
git clone --depth 1 "$REPO_URL" "$TMP_DIR" 2>/dev/null

# Detect skill directory
if [ -d "$HOME/.codex/skills" ]; then
  SKILL_DIR="$HOME/.codex/skills/$SKILL_NAME"
elif [ -d "$HOME/.agents/skills" ]; then
  SKILL_DIR="$HOME/.agents/skills/$SKILL_NAME"
else
  SKILL_DIR="$HOME/.codex/skills/$SKILL_NAME"
  mkdir -p "$(dirname "$SKILL_DIR")"
fi

# Copy skill files
mkdir -p "$SKILL_DIR"
cp -r "$TMP_DIR/.codex-skill/"* "$SKILL_DIR/"

# Cleanup
rm -rf "$TMP_DIR"

echo "✅ Installed to $SKILL_DIR"
echo ""
echo "Usage:"
echo "  Ask your AI tool: 'What's the current AI compute capital flow status?'"
echo "  Or: 'Fetch view.dxtools.top data and summarize key signals'"
