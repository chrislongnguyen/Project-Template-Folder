#!/usr/bin/env bash
# version: 2.0 | status: draft | last_updated: 2026-04-03
# setup-obsidian.sh — one-command installer for LTC Obsidian workspace
# Copies Bases and Templater templates into an Obsidian vault's .obsidian/ directory

set -euo pipefail

# Resolve script location (essential for relative path resolution)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source and target locations
SRC_BASES="$PROJECT_ROOT/4-EXECUTE/src/obsidian/bases"
SRC_TEMPLATES="$PROJECT_ROOT/4-EXECUTE/src/obsidian/templates"

# Optional: accept VAULT_ROOT as argument, default to current directory
VAULT_ROOT="${1:-.}"

# Normalize VAULT_ROOT to absolute path
VAULT_ROOT="$(cd "$VAULT_ROOT" 2>/dev/null && pwd)" || {
  echo "ERROR: VAULT_ROOT directory does not exist: $1"
  exit 1
}

# Target directories inside the vault
TARGET_BASES="$VAULT_ROOT/0-REUSABLE-RESOURCES/bases"
TARGET_TEMPLATES="$VAULT_ROOT/0-REUSABLE-RESOURCES/templates"
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

# Copy base files to target (idempotent with -f for overwrite)
cp -f "$SRC_BASES"/*.base "$TARGET_BASES/" 2>/dev/null || {
  echo "ERROR: Failed to copy base files from $SRC_BASES"
  exit 1
}

# Copy template files to target (idempotent with -f for overwrite)
cp -f "$SRC_TEMPLATES"/*.md "$TARGET_TEMPLATES/" 2>/dev/null || {
  echo "ERROR: Failed to copy template files from $SRC_TEMPLATES"
  exit 1
}

# Create a minimal community-plugins.json hint file in .obsidian/
# This lists required plugins — users still need to install from Obsidian marketplace
PLUGINS_FILE="$TARGET_OBSIDIAN/community-plugins.json"
cat > "$PLUGINS_FILE" << 'EOF'
[
  "obsidian-bases",
  "templater-obsidian",
  "dataview",
  "obsidian-kanban"
]
EOF

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
echo "  2. Install plugins from Settings → Community Plugins:"
echo "     - Obsidian Bases"
echo "     - Templater"
echo "     - Dataview"
echo "     - Obsidian Kanban"
echo "  3. Reload Obsidian (Ctrl+R or Cmd+R)"
echo "  4. Open 0-REUSABLE-RESOURCES/bases/ — dashboards will load"
echo "  5. New note? Use Templater → ues-deliverable or daily-note template"

exit 0
