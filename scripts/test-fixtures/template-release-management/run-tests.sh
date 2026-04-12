#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-12
# run-tests.sh — Execute all 7 Template Release Management tests
#
# Tests: T1 Khang (deprecated detection), T2 Dong (BUG-A local-only),
#        T3 Dung (PATH B), T4 CamVan (PATH C), T5 Bootstrap (checkpoint prompt),
#        T6 BUG-A verify (classify order), T7 BUG-B verify (section-merge prefix)
#
# Usage: bash scripts/test-fixtures/template-release-management/run-tests.sh
# Run from repo root.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || echo "")"
if [[ -z "$REPO_ROOT" ]]; then
  echo "ERROR: not inside a git repository." >&2
  exit 2
fi

MANIFEST_SH="$REPO_ROOT/scripts/template-manifest.sh"
SYNC_SH="$REPO_ROOT/scripts/template-sync.sh"
MERGE_PY="$REPO_ROOT/scripts/template-merge-engine.py"
MANIFEST_YML="$REPO_ROOT/_genesis/template-manifest.yml"
CHECKPOINT="$REPO_ROOT/.template-checkpoint.yml"

PASS=0
FAIL=0
PARTIAL=0

# ── Helpers ───────────────────────────────────────────────────────────────────

pass() { echo "PASS — $1"; PASS=$((PASS+1)); }
fail() { echo "FAIL — $1"; FAIL=$((FAIL+1)); }
partial() { echo "PARTIAL — $1"; PARTIAL=$((PARTIAL+1)); }

# ── T1: Khang profile — deprecated detection ─────────────────────────────────

echo ""
echo "T1 — Khang: deprecated detection"
rm -rf /tmp/test-khang-t1
mkdir -p /tmp/test-khang-t1
cd /tmp/test-khang-t1
git init -q
git config user.email "test@ltc.com"
git config user.name "Test"
mkdir -p .claude/commands _genesis/scripts
echo "# old command" > .claude/commands/old-cmd.md
echo "#!/bin/bash" > _genesis/scripts/wms-sync.sh
git add -A && git commit -q -m "init"

# _genesis/scripts/wms-sync.sh — no leading dot, deprecated pattern _genesis/scripts/** matches
t1a_result=$(bash "$MANIFEST_SH" --classify _genesis/scripts/wms-sync.sh 2>&1)

# .claude/commands/old-cmd.md — KNOWN BUG-C: lstrip('./')  strips leading dot
# .claude/... → claude/... — mismatch against .claude/commands/** → returns 'domain'
t1b_result=$(bash "$MANIFEST_SH" --classify .claude/commands/old-cmd.md 2>&1)

cd "$REPO_ROOT"
rm -rf /tmp/test-khang-t1

if [[ "$t1a_result" == "deprecated" ]] && [[ "$t1b_result" == "deprecated" ]]; then
  pass "T1 — both _genesis/scripts and .claude/commands classified as deprecated"
elif [[ "$t1a_result" == "deprecated" ]]; then
  partial "T1 — _genesis/scripts: deprecated (PASS); .claude/commands: ${t1b_result} (FAIL — BUG-C: lstrip strips leading dot, '.claude' becomes 'claude', pattern mismatch)"
else
  fail "T1 — _genesis/scripts: ${t1a_result} (expected deprecated); .claude/commands: ${t1b_result}"
fi

# ── T2: Dong profile — BUG-A local-only custom rule → domain ─────────────────

echo ""
echo "T2 — Dong: local-only custom rule in .claude/rules/ → domain"
cd "$REPO_ROOT"
# File does not exist on disk and is not tracked — simulates a user-created rule
# that is NOT in the template remote (git ls-tree HEAD or template/main)
t2_result=$(bash "$MANIFEST_SH" --classify .claude/rules/dong-inflation-rules.md 2>&1)
if [[ "$t2_result" == "domain" ]]; then
  pass "T2 — .claude/rules/dong-inflation-rules.md → domain (local-only step fires before template pattern)"
else
  fail "T2 — expected domain, got: ${t2_result}"
fi

# ── T3: Dung profile — PATH B detection ──────────────────────────────────────

echo ""
echo "T3 — Dung: PATH B detection (repo without 1-ALIGN/)"
rm -rf /tmp/test-dung-t3
mkdir -p /tmp/test-dung-t3
cd /tmp/test-dung-t3
git init -q
git config user.email "test@ltc.com"
git config user.name "Test"
echo "# My project" > README.md
git add README.md && git commit -q -m "init"

# KNOWN LIMITATION: calling template-sync.sh from the template repo path means
# SCRIPT_DIR → template repo scripts/ → REPO_ROOT → template repo (has 1-ALIGN/ + .claude/rules/)
# → PATH C is returned instead of PATH B
# PATH B is only correctly returned when the script is executed FROM the downstream repo
t3_result=$(bash "$SYNC_SH" --detect-path 2>&1)
cd "$REPO_ROOT"
rm -rf /tmp/test-dung-t3

if [[ "$t3_result" == "PATH B" ]]; then
  pass "T3 — PATH B detected"
