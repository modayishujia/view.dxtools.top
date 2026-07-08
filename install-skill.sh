#!/bin/bash
# Install dxtools-ai-compute context for any AI coding tool
# Usage: curl -sSL https://raw.githubusercontent.com/modayishujia/view.dxtools.top/main/install-skill.sh | bash

set -e

REPO_URL="https://github.com/modayishujia/view.dxtools.top.git"
SKILL_NAME="dxtools-ai-compute"
TMP_DIR=$(mktemp -d)
INSTALLED=0

echo "📦 Installing $SKILL_NAME AI context..."

# Clone repo
git clone --depth 1 "$REPO_URL" "$TMP_DIR" 2>/dev/null

# Detect and install to all available tool directories
declare -A TOOL_DIRS=(
  ["Codex"]="$HOME/.codex/skills"
  ["MiMoCode"]="$HOME/.agents/skills"
  ["Claude Code"]="$HOME/.claude/skills"
)

for tool in "${!TOOL_DIRS[@]}"; do
  base="${TOOL_DIRS[$tool]}"
  # Create parent dir if tool is installed (check for config files)
  if [[ "$tool" == "Codex" && -d "$HOME/.codex" ]] || \
     [[ "$tool" == "MiMoCode" && -d "$HOME/.local/share/mimocode" ]] || \
     [[ "$tool" == "Claude Code" && -d "$HOME/.claude" ]]; then
    dest="$base/$SKILL_NAME"
    mkdir -p "$dest"
    cp -r "$TMP_DIR/.codex-skill/"* "$dest/"
    echo "  ✅ $tool → $dest"
    INSTALLED=$((INSTALLED+1))
  fi
done

# Also copy to project-local .ai-context/ for tools that read project files (Cursor, Windsurf, etc.)
PROJECT_CONTEXT=".ai-context"
if [ -d ".git" ] || [ -f "package.json" ] || [ -f "Cargo.toml" ] || [ -f "go.mod" ]; then
  mkdir -p "$PROJECT_CONTEXT/$SKILL_NAME"
  cp -r "$TMP_DIR/.codex-skill/"* "$PROJECT_CONTEXT/$SKILL_NAME/"
  # Also create a flat prompt file for Cursor/Windsurf
  cp "$TMP_DIR/.codex-skill/SKILL.md" "$PROJECT_CONTEXT/dxtools-prompt.md" 2>/dev/null || true
  echo "  ✅ Project-local → $PROJECT_CONTEXT/$SKILL_NAME/"
  INSTALLED=$((INSTALLED+1))
fi

# Cleanup
rm -rf "$TMP_DIR"

if [ $INSTALLED -eq 0 ]; then
  # Fallback: install to default location
  dest="$HOME/.codex/skills/$SKILL_NAME"
  mkdir -p "$dest"
  git clone --depth 1 "$REPO_URL" /tmp/dxtools-install 2>/dev/null
  cp -r /tmp/dxtools-install/.codex-skill/* "$dest/"
  rm -rf /tmp/dxtools-install
  echo "  ✅ Default → $dest"
fi

echo ""
echo "🎉 Done! Installed to $INSTALLED location(s)."
echo ""
echo "━━━ How to use ━━━"
echo ""
echo "With any AI tool, paste this prompt:"
echo ""
echo '  Fetch https://view.dxtools.top/data/indicators.json'
echo '  Summarize: investment stance, capex total, risk score,'
echo '  top 3 risk triggers, and any new events this week.'
echo ""
echo "Or ask: 'What is the current AI compute capital flow status?'"
echo ""
