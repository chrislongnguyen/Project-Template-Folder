#!/bin/bash
# version: 1.0 | status: draft | last_updated: 2026-04-09
# Classifies a FAIL description into one of 4 categories based on keyword matching.
# Usage: classify-fail.sh "<fail_text>"
# Output: one of: SYNTACTIC | SEMANTIC | ENVIRONMENTAL | SCOPE
# Exit 0 always (classification is always possible)

FAIL_TEXT="$1"

if [ -z "$FAIL_TEXT" ]; then
  echo "Usage: classify-fail.sh \"<fail_text>\"" >&2
  echo "SYNTACTIC"
  exit 0
fi

# Convert to lowercase using tr (Bash 3 compatible — no ${var,,})
LOWER_TEXT=$(echo "$FAIL_TEXT" | tr '[:upper:]' '[:lower:]')

# Category 1: SYNTACTIC — first match wins
if echo "$LOWER_TEXT" | grep -qi "missing\|format\|frontmatter\|structure\|syntax\|malformed\|invalid\|wrong format\|schema"; then
  echo "SYNTACTIC"
  exit 0
fi

# Category 2: SEMANTIC
if echo "$LOWER_TEXT" | grep -qi "wrong\|incorrect\|misunderstood\|content\|logic\|inaccurate\|doesn't match\|inconsistent"; then
  echo "SEMANTIC"
  exit 0
fi

# Category 3: ENVIRONMENTAL
if echo "$LOWER_TEXT" | grep -qi "not found\|permission\|script failed\|exit code\|command not found\|no such file\|enoent"; then
  echo "ENVIRONMENTAL"
  exit 0
fi

# Category 4: SCOPE
if echo "$LOWER_TEXT" | grep -qi "not in sequence\|out of scope\|needs research\|not specified\|undefined\|beyond scope"; then
  echo "SCOPE"
  exit 0
fi

# Default: SYNTACTIC
echo "SYNTACTIC"
exit 0
