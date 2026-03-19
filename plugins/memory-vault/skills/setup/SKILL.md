---
name: setup
description: First-run configuration for Memory Vault. Creates vault folder structure, installs QMD, configures collections, and writes config file. Run once after enabling the memory-vault plugin.
---

# /setup — Memory Vault First-Run Setup

**Trigger:** User says `/setup` or "set up memory vault" or first time using the plugin.

**Purpose:** Configure the Memory Vault on this machine in <5 minutes. Idempotent — safe to re-run.

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

### Step 4 — Write config file

```bash
mkdir -p ~/.config/memory-vault
echo "MEMORY_VAULT_PATH=\"$VAULT_PATH\"" > ~/.config/memory-vault/config.sh
```

### Step 5 — Configure QMD collections

Write `~/.config/qmd/index.yml`:
```yaml
collections:
  sessions:
    path: {VAULT_PATH}/07-Claude/sessions
    pattern: "**/*.md"
  conversations:
    path: {VAULT_PATH}/07-Claude/conversations
    pattern: "**/*.md"
  daily:
    path: {VAULT_PATH}/data/processed/daily
    pattern: "**/*.md"
  decisions:
    path: {VAULT_PATH}/decisions
    pattern: "**/*.md"
```

Replace `{VAULT_PATH}` with the actual resolved path.

### Step 6 — Index and embed

```bash
qmd update && qmd embed
```

If this is the first run, warn the user: "First-time embedding downloads ~300MB of models. This may take a few minutes."

### Step 7 — Verify

Run these checks:
1. `qmd collection list` → should show 4 collections
2. `qmd status` → should show hasVectorIndex: true
3. Confirm config file exists: `cat ~/.config/memory-vault/config.sh`

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

## Idempotency

- If vault folders already exist → skip creation, log "Found existing vault at {path}"
- If config file already exists → ask "Overwrite existing config? Current path: {existing_path}"
- If QMD collections already configured → skip, log "QMD already configured with {N} collections"
- If QMD index exists → run `qmd update && qmd embed` anyway (refreshes)

---

## Migration Detection

If the user has manual hooks in `~/.claude/settings.json` (legacy setup):
1. Detect by checking for hook commands containing `session-summary.sh`, `state-saver.sh`, `strategic-compact.sh`, or `session-reconstruct.sh` in `~/.claude/settings.json`
2. Warn: "Detected manual hook setup. The plugin provides these hooks automatically. Remove the manual entries from ~/.claude/settings.json to avoid double-firing."
3. List the specific hook entries to remove

If old skills exist in `~/.claude/skills/` (session-start, compress, resume, session-end):
1. Warn: "Found old skill files in ~/.claude/skills/. Plugin skills will shadow them. Remove old copies to avoid confusion."
