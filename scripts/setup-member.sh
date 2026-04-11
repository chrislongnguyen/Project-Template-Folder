#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-03
# setup-member.sh — One-time LTC Memory Vault setup for new project members
#
# What this does:
#   1. Enables AutoDream in your global Claude Code settings
#   2. Wires the memory-guard hook (blocks malformed MEMORY.md writes)
#   3. Creates your project memory vault at ~/.claude/projects/{hash}/memory/
#   4. Seeds it with MEMORY.md + 3 starter topic files
#
# Run once after cloning this repo. Safe to re-run (idempotent).
# Usage: ./scripts/setup-member.sh [--name "Your Name"] [--role "Your Role"]

set -euo pipefail

# ── Arguments ──────────────────────────────────────────────────────────────────
MEMBER_NAME=""
MEMBER_ROLE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) MEMBER_NAME="$2"; shift 2 ;;
    --role) MEMBER_ROLE="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

[[ -z "$MEMBER_NAME" ]] && read -r -p "Your name: " MEMBER_NAME
[[ -z "$MEMBER_ROLE" ]] && read -r -p "Your role (e.g. 'LTC Partners, COE OPS'): " MEMBER_ROLE

TODAY=$(date +%Y-%m-%d)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_NAME="$(basename "$REPO_ROOT")"

# ── Derive memory vault path ────────────────────────────────────────────────────
# Claude Code hashes the project path by replacing / with - (dropping leading /)
HASH=$(echo "$REPO_ROOT" | sed 's|^/||; s|/|-|g')
MEMORY_DIR="$HOME/.claude/projects/$HASH/memory"

echo ""
echo "LTC Memory Vault Setup"
echo "======================"
echo "Member:   $MEMBER_NAME ($MEMBER_ROLE)"
echo "Project:  $PROJECT_NAME"
echo "Vault:    $MEMORY_DIR"
echo ""

# ── Step 1: Enable AutoDream + wire memory-guard in global settings ────────────
GLOBAL_SETTINGS="$HOME/.claude/settings.json"

if [[ ! -f "$GLOBAL_SETTINGS" ]]; then
  echo '{}' > "$GLOBAL_SETTINGS"
  echo "Created $GLOBAL_SETTINGS"
fi

# Use python3 to safely merge JSON (handles existing keys)
python3 - "$GLOBAL_SETTINGS" "$REPO_ROOT/scripts/memory-guard.sh" <<'PYEOF'
import json, sys, os

settings_path = sys.argv[1]
guard_script = sys.argv[2]

with open(settings_path) as f:
    s = json.load(f)

# Enable AutoDream
s["autoMemoryEnabled"] = True
s.pop("autoDreamEnabled", None)  # remove legacy no-op flag

# Wire memory-guard hook into PreToolUse
hooks = s.setdefault("hooks", {})
pre = hooks.setdefault("PreToolUse", [])

guard_entry = {
    "matcher": "Write",
    "hooks": [{
        "type": "command",
        "command": f"bash {guard_script}",
        "timeout": 5
    }]
}

# Check if already wired (avoid duplicates)
already_wired = any(
    any(h.get("command", "").endswith("memory-guard.sh") for h in entry.get("hooks", []))
    for entry in pre
)

if not already_wired:
    pre.append(guard_entry)
    print("  + memory-guard hook wired")
else:
    print("  ✓ memory-guard hook already wired")

with open(settings_path, "w") as f:
    json.dump(s, f, indent=2)

print("  ✓ autoMemoryEnabled = true")
PYEOF

echo "Step 1 done: global settings updated"

# ── Step 2: Create memory vault ────────────────────────────────────────────────
mkdir -p "$MEMORY_DIR"
echo "Step 2 done: vault created at $MEMORY_DIR"

# ── Step 3: Seed MEMORY.md ─────────────────────────────────────────────────────
SEED_MEMORY="$REPO_ROOT/_genesis/templates/MEMORY-seed.md"
TARGET_MEMORY="$MEMORY_DIR/MEMORY.md"

if [[ -f "$TARGET_MEMORY" ]]; then
  echo "Step 3 skip: MEMORY.md already exists (not overwriting)"
else
  sed \
    -e "s/{PROJECT_NAME}/$PROJECT_NAME/g" \
    -e "s/{MEMBER_NAME}/$MEMBER_NAME/g" \
    -e "s|{ORG_ROLE}|$MEMBER_ROLE|g" \
    -e "s/{TITLE}/Member/g" \
    -e "s|{PROJECT_DESCRIPTION}|$(basename "$REPO_ROOT") — LTC project clone|g" \
    -e "s|{EXPECTED_OUTCOME}|See 1-ALIGN/1-PD/ for EO|g" \
    -e "s/{DATE}/$TODAY/g" \
    "$SEED_MEMORY" > "$TARGET_MEMORY"
  echo "Step 3 done: MEMORY.md seeded"
fi

# ── Step 4: Seed topic files ───────────────────────────────────────────────────
SEED_DIR="$REPO_ROOT/_genesis/templates/memory-seeds"
SEEDED=0

for seed_file in "$SEED_DIR"/*.md; do
  fname="$(basename "$seed_file")"
  target="$MEMORY_DIR/$fname"
  if [[ -f "$target" ]]; then
    echo "  skip: $fname already exists"
  else
    # Substitute placeholders in seed files (same vars as MEMORY-seed.md)
    sed \
      -e "s/{MEMBER_NAME}/$MEMBER_NAME/g" \
      -e "s|{ORG_ROLE}|$MEMBER_ROLE|g" \
      "$seed_file" > "$target"
    echo "  + $fname"
    SEEDED=$((SEEDED + 1))
  fi
done

echo "Step 4 done: $SEEDED topic file(s) seeded"

# ── Summary ────────────────────────────────────────────────────────────────────
echo ""
echo "Setup complete."
echo ""
echo "What's now active:"
echo "  AutoDream   — fires every ~24h + 5 sessions, distills memory automatically"
echo "  Memory Vault — $MEMORY_DIR"
echo "  Guard hook  — blocks malformed MEMORY.md writes"
echo ""
echo "Next: open Claude Code in this project and run /resume to load your vault."
