#!/usr/bin/env bash
# version: 2.1 | status: in-review | last_updated: 2026-04-09
# rename-ripple.sh — Find/replace stale [[wikilinks]] after a file rename
#
# Usage: ./scripts/rename-ripple.sh <old-name> <new-name> [--apply]
#   old-name: previous filename (without .md extension)
#   new-name: new filename (without .md extension)
#   --apply:  auto-replace (default: report-only dry run)
#
# Output: files and lines containing [[old-name]]
# Exit 0 if no stale refs, exit 1 if stale refs found (dry run)
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <old-name> <new-name> [--apply]" >&2
  exit 1
fi

OLD_NAME="$1"
NEW_NAME="$2"
APPLY=false
[[ "${3:-}" == "--apply" ]] && APPLY=true

REPO_ROOT="$(git -C "$(dirname "$0")/.." rev-parse --show-toplevel 2>/dev/null || echo "$(cd "$(dirname "$0")/.." && pwd)")"

# Find all files containing [[old-name]] or [[old-name|...]]
found=0
while IFS= read -r file; do
  [[ -f "$file" ]] || continue
  line_num=0
  file_had_match=false
  while IFS= read -r line; do
    ((line_num++))
    if [[ "$line" == *"[[$OLD_NAME]]"* || "$line" == *"[[$OLD_NAME|"* ]]; then
      rel_file="${file#$REPO_ROOT/}"
      echo "${rel_file}:${line_num}: $line"
      ((found++))
      file_had_match=true
    fi
  done < "$file"

  if [[ "$APPLY" == true && "$file_had_match" == true ]]; then
    # Replace [[old-name]] → [[new-name]] and [[old-name|X]] → [[new-name|X]]
    sed -i '' \
      -e "s/\[\[$OLD_NAME\]\]/[[$NEW_NAME]]/g" \
      -e "s/\[\[$OLD_NAME|/[[$NEW_NAME|/g" \
      "$file"
    echo "  → Applied replacements in ${file#$REPO_ROOT/}"
  fi
done < <(grep -rl "\[\[$OLD_NAME" --include='*.md' "$REPO_ROOT" 2>/dev/null \
  | grep -v '/.git/' | grep -v '/.obsidian/' | grep -v '/node_modules/' || true)

if [[ $found -eq 0 ]]; then
  echo "No stale references to [[$OLD_NAME]] found."
  exit 0
fi

if [[ "$APPLY" == false ]]; then
  echo "---"
  echo "$found stale reference(s) found. Run with --apply to auto-replace."
  exit 1
fi

exit 0
