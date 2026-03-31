#!/usr/bin/env bash
# version: 1.0 | last_updated: 2026-03-29
# config.sh — vault path resolution for memory-vault plugin
# Source this file in every hook script:
#   source "${CLAUDE_PLUGIN_ROOT}/hooks/lib/config.sh"
# After sourcing, $VAULT is set or the script has exited.

resolve_vault() {
  # Priority 1: config file (user-controlled, written by /setup)
  if [[ -f "$HOME/.config/memory-vault/config.sh" ]]; then
    source "$HOME/.config/memory-vault/config.sh"
  fi

  # Priority 2: env var (may have been set by config file or shell profile)
  if [[ -n "${MEMORY_VAULT_PATH:-}" && -d "$MEMORY_VAULT_PATH" ]]; then
    VAULT="$MEMORY_VAULT_PATH"
    return 0
  fi

  # Priority 3: scan candidates
  for candidate in \
    "$HOME"/Library/CloudStorage/GoogleDrive-*/My\ Drive/Long-Memory-Vault \
    "$HOME/Long-Memory-Vault"; do
    if [[ -d "$candidate" ]]; then
      VAULT="$candidate"
      return 0
    fi
  done

  # Priority 4: not found — graceful exit
  VAULT=""
  return 1
}

resolve_vault || exit 0
