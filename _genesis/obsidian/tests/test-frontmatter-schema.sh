#!/usr/bin/env bash
# Test: Frontmatter schema validation (A6) — AC-18, AC-19, AC-20
# version: 2.0 | status: draft | last_updated: 2026-04-03
set -euo pipefail

PROJ="$(cd "$(dirname "$0")/../../.." && pwd)"
WORKSTREAMS=("1-ALIGN" "2-LEARN" "3-PLAN" "4-EXECUTE" "5-IMPROVE")

# S2 status vocabulary
VALID_STATUSES="draft in-progress in-review validated archived"
VALID_STAGES="design sequence build validate"
VALID_UES_VERSIONS="logic-scaffold concept prototype mve leadership"

PASS=0; FAIL=0; TOTAL=0

pass() { echo "  PASS: $1"; PASS=$((PASS+1)); TOTAL=$((TOTAL+1)); }
fail() { echo "  FAIL: $1"; FAIL=$((FAIL+1)); TOTAL=$((TOTAL+1)); }

# Extract frontmatter block (lines between first and second ---) from a file.
extract_frontmatter() {
  local file="$1"
  awk 'NR==1 && /^---[[:space:]]*$/ { in_fm=1; next }
       in_fm && /^---[[:space:]]*$/ { exit }
       in_fm { print }' "$file"
}

# Get value for a frontmatter key. Returns empty string if key absent.
get_field() {
  local fm="$1"
  local key="$2"
  echo "$fm" | grep -E "^${key}[[:space:]]*:" | head -1 | sed "s/^${key}[[:space:]]*:[[:space:]]*//" | tr -d '"' | tr -d "'" || true
}

# Returns 0 if value is in space-separated list, 1 otherwise.
in_list() {
  local val="$1"
  local list="$2"
  for item in $list; do
    [ "$item" = "$val" ] && return 0
  done
  return 1
}

echo "=== A6: Frontmatter Schema Validation (S2) ==="
echo ""

for ws in "${WORKSTREAMS[@]}"; do
  ws_dir="$PROJ/$ws"
  [ -d "$ws_dir" ] || continue

  while IFS= read -r -d '' file; do
    # Skip files with no YAML frontmatter opener
    first_line="$(head -1 "$file")"
    if [ "$first_line" != "---" ]; then
      continue
    fi

    fm="$(extract_frontmatter "$file")"
    [ -z "$fm" ] && continue

    rel="${file#$PROJ/}"
    type_val="$(get_field "$fm" "type")"
    file_fail=0

    if [ "$type_val" = "ues-deliverable" ]; then
      # Full 9-field validation for ues-deliverable artifacts

      # 1. version
      v="$(get_field "$fm" "version")"
      if [ -z "$v" ]; then
        fail "$rel — missing field: version"
        file_fail=1
      fi

      # 2. status — present and S2 vocabulary
      s="$(get_field "$fm" "status")"
      if [ -z "$s" ]; then
        fail "$rel — missing field: status"
        file_fail=1
      elif ! in_list "$s" "$VALID_STATUSES"; then
        fail "$rel — invalid status: '$s' (expected one of: $VALID_STATUSES)"
        file_fail=1
      fi

      # 3. last_updated — present and YYYY-MM-DD
      lu="$(get_field "$fm" "last_updated")"
      if [ -z "$lu" ]; then
        fail "$rel — missing field: last_updated"
        file_fail=1
      elif ! echo "$lu" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
        fail "$rel — invalid last_updated: '$lu' (expected YYYY-MM-DD)"
        file_fail=1
      fi

      # 4. type — already confirmed ues-deliverable (no extra check needed)

      # 5. sub_system
      ss="$(get_field "$fm" "sub_system")"
      if [ -z "$ss" ]; then
        fail "$rel — missing field: sub_system"
        file_fail=1
      fi

      # 6. work_stream
      ws_val="$(get_field "$fm" "work_stream")"
      if [ -z "$ws_val" ]; then
        fail "$rel — missing field: work_stream"
        file_fail=1
      fi

      # 7. stage — present and valid
      stage="$(get_field "$fm" "stage")"
      if [ -z "$stage" ]; then
        fail "$rel — missing field: stage"
        file_fail=1
      elif ! in_list "$stage" "$VALID_STAGES"; then
        fail "$rel — invalid stage: '$stage' (expected one of: $VALID_STAGES)"
        file_fail=1
      fi

      # 8. iteration — present and integer
      iter="$(get_field "$fm" "iteration")"
      if [ -z "$iter" ]; then
        fail "$rel — missing field: iteration"
        file_fail=1
      elif ! echo "$iter" | grep -qE '^[0-9]+$'; then
        fail "$rel — invalid iteration: '$iter' (expected integer)"
        file_fail=1
      fi

      # 9. ues_version — present and valid
      ues_ver="$(get_field "$fm" "ues_version")"
      if [ -z "$ues_ver" ]; then
        fail "$rel — missing field: ues_version"
        file_fail=1
      elif ! in_list "$ues_ver" "$VALID_UES_VERSIONS"; then
        fail "$rel — invalid ues_version: '$ues_ver' (expected one of: $VALID_UES_VERSIONS)"
        file_fail=1
      fi

      [ "$file_fail" -eq 0 ] && pass "$rel — full S2 schema valid (ues-deliverable)"

    else
      # Minimal 3-field validation for all other files that have frontmatter

      # 1. version
      v="$(get_field "$fm" "version")"
      if [ -z "$v" ]; then
        fail "$rel — missing field: version"
        file_fail=1
      fi

      # 2. status — present and S2 vocabulary
      s="$(get_field "$fm" "status")"
      if [ -z "$s" ]; then
        fail "$rel — missing field: status"
        file_fail=1
      elif ! in_list "$s" "$VALID_STATUSES"; then
        fail "$rel — invalid status: '$s' (expected one of: $VALID_STATUSES)"
        file_fail=1
      fi

      # 3. last_updated — present and YYYY-MM-DD
      lu="$(get_field "$fm" "last_updated")"
      if [ -z "$lu" ]; then
        fail "$rel — missing field: last_updated"
        file_fail=1
      elif ! echo "$lu" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
        fail "$rel — invalid last_updated: '$lu' (expected YYYY-MM-DD)"
        file_fail=1
      fi

      [ "$file_fail" -eq 0 ] && pass "$rel — 3-field schema valid"
    fi

  done < <(find "$ws_dir" -name "*.md" -print0 2>/dev/null)
done

echo ""
echo "--- $PASS/$TOTAL passed ---"
[ "$FAIL" -eq 0 ]
