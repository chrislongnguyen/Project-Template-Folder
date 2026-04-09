#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-09
# rename-criterion-vocab.sh — One-time: unify Check/Checklist → Criterion
set -euo pipefail
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"
MODE="dry-run"
[[ "${1:-}" == "--apply" ]] && MODE="apply"

FILES=$(find . -type f \( -name '*.md' -o -name '*.sh' -o -name '*.py' -o -name '*.tsx' \) \
  ! -path './.git/*' ! -path '*/node_modules/*' ! -path '*/__pycache__/*' \
  ! -name 'rename-criterion-vocab.sh' ! -name 'rename-iteration-shorthand.sh' | sort)

changed=0
for file in $FILES; do
  if ! grep -qE 'Checklist [1-9]|Check [1-9][0-9]? \(C[1-9]|# ─── Check [1-9]|^echo "Check [1-9]' "$file" 2>/dev/null; then
    continue
  fi
  changed=$((changed + 1))
  if [[ "$MODE" == "apply" ]]; then
    perl -pi \
      -e 's/Checklist ([0-9]+)-([0-9]+) \(C[0-9]+-C[0-9]+\)/Criterion $1-$2/g;' \
      -e 's/Checklist ([0-9]+) \(C([0-9]+)\)/Criterion $1/g;' \
      -e 's/Checklist ([0-9]+)-([0-9]+)/Criterion $1-$2/g;' \
      -e 's/Checklist ([0-9]+)/Criterion $1/g;' \
      -e 's/Check ([0-9]+) \(C([0-9]+)\)/Criterion $1/g;' \
      -e 's/# ─── Check ([0-9]+):/# ─── Criterion $1:/g;' \
      -e 's/^(echo ")Check ([0-9]+):/$1Criterion $2:/g;' \
      "$file"
    echo "  APPLIED: $file"
  else
    echo "  WOULD CHANGE: $file"
  fi
done
echo ""; echo "--- Summary ---"; echo "Files: $changed | Mode: $MODE"
[[ "$MODE" == "dry-run" ]] && echo "Pass --apply to make changes."
