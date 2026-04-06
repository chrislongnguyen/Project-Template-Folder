#!/usr/bin/env bash
# version: 1.0 | last_updated: 2026-03-30
# save-context-state.sh — PreCompact hook
# Saves current working state to project memory before context compaction.
# PreCompact is observe-only (cannot block compaction).
set -euo pipefail

# Read hook input from stdin
INPUT=$(cat)
COMPACT_TYPE=$(echo "$INPUT" | jq -r '.matcher // "auto"')

# Resolve project root
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [[ -z "$PROJECT_ROOT" ]]; then
  exit 0
fi

# Debounce: skip if last save was < 60 seconds ago
DEBOUNCE_FILE="/tmp/claude-precompact-debounce"
if [[ -f "$DEBOUNCE_FILE" ]]; then
  # stat -f (macOS) / stat -c (Linux) for mtime
  mtime=$(stat -f %m "$DEBOUNCE_FILE" 2>/dev/null || stat -c %Y "$DEBOUNCE_FILE" 2>/dev/null || echo 0)
  age=$(( $(date +%s) - mtime ))
  if [[ $age -lt 60 ]]; then
    exit 0
  fi
fi
touch "$DEBOUNCE_FILE"

# Save state to project memory directory
MEMORY_DIR="$PROJECT_ROOT/.claude/memory"
mkdir -p "$MEMORY_DIR"

REPO=$(basename "$PROJECT_ROOT")
TIMESTAMP=$(date +%Y-%m-%dT%H:%M:%S)
STATE_FILE="$MEMORY_DIR/precompact-state.md"

{
  echo "---"
  echo "name: Pre-Compaction State"
  echo "description: Auto-saved working state before context compaction"
  echo "type: project"
  echo "last_saved: $TIMESTAMP"
  echo "compact_type: $COMPACT_TYPE"
  echo "---"
  echo ""
  echo "# Pre-Compaction State — $TIMESTAMP"
  echo ""
  echo "## Git State"
  echo "\`\`\`"
  echo "Branch: $(git branch --show-current 2>/dev/null || echo 'unknown')"
  echo "Last commit: $(git log --oneline -1 2>/dev/null || echo 'none')"
  echo ""
  echo "Modified files:"
  git status --short 2>/dev/null || echo "(no changes)"
  echo "\`\`\`"
  echo ""
  echo "## Task Progress"
  echo ""
  # Check for SEQUENCE.md to extract current progress
  for seq_file in "$PROJECT_ROOT"/*/SEQUENCE.md; do
    if [[ -f "$seq_file" ]]; then
      echo "Sequence: $(basename "$(dirname "$seq_file")")/SEQUENCE.md"
      # Extract task count indicators
      grep -c "^| T" "$seq_file" 2>/dev/null && echo " tasks found" || true
      break
    fi
  done
  echo ""
  echo "## Recent Changes"
  echo "\`\`\`"
  git log --oneline -5 2>/dev/null || echo "(no commits)"
  echo "\`\`\`"
} > "$STATE_FILE"

exit 0
