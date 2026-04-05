#!/usr/bin/env bash
# version: 2.0 | status: draft | last_updated: 2026-04-03
#
# migrate-status.sh — Bulk migration of frontmatter status values from I1 to S2 vocabulary.
#
# S2 migration mapping:
#   status: Draft    → status: draft
#   status: Review   → status: in-review
#   status: Approved → status: validated
#
# Usage:
#   ./migrate-status.sh              # dry-run (default — no files changed)
#   ./migrate-status.sh --dry-run    # explicit dry-run
#   ./migrate-status.sh --apply      # apply changes in place
#
# Scope: .md files in 1-ALIGN/ 2-LEARN/ 3-PLAN/ 4-EXECUTE/ 5-IMPROVE/
# Excluded: .claude/ _genesis/ node_modules/
#
# Idempotent: safe to run multiple times — already-migrated values are unchanged.

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Repo root is two levels up from 4-EXECUTE/scripts/ (scripts/ → 4-EXECUTE/ → repo root)
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

WORKSTREAM_DIRS=(
  "1-ALIGN"
  "2-LEARN"
  "3-PLAN"
  "4-EXECUTE"
  "5-IMPROVE"
)

DRY_RUN=true

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

for arg in "$@"; do
  case "$arg" in
    --apply)
      DRY_RUN=false
      ;;
    --dry-run)
      DRY_RUN=true
      ;;
    *)
      echo "ERROR: Unknown argument: $arg" >&2
      echo "Usage: $0 [--dry-run|--apply]" >&2
      exit 1
      ;;
  esac
done

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

log_mode() {
  if [[ "$DRY_RUN" == true ]]; then
    echo "[DRY-RUN] $*"
  else
    echo "[APPLY]   $*"
  fi
}

# Apply sed replacements to a single file.
# Args: $1 = file path
migrate_file() {
  local file="$1"
  local changed=false

  # Read current content
  local content
  content="$(cat "$file")"

  # Check if file has frontmatter (starts with ---)
  if ! echo "$content" | head -1 | grep -q "^---"; then
    return 0
  fi

  # Build new content using sed replacements — only within frontmatter block.
  # Strategy: replace only lines matching `^status: <OldValue>$` inside the
  # YAML block (between the first pair of --- delimiters).
  # We use perl for reliable in-block substitution across platforms.

  local new_content
  new_content="$(perl -0777 -pe '
    # Match the YAML frontmatter block (first --- to second ---)
    s{^(---\n)(.*?)(---\n)}{
      my ($open, $body, $close) = ($1, $2, $3);
      $body =~ s/^(status:\s*)Draft\s*$/${1}draft/mg;
      $body =~ s/^(status:\s*)Review\s*$/${1}in-review/mg;
      $body =~ s/^(status:\s*)Approved\s*$/${1}validated/mg;
      "$open$body$close"
    }es
  ' "$file")"

  if [[ "$content" != "$new_content" ]]; then
    changed=true
    log_mode "CHANGED: $file"
    if [[ "$DRY_RUN" == false ]]; then
      printf '%s' "$new_content" > "$file"
    else
      # Show diff in dry-run mode
      diff <(echo "$content") <(echo "$new_content") | head -20 || true
    fi
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

echo "migrate-status.sh — S2 frontmatter migration"
echo "Repo root: ${REPO_ROOT}"
if [[ "$DRY_RUN" == true ]]; then
  echo "Mode: DRY-RUN (pass --apply to write changes)"
else
  echo "Mode: APPLY (files will be modified in place)"
fi
echo "---"

total_files=0
changed_files=0

for dir in "${WORKSTREAM_DIRS[@]}"; do
  target="${REPO_ROOT}/${dir}"
  if [[ ! -d "$target" ]]; then
    echo "SKIP (not found): ${target}"
    continue
  fi

  # Find all .md files recursively, excluding node_modules
  while IFS= read -r -d '' file; do
    total_files=$((total_files + 1))

    # Capture pre-count of changes by checking before vs after (dry-run)
    before_count=$changed_files
    migrate_file "$file"
    # If migrate_file printed CHANGED, bump counter
    # We detect this by re-checking; simpler: count lines with CHANGED in output
    # Since migrate_file logs inline, we track via a flag approach:
    # Re-check: grep status lines for old values
    if grep -q "^status: Draft\|^status: Review\|^status: Approved" "$file" 2>/dev/null; then
      changed_files=$((changed_files + 1))
    fi
  done < <(find "$target" -name "*.md" -not -path "*/node_modules/*" -print0)
done

echo "---"
echo "Total .md files scanned: ${total_files}"

if [[ "$DRY_RUN" == true ]]; then
  echo "Files with old status values (would be changed): ${changed_files}"
  echo ""
  echo "Run with --apply to apply changes."
else
  echo "Files migrated: ${changed_files}"
  echo "Migration complete."
fi

exit 0
