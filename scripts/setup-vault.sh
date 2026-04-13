#!/usr/bin/env bash
# version: 2.4 | status: in-review | last_updated: 2026-04-13
#
# setup-vault.sh — Idempotent Obsidian Vault Folder Creation
#
# PURPOSE:
#   Creates the complete vault folder hierarchy (10 folders + .gitkeep files)
#   on a fresh checkout. Safe to run multiple times — exits 0 both times.
#
# USAGE:
#   ./setup-vault.sh                    # Uses current directory as VAULT_ROOT
#   ./setup-vault.sh /path/to/vault     # Uses specified VAULT_ROOT
#
# EXIT CODES:
#   0  — Success (all folders created or already exist)
#   1  — Error (missing VAULT_ROOT, permission denied, mkdir failure)
#
# DEPENDENCIES:
#   - bash (modern; tested on Bash 3.2+)
#   - mkdir, touch (POSIX standard)
#

set -euo pipefail

# ─────────────────────────────────────────────────────────────
# HELP
# ─────────────────────────────────────────────────────────────

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  grep '^#' "$0" | grep -v '^#!/' | sed 's/^# //' | sed 's/^#//'
  exit 0
fi

# ─────────────────────────────────────────────────────────────
# CONFIG
# ─────────────────────────────────────────────────────────────

VAULT_ROOT="${1:-.}"

# List of all top-level folders to create
FOLDERS=(
  "1-ALIGN"
  "2-LEARN"
  "3-PLAN"
  "4-EXECUTE"
  "5-IMPROVE"
  "DAILY-NOTES"
  "MISC-TASKS"
  "PEOPLE"
  "PERSONAL-KNOWLEDGE-BASE"
  "inbox"
)


# ─────────────────────────────────────────────────────────────
# VALIDATION
# ─────────────────────────────────────────────────────────────

if [[ ! -d "$VAULT_ROOT" ]]; then
  echo "ERROR: VAULT_ROOT '$VAULT_ROOT' does not exist" >&2
  exit 1
fi

# ─────────────────────────────────────────────────────────────
# EXECUTION
# ─────────────────────────────────────────────────────────────

# Detect existing vault content — skip scaffold if vault already has folders.
# This handles users who have a pre-existing Obsidian vault with custom structure.
# Hooks create 07-Claude/sessions and 07-Claude/state via mkdir -p on demand.
EXISTING_DIRS=$(find "$VAULT_ROOT" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
if [[ "$EXISTING_DIRS" -gt 0 ]]; then
  echo "✓ Vault already has content ($EXISTING_DIRS folder(s) found) — skipping scaffold"
  echo "  Your existing structure is preserved as-is."
  echo "  Hooks will auto-create 07-Claude/sessions and 07-Claude/state on first run."
  exit 0
fi

# Create all top-level workstream + operational folders
for folder in "${FOLDERS[@]}"; do
  mkdir -p "$VAULT_ROOT/$folder" || {
    echo "ERROR: Failed to create folder '$VAULT_ROOT/$folder'" >&2
    exit 1
  }
done

# PKB sub-directories: 1-captured (raw immutable), 2-organised (AI wiki pages), 3-distilled (human synthesis), 4-expressed (outputs)
PKB_SUBDIRS=(
  "PERSONAL-KNOWLEDGE-BASE/1-captured"
  "PERSONAL-KNOWLEDGE-BASE/2-organised"
  "PERSONAL-KNOWLEDGE-BASE/3-distilled"
  "PERSONAL-KNOWLEDGE-BASE/4-expressed"
)

for subdir in "${PKB_SUBDIRS[@]}"; do
  mkdir -p "$VAULT_ROOT/$subdir" || {
    echo "ERROR: Failed to create '$VAULT_ROOT/$subdir'" >&2
    exit 1
  }
  touch "$VAULT_ROOT/$subdir/.gitkeep" || {
    echo "ERROR: Failed to create .gitkeep in '$VAULT_ROOT/$subdir'" >&2
    exit 1
  }
done

# Add .gitkeep files to folders that must be tracked (empty folders need this for Git)
GITKEEP_FOLDERS=(
  "inbox"
)

for folder in "${GITKEEP_FOLDERS[@]}"; do
  gitkeep_file="$VAULT_ROOT/$folder/.gitkeep"
  touch "$gitkeep_file" || {
    echo "ERROR: Failed to create .gitkeep in '$VAULT_ROOT/$folder'" >&2
    exit 1
  }
done

# ─────────────────────────────────────────────────────────────
# SUCCESS
# ─────────────────────────────────────────────────────────────

echo "✓ Vault folder structure created successfully at $VAULT_ROOT"
echo "  Created 10 folders + 1 .gitkeep file"
exit 0
