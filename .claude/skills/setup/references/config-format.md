---
version: "1.0"
status: draft
last_updated: 2026-04-05
---
# Config File Format Reference

## ~/.config/memory-vault/config.sh

Written by `/setup` Step 1. Read by `.claude/hooks/lib/config.sh` Priority 1.

```bash
export MEMORY_VAULT_PATH="/full/absolute/path/to/vault"
```

**Rules:**
- Must be a shell script (sourced by bash)
- MEMORY_VAULT_PATH must be an absolute path (no `~` expansion)
- Path must point to an existing directory
- No trailing slash

**Example (Google Drive):**
```bash
export MEMORY_VAULT_PATH="/Users/long/Library/CloudStorage/GoogleDrive-long@ltcapital.partners (18-3-26 11:52)/My Drive/Long-Memory-Vault"
```

**Example (local):**
```bash
export MEMORY_VAULT_PATH="/Users/long/Long-Memory-Vault"
```

## Priority Chain (config.sh lib)

```
P1: ~/.config/memory-vault/config.sh   ← written by /setup (fastest, explicit)
P2: $MEMORY_VAULT_PATH env var          ← set in shell profile
P3: scan ~/Library/CloudStorage/... + ~/Long-Memory-Vault  ← fallback scan
P4: not found → hook exits 0 silently (graceful degradation)
```

Run `/setup` to ensure P1 is set — hooks run faster and are more reliable.
