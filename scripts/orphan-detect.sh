#!/usr/bin/env bash
# version: 2.1 | status: in-review | last_updated: 2026-04-09
# orphan-detect.sh — Find .md files with zero inbound [[backlinks]]
#
# Usage: ./scripts/orphan-detect.sh [repo-root]
#
# Output: one orphan file path per line
# Excludes: README.md, CHANGELOG.md, index.md, files in .git/.obsidian/node_modules
# Exit 0 always (informational)
set -euo pipefail

REPO_ROOT="${1:-.}"
REPO_ROOT=$(cd "$REPO_ROOT" && pwd)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Exclusion patterns (basenames, case-insensitive)
EXCLUDE_PATTERN="^(README|CHANGELOG|index|INDEX|MEMORY)$"

# Build set of all link targets from backlink map (newline-separated for grep lookup)
LINKED_TARGETS=$("$SCRIPT_DIR/backlink-map.sh" "$REPO_ROOT" | cut -f2 | sort -u)

# Check each .md file
while IFS= read -r file; do
  rel_path="${file#$REPO_ROOT/}"
  basename_no_ext=$(basename "$file" .md)

  # Skip excluded files
  if [[ "$basename_no_ext" =~ $EXCLUDE_PATTERN ]]; then
    continue
  fi

  # Check if this file is a target of any link
  if ! echo "$LINKED_TARGETS" | grep -qxF "$basename_no_ext"; then
    echo "$rel_path"
  fi
done < <(find "$REPO_ROOT" -name '*.md' \
  -not -path '*/.git/*' \
  -not -path '*/.obsidian/*' \
  -not -path '*/node_modules/*' \
  2>/dev/null | sort)

exit 0
