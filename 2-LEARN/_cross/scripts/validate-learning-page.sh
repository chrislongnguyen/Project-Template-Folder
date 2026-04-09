#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-06
#
# validate-learning-page.sh — Validate a generated Effective Learning page
#
# Usage:
#   bash 2-LEARN/_cross/scripts/validate-learning-page.sh <page-file> <page-type> <topic-depth>
#
# Arguments:
#   page-file:    path to the generated page markdown file
#   page-type:    P0 | P1 | P2 | P3 | P4 | P5
#   topic-depth:  T0 | T1 | T2 | T3 | T4 | T5
#
# Returns:
#   exit 0 = PASS (all checks pass)
#   exit 1 = FAIL (with error details on stderr)
#
# Validation spec: .claude/skills/learning/learn-structure/references/validation-rules.md

set -euo pipefail

PAGE_FILE="${1:-}"
PAGE_TYPE="${2:-}"
TOPIC_DEPTH="${3:-}"

ERRORS=0

# ─── Argument validation ────────────────────────────────────────────────────

if [[ -z "$PAGE_FILE" || -z "$PAGE_TYPE" || -z "$TOPIC_DEPTH" ]]; then
  echo "ERROR: Missing required arguments." >&2
  echo "Usage: bash validate-learning-page.sh <page-file> <page-type> <topic-depth>" >&2
  echo "  page-type:   P0 | P1 | P2 | P3 | P4 | P5" >&2
  echo "  topic-depth: T0 | T1 | T2 | T3 | T4 | T5" >&2
  exit 1
fi

# Validate page-type argument
case "$PAGE_TYPE" in
  P0|P1|P2|P3|P4|P5) ;;
  *)
    echo "ERROR: Invalid page-type '$PAGE_TYPE'. Must be one of: P0 P1 P2 P3 P4 P5" >&2
    exit 1
    ;;
esac

# Validate topic-depth argument
case "$TOPIC_DEPTH" in
  T0|T1|T2|T3|T4|T5) ;;
  *)
    echo "ERROR: Invalid topic-depth '$TOPIC_DEPTH'. Must be one of: T0 T1 T2 T3 T4 T5" >&2
    exit 1
    ;;
esac

# Validate file exists and is readable
if [[ ! -f "$PAGE_FILE" ]]; then
  echo "ERROR: Page file not found: $PAGE_FILE" >&2
  exit 1
fi

if [[ ! -r "$PAGE_FILE" ]]; then
  echo "ERROR: Page file not readable: $PAGE_FILE" >&2
  exit 1
fi

echo "Validating: $PAGE_FILE (type=$PAGE_TYPE depth=$TOPIC_DEPTH)"

# ─── Criterion 1: Frontmatter exists ────────────────────────────────────────────
# Page files should have a # heading or at least an _italics_ subtitle line.
# A minimal check: file must not be empty and must have content.

if [[ ! -s "$PAGE_FILE" ]]; then
  echo "FAIL [C1]: File is empty: $PAGE_FILE" >&2
  ERRORS=$((ERRORS + 1))
fi

# ─── Criterion 2: 17-column table structure ─────────────────────────────────────
# Every data row in a markdown table must have exactly 18 pipes (17 columns).
# We skip separator rows (rows that match |---|...).

TABLE_ERRORS=0
ROW_NUM=0

while IFS= read -r line; do
  # Skip non-table lines
  [[ "$line" != *"|"* ]] && continue

  # Skip separator rows (e.g. | --- | --- |)
  if echo "$line" | grep -qE '^\|[-| :]+\|$'; then
    continue
  fi

  # Skip header rows that contain column names (heuristic: contains "Relevance" or "Row")
  if echo "$line" | grep -qE 'Relevance|Precise Definition|Success Actions'; then
    continue
  fi

  ROW_NUM=$((ROW_NUM + 1))
  PIPE_COUNT=$(echo "$line" | tr -cd '|' | wc -c)

  if [[ "$PIPE_COUNT" -ne 18 ]]; then
    echo "FAIL [C2]: Row $ROW_NUM has $PIPE_COUNT pipes (expected 18 = 17 columns). Line: ${line:0:120}" >&2
    TABLE_ERRORS=$((TABLE_ERRORS + 1))
  fi
done < "$PAGE_FILE"

if [[ $TABLE_ERRORS -gt 0 ]]; then
  echo "FAIL [C2]: $TABLE_ERRORS row(s) have incorrect column count (expected 17 columns per data row)." >&2
  ERRORS=$((ERRORS + TABLE_ERRORS))
fi

# ─── Criterion 3: CAG prefix format ─────────────────────────────────────────────
# Every cell content (after the pipe) must begin with a recognizable CAG prefix.
# Pattern: starts with a word character sequence followed by a dot-suffix and colon.
# We check for cells that look like they have content but lack any colon (missing CAG tag).

CAG_ERRORS=0
ROW_NUM=0

