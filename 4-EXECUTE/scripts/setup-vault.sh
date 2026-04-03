#!/usr/bin/env bash
# version: 2.0 | status: draft | last_updated: 2026-04-03
#
# setup-vault.sh — Idempotent Obsidian Vault Folder Creation
#
# PURPOSE:
#   Creates the complete vault folder hierarchy (17 folders + .gitkeep files)
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
  "PLACES"
  "TEMP-IN"
  "TEMP-OUT"
  "THINGS"
  "AI-AGENT-MEMORY"
  "inbox"
)

# Nested folders under 0-REUSABLE-RESOURCES
REUSABLE_NESTED=(
  "templates"
  "bases"
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

# Create all top-level workstream + operational folders
for folder in "${FOLDERS[@]}"; do
  mkdir -p "$VAULT_ROOT/$folder" || {
    echo "ERROR: Failed to create folder '$VAULT_ROOT/$folder'" >&2
    exit 1
  }
done

# Create 0-REUSABLE-RESOURCES and nested templates/ + bases/
mkdir -p "$VAULT_ROOT/0-REUSABLE-RESOURCES" || {
  echo "ERROR: Failed to create folder '$VAULT_ROOT/0-REUSABLE-RESOURCES'" >&2
  exit 1
}

for nested in "${REUSABLE_NESTED[@]}"; do
  mkdir -p "$VAULT_ROOT/0-REUSABLE-RESOURCES/$nested" || {
    echo "ERROR: Failed to create folder '$VAULT_ROOT/0-REUSABLE-RESOURCES/$nested'" >&2
    exit 1
  }
done

# Add .gitkeep files to folders that must be tracked (empty folders need this for Git)
GITKEEP_FOLDERS=(
  "inbox"
  "AI-AGENT-MEMORY"
  "0-REUSABLE-RESOURCES/templates"
  "0-REUSABLE-RESOURCES/bases"
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
echo "  Created 17 folders + 4 .gitkeep files"
exit 0
