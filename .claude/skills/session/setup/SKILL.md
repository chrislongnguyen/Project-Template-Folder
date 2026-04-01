---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
name: setup
description: First-run configuration for Memory Vault. Creates vault folder structure, installs QMD, configures collections, and writes config file. Run once after enabling the memory-vault plugin.
---
# /setup — Memory Vault First-Run Setup

**Trigger:** User says `/setup` or "set up memory vault" or first time using the plugin.

**Purpose:** Configure the Memory Vault on this machine in <5 minutes. Idempotent — safe to re-run.

<HARD-GATE>
1. Do NOT overwrite existing config file (`~/.config/memory-vault/config.sh`) without asking the user first.
2. Do NOT skip QMD installation check — if QMD is missing, prompt the user before installing.
3. Do NOT run `qmd embed` without warning about first-time download size (~300MB).
</HARD-GATE>

---

## Steps

### Step 1 — Check prerequisites

Verify these are available (use Bash tool):
- `node --version` → must be v18+
- `git --version` → must be installed
- `claude --version` → must be installed

If `qmd` is not installed:
- Prompt: "QMD is not installed. Install it now with `npm install -g @tobilu/qmd`?"
- On yes → run the install command
- On no → warn that search/recall won't work without QMD, but hooks will still save files

### Step 2 — Determine vault path

1. Scan for Google Drive candidates:
   ```bash
   ls -d "$HOME"/Library/CloudStorage/GoogleDrive-*/My\ Drive/ 2>/dev/null
   ```
2. If found, ask user: "Found Google Drive at {path}. Create Memory Vault here? (Y/n)"
   - If yes → `VAULT_PATH="{path}/Long-Memory-Vault"`
3. If not found or user says no, ask for a custom path
   - Offer default: `$HOME/Long-Memory-Vault`

### Step 3 — Create folder structure

```bash
mkdir -p "$VAULT_PATH/07-Claude/sessions"
mkdir -p "$VAULT_PATH/07-Claude/conversations"
mkdir -p "$VAULT_PATH/07-Claude/state"
mkdir -p "$VAULT_PATH/data/processed/daily"
mkdir -p "$VAULT_PATH/decisions"
```

GATE: Verify all 5 vault directories exist (`07-Claude/sessions`, `07-Claude/conversations`, `07-Claude/state`, `data/processed/daily`, `decisions`). If any missing, stop.

### Step 4 — Write config file

```bash
mkdir -p ~/.config/memory-vault
echo "MEMORY_VAULT_PATH=\"$VAULT_PATH\"" > ~/.config/memory-vault/config.sh
```

GATE: Verify `~/.config/memory-vault/config.sh` exists and contains a valid `MEMORY_VAULT_PATH`. If missing or malformed, stop.

### Step 5 — Configure QMD collections

Write QMD config from [templates/qmd-config.yml](templates/qmd-config.yml), replacing `${VAULT_PATH}` with the resolved path. Write the result to `~/.config/qmd/index.yml`.

### Step 6 — Index and embed

```bash
qmd update && qmd embed
```

If this is the first run, warn the user: "First-time embedding downloads ~300MB of models. This may take a few minutes."

### Step 7 — Verify

HARD-GATE: ALL 3 checks below must be TRUE. If ANY is FALSE, stop and report to user. No partial pass.

1. `qmd collection list` → must show exactly 4 collections. TRUE/FALSE.
2. `qmd status` → must show `hasVectorIndex: true`. TRUE/FALSE.
3. `cat ~/.config/memory-vault/config.sh` → must exist and contain `MEMORY_VAULT_PATH`. TRUE/FALSE.

Output results:
```
Memory Vault setup complete!

  Vault: {VAULT_PATH}
  Collections: sessions, conversations, daily, decisions
  Config: ~/.config/memory-vault/config.sh

  Next: Start a new Claude Code session. Hooks will auto-fire.
  Try: /session-start to verify recall works.
```

---

## Gotchas

1. **Google Drive sync lag** — After creating vault folders on Google Drive, the cloud sync may take 30-60 seconds. Do not run `qmd update` immediately if the vault path is on Google Drive. Wait for sync or verify folders are visible in Finder first.
2. **QMD version mismatch** — If `qmd` is installed but `qmd embed` fails, check the version. Versions below 0.5 do not support the `embed` command. Upgrade with `npm install -g @tobilu/qmd@latest`.

---

## Idempotency

- If vault folders already exist → skip creation, log "Found existing vault at {path}"
- If config file already exists → ask "Overwrite existing config? Current path: {existing_path}"
- If QMD collections already configured → skip, log "QMD already configured with {N} collections"
- If QMD index exists → run `qmd update && qmd embed` anyway (refreshes)

---

## Migration Detection

> Load references/migration-detection.md when an existing vault is detected

---

## Post-Setup Verification

**GATE — Verify:** After Step 7, confirm: (1) vault directories exist via `ls`, (2) config file contains a valid non-empty MEMORY_VAULT_PATH, (3) `qmd collection list` returns 4 collections. If any check fails, report which specific check failed and the remediation step.

If `qmd update && qmd embed` fails (npm error, model download timeout, permission denied): Do NOT mark setup as complete. Report the error. The vault directories and config are still valid — note that search/recall won't work until embedding succeeds, but file-based operations (compress, session logging) will still function.

## Gotchas

- **Overwriting existing config** — always check if `~/.config/memory-vault/config.sh` exists and ask before overwriting.
- **Google Drive not mounted** — verify the vault path actually exists on disk before writing config. Stale symlinks are common after Drive desktop restarts.
- **First-time QMD embed** — warn about ~300MB download. Don't let the user think the session is frozen.
- **Google Drive sync lag** — After creating vault folders on Google Drive, cloud sync may take 30-60 seconds. Do not run `qmd update` immediately.
- **QMD version mismatch** — If `qmd embed` fails, check the version. Versions below 0.5 do not support `embed`. Upgrade with `npm install -g @tobilu/qmd@latest`.
- **LT-1 Path fabrication** — Agent assumes a Google Drive path exists based on common patterns without running the `ls` check. Always run discovery in Step 2 and use only actual output. If no Google Drive is found, do NOT guess — ask the user.

## Links

- [[CLAUDE]]
- [[gotchas]]
- [[migration-detection]]