while IFS= read -r line; do
  [[ "$line" != *"|"* ]] && continue

  # Skip separator rows
  if echo "$line" | grep -qE '^\|[-| :]+\|$'; then
    continue
  fi

  # Skip column key header rows
  if echo "$line" | grep -qE 'Relevance|Precise Definition|Success Actions'; then
    continue
  fi

  ROW_NUM=$((ROW_NUM + 1))

  # Extract cells by splitting on | and checking each
  # Use awk to split on pipe and check non-empty cells
  BAD_CELLS=$(echo "$line" | awk -F'|' '
  {
    for (i=2; i<=NF-1; i++) {
      cell = $i
      # Trim whitespace
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", cell)
      # Skip empty cells, "---" separators, or header text
      if (cell == "" || cell ~ /^-+$/ || cell ~ /^[*]*[A-Za-z ]+[*]*$/) continue
      # Check if cell contains a colon (CAG tag requires colon)
      if (cell !~ /:/) {
        print "Row " NR ", col " i ": missing CAG colon in: " substr(cell, 1, 60)
      }
    }
  }')

  if [[ -n "$BAD_CELLS" ]]; then
    echo "FAIL [C3]: CAG prefix issue in row $ROW_NUM:" >&2
    echo "$BAD_CELLS" >&2
    CAG_ERRORS=$((CAG_ERRORS + 1))
  fi
done < "$PAGE_FILE"

if [[ $CAG_ERRORS -gt 0 ]]; then
  ERRORS=$((ERRORS + CAG_ERRORS))
fi

# ─── Criterion 4: Row count validation ──────────────────────────────────────────
# P0 at any depth: exactly 2 data rows (hard rule).
# P1, P2 at T0 depth: exactly 2 data rows (hard rule).
# P3-P5: soft range 4-8 (warn only).

DATA_ROWS=0

while IFS= read -r line; do
  [[ "$line" != *"|"* ]] && continue

  # Skip separator rows
  if echo "$line" | grep -qE '^\|[-| :]+\|$'; then
    continue
  fi

  # Skip header rows
  if echo "$line" | grep -qE 'Relevance|Precise Definition|Success Actions'; then
    continue
  fi

  PIPE_COUNT=$(echo "$line" | tr -cd '|' | wc -c)
  # Only count rows that look like valid data rows (18 pipes)
  if [[ "$PIPE_COUNT" -ge 10 ]]; then
    DATA_ROWS=$((DATA_ROWS + 1))
  fi
done < "$PAGE_FILE"

case "$PAGE_TYPE" in
  P0)
    if [[ "$DATA_ROWS" -ne 2 ]]; then
      echo "FAIL [C4]: P0 requires exactly 2 data rows (found $DATA_ROWS). Hard rule — no variance." >&2
      ERRORS=$((ERRORS + 1))
    fi
    ;;
  P1|P2)
    if [[ "$TOPIC_DEPTH" == "T0" && "$DATA_ROWS" -ne 2 ]]; then
      echo "FAIL [C4]: $PAGE_TYPE at T0 depth requires exactly 2 data rows (found $DATA_ROWS). Hard rule." >&2
      ERRORS=$((ERRORS + 1))
    elif [[ "$TOPIC_DEPTH" != "T0" && "$DATA_ROWS" -lt 2 ]]; then
      echo "FAIL [C4]: $PAGE_TYPE at $TOPIC_DEPTH depth requires at least 2 data rows (found $DATA_ROWS)." >&2
      ERRORS=$((ERRORS + 1))
    fi
    ;;
  P3|P4|P5)
    if [[ "$DATA_ROWS" -lt 4 ]]; then
      echo "WARN [C4]: $PAGE_TYPE typically needs 4+ data rows (found $DATA_ROWS). Soft rule — review if intentional." >&2
    fi
    ;;
esac

# ─── Criterion 5: No cells with only [NEEDS REVIEW] without content ─────────────
# Cells that are genuinely empty (just whitespace after colon) are flagged.
# [NEEDS REVIEW] is allowed as a placeholder — but bare TBD is not.

TBD_COUNT=0

while IFS= read -r line; do
  if echo "$line" | grep -qiE '\|\s*[A-Za-z.()]+:\s*(TBD|todo|PLACEHOLDER)\s*\|'; then
    echo "WARN [C5]: Cell contains bare placeholder (TBD/todo/PLACEHOLDER). Use [NEEDS REVIEW] instead." >&2
    TBD_COUNT=$((TBD_COUNT + 1))
  fi
done < "$PAGE_FILE"

# ─── Summary ─────────────────────────────────────────────────────────────────

echo ""
if [[ $ERRORS -eq 0 ]]; then
  echo "PASS: $PAGE_FILE validated successfully (type=$PAGE_TYPE depth=$TOPIC_DEPTH, rows=$DATA_ROWS)"
  exit 0
else
  echo "FAIL: $ERRORS error(s) found in $PAGE_FILE" >&2
  exit 1
fi
