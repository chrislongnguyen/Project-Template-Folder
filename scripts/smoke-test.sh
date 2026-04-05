#!/usr/bin/env bash
# version: 1.0 | status: Draft | last_updated: 2026-04-05
# smoke-test.sh — LTC harness health check (5 checks)
#
# PURPOSE: Verify the memory-vault hook system is correctly configured on this machine.
# Run after /setup, or anytime to verify harness health.
#
# USAGE:
#   ./scripts/smoke-test.sh
#
# EXIT CODES:
#   0 — All 5 checks pass
#   1 — One or more checks failed (see output for fix hints)
#
# CHECKS:
#   S1 — ~/.config/memory-vault/config.sh exists
#   S2 — MEMORY_VAULT_PATH resolves to an existing directory
#   S3 — inbox/ and AI-AGENT-MEMORY/ present in vault
#   S4 — pre-commit scripts present, executable, and valid syntax
#   S5 — settings.json has PostToolUse + SubagentStop + SessionStart hooks

set -euo pipefail

# ── Resolve project root ──────────────────────────────────────────────────────
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [[ -z "$PROJECT_ROOT" ]]; then
  echo "✗ ABORT — not inside a git repository. Run from project root." >&2
  exit 1
fi

PASS=0
FAIL=0

# ── Helper ────────────────────────────────────────────────────────────────────
result() {
  local id="$1" desc="$2" hint="$3" status="$4"
  if [[ "$status" == "pass" ]]; then
    printf "✓ PASS — S%s: %s\n" "$id" "$desc"
    PASS=$((PASS + 1))
  else
    printf "✗ FAIL — S%s: %s\n" "$id" "$desc"
    printf "         Fix: %s\n" "$hint"
    FAIL=$((FAIL + 1))
  fi
}

# ── S1: Config file exists ────────────────────────────────────────────────────
CONFIG_FILE="$HOME/.config/memory-vault/config.sh"
if [[ -f "$CONFIG_FILE" ]]; then
  result 1 "Config file exists (~/.config/memory-vault/config.sh)" "" "pass"
else
  result 1 "Config file exists (~/.config/memory-vault/config.sh)" \
    "Run /setup step 1 to configure your vault path" "fail"
fi

# ── S2: Vault path resolves ───────────────────────────────────────────────────
# Parse MEMORY_VAULT_PATH safely from config file (no eval/source)
VAULT=""
if [[ -f "$CONFIG_FILE" ]]; then
  RAW_PATH=$(grep -oE 'MEMORY_VAULT_PATH=[^[:space:]]+' "$CONFIG_FILE" 2>/dev/null \
    | head -1 | sed 's/MEMORY_VAULT_PATH=//' | tr -d '"' || true)
  if [[ -n "$RAW_PATH" && -d "$RAW_PATH" ]]; then
    VAULT="$RAW_PATH"
  fi
fi

# Fallback: scan known candidate locations (mirrors config.sh Priority 3)
if [[ -z "$VAULT" ]]; then
  for candidate in \
    "$HOME"/Library/CloudStorage/GoogleDrive-*/My\ Drive/Long-Memory-Vault \
    "$HOME/Long-Memory-Vault"; do
    if [[ -d "$candidate" ]]; then
      VAULT="$candidate"
      break
    fi
  done
fi

if [[ -n "$VAULT" ]]; then
  result 2 "Vault path resolves (${VAULT})" "" "pass"
else
  result 2 "Vault path resolves to existing directory" \
    "Check MEMORY_VAULT_PATH in ~/.config/memory-vault/config.sh — ensure the directory exists" "fail"
fi

# ── S3: Vault folders exist ───────────────────────────────────────────────────
if [[ -n "$VAULT" && -d "${VAULT}/inbox" && -d "${VAULT}/AI-AGENT-MEMORY" ]]; then
  result 3 "Vault folders present (inbox/, AI-AGENT-MEMORY/)" "" "pass"
else
  result 3 "Vault folders present (inbox/, AI-AGENT-MEMORY/)" \
    "Run: ./scripts/setup-vault.sh ${VAULT:-<vault-path>}" "fail"
fi

# ── S4: Pre-commit scripts present, executable, valid syntax ──────────────────
S4_OK=true
S4_MISSING=""
for script in \
  "$PROJECT_ROOT/scripts/status-guard.sh" \
  "$PROJECT_ROOT/scripts/link-validator.sh"; do
  if [[ ! -f "$script" ]]; then
    S4_OK=false
    S4_MISSING="$script not found"
    break
  fi
  if [[ ! -x "$script" ]]; then
    S4_OK=false
    S4_MISSING="$script not executable"
    break
  fi
  if ! bash -n "$script" 2>/dev/null; then
    S4_OK=false
    S4_MISSING="$script has syntax errors"
    break
  fi
done

if [[ "$S4_OK" == "true" ]]; then
  result 4 "Pre-commit scripts present, executable, valid syntax" "" "pass"
else
  result 4 "Pre-commit scripts present, executable, valid syntax" \
    "Pull latest: git pull origin I2/feat/obsidian-bases (${S4_MISSING})" "fail"
fi

# ── S5: settings.json hook events wired ──────────────────────────────────────
SETTINGS="$PROJECT_ROOT/.claude/settings.json"
if [[ -f "$SETTINGS" ]] \
  && grep -q '"PostToolUse"' "$SETTINGS" \
  && grep -q '"SubagentStop"' "$SETTINGS" \
  && grep -q '"SessionStart"' "$SETTINGS"; then
  result 5 "settings.json has PostToolUse + SubagentStop + SessionStart" "" "pass"
else
  result 5 "settings.json has PostToolUse + SubagentStop + SessionStart" \
    "Pull latest: git pull origin I2/feat/obsidian-bases" "fail"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf " Smoke Test: %d/5 PASS | %d/5 FAIL\n" "$PASS" "$FAIL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

[[ $FAIL -eq 0 ]]
