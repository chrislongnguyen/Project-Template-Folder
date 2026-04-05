#!/usr/bin/env bash
# version: 2.0 | status: Draft | last_updated: 2026-04-04
# frontmatter-extract.sh — Parse YAML frontmatter fields from .md files
#
# Usage: ./scripts/frontmatter-extract.sh <file> <field>
#   file:  path to .md file with YAML frontmatter
#   field: YAML field name to extract (e.g., "version", "status", "last_updated")
#
# Output: field value to stdout (stripped of quotes)
# Exit 0: field found | Exit 1: field not found or no frontmatter
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <file> <field>" >&2
  exit 1
fi

FILE="$1"
FIELD="$2"

if [[ ! -f "$FILE" ]]; then
  echo "Error: file not found: $FILE" >&2
  exit 1
fi

# Check for frontmatter delimiter
first_line=$(head -1 "$FILE")
if [[ "$first_line" != "---" ]]; then
  exit 1
fi

# Extract frontmatter block (between first and second ---)
# Read lines 2+ until we hit another ---
in_frontmatter=false
while IFS= read -r line; do
  if [[ "$in_frontmatter" == false ]]; then
    in_frontmatter=true
    continue
  fi
  [[ "$line" == "---" ]] && break

  # Match field: value pattern
  if [[ "$line" =~ ^${FIELD}:[[:space:]]*(.*) ]]; then
    value="${BASH_REMATCH[1]}"
    # Strip surrounding quotes (single or double)
    value="${value#\"}"
    value="${value%\"}"
    value="${value#\'}"
    value="${value%\'}"
    # Trim whitespace
    value=$(echo "$value" | xargs)
    echo "$value"
    exit 0
  fi
done < "$FILE"

# Field not found
exit 1
