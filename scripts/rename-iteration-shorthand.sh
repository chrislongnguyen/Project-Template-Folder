#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-09
# rename-iteration-shorthand.sh — One-time find-replace: I0-I4 → Iteration 0-4
# Operates on .md, .sh, .py, .tsx, .ts files. Skips .git, node_modules, __pycache__.
# Uses word-boundary-aware sed to avoid false positives.
# DRY RUN by default. Pass --apply to make changes.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

MODE="dry-run"
[[ "${1:-}" == "--apply" ]] && MODE="apply"

# Build file list
FILES=$(find . \
  -type f \( -name '*.md' -o -name '*.sh' -o -name '*.py' -o -name '*.tsx' -o -name '*.ts' \) \
  ! -path './.git/*' \
  ! -path '*/node_modules/*' \
  ! -path '*/__pycache__/*' \
  ! -path '*/rename-iteration-shorthand.sh' \
  | sort)

# Replacements: word-boundary I0-I4 → Iteration 0-4
# Using \b equivalent for BSD sed: match on non-alphanumeric boundaries
# Strategy: use perl for proper \b word boundary support (available on macOS)
PATTERNS=(
  's/\bI0\b/Iteration 0/g'
  's/\bI1\b/Iteration 1/g'
  's/\bI2\b/Iteration 2/g'
  's/\bI3\b/Iteration 3/g'
  's/\bI4\b/Iteration 4/g'
)

# Also rename the file I2-training-deck.md
FILE_RENAME_OLD="_genesis/training/I2-training-deck.md"
FILE_RENAME_NEW="_genesis/training/iteration-2-training-deck.md"

changed_files=0
total_replacements=0

for file in $FILES; do
  # Count matches before replacing
  count=0
  for pattern in "${PATTERNS[@]}"; do
    c=$(perl -ne "BEGIN{\$n=0} \$n++ while /\\bI[0-4]\\b/g; END{print \$n}" "$file" 2>/dev/null || echo 0)
    count=$c
    break  # Only need one count pass
  done

  if [[ "$count" -gt 0 ]]; then
    changed_files=$((changed_files + 1))
    total_replacements=$((total_replacements + count))

    if [[ "$MODE" == "apply" ]]; then
      perl -pi -e 's/\bI0\b/Iteration 0/g; s/\bI1\b/Iteration 1/g; s/\bI2\b/Iteration 2/g; s/\bI3\b/Iteration 3/g; s/\bI4\b/Iteration 4/g' "$file"
      echo "  APPLIED: $file ($count replacements)"
    else
      echo "  WOULD CHANGE: $file ($count replacements)"
    fi
  fi
done

echo ""
echo "--- Summary ---"
echo "Files affected: $changed_files"
echo "Total replacements: $total_replacements"
echo "Mode: $MODE"

# File rename
if [[ -f "$FILE_RENAME_OLD" ]]; then
  if [[ "$MODE" == "apply" ]]; then
    git mv "$FILE_RENAME_OLD" "$FILE_RENAME_NEW"
    echo "RENAMED: $FILE_RENAME_OLD → $FILE_RENAME_NEW"
    # Update wikilinks referencing old name
    perl -pi -e 's/\[\[I2-training-deck\]\]/[[iteration-2-training-deck]]/g; s/\[\[I2-training-deck\|/[[iteration-2-training-deck|/g' $(find . -name '*.md' ! -path './.git/*')
    echo "UPDATED: wikilinks referencing I2-training-deck"
  else
    echo "WOULD RENAME: $FILE_RENAME_OLD → $FILE_RENAME_NEW"
    echo "WOULD UPDATE: wikilinks referencing I2-training-deck"
  fi
fi

echo ""
if [[ "$MODE" == "dry-run" ]]; then
  echo "This was a DRY RUN. Pass --apply to make changes."
fi
