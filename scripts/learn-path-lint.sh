#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-06
#
# learn-path-lint.sh — Detect stale flat paths in learning skill files
#
# Background: The learning pipeline was refactored from a flat 2-LEARN/{dir}/ layout
# to a per-system layout under 2-LEARN/{system-slug}/. Cross-system scripts and config
# moved to 2-LEARN/_cross/. Any skill referencing the old flat paths is stale.
#
# Stale patterns (old flat layout):
#   2-LEARN/input/       → now: 2-LEARN/{system-slug}/input/
#   2-LEARN/research/    → now: 2-LEARN/{system-slug}/research/
#   2-LEARN/output/      → now: 2-LEARN/{system-slug}/output/
#   2-LEARN/specs/       → now: 2-LEARN/{system-slug}/specs/
#   2-LEARN/scripts/     → now: 2-LEARN/_cross/scripts/
#   2-LEARN/config/      → now: 2-LEARN/_cross/config/
#   2-LEARN/templates/   → now: _genesis/templates/learning-book/
#
# Correct patterns (not flagged):
#   2-LEARN/_cross/      — cross-system shared resources (correct new pattern)
#
# Usage:
#   bash scripts/learn-path-lint.sh
#
# Returns:
#   exit 0 = no stale paths found
#   exit 1 = stale paths found (with file:line listing on stdout)

set -euo pipefail

SKILLS_DIR=".claude/skills/learning"
STALE_FOUND=0

# Stale path patterns to detect (plain strings, not regexes)
# These match the OLD flat layout paths.
STALE_PATTERNS=(
  "2-LEARN/input/"
  "2-LEARN/research/"
  "2-LEARN/output/"
  "2-LEARN/specs/"
  "2-LEARN/scripts/"
  "2-LEARN/config/"
  "2-LEARN/templates/"
)

if [[ ! -d "$SKILLS_DIR" ]]; then
  echo "ERROR: Skills directory not found: $SKILLS_DIR" >&2
  echo "Run this script from the repo root." >&2
  exit 1
fi

# Build grep pattern: join stale patterns with | for a single grep pass
GREP_PATTERN=$(printf '%s|' "${STALE_PATTERNS[@]}" | sed 's/|$//')

# grep -rn: recursive, with line numbers
# --include: only .md and .sh files in the skills dir
# Exclude 2-LEARN/_cross/ paths (correct new pattern — should NOT be flagged)
MATCHES=$(grep -rn -E "$GREP_PATTERN" "$SKILLS_DIR" --include="*.md" --include="*.sh" 2>/dev/null \
  | grep -v "2-LEARN/_cross/" \
  || true)

if [[ -n "$MATCHES" ]]; then
  echo "FAIL: Stale flat paths found in learning skills. Update to new per-system layout."
  echo ""
  echo "Stale references:"
  echo "$MATCHES"
  echo ""
  echo "Migration guide:"
  echo "  2-LEARN/input/      → 2-LEARN/{system-slug}/input/"
  echo "  2-LEARN/research/   → 2-LEARN/{system-slug}/research/"
  echo "  2-LEARN/output/     → 2-LEARN/{system-slug}/output/"
  echo "  2-LEARN/specs/      → 2-LEARN/{system-slug}/specs/"
  echo "  2-LEARN/scripts/    → 2-LEARN/_cross/scripts/"
  echo "  2-LEARN/config/     → 2-LEARN/_cross/config/"
  echo "  2-LEARN/templates/  → _genesis/templates/learning-book/"
  STALE_FOUND=1
else
  echo "PASS: No stale flat paths found in $SKILLS_DIR"
fi

exit $STALE_FOUND
