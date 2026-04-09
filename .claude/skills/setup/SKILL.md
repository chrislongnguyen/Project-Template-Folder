---
name: setup
version: "1.0"
status: draft
last_updated: 2026-04-05
description: "Configure the LTC memory-vault harness on a fresh clone. Writes vault config, scaffolds vault folders, checks QMD, runs smoke test. Use when onboarding to a new machine or after cloning the project template."
trigger: "/setup | set up my vault | configure memory vault | configure my vault | onboard"
---

# /setup — LTC Harness Onboarding

**Trigger:** User says `/setup`, "set up my vault", "configure memory vault", or "onboard".

**Purpose:** Guide a new LTC member from fresh clone to a working memory-vault harness in 4 steps.
Safe to run twice — all steps are idempotent.

---

## Pre-Flight

### Migration Check (run first, once)

Check for the old `4-EXECUTE/scripts/setup-vault.sh` path — it moved to `scripts/` in Iteration 2:

```bash
# 1. Remove stale copy if it somehow still exists
if [ -f "4-EXECUTE/scripts/setup-vault.sh" ]; then
  echo "⚠ Found stale 4-EXECUTE/scripts/setup-vault.sh — removing (moved to scripts/)"
  rm 4-EXECUTE/scripts/setup-vault.sh
fi

# 2. Scan for references to the old path in common locations
grep -r "4-EXECUTE/scripts/setup-vault" . \
  --include="*.sh" --include="*.md" --include="*.json" \
  -l 2>/dev/null | grep -v ".git"
```

If files reference the old path: show them and offer to sed-replace in-place.
If nothing found: skip silently.

### Project Root Check

Confirm you are in the project root:

```bash
git rev-parse --show-toplevel   # should return the project directory
```

If not in the project root, stop and ask the user to navigate there first.

---

## Step 1 — Vault Path Configuration

Ask the user (use AskUserQuestion if available, otherwise ask directly):

> "Where is your memory vault directory? Enter the full path, or press Enter to auto-detect."

**If path provided:**
```bash
mkdir -p ~/.config/memory-vault/
cat > ~/.config/memory-vault/config.sh << EOF
export MEMORY_VAULT_PATH="${USER_PATH}"
EOF
echo "Config written: ~/.config/memory-vault/config.sh → MEMORY_VAULT_PATH=${USER_PATH}"
```

**If blank (auto-detect):** scan these candidates in order:
```bash
# Candidates (in order)
"$HOME"/Library/CloudStorage/GoogleDrive-*/My\ Drive/*-Memory-Vault
"$HOME"/*-Memory-Vault
```
- If found: confirm with user → write config as above
- If not found: create default and write config:
  ```bash
  mkdir -p "$HOME/Long-Memory-Vault"
  mkdir -p ~/.config/memory-vault/
  cat > ~/.config/memory-vault/config.sh << EOF
  export MEMORY_VAULT_PATH="${HOME}/Long-Memory-Vault"
  EOF
  echo "Created default vault: ~/Long-Memory-Vault"
  ```

**Verify Step 1:**
```bash
cat ~/.config/memory-vault/config.sh   # confirm MEMORY_VAULT_PATH is written
```

---

## Step 2 — Vault Folder Scaffold

Run the setup script with the configured vault path:

```bash
VAULT_PATH=$(grep -oE 'MEMORY_VAULT_PATH=[^[:space:]]+' ~/.config/memory-vault/config.sh \
  | head -1 | sed 's/MEMORY_VAULT_PATH=//' | tr -d '"')

./scripts/setup-vault.sh "$VAULT_PATH"
```

**Two expected outcomes:**
- **Existing vault** (user already has an Obsidian vault): `✓ Vault already has content — skipping scaffold`. Hooks auto-create `07-Claude/` on first run. Continue to Step 3.
- **Empty/new vault**: `✓ Vault folder structure created successfully`. Continue to Step 3.

If the script exits non-zero: report the error — do NOT continue to Step 3.

---

## Step 3 — QMD Index (skip if not installed)

Check whether QMD is available:

```bash
which qmd 2>/dev/null && echo "found" || echo "not found"
```

**If found:** Instruct the user to index the vault:
```
QMD found. To enable semantic search over your vault, run:
  qmd index "$VAULT_PATH"
This indexes all markdown files for the mcp__qmd__query tool.
```

**If not found:**
```
QMD not found — skipping. Install from the LTC Extension Registry if you
want semantic search (mcp__qmd__query) over your vault content.
```

---

## Step 4 — Smoke Test

Run the harness health check:

```bash
./scripts/smoke-test.sh
```

Parse and report the results. Show the full output, then summarize:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 /setup complete — harness health report:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 S1 Config file    [PASS/FAIL]
 S2 Vault resolves [PASS/FAIL]
 S3 Vault folders  [PASS/FAIL]
 S4 Scripts ready  [PASS/FAIL]
 S5 Hooks wired    [PASS/FAIL]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

If any check fails: show the fix hint from smoke-test.sh output and offer to fix it.
If all pass: confirm harness is ready.

---

## Idempotency

Running `/setup` twice is safe:
- Config write overwrites with the same value
- `setup-vault.sh` uses `mkdir -p` — no duplicates
- QMD index is additive
- Smoke test is read-only

---

## Error Handling

| Scenario | Action |
|---|---|
| Not in project root | Stop — ask user to navigate to project root first |
| setup-vault.sh exits non-zero | Stop at Step 2 — report error, do not continue |
| Vault path contains spaces | Wrap in quotes in all bash commands (Google Drive paths often have spaces) |
| Permission denied on config write | Suggest: `mkdir -p ~/.config/memory-vault/` with explicit user permission |

---

## Gotchas

- **Vault path with spaces** — Google Drive paths contain spaces. Always quote: `"$VAULT_PATH"` in every bash command. Missing quotes = silent failure.
- **Running setup-vault.sh on wrong vault** — Step 2 creates LTC folders only if vault is empty. If you accidentally point it at a non-empty directory, it exits safely with no changes. Still, confirm the vault path before running.
- **S1 fails but S2 passes** — config.sh doesn't exist but vault was auto-detected via Priority 3 scan. Step 1 did not complete — go back and write the config file so hooks can find the vault on next session start.
- **QMD index step skipped then forgotten** — if QMD was not installed at /setup time, remind user to index when they install it. Semantic search is silently degraded until indexed.

Full gotchas: [gotchas.md](gotchas.md)

## Verify

After each step, confirm before proceeding:

| Step | Gate | Check command |
|---|---|---|
| Step 1 | Config file written | `cat ~/.config/memory-vault/config.sh` → MEMORY_VAULT_PATH set |
| Step 2 | Vault ready | `ls "$VAULT_PATH"` → has at least one folder (any structure accepted) |
| Step 4 | Smoke test 5/5 | `./scripts/smoke-test.sh` → exit 0 |

If any gate fails, fix before proceeding to the next step.

---

## Links

- [[gotchas]]
- [[project]]
