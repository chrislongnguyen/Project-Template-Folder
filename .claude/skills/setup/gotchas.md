---
version: "1.0"
status: Draft
last_updated: 2026-04-05
---
# /setup Gotchas

## G1 — Vault path with spaces (Google Drive)

Google Drive paths on macOS contain spaces and special characters:
```
~/Library/CloudStorage/GoogleDrive-user@domain.com (date)/My Drive/Vault
```

Always wrap `$VAULT_PATH` in double quotes in every bash command. A missing quote
causes the path to be split at the space — `mkdir -p` silently creates wrong directories.

**Fix:** `"$VAULT_PATH"` — never bare `$VAULT_PATH`.

## G2 — setup-vault.sh creates Obsidian vault structure

`4-EXECUTE/scripts/setup-vault.sh` creates 17 Obsidian PM folders (1-ALIGN/, DAILY-NOTES/,
PEOPLE/, etc.) including inbox/ and AI-AGENT-MEMORY/. Running it on an existing vault is safe (idempotent), but confirm you are running on the INTENDED vault path.

**Fix:** Before Step 2, read back the config: `cat ~/.config/memory-vault/config.sh`.
Confirm MEMORY_VAULT_PATH is the correct vault before running setup-vault.sh.

## G3 — S1 fails but S2 passes — hooks are broken

If the smoke test shows:
```
✗ FAIL — S1: Config file exists
✓ PASS — S2: Vault path resolves
```

This means config.sh doesn't exist, but the vault was found via the Priority 3 path scan.
Hooks use Priority 1 (config.sh) first. Without config.sh, hooks will re-scan on every
session start — which is slower and breaks if the Google Drive path changes.

**Fix:** Complete Step 1 — write the config file.

## G4 — QMD index must be re-run after vault content changes

The QMD index is a snapshot. If you add new files to the vault (daily notes, session
summaries), QMD won't find them until the next index run. The hooks write to the vault
continuously — QMD needs periodic re-indexing.

**Fix:** Run `qmd index <VAULT_PATH>` periodically (or automate via cron).
