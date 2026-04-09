#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-09
# bulk-validate.sh — Set status: in-review → validated on all matching .md files under a path
#
# Usage:
#   ./scripts/bulk-validate.sh <path> [--dry-run]
#   ./scripts/bulk-validate.sh --subsystem 1-PD [--dry-run]
#
# Safety: ONLY modifies files with `status: in-review`. Never touches draft, in-progress, or validated.
# Requires FORCE_APPROVE=1 to bypass status-guard.sh at commit time.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
TODAY="$(date +%Y-%m-%d)"
DRY_RUN=0
SUBSYSTEM=""
SEARCH_PATHS=()

# --- Argument parsing ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --subsystem)
      shift
      if [[ $# -eq 0 ]]; then
        echo "ERROR: --subsystem requires a value (e.g. 1-PD)" >&2
        exit 1
      fi
      SUBSYSTEM="$1"
      shift
      ;;
    -*)
      echo "ERROR: Unknown flag: $1" >&2
      exit 1
      ;;
    *)
      SEARCH_PATHS+=("$1")
      shift
      ;;
  esac
done

# --- Resolve search paths ---
if [[ -n "$SUBSYSTEM" ]]; then
  # Find the subsystem dir across all workstreams
  while IFS= read -r -d '' dir; do
    SEARCH_PATHS+=("$dir")
  done < <(find "$REPO_ROOT" -maxdepth 2 -type d -name "$SUBSYSTEM" -print0 2>/dev/null)
  if [[ ${#SEARCH_PATHS[@]} -eq 0 ]]; then
    echo "ERROR: No directories found matching subsystem '$SUBSYSTEM'" >&2
    exit 1
  fi
fi

if [[ ${#SEARCH_PATHS[@]} -eq 0 ]]; then
  echo "ERROR: No path or --subsystem provided." >&2
  echo "Usage: $0 <path> [--dry-run]" >&2
  echo "       $0 --subsystem 1-PD [--dry-run]" >&2
  exit 1
fi

# Resolve paths to absolute
ABS_PATHS=()
for p in "${SEARCH_PATHS[@]}"; do
  if [[ "$p" = /* ]]; then
    ABS_PATHS+=("$p")
  else
    ABS_PATHS+=("$REPO_ROOT/$p")
  fi
done

# --- Find candidate files ---
MATCHING_FILES=()
while IFS= read -r -d '' file; do
  # Check for status: in-review in YAML frontmatter (first 30 lines, anchored)
  if head -30 "$file" | grep -qE '^status:\s*"?in-review"?\s*$'; then
    MATCHING_FILES+=("$file")
  fi
done < <(find "${ABS_PATHS[@]}" -type f -name "*.md" -print0 2>/dev/null | sort -z)

COUNT=${#MATCHING_FILES[@]}

if [[ $COUNT -eq 0 ]]; then
  echo "No files with status: in-review found under the specified path(s)."
  exit 0
fi

# --- Report ---
echo "Files with status: in-review (${COUNT} found):"
for f in "${MATCHING_FILES[@]}"; do
  echo "  ${f#"$REPO_ROOT/"}"
done
echo ""

if [[ $DRY_RUN -eq 1 ]]; then
  echo "[DRY RUN] ${COUNT} file(s) would be changed. No modifications made."
  exit 0
fi

# --- Confirmation ---
printf "Apply bulk-validate to %d file(s)? [y/N] " "$COUNT"
read -r CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi

# --- Apply changes ---
MODIFIED=0
for file in "${MATCHING_FILES[@]}"; do
  rel="${file#"$REPO_ROOT/"}"

  # 1. status: in-review → status: validated
  sed -i'' -e 's/^status:[[:space:]]*"*in-review"*[[:space:]]*$/status: validated/' "$file"

  # 2. last_updated: → today
  sed -i'' -e "s/^last_updated:[[:space:]]*.*/last_updated: ${TODAY}/" "$file"

  # 3. Approval log — append record
  APPROVAL_ROW="| ${TODAY} | bulk | APPROVED | bulk-validate.sh | bulk |"

  if grep -q '^## Approval Log' "$file"; then
    # Section exists — find the table header line and append after the last table row
    # Insert the new row after the last existing | row in the Approval Log section
    python3 - "$file" "$APPROVAL_ROW" <<'PYEOF'
import sys, re

filepath = sys.argv[1]
new_row  = sys.argv[2]

with open(filepath, 'r') as fh:
    content = fh.read()

# Find the Approval Log section
section_start = content.find('\n## Approval Log')
if section_start == -1:
    section_start = content.find('## Approval Log')

# Find the last pipe-row within the section
after_section = content[section_start:]
# Find last table row
lines = after_section.split('\n')
last_row_idx = None
for i, line in enumerate(lines):
    if line.startswith('|') and i > 0:
        last_row_idx = i

if last_row_idx is not None:
    lines.insert(last_row_idx + 1, new_row)
else:
    # No rows yet — append after the header and separator
    lines.append(new_row)

new_after = '\n'.join(lines)
new_content = content[:section_start] + new_after

with open(filepath, 'w') as fh:
    fh.write(new_content)
PYEOF
  else
    # Section missing — append to end of file
    printf '\n## Approval Log\n\n| Date | Gate | Verdict | Signal | Tier |\n|------|------|---------|--------|------|\n%s\n' \
      "$APPROVAL_ROW" >> "$file"
  fi

  echo "  VALIDATED: ${rel}"
  MODIFIED=$((MODIFIED + 1))
done

echo ""
echo "${MODIFIED} file(s) updated."

# --- Regenerate version registry if script exists ---
REGISTRY_SCRIPT="$REPO_ROOT/scripts/generate-registry.sh"
if [[ -x "$REGISTRY_SCRIPT" ]]; then
  echo "Regenerating version registry..."
  FORCE_APPROVE=1 "$REGISTRY_SCRIPT"
else
  echo "(generate-registry.sh not found — skipping registry regeneration)"
fi

echo "Done."
