#!/bin/bash
# version: 1.0 | status: draft | last_updated: 2026-04-08
#
# skill-sync-user.sh — Copy project-scope skills to user-scope (~/.claude/skills/)
#
# Syncs ONLY skills that are intended to be cross-project (resume, compress, deep-research).
# Does NOT sync LTC-specific skills (ltc-*, learn-*, dsbv, etc.) — those stay project-scoped.
#
# Usage:
#   ./scripts/skill-sync-user.sh           # sync cross-project skills
#   ./scripts/skill-sync-user.sh --dry-run # show what would be synced
#   ./scripts/skill-sync-user.sh --all     # sync ALL project skills to user scope

set -euo pipefail

PROJECT_SKILLS="$(cd "$(dirname "$0")/.." && pwd)/.claude/skills"
USER_SKILLS="$HOME/.claude/skills"

# Cross-project skills — these are useful in ALL repos, not just this template
CROSS_PROJECT_SKILLS=(
  "resume"
  "compress"
  "deep-research"
  "slide-deck"
  "vault-capture"
)

DRY_RUN=false
SYNC_ALL=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --all)     SYNC_ALL=true ;;
  esac
done

synced=0
skipped=0

if $SYNC_ALL; then
  skill_dirs=("$PROJECT_SKILLS"/*)
else
  skill_dirs=()
  for name in "${CROSS_PROJECT_SKILLS[@]}"; do
    if [[ -d "$PROJECT_SKILLS/$name" ]]; then
      skill_dirs+=("$PROJECT_SKILLS/$name")
    fi
  done
fi

for skill_dir in "${skill_dirs[@]}"; do
  [[ -d "$skill_dir" ]] || continue
  name="$(basename "$skill_dir")"
  target="$USER_SKILLS/$name"

  # Check if content differs
  if [[ -d "$target" ]] && diff -rq "$skill_dir" "$target" >/dev/null 2>&1; then
    skipped=$((skipped + 1))
    continue
  fi

  if $DRY_RUN; then
    if [[ -d "$target" ]]; then
      echo "[dry-run] UPDATE: $name"
    else
      echo "[dry-run] NEW:    $name"
    fi
  else
    mkdir -p "$target"
    # -L dereferences symlinks so user-scope gets real files (not broken links)
    cp -rL "$skill_dir"/* "$target"/
    echo "  ✓ $name"
  fi
  synced=$((synced + 1))
done

if $DRY_RUN; then
  echo ""
  echo "Would sync $synced skill(s), skip $skipped unchanged"
else
  echo ""
  echo "Synced $synced skill(s) to $USER_SKILLS/ ($skipped unchanged)"
fi
