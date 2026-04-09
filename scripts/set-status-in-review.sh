#!/bin/bash
# version: 1.0 | status: draft | last_updated: 2026-04-09
# Sets status: in-review in a markdown file's YAML frontmatter.
# Usage: set-status-in-review.sh <filepath>
# Exit 0: status updated (or already in-review)
# Exit 1: file not found or no frontmatter

set -e

FILE="$1"

if [ -z "$FILE" ]; then
  echo "Usage: set-status-in-review.sh <filepath>" >&2
  exit 1
fi

if [ ! -f "$FILE" ]; then
  echo "Error: file not found: $FILE" >&2
  exit 1
fi

# Check file has frontmatter (first line must be ---)
FIRST_LINE=$(head -1 "$FILE")
if [ "$FIRST_LINE" != "---" ]; then
  echo "Error: no frontmatter found in $FILE (does not start with ---)" >&2
  exit 1
fi

# Check if already in-review
if grep -q "^status: in-review" "$FILE"; then
  echo "already in-review, no change"
  exit 0
fi

# Replace status: draft or status: in-progress with status: in-review
sed -i '' "s/^status: draft/status: in-review/" "$FILE"
sed -i '' "s/^status: in-progress/status: in-review/" "$FILE"

# Update last_updated to today
sed -i '' "s/^last_updated:.*/last_updated: $(date +%Y-%m-%d)/" "$FILE"

echo "Updated $FILE: status → in-review"
exit 0
