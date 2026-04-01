#!/usr/bin/env bash
# version: 1.0 | last_updated: 2026-03-30
# resume-check.sh — SessionStart hook (project-level)
# Checks for pre-compaction state and DSBV progress, outputs context summary.
# Complements the plugin-level session-reconstruct.sh (vault-level context).
set -euo pipefail

# Resolve project root
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [[ -z "$PROJECT_ROOT" ]]; then
  exit 0
fi

REPO=$(basename "$PROJECT_ROOT")
BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")

# Check for pre-compaction state
STATE_FILE="$PROJECT_ROOT/.claude/memory/precompact-state.md"
HAS_STATE="no"
if [[ -f "$STATE_FILE" ]]; then
  LAST_SAVED=$(grep "^last_saved:" "$STATE_FILE" | head -1 | cut -d' ' -f2-)
  HAS_STATE="yes (saved: ${LAST_SAVED:-unknown})"
fi

# Check DSBV progress — scan for DESIGN.md, SEQUENCE.md, VALIDATE.md in workstream dirs
DSBV_STATUS=""
for workstream_dir in "$PROJECT_ROOT"/0-GOVERN "$PROJECT_ROOT"/[1-4]-*/; do
  if [[ -d "$workstream_dir" ]]; then
    workstream_name=$(basename "$workstream_dir")
    design="—"; sequence="—"; validate="—"
    [[ -f "$workstream_dir/DESIGN.md" ]] && design="✓"
    [[ -f "$workstream_dir/SEQUENCE.md" ]] && sequence="✓"
    [[ -f "$workstream_dir/VALIDATE.md" ]] && validate="✓"
    # Only show workstreams with at least one DSBV artifact
    if [[ "$design" != "—" || "$sequence" != "—" || "$validate" != "—" ]]; then
      DSBV_STATUS="${DSBV_STATUS}  ${workstream_name}: D=${design} S=${sequence} B=? V=${validate}\n"
    fi
  fi
done

# Output context (shown to agent via hook stdout)
echo "SESSION CONTEXT — ${REPO} (${BRANCH})"
echo "Pre-compaction state: ${HAS_STATE}"
if [[ -n "$DSBV_STATUS" ]]; then
  echo "DSBV Progress:"
  printf "%b" "$DSBV_STATUS"
fi
echo "Last commit: $(git log --oneline -1 2>/dev/null || echo 'none')"
echo "Modified files: $(git status --short 2>/dev/null | wc -l | tr -d ' ') uncommitted"

exit 0
