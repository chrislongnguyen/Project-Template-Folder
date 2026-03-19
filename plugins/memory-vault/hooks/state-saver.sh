#!/usr/bin/env bash
# state-saver.sh — PostToolUse hook (Write|Edit|MultiEdit)
# Snapshots current git state to the vault for crash recovery.
set -euo pipefail

source "${CLAUDE_PLUGIN_ROOT}/hooks/lib/config.sh"

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
