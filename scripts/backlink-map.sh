#!/usr/bin/env bash
# version: 2.0 | status: Draft | last_updated: 2026-04-04
# backlink-map.sh — Build adjacency list of all [[wikilinks]] in repo
#
# Usage: ./scripts/backlink-map.sh [directory]
#   directory: root to scan (default: repo root)
#
# Output: TSV to stdout — source_file<TAB>target
#   target is the resolved wikilink text (without [[ ]])
#
# Handles: [[simple]], [[path/file]], [[alias|display text]]
# Excludes: .git/, .obsidian/, node_modules/
set -euo pipefail

ROOT="${1:-.}"
ROOT=$(cd "$ROOT" && pwd)

# grep extracts all [[...]] matches with filename prefix
# awk parses: strips [[]], handles aliases, outputs TSV
grep -roHE '\[\[[^]]+\]\]' --include='*.md' "$ROOT" 2>/dev/null | \
  grep -v '/.git/' | \
  grep -v '/.obsidian/' | \
  grep -v '/node_modules/' | \
  awk -v root="$ROOT/" '
  {
    # Line format: /abs/path/file.md:[[target]] or :[[target|display]]
    idx = index($0, ":[[")
    if (idx == 0) next
    file = substr($0, 1, idx - 1)
    match_raw = substr($0, idx + 3)
    # Strip trailing ]]
    gsub(/\]\]$/, "", match_raw)
    # Handle aliases: [[target|display]] → take target
    split(match_raw, parts, "|")
    target = parts[1]
    # Trim whitespace
    gsub(/^[ \t]+|[ \t]+$/, "", target)
    if (target == "") next
    # Make path relative
    sub(root, "", file)
    printf "%s\t%s\n", file, target
  }'

exit 0
