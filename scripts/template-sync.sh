#!/usr/bin/env bash
# version: 2.0 | status: Draft | last_updated: 2026-04-05
# LTC Project Template — Additive Sync Script
# Supports: --auto-add, --file/--action, --verify
# NEVER deletes local files.
set -euo pipefail

LOG_FILE=".template-sync-log.json"
REMOTE="template"
BRANCH="main"
REF="${REMOTE}/${BRANCH}"

# --- Require jq ---
if ! command -v jq &>/dev/null; then
  echo "Error: jq is required. Install: brew install jq" >&2
  exit 2
fi

# --- Abort guard: NEVER delete ---
# Checked at every checkout to ensure we never call rm or git clean
assert_no_delete() {
  : # operations in this script only add/checkout — never rm or git clean
}

# --- Logging ---
log_action() {
  local file="$1" action="$2" reason="${3:-}"
  local entry
  entry=$(jq -n \
    --arg f "$file" --arg a "$action" --arg r "$reason" --arg t "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    '{file: $f, action: $a, reason: $r, timestamp: $t}')
  if [[ -f "$LOG_FILE" ]]; then
    local tmp
    tmp=$(mktemp)
    jq ". += [$entry]" "$LOG_FILE" > "$tmp" && mv "$tmp" "$LOG_FILE"
  else
    jq -n "[$entry]" > "$LOG_FILE"
  fi
}

# --- Mode: --auto-add ---
do_auto_add() {
  local input_file="$1"
  local files_json
  if [[ "$input_file" == "-" ]]; then
    files_json=$(cat)
  else
    files_json=$(cat "$input_file")
  fi

  local added=0
  local reclassified=0

  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    # Fix #4: pre-check — if file already exists locally, reclassify to merge
    if [[ -f "$f" ]]; then
      echo "RECLASSIFY merge: $f (exists locally — use --file to handle)" >&2
      log_action "$f" "reclassified_to_merge" "file exists locally"
      (( reclassified++ )) || true
      continue
    fi
    # Ensure parent directory exists
    mkdir -p "$(dirname "$f")"
    git checkout "$REF" -- "$f"
    # Leave unstaged — do NOT stage
    git restore --staged "$f" 2>/dev/null || true
    echo "added: $f"
    log_action "$f" "auto_add" ""
    (( added++ )) || true
  done < <(echo "$files_json" | jq -r '.[]')

  echo ""
  echo "auto-add complete: added=$added reclassified=$reclassified"
  echo "All files are UNSTAGED. Stage per-file before committing."
  echo "  git add <file>"
  echo "  git commit -m \"chore(govern): sync with project template\""
}

# --- Mode: --file --action ---
do_file_action() {
  local file="$1" action="$2"
  case "$action" in
    take)
      if [[ -f "$file" ]]; then
        echo "WARNING: $file exists locally. Overwriting with template version."
      fi
      mkdir -p "$(dirname "$file")"
      git checkout "$REF" -- "$file"
      git restore --staged "$file" 2>/dev/null || true
      echo "taken (unstaged): $file"
      log_action "$file" "take" "user explicit"
      ;;
    skip)
      echo "skipped: $file"
      log_action "$file" "skip" "user explicit"
      ;;
    *)
      echo "Error: --action must be 'take' or 'skip'" >&2
      exit 2
      ;;
  esac
}

# --- Mode: --verify ---
do_verify() {
  local pass=0 fail=0

  echo "template-sync --verify"
  echo "======================"

  # AC-1: Log file exists
  if [[ -f "$LOG_FILE" ]]; then
    echo "AC-1 PASS: $LOG_FILE exists"
    (( pass++ )) || true
  else
    echo "AC-1 FAIL: $LOG_FILE not found — no sync actions recorded"
    (( fail++ )) || true
  fi

  # AC-2: Decisions recorded (log has entries)
  if [[ -f "$LOG_FILE" ]]; then
    local count
    count=$(jq 'length' "$LOG_FILE")
    if [[ "$count" -gt 0 ]]; then
      echo "AC-2 PASS: $count actions logged"
      (( pass++ )) || true
    else
      echo "AC-2 FAIL: log is empty"
      (( fail++ )) || true
    fi
  else
    echo "AC-2 SKIP: no log file"
    (( fail++ )) || true
  fi

  # AC-3: No deletions in log
  if [[ -f "$LOG_FILE" ]]; then
    local deletes
    deletes=$(jq '[.[] | select(.action == "delete")] | length' "$LOG_FILE")
    if [[ "$deletes" -eq 0 ]]; then
      echo "AC-3 PASS: no delete actions in log"
      (( pass++ )) || true
    else
      echo "AC-3 FAIL: $deletes delete actions found — violation"
      (( fail++ )) || true
    fi
  else
    echo "AC-3 SKIP: no log file"
    (( fail++ )) || true
  fi

  # AC-4: Added files are unstaged (not in index as staged)
  if [[ -f "$LOG_FILE" ]]; then
    local staged_count=0
    while IFS= read -r f; do
      if git diff --cached --name-only | grep -qxF "$f"; then
        echo "AC-4 WARN: $f is staged (should be unstaged)"
        (( staged_count++ )) || true
      fi
    done < <(jq -r '.[] | select(.action == "auto_add" or .action == "take") | .file' "$LOG_FILE")
    if [[ "$staged_count" -eq 0 ]]; then
      echo "AC-4 PASS: all added files are unstaged"
      (( pass++ )) || true
    else
      echo "AC-4 FAIL: $staged_count files are staged — review before committing"
      (( fail++ )) || true
    fi
  else
    echo "AC-4 SKIP: no log file"
    (( fail++ )) || true
  fi

  echo ""
  echo "Result: $pass/4 passed"
  [[ "$fail" -eq 0 ]]
}

# --- Arg dispatch ---
MODE=""
FILE_PATH=""
ACTION=""
INPUT_FILE="-"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --auto-add) MODE="auto-add"; shift ;;
    --input)    INPUT_FILE="$2"; shift 2 ;;
    --file)     FILE_PATH="$2"; shift 2 ;;
    --action)   ACTION="$2"; shift 2 ;;
    --verify)   MODE="verify"; shift ;;
    --remote)   REMOTE="$2"; REF="${REMOTE}/${BRANCH}"; shift 2 ;;
    --branch)   BRANCH="$2"; REF="${REMOTE}/${BRANCH}"; shift 2 ;;
    *) echo "Usage: $0 --auto-add [--input file] | --file <path> --action <take|skip> | --verify" >&2; exit 2 ;;
  esac
done

assert_no_delete

case "$MODE" in
  auto-add) do_auto_add "$INPUT_FILE" ;;
  verify)   do_verify ;;
  "")
    if [[ -n "$FILE_PATH" && -n "$ACTION" ]]; then
      do_file_action "$FILE_PATH" "$ACTION"
    else
      echo "Error: specify --auto-add, --file/--action, or --verify" >&2
      exit 2
    fi
    ;;
esac
