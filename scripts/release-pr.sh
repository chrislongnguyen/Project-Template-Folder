#!/usr/bin/env bash
set -euo pipefail

# LTC Project Template — Release PR Creator
# Creates a PR from the current branch → main with I-level deliverable summary.
# Usage: ./scripts/release-pr.sh [--dry-run]
#
# Prerequisites: gh CLI authenticated, .templateignore at repo root

REPO_ROOT="$(git rev-parse --show-toplevel)"
TEMPLATEIGNORE="${REPO_ROOT}/.templateignore"
VERSION_FILE="${REPO_ROOT}/VERSION"
CHANGELOG_FILE="${REPO_ROOT}/4-IMPROVE/changelog/CHANGELOG.md"
BASE_BRANCH="main"

# --- Flag parsing ---
DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --help|-h)
      echo "Usage: $0 [--dry-run]"
      echo "  --dry-run  Show what would be created without actually creating the PR"
      exit 0
      ;;
    *) echo "Unknown flag: $arg"; exit 2 ;;
  esac
done

# --- Preflight checks ---
CURRENT_BRANCH="$(git branch --show-current)"
if [[ "$CURRENT_BRANCH" == "$BASE_BRANCH" ]]; then
  echo "Error: Already on ${BASE_BRANCH}. Switch to your feature branch first."
  exit 1
fi

if ! command -v gh &>/dev/null; then
  echo "Error: gh CLI not found. Install: https://cli.github.com"
  exit 1
fi

if ! gh auth status &>/dev/null 2>&1; then
  echo "Error: gh CLI not authenticated. Run: gh auth login"
  exit 1
fi

# --- Gather info ---
VERSION="unknown"
[[ -f "$VERSION_FILE" ]] && VERSION="$(cat "$VERSION_FILE" | tr -d '[:space:]')"

# Count changes vs base
STAT_SUMMARY="$(git diff --stat "${BASE_BRANCH}...HEAD" 2>/dev/null | tail -1 || echo "unknown")"
FILE_COUNT="$(git diff --name-only "${BASE_BRANCH}...HEAD" 2>/dev/null | wc -l | tr -d ' ')"
COMMIT_COUNT="$(git rev-list --count "${BASE_BRANCH}..HEAD" 2>/dev/null || echo "?")"

# Filter out .templateignore patterns from the diff
SHIPPED_FILES=""
if [[ -f "$TEMPLATEIGNORE" ]]; then
  # Build exclude args from .templateignore (skip comments and blank lines)
  EXCLUDE_ARGS=()
  while IFS= read -r line; do
    line="${line%%#*}"           # strip inline comments
    line="${line%"${line##*[![:space:]]}"}"  # trim trailing whitespace
    [[ -z "$line" ]] && continue
    EXCLUDE_ARGS+=(":!${line}")
  done < "$TEMPLATEIGNORE"

  SHIPPED_FILES="$(git diff --name-only "${BASE_BRANCH}...HEAD" -- . "${EXCLUDE_ARGS[@]}" 2>/dev/null || true)"
  SHIPPED_COUNT="$(echo "$SHIPPED_FILES" | grep -c . 2>/dev/null || echo "0")"
  EXCLUDED_COUNT=$(( FILE_COUNT - SHIPPED_COUNT ))
else
  SHIPPED_FILES="$(git diff --name-only "${BASE_BRANCH}...HEAD" 2>/dev/null || true)"
  SHIPPED_COUNT="$FILE_COUNT"
  EXCLUDED_COUNT=0
fi

# --- Zone breakdown ---
zone_count() {
  local c
  c="$(echo "$SHIPPED_FILES" | grep -c "^${1}" 2>/dev/null)" || true
  echo "${c:-0}"
}

Z0_COUNT="$(echo "$SHIPPED_FILES" | grep -cE "^(CLAUDE|GEMINI|AGENTS|rules/|\.claude/)" 2>/dev/null)" || true
Z0_COUNT="${Z0_COUNT:-0}"
Z1_COUNT="$(zone_count "1-ALIGN/")"
Z2_COUNT="$(zone_count "2-PLAN/")"
Z3_COUNT="$(zone_count "3-EXECUTE/")"
Z4_COUNT="$(zone_count "4-IMPROVE/")"
ZS_COUNT="$(zone_count "_shared/")"
ZROOT_COUNT="$(echo "$SHIPPED_FILES" | grep -cE "^(README|VERSION|\.gitignore|\.templateignore|scripts/)" 2>/dev/null)" || true
ZROOT_COUNT="${ZROOT_COUNT:-0}"

# --- Build PR body ---
PR_TITLE="feat(scaffold): I0 — LTC Project Template v${VERSION}"

PR_BODY="$(cat <<'HEADER'
## Summary

I0 delivers the complete LTC Project Template scaffold — a 5×4 APEI matrix with agent governance, global rules, frameworks, templates, quality gates, and skills infrastructure.

## Deliverables

| ID | Deliverable | Description |
|----|-------------|-------------|
| D1 | Zone Structure | 5×4 matrix (1-ALIGN, 2-PLAN, 3-EXECUTE, 4-IMPROVE, _shared) |
| D2 | Agent Governance | CLAUDE.md, GEMINI.md, rules/, .claude/ (hooks, skills, config) |
| D3 | Templates & Frameworks | 11 templates (_shared/templates), 10 framework pointers |
| D4 | Quality Gates | 6 stage validators + test fixtures + test scaffolding |
| D5 | Distribution System | VERSION, template-check.sh, CHANGELOG.md, .templateignore |
| D6 | Skills Infrastructure | 6 skills zone-scoped + symlinked in .claude/skills/ |
HEADER
)"