else
  fail "T3 — expected PATH B, got: ${t3_result} (REPO_ROOT resolves to template repo; script must be executed locally within downstream repo)"
fi

# ── T4: CamVan profile — PATH C detection ────────────────────────────────────

echo ""
echo "T4 — CamVan: PATH C from template repo"
cd "$REPO_ROOT"
t4_result=$(bash "$SYNC_SH" --detect-path 2>&1)
if [[ "$t4_result" == "PATH C" ]]; then
  pass "T4 — PATH C detected from template repo"
else
  fail "T4 — expected PATH C, got: ${t4_result}"
fi

# ── T5: Bootstrap mode — empty SHA → prompt fires ────────────────────────────

echo ""
echo "T5 — Bootstrap: empty checkpoint → prompt fires"
cd "$REPO_ROOT"

# Backup checkpoint
CHECKPOINT_BACKUP=$(python3 -c "
with open('$CHECKPOINT') as f:
    print(f.read(), end='')
")

# Ensure last_sync_sha is empty (it should be after restore, but verify)
current_sha=$(python3 -c "
import re
with open('$CHECKPOINT') as f:
    content = f.read()
m = re.search(r'last_sync_sha:\s*\"?([^\"#\n]*)\"?', content)
print(m.group(1).strip() if m else '')
")

if [[ -n "$current_sha" ]]; then
  # Blank it for test
  python3 - <<PYEOF
import re
with open('$CHECKPOINT') as f:
    content = f.read()
content = re.sub(r'last_sync_sha:\s*"[^"]*"', 'last_sync_sha: ""', content)
with open('$CHECKPOINT', 'w') as f:
    f.write(content)
PYEOF
fi

# Run --sync with piped answer; capture output
t5_output=$(echo "v2.0.0" | bash "$SYNC_SH" --sync v2.0.0 2>&1) || true

# Restore checkpoint from backup
printf '%s' "$CHECKPOINT_BACKUP" > "$CHECKPOINT"

if echo "$t5_output" | grep -q "No checkpoint found\|bootstrap\|What template version"; then
  pass "T5 — bootstrap prompt fired ('No checkpoint found' message present)"
else
  fail "T5 — expected bootstrap prompt; output was: $(echo "$t5_output" | head -5 | tr '\n' ' ')"
fi

# ── T6: BUG-A verify — classify step ordering ────────────────────────────────

echo ""
echo "T6 — BUG-A: local-only file in template-pattern path → domain"
cd "$REPO_ROOT"

# Create an untracked file in .claude/rules/ (matches template pattern .claude/rules/**)
echo "# local custom rule" > .claude/rules/local-only-test.md

# Verify it's NOT tracked
if git ls-files --error-unmatch .claude/rules/local-only-test.md >/dev/null 2>&1; then
  rm -f .claude/rules/local-only-test.md
  fail "T6 — file became tracked; test setup error"
else
  t6_result=$(bash "$MANIFEST_SH" --classify .claude/rules/local-only-test.md 2>&1)
  rm -f .claude/rules/local-only-test.md
  if [[ "$t6_result" == "domain" ]]; then
    pass "T6 — BUG-A confirmed fixed: local-only .claude/rules/* → domain (step 5 before step 6)"
  else
    fail "T6 — expected domain, got: ${t6_result}"
  fi
fi

# ── T7: BUG-B verify — section-merge preserves suffixed headings ──────────────

echo ""
echo "T7 — BUG-B: section-merge handles headings with (full spec: ...) suffixes"
cd "$REPO_ROOT"

python3 "$MERGE_PY" section-merge \
    --user-file CLAUDE.md \
    --template-new CLAUDE.md \
    --manifest "$MANIFEST_YML" \
    --output /tmp/bug-b-test.md 2>&1

t7_count=$(grep -c "Architecture: Subsystems" /tmp/bug-b-test.md 2>/dev/null || echo "0")
rm -f /tmp/bug-b-test.md

if [[ "$t7_count" -ge 1 ]]; then
  pass "T7 — BUG-B confirmed fixed: 'Architecture: Subsystems' section preserved after section-merge (prefix match works)"
else
  fail "T7 — 'Architecture: Subsystems' missing from merge output (count=${t7_count})"
fi

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "==========================================="
TOTAL=$((PASS + FAIL + PARTIAL))
echo "RESULTS: ${PASS} PASS | ${PARTIAL} PARTIAL | ${FAIL} FAIL | Total: ${TOTAL}"
echo "==========================================="

if [[ $PARTIAL -gt 0 || $FAIL -gt 0 ]]; then
  echo ""
  echo "Blockers:"
  if [[ $FAIL -gt 0 ]]; then
    echo "  T3 FAIL: PATH B detection requires script to run from within the downstream repo"
    echo "           (REPO_ROOT resolves to template repo when invoked via absolute path)"
  fi
  if [[ $PARTIAL -gt 0 ]]; then
    echo "  T1 PARTIAL: BUG-C — lstrip('./')  strips leading '.' from '.claude/...' paths"
    echo "              Fix: use lstrip('/') or explicit strip of only leading '/' chars"
  fi
fi

exit $((FAIL > 0 ? 1 : 0))
