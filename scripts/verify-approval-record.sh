#!/bin/bash
# version: 1.0 | status: draft | last_updated: 2026-04-09
# Greps a markdown file for an approval record row in a markdown table.
# Usage: verify-approval-record.sh <filepath>
# Exit 0: approval record found
# Exit 1: not found or file doesn't exist

FILE="$1"

if [ -z "$FILE" ]; then
  echo "Usage: verify-approval-record.sh <filepath>" >&2
  exit 1
fi

if [ ! -f "$FILE" ]; then
  echo "Error: file not found: $FILE" >&2
  exit 1
fi

# Grep for a markdown table row starting with a pipe followed by a YYYY-MM-DD date
if grep -E "^\| [0-9]{4}-[0-9]{2}-[0-9]{2}" "$FILE" > /dev/null 2>&1; then
  echo "Approval record found in $FILE"
  exit 0
else
  echo "Approval record NOT found in $FILE. Verify manually before setting status: validated."
  exit 1
fi
