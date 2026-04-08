#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-08
#
# alignment-check.sh — Verify condition-to-artifact mapping in DESIGN.md
#
# Checks:
#   1. Every completion condition references at least one artifact
#   2. Every artifact reference maps to a completion condition
#   3. Reports orphans (conditions without artifacts, artifacts without conditions)
#
# Usage: ./scripts/alignment-check.sh <path-to-DESIGN.md>

set -euo pipefail

# --- Argument validation ---
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <DESIGN.md path>"
  exit 1
fi

DESIGN_FILE="$1"

if [[ ! -f "$DESIGN_FILE" ]]; then
  echo "ERROR: File not found: $DESIGN_FILE"
  exit 1
fi

# --- Extract completion conditions ---
# Conditions are lines containing "AC", "acceptance criter", "completion condition",
# or lines in tables with pass/fail indicators
CONDITIONS_FILE=$(mktemp)
grep -inE '(AC-[0-9]+|acceptance criter|completion condition|pass/fail|\bAC[0-9]+\b)' "$DESIGN_FILE" \
  | sed 's/^[[:space:]]*//' \
  > "$CONDITIONS_FILE" 2>/dev/null || true

CONDITION_COUNT=$(wc -l < "$CONDITIONS_FILE" | tr -d ' ')

# --- Extract artifact references ---
# Artifacts are file paths (containing / or ending in .md, .sh, .py, .yaml, .json)
# or backtick-quoted paths
ARTIFACTS_FILE=$(mktemp)
grep -oE '`[^`]*\.(md|sh|py|yaml|json|toml|html|css|js|ts)`' "$DESIGN_FILE" \
  | sort -u \
  > "$ARTIFACTS_FILE" 2>/dev/null || true

# Also catch paths in prose (e.g., .claude/agents/ltc-planner.md)
grep -oE '[a-zA-Z0-9_./-]+\.(md|sh|py|yaml|json|toml)' "$DESIGN_FILE" \
  | grep '/' \
  | sort -u \
  >> "$ARTIFACTS_FILE" 2>/dev/null || true

# Deduplicate
sort -u "$ARTIFACTS_FILE" -o "$ARTIFACTS_FILE"
ARTIFACT_COUNT=$(wc -l < "$ARTIFACTS_FILE" | tr -d ' ')

# --- Cross-reference: conditions that mention no artifact ---
ORPHAN_CONDITIONS=0
ORPHAN_COND_FILE=$(mktemp)
while IFS= read -r condition; do
  # Check if any artifact path appears in this condition line
  HAS_ARTIFACT=0
  while IFS= read -r artifact; do
    clean_artifact=$(echo "$artifact" | tr -d '`')
    if echo "$condition" | grep -qF "$clean_artifact"; then
      HAS_ARTIFACT=1
      break
    fi
  done < "$ARTIFACTS_FILE"
  if [[ $HAS_ARTIFACT -eq 0 ]]; then
    ORPHAN_CONDITIONS=$((ORPHAN_CONDITIONS + 1))
    echo "  $condition" >> "$ORPHAN_COND_FILE"
  fi
done < "$CONDITIONS_FILE"

# --- Cross-reference: artifacts not mentioned in any condition ---
ORPHAN_ARTIFACTS=0
ORPHAN_ART_FILE=$(mktemp)
while IFS= read -r artifact; do
  clean_artifact=$(echo "$artifact" | tr -d '`')
  if ! grep -qF "$clean_artifact" "$CONDITIONS_FILE" 2>/dev/null; then
    ORPHAN_ARTIFACTS=$((ORPHAN_ARTIFACTS + 1))
    echo "  $artifact" >> "$ORPHAN_ART_FILE"
  fi
done < "$ARTIFACTS_FILE"

# --- Report ---
TOTAL_ORPHANS=$((ORPHAN_CONDITIONS + ORPHAN_ARTIFACTS))

echo "=== Alignment Check Report ==="
echo "File: $DESIGN_FILE"
echo "Conditions found: $CONDITION_COUNT"
echo "Artifacts found:  $ARTIFACT_COUNT"
echo ""
echo "Orphan conditions (no artifact ref): $ORPHAN_CONDITIONS"
if [[ $ORPHAN_CONDITIONS -gt 0 && -s "$ORPHAN_COND_FILE" ]]; then
  cat "$ORPHAN_COND_FILE"
fi
echo ""
echo "Orphan artifacts (not in any condition): $ORPHAN_ARTIFACTS"
if [[ $ORPHAN_ARTIFACTS -gt 0 && -s "$ORPHAN_ART_FILE" ]]; then
  cat "$ORPHAN_ART_FILE"
fi
echo ""
echo "Total orphans: $TOTAL_ORPHANS"

if [[ $TOTAL_ORPHANS -eq 0 ]]; then
  echo "RESULT: PASS — zero orphans"
else
  echo "RESULT: WARN — $TOTAL_ORPHANS orphan(s) found"
fi

# --- Cleanup ---
rm -f "$CONDITIONS_FILE" "$ARTIFACTS_FILE" "$ORPHAN_COND_FILE" "$ORPHAN_ART_FILE"

exit 0
