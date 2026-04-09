#!/usr/bin/env bash
# version: 2.2 | status: in-review | last_updated: 2026-04-09
# ripple-check.sh — Show depth-1 and depth-2 backlinks for a given file
#
# Usage: ./scripts/ripple-check.sh <filename> [repo-root]
#   filename:  basename or relative path of the file to check (e.g., CHARTER.md)
#   repo-root: directory to scan (default: repo root)
#
# Output: Structured lines — depth:source_file:line_num:target
# Exit 0 always (informational tool)
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <filename> [repo-root]" >&2
  exit 1
fi

TARGET="$1"
REPO_ROOT="${2:-.}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Strip path and extension to get the wikilink name
TARGET_NAME=$(basename "$TARGET" .md)

# Write backlink map to temp file for fast repeated lookups
BMAP=$(mktemp)
trap 'rm -f "$BMAP"' EXIT

"$SCRIPT_DIR/backlink-map.sh" "$REPO_ROOT" > "$BMAP"

# get_line_num <source_file> <link_name>
# Returns first line number where [[link_name]] appears in source_file, or 0
get_line_num() {
  local src="$1" link="$2"
  local repo_src="${REPO_ROOT}/${src}"
  # Try absolute path first, then as-is
  local path=""
  if [[ -f "$repo_src" ]]; then
    path="$repo_src"
  elif [[ -f "$src" ]]; then
    path="$src"
  else
    echo "0"
    return
  fi
  grep -n "\[\[${link}" "$path" 2>/dev/null | head -1 | cut -d: -f1 || echo "0"
}

# Depth-1: files that link TO our target
# grep -F finds all source lines where target column matches TARGET_NAME
d1_sources=$(grep -F "	${TARGET_NAME}" "$BMAP" | cut -f1 | sort -u || true)

while IFS= read -r source; do
  [[ -z "$source" ]] && continue
  line=$(get_line_num "$source" "$TARGET_NAME")
  echo "1:${source}:${line}:${TARGET_NAME}"
done <<< "$d1_sources"

# Depth-2: files that link to any depth-1 source
while IFS= read -r d1; do
  [[ -z "$d1" ]] && continue
  d1_name=$(basename "$d1" .md)
  d2_sources=$(grep -F "	${d1_name}" "$BMAP" | cut -f1 | sort -u || true)
  while IFS= read -r source; do
    [[ -z "$source" ]] && continue
    source_name=$(basename "$source" .md)
    [[ "$source_name" == "$TARGET_NAME" ]] && continue
    line=$(get_line_num "$source" "$d1_name")
    echo "2:${source}:${line}:${d1_name}"
  done <<< "$d2_sources"
done <<< "$d1_sources"

exit 0
