#!/usr/bin/env bash
# version: 2.5 | status: draft | last_updated: 2026-04-09
# setup-obsidian.sh — one-command installer for LTC Obsidian workspace
# Copies Bases and Templater templates into an Obsidian vault's .obsidian/ directory

set -euo pipefail

# Resolve script location (essential for relative path resolution)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source and target locations (Iteration 2: moved from 4-EXECUTE/src/ to _genesis/)
SRC_BASES="$PROJECT_ROOT/_genesis/obsidian/bases"
SRC_TEMPLATES="$PROJECT_ROOT/_genesis/obsidian/templates"

# Optional: accept VAULT_ROOT as argument, default to current directory
VAULT_ROOT="${1:-.}"

# Normalize VAULT_ROOT to absolute path
VAULT_ROOT="$(cd "$VAULT_ROOT" 2>/dev/null && pwd)" || {
  echo "ERROR: VAULT_ROOT directory does not exist: $1"
  exit 1
}

# Target directories inside the vault (_genesis/ is the canonical shared resources folder)
TARGET_BASES="$VAULT_ROOT/_genesis/obsidian/bases"
TARGET_TEMPLATES="$VAULT_ROOT/_genesis/obsidian/templates"
TARGET_OBSIDIAN="$VAULT_ROOT/.obsidian"

# Verify source directories exist
if [[ ! -d "$SRC_BASES" ]]; then
  echo "ERROR: Source bases directory not found: $SRC_BASES"
  exit 1
fi

if [[ ! -d "$SRC_TEMPLATES" ]]; then
  echo "ERROR: Source templates directory not found: $SRC_TEMPLATES"
  exit 1
fi

# Create target directories if they don't exist (idempotent)
mkdir -p "$TARGET_BASES"
mkdir -p "$TARGET_TEMPLATES"
mkdir -p "$TARGET_OBSIDIAN"

# Copy base files to target — skip if source = target (vault IS the project repo)
if [[ "$SRC_BASES" != "$TARGET_BASES" ]]; then
  cp -f "$SRC_BASES"/*.base "$TARGET_BASES/" 2>/dev/null || {
    echo "ERROR: Failed to copy base files from $SRC_BASES"
    exit 1
  }
else
  echo "✓ Bases already in place (vault = project repo — no copy needed)"
fi

# Copy template files to target — skip if source = target
if [[ "$SRC_TEMPLATES" != "$TARGET_TEMPLATES" ]]; then
  cp -f "$SRC_TEMPLATES"/*.md "$TARGET_TEMPLATES/" 2>/dev/null || {
    echo "ERROR: Failed to copy template files from $SRC_TEMPLATES"
    exit 1
  }
else
  echo "✓ Templates already in place (vault = project repo — no copy needed)"
fi

# Create a minimal community-plugins.json hint file in .obsidian/
# This lists required COMMUNITY plugins — Bases is a core feature since Obsidian v1.8+
PLUGINS_FILE="$TARGET_OBSIDIAN/community-plugins.json"
cat > "$PLUGINS_FILE" << 'EOF'
[
  "templater-obsidian",
  "dataview",
  "obsidian-kanban"
]
EOF

# Install CSS snippet
SRC_SNIPPET="$PROJECT_ROOT/_genesis/obsidian/ltc-bases-colors.css"
TARGET_SNIPPETS="$VAULT_ROOT/.obsidian/snippets"
if [[ -f "$SRC_SNIPPET" ]]; then
  mkdir -p "$TARGET_SNIPPETS"
  cp -f "$SRC_SNIPPET" "$TARGET_SNIPPETS/ltc-bases-colors.css"
fi

# Count files for summary
BASE_COUNT=$(find "$TARGET_BASES" -name "*.base" -type f | wc -l)
TEMPLATE_COUNT=$(find "$TARGET_TEMPLATES" -name "*.md" -type f | wc -l)

# Print summary
echo "✓ Obsidian workspace setup complete!"
echo ""
echo "Installation summary:"
echo "  Vault root: $VAULT_ROOT"
echo "  Bases installed: $BASE_COUNT files → $TARGET_BASES/"
echo "  Templates installed: $TEMPLATE_COUNT files → $TARGET_TEMPLATES/"
echo "  Plugin hint: $PLUGINS_FILE"
echo ""
echo "Next steps:"
echo "  1. Open Obsidian and point to: $VAULT_ROOT"
echo "  2. Bases is a core feature (v1.8+) — no install needed"
echo "  3. Install community plugins from Settings → Community Plugins:"
echo "     - Templater"
echo "     - Dataview"
echo "     - Obsidian Kanban"
echo "  4. Reload Obsidian (Ctrl+R or Cmd+R)"
echo "  5. Open _genesis/obsidian/bases/ — dashboards will load"
echo "  6. New note? Use Templater → ues-deliverable or daily-note template"

exit 0
