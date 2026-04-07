# Vault Access Fallback Chain

When the primary access method fails, follow this chain:

1. **qmd query** (preferred) — `qmd query -c sessions "{repo-name}" -n 3`
2. **obsidian recents** — `obsidian recents --limit 20 2>/dev/null | grep -v FATAL`
3. **Direct filesystem** — `ls -t "$MEMORY_VAULT_PATH/07-Claude/sessions/" | head -20`
   - Resolve path: `source ~/.config/memory-vault/config.sh`
   - IMPORTANT: Use absolute paths, never tilde in double quotes (zsh won't expand it)
4. **No access** — Output "No prior sessions found" and proceed without vault context

## Path Resolution Gotcha

`~/Library/...` will NOT expand inside double quotes in zsh. Always use:
- `"$HOME/Library/..."` or
- `/Users/{username}/Library/...`
