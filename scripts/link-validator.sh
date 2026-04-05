#!/usr/bin/env bash
# version: 2.0 | status: Draft | last_updated: 2026-04-05
# link-validator.sh — Find broken [[wikilinks]] in specified or staged files
#
# Usage: ./scripts/link-validator.sh [file ...] [--staged]
#   file:    specific files to check
#   --staged: check all staged .md files (default if no files given)
#
# Output: broken links as "file:line:[[target]]"
# Exit 0 if clean, exit 1 if broken links found
set -euo pipefail

REPO_ROOT="$(git -C "$(dirname "$0")/.." rev-parse --show-toplevel 2>/dev/null || echo "$(cd "$(dirname "$0")/.." && pwd)")"

# Collect files to check
files=()
use_staged=false

for arg in "$@"; do
  if [[ "$arg" == "--staged" ]]; then
    use_staged=true
  else
    files+=("$arg")
  fi
done

if [[ ${#files[@]} -eq 0 ]]; then
  use_staged=true
fi

if [[ "$use_staged" == true ]]; then
  while IFS= read -r f; do
    [[ "$f" == *.md ]] && files+=("$REPO_ROOT/$f")
  done < <(git -C "$REPO_ROOT" diff --cached --name-only 2>/dev/null || true)
fi

if [[ ${#files[@]} -eq 0 ]]; then
  exit 0
fi

# Build set of existing .md basenames (without extension) for resolution
EXISTING_FILES=$(find "$REPO_ROOT" -name '*.md' -not -path '*/.git/*' -not -path '*/.obsidian/*' -not -path '*/node_modules/*' 2>/dev/null | while IFS= read -r f; do basename "$f" .md; done | sort -u)

broken=0
for file in "${files[@]}"; do
  [[ -f "$file" ]] || continue
  line_num=0
  while IFS= read -r line; do
    ((line_num++))
    # Extract all [[...]] from line
    while [[ "$line" =~ \[\[([^\]]+)\]\] ]]; do
      link="${BASH_REMATCH[1]}"
      # Handle alias: [[target|display]]
      target="${link%%|*}"
      # Trim whitespace
      target=$(echo "$target" | xargs)
      # Strip .md if present
      target="${target%.md}"
      # Check existence
      if ! echo "$EXISTING_FILES" | grep -qxF "$target"; then
        rel_file="${file#$REPO_ROOT/}"
        echo "${rel_file}:${line_num}:[[${link}]]"
        ((broken++))
      fi
      # Remove matched link to find next
      line="${line#*"[[${link}]]"}"
    done
  done < "$file"
done

if [[ $broken -gt 0 ]]; then
  echo "---"
  echo "$broken broken link(s) found"
  exit 1
fi

exit 0
