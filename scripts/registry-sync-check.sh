#!/usr/bin/env bash
# version: 2.0 | status: Draft | last_updated: 2026-04-05
# registry-sync-check.sh — Compare staged .md versions against VERSION_REGISTRY.md
#
# Usage: ./scripts/registry-sync-check.sh [repo-root]
#
# Checks each staged .md file's frontmatter "version" against its row in
# _genesis/VERSION_REGISTRY.md. Reports mismatches.
#
# Exit 0 if all in sync, exit 1 if mismatches found
set -euo pipefail

REPO_ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || echo ".")}"
REPO_ROOT=$(cd "$REPO_ROOT" && pwd)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REGISTRY="$REPO_ROOT/_genesis/VERSION_REGISTRY.md"
EXTRACT="$SCRIPT_DIR/frontmatter-extract.sh"

if [[ ! -f "$REGISTRY" ]]; then
  echo "Warning: VERSION_REGISTRY.md not found, skipping sync check" >&2
  exit 0
fi

# Get staged .md files
staged_files=()
while IFS= read -r f; do
  [[ "$f" == *.md ]] && staged_files+=("$f")
done < <(git -C "$REPO_ROOT" diff --cached --name-only 2>/dev/null || true)

if [[ ${#staged_files[@]} -eq 0 ]]; then
  exit 0
fi

mismatches=0
for rel_path in "${staged_files[@]}"; do
  file="$REPO_ROOT/$rel_path"
  [[ -f "$file" ]] || continue

  # Extract version from frontmatter
  file_version=$("$EXTRACT" "$file" "version" 2>/dev/null) || continue

  # Look up in registry by filename
  basename_file=$(basename "$rel_path")
  # Registry format: | path or name | version | status | date |
  registry_line=$(grep -i "$basename_file" "$REGISTRY" 2>/dev/null | head -1) || continue
  [[ -z "$registry_line" ]] && continue

  # Extract version from registry table row (second column in pipe-delimited table)
  registry_version=$(echo "$registry_line" | awk -F'|' '{gsub(/^[ \t]+|[ \t]+$/, "", $3); print $3}')
  [[ -z "$registry_version" ]] && continue

  if [[ "$file_version" != "$registry_version" ]]; then
    echo "MISMATCH: $rel_path — file=$file_version registry=$registry_version"
    ((mismatches++))
  fi
done

if [[ $mismatches -gt 0 ]]; then
  echo "---"
  echo "$mismatches file(s) out of sync with VERSION_REGISTRY.md"
  exit 1
fi

exit 0
