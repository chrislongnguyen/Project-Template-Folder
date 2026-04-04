#!/usr/bin/env bash
# version: 1.2 | last_updated: 2026-04-04
# state-saver.sh — PostToolUse hook (Write|Edit|MultiEdit)
# Snapshots current git state to the vault for crash recovery.
set -euo pipefail

# Debounce: skip if last write was < 30 seconds ago (avoids Drive latency on every edit)
DEBOUNCE_FILE="/tmp/claude-state-saver-debounce"
if [[ -f "$DEBOUNCE_FILE" ]]; then
  age=$(( $(date +%s) - $(stat -f %m "$DEBOUNCE_FILE" 2>/dev/null || echo 0) ))
  if [[ $age -lt 30 ]]; then
    exit 0
  fi
fi
touch "$DEBOUNCE_FILE"

# Resolve config.sh relative to this script (works in both plugin and project mode)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_LIB="${CLAUDE_PLUGIN_ROOT:-$SCRIPT_DIR}/hooks/lib/config.sh"
[[ -f "$CONFIG_LIB" ]] || CONFIG_LIB="$SCRIPT_DIR/lib/config.sh"
[[ -f "$CONFIG_LIB" ]] || exit 0
source "$CONFIG_LIB"

STATE_DIR="$VAULT/07-Claude/state"
mkdir -p "$STATE_DIR"

DATE=$(date +%Y-%m-%d)
STATE_FILE="$STATE_DIR/session-state-$DATE.md"

git rev-parse --git-dir >/dev/null 2>&1 || exit 0
REPO=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
TIMESTAMP=$(date +%H:%M:%S)

{
  echo "# Session state — $DATE"
  echo "_Last updated: $TIMESTAMP | Repo: ${REPO}_"
  echo ""
  echo "## Changed files"
  git status --short 2>/dev/null || echo "(no changes)"
  echo ""
  echo "## Staged diff summary"
  git diff --stat HEAD 2>/dev/null || true
  echo ""
  echo "## Recent commits"
  git log --oneline -5 2>/dev/null || true
} > "$STATE_FILE"

exit 0
