#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-08
# inject-frontmatter.sh — PostToolUse hook (Write/Edit)
# Deterministically injects/fills missing YAML frontmatter fields for workstream artifacts.
# Derives work_stream, sub_system, stage, type from file path. Never overwrites existing values.
# Compensates for LT-3 (agent forgets fields) and LT-8 (agent drifts on values).
set -euo pipefail

# --- Input: file path from tool result ---
FILE_PATH="${CLAUDE_FILE_PATH:-}"
[[ -z "$FILE_PATH" ]] && exit 0
[[ "$FILE_PATH" == *.md ]] || exit 0

# --- Path guard: only workstream dirs [1-5]-*/ ---
BASENAME=$(basename "$FILE_PATH")
REL_PATH="${FILE_PATH#*/}"  # strip leading absolute path noise

# Match workstream dirs: 1-ALIGN, 2-LEARN, 3-PLAN, 4-EXECUTE, 5-IMPROVE
if [[ ! "$FILE_PATH" =~ /[1-5]-[A-Z]+/ ]]; then
  exit 0
fi

# --- Parse path components ---
# Extract workstream dir (e.g., "1-ALIGN")
WORK_STREAM=$(echo "$FILE_PATH" | grep -oE '/[1-5]-[A-Z]+/' | head -1 | tr -d '/')

# Extract subsystem dir (e.g., "1-PD", "2-DP", "_cross")
SUB_SYSTEM=""
if [[ "$FILE_PATH" =~ /[1-5]-[A-Z]+/([0-9]+-[A-Z]+)/ ]]; then
  SUB_SYSTEM="${BASH_REMATCH[1]}"
elif [[ "$FILE_PATH" =~ /[1-5]-[A-Z]+/_cross/ ]]; then
  SUB_SYSTEM=""  # cross-cutting, leave blank
fi

# --- Derive stage and type from filename ---
STAGE=""
TYPE=""
case "$BASENAME" in
  DESIGN.md)    STAGE="design";   TYPE="dsbv-design" ;;
  SEQUENCE.md)  STAGE="sequence"; TYPE="dsbv-sequence" ;;
  VALIDATE.md)  STAGE="validate"; TYPE="dsbv-validate" ;;
  README.md)    exit 0 ;;  # Never inject into READMEs
  *)            STAGE="build" ;;  # All other deliverables are Build outputs
esac

# --- Read current frontmatter ---
TODAY=$(date +%Y-%m-%d)
ITERATION=""
if [[ -f "VERSION" ]]; then
  ITERATION=$(head -1 VERSION 2>/dev/null | grep -oE '^[0-9]+' || echo "")
fi

# Check if file has frontmatter block
if ! head -1 "$FILE_PATH" | grep -q '^---$'; then
  # No frontmatter at all — inject complete block
  TMPFILE=$(mktemp)
  {
    echo "---"
    echo "version: \"1.0\""
    echo "status: draft"
    echo "last_updated: $TODAY"
    echo "work_stream: $WORK_STREAM"
    [[ -n "$SUB_SYSTEM" ]] && echo "sub_system: $SUB_SYSTEM"
    echo "stage: $STAGE"
    [[ -n "$TYPE" ]] && echo "type: $TYPE"
    [[ -n "$ITERATION" ]] && echo "iteration: $ITERATION"
    echo "---"
    cat "$FILE_PATH"
  } > "$TMPFILE"
  mv "$TMPFILE" "$FILE_PATH"
  exit 0
fi

# --- File has frontmatter — fill missing fields only, never overwrite ---
# Use awk to parse and inject into existing frontmatter block

TMPFILE=$(mktemp)
awk -v ws="$WORK_STREAM" -v ss="$SUB_SYSTEM" -v st="$STAGE" -v tp="$TYPE" \
    -v today="$TODAY" -v iter="$ITERATION" '
BEGIN {
  in_fm = 0; fm_end = 0
  has_version = 0; has_status = 0; has_updated = 0
  has_ws = 0; has_ss = 0; has_stage = 0; has_type = 0; has_iter = 0
}
NR == 1 && /^---$/ { in_fm = 1; print; next }
in_fm && /^---$/ {
  # End of frontmatter — inject missing fields before closing ---
  if (!has_version)  print "version: \"1.0\""
  if (!has_status)   print "status: draft"
  if (!has_updated)  print "last_updated: " today
  if (!has_ws && ws != "")  print "work_stream: " ws
  if (!has_ss && ss != "")  print "sub_system: " ss
  if (!has_stage && st != "") print "stage: " st
  if (!has_type && tp != "")  print "type: " tp
  if (!has_iter && iter != "") print "iteration: " iter
  in_fm = 0; fm_end = 1
  print; next
}
in_fm {
  # Track which fields exist — update last_updated always
  if (/^version:/)      has_version = 1
  if (/^status:/)       has_status = 1
  if (/^last_updated:/) { has_updated = 1; print "last_updated: " today; next }
  if (/^work_stream:/)  has_ws = 1
  if (/^sub_system:/)   has_ss = 1
  if (/^stage:/)        has_stage = 1
  if (/^type:/)         has_type = 1
  if (/^iteration:/)    has_iter = 1
  print; next
}
{ print }
' "$FILE_PATH" > "$TMPFILE"

mv "$TMPFILE" "$FILE_PATH"