PR_BODY="${PR_BODY}

## Zone Breakdown

| Zone | Files | Description |
|------|------:|-------------|
| Z0 — Governance | ${Z0_COUNT} | CLAUDE.md, rules, .claude config |
| Z1 — ALIGN | ${Z1_COUNT} | Charter, decisions, OKRs, learning pipeline |
| Z2 — PLAN | ${Z2_COUNT} | Architecture, risks, drivers, roadmap |
| Z3 — EXECUTE | ${Z3_COUNT} | Src, tests, config, docs, scripts |
| Z4 — IMPROVE | ${Z4_COUNT} | Changelog, metrics, retros, reviews |
| _shared | ${ZS_COUNT} | Brand, frameworks, security, SOPs, templates |
| Root | ${ZROOT_COUNT} | README, VERSION, .gitignore, scripts |
| **Total shipped** | **${SHIPPED_COUNT}** | (${EXCLUDED_COUNT} design-time files excluded via .templateignore) |

## Stats
- **Version:** ${VERSION}
- **Commits:** ${COMMIT_COUNT}
- **Branch:** \`${CURRENT_BRANCH}\` → \`${BASE_BRANCH}\`
- **Changes:** ${STAT_SUMMARY}

## Test Plan
- [ ] Clone fresh copy using this as template — verify 5×4 structure intact
- [ ] Run \`./scripts/template-check.sh --init\` in child repo — verify version stamp
- [ ] Confirm all .claude/skills/ symlinks resolve
- [ ] Spot-check 3 templates have placeholder content (not LTC-specific data)
- [ ] Verify no secrets, .env files, or personal paths in committed files

---
🤖 Generated with [Claude Code](https://claude.com/claude-code)"

# --- Output or create ---
echo "═══════════════════════════════════════════════════════"
echo "  LTC Project Template — Release PR"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "  Branch:    ${CURRENT_BRANCH} → ${BASE_BRANCH}"
echo "  Version:   ${VERSION}"
echo "  Commits:   ${COMMIT_COUNT}"
echo "  Files:     ${SHIPPED_COUNT} shipped, ${EXCLUDED_COUNT} excluded"
echo "  Changes:   ${STAT_SUMMARY}"
echo ""
echo "  Zone breakdown:"
echo "    Z0 Governance:  ${Z0_COUNT}"
echo "    Z1 ALIGN:       ${Z1_COUNT}"
echo "    Z2 PLAN:        ${Z2_COUNT}"
echo "    Z3 EXECUTE:     ${Z3_COUNT}"
echo "    Z4 IMPROVE:     ${Z4_COUNT}"
echo "    _shared:        ${ZS_COUNT}"
echo "    Root:           ${ZROOT_COUNT}"
echo ""

if [[ "$DRY_RUN" == true ]]; then
  echo "  [DRY RUN] Would create PR with title:"
  echo "    ${PR_TITLE}"
  echo ""
  echo "  Body preview (first 20 lines):"
  echo "$PR_BODY" | head -20
  echo "  ..."
  echo ""
  echo "  To create for real: $0"
  exit 0
fi

# Push branch if needed
if ! git ls-remote --exit-code origin "${CURRENT_BRANCH}" &>/dev/null; then
  echo "  Pushing ${CURRENT_BRANCH} to origin..."
  git push -u origin "${CURRENT_BRANCH}"
fi

# Create PR
echo "  Creating PR..."
PR_URL="$(gh pr create \
  --base "${BASE_BRANCH}" \
  --head "${CURRENT_BRANCH}" \
  --title "${PR_TITLE}" \
  --body "${PR_BODY}" 2>&1)"

echo ""
echo "  ✓ PR created: ${PR_URL}"
echo ""
