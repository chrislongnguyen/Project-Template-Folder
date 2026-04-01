#!/bin/bash
# validate-learning-page.sh — Validates an Effective Learning page output file
# Usage: validate-learning-page.sh <page-file> <page-type> <topic-depth>
#   page-type:    P0 | P1 | P2 | P3 | P4 | P5
#   topic-depth:  T0 | T1 | T2 | T3 | T4 | T5
# Returns: exit 0 = PASS, exit 1 = FAIL (errors on stderr)

set -euo pipefail

PAGE_FILE="${1:-}"
PAGE_TYPE="${2:-}"
TOPIC_DEPTH="${3:-}"

if [ -z "$PAGE_FILE" ] || [ -z "$PAGE_TYPE" ] || [ -z "$TOPIC_DEPTH" ]; then
  echo "Usage: validate-learning-page.sh <page-file> <page-type> <topic-depth>" >&2
  exit 1
fi

if [ ! -f "$PAGE_FILE" ]; then
  echo "FAIL: File not found: $PAGE_FILE" >&2
  exit 1
fi

if [ ! -s "$PAGE_FILE" ]; then
  echo "FAIL: File is empty: $PAGE_FILE" >&2
  exit 1
fi

ERRORS=0

# --- 1. Extract Effective Learning data table rows only ---
# Three filters applied in sequence:
#   a) Lines starting with | (table rows)
#   b) Exclude separator rows (only dashes/colons/spaces between pipes)
#   c) awk: require ≥18 pipe-delimited fields (17 columns = row label + 16 content)
#      AND row label (field 2) must contain "(" — every Effective Learning data row label has a role
#      tag like (R), (A), (both), which excludes column header rows ("Row", "#", "Layer").
TABLE_ROWS=$(grep '^\s*|' "$PAGE_FILE" | grep -v '^\s*|[-: ]*|' | awk -F'|' 'NF >= 18 && $2 ~ /\(/')

ROW_COUNT=$(echo "$TABLE_ROWS" | grep -c '.' 2>/dev/null || true)
ROW_COUNT=${ROW_COUNT:-0}

if [ "$ROW_COUNT" -eq 0 ]; then
  echo "FAIL: No table data rows found in $PAGE_FILE" >&2
  exit 1
fi

# --- 2. Row count validation ---
case "$PAGE_TYPE" in
  P0)
    if [ "$ROW_COUNT" -ne 2 ]; then
      echo "FAIL: P0 must have exactly 2 rows, found $ROW_COUNT" >&2
      ERRORS=$((ERRORS + 1))
    fi
    ;;
  P1|P2)
    if [ "$TOPIC_DEPTH" = "T0" ]; then
      if [ "$ROW_COUNT" -ne 2 ]; then
        echo "FAIL: ${PAGE_TYPE} at T0 must have exactly 2 rows, found $ROW_COUNT" >&2
        ERRORS=$((ERRORS + 1))
      fi
    else
      if [ "$ROW_COUNT" -lt 2 ] || [ "$ROW_COUNT" -gt 6 ]; then
        echo "WARN: ${PAGE_TYPE} at ${TOPIC_DEPTH} has $ROW_COUNT rows (expected 2-6)" >&2
      fi
    fi
    ;;
  P3|P4)
    if [ "$ROW_COUNT" -lt 3 ] || [ "$ROW_COUNT" -gt 12 ]; then
      echo "WARN: ${PAGE_TYPE} has $ROW_COUNT rows (expected ~4-8)" >&2
    fi
    ;;
  P5)
    if [ "$ROW_COUNT" -lt 3 ] || [ "$ROW_COUNT" -gt 10 ]; then
      echo "WARN: ${PAGE_TYPE} has $ROW_COUNT rows (expected ~4-6)" >&2
    fi
    ;;
esac

# --- 3. Column count validation (17 columns = 18 pipes per row) ---
# Use here-string to avoid subshell variable scoping bug
while IFS= read -r row; do
  PIPE_COUNT=$(echo "$row" | tr -cd '|' | wc -c | tr -d ' ')
  if [ "$PIPE_COUNT" -lt 17 ]; then
    echo "FAIL: Row has $PIPE_COUNT pipes (need at least 17 for 16 content columns + row label): ${row:0:80}..." >&2
    ERRORS=$((ERRORS + 1))
  fi
done <<< "$TABLE_ROWS"

# --- 4. CAG tag validation on content cells ---
CAG_REGEX='^(Eff\.[A-Z][A-Z0-9-]*|UBS|UDS|(P_?F?[0-9]*)(\([A-Za-z]+\))?|([A-Z][A-Z0-9_]*)(\.[0-9]+)?)\([RAb][A-Za-z]*\)(\.U[BD])*\.(REL|DEF|ACT|UD|UB|FAIL|ELSE|NEXT|UD\.MECH|UD\.EP|UD\.EOT|UD\.EOE|UB\.MECH|UB\.EP|UB\.EOT|UB\.EOE): .+'

ROW_NUM=0
while IFS= read -r row; do
  ROW_NUM=$((ROW_NUM + 1))
  # Split row by | and check each content cell (skip first which is row label)
  CELL_NUM=0
  while IFS= read -r cell; do
    CELL_NUM=$((CELL_NUM + 1))
    TRIMMED=$(echo "$cell" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    if [ -n "$TRIMMED" ]; then
      if ! echo "$TRIMMED" | grep -qE "$CAG_REGEX"; then
        echo "FAIL: Row $ROW_NUM, Col $CELL_NUM — CAG tag missing or malformed: '${TRIMMED:0:60}...'" >&2
        ERRORS=$((ERRORS + 1))
      fi
    fi
  done < <(echo "$row" | tr '|' '\n' | tail -n +3 | head -n 16)
done <<< "$TABLE_ROWS"

# --- 5. Summary ---
if [ "$ERRORS" -gt 0 ]; then
  echo "RESULT: FAIL — $PAGE_FILE ($PAGE_TYPE, $TOPIC_DEPTH): $ROW_COUNT rows, $ERRORS errors" >&2
  exit 1
else
  echo "RESULT: PASS — $PAGE_FILE ($PAGE_TYPE, $TOPIC_DEPTH): $ROW_COUNT rows"
  exit 0
fi
