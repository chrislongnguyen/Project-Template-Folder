# Design Spec: memory-vault Plugin

**Date:** 2026-03-18
**Status:** Approved
**Task:** OPS_OE.247 (revised) + OPS_OE.272
**Deliverable:** OPS_PROCESS_OE.243. DEL-5.MV · Memory Vault Product

---

## 1. Purpose

Package the LTC Memory Vault as a Claude Code plugin that provides cross-session memory. One-command install replaces the current 20-minute manual setup (copy scripts, edit settings.json, configure MCP, write index.yml).

**VANA:** LTC members install and operate confidently a cross-session memory system that is content-rich, fast-recalling, and zero-config after setup.

## 2. Scope

### In scope
- 4 hook scripts (session-reconstruct, session-summary, state-saver, strategic-compact)
- 5 skills (session-start, compress, resume, session-end, setup)
- Shared vault path resolution library (config.sh)
- README.md (A-Z install & reference guide)
- hooks.json (auto-wired hook definitions)
- plugin.json (manifest)
- marketplace.json (plugin discovery)

### Out of scope
- QMD binary (external dependency — installed via npm)
- Conversation export from non-Claude-Code tools (Cursor, Gemini web, Claude web)
- Public marketplace publishing (LTC-only distribution)
- Build-metrics hook (learn-build-cycle specific, not core Memory Vault)

## 3. AMT Mapping

- **Primary:** Session 5 — Environment (#4 in 7-Component System)
- **Framing:** Environment infrastructure for context persistence
- **Not:** cross-cutting product across multiple components

## 4. Distribution

The plugin lives in a `plugins/memory-vault/` subdirectory inside `OPS_OE.6.4.LTC-PROJECT-TEMPLATE`. The repo root contains a `.claude-plugin/marketplace.json` that registers it. This keeps plugin files separate from the template's own rules, docs, and src.

Members install by adding the repo as a local marketplace source:

```json
{
  "extraKnownMarketplaces": {
    "ltc-plugins": {
      "source": "directory",
      "path": "/path/to/OPS_OE.6.4.LTC-PROJECT-TEMPLATE"
    }
  }
}
```

Or via GitHub (private repo):

```json
{
  "extraKnownMarketplaces": {
    "ltc-plugins": {
      "source": "github",
      "repo": "Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE"
    }
  }
}
```

Then enable: `memory-vault@ltc-plugins`

### marketplace.json (repo root)

File: `.claude-plugin/marketplace.json`

```json
{
  "$schema": "https://anthropic.com/claude-code/marketplace.schema.json",
  "name": "ltc-plugins",
  "owner": {
    "name": "Long Nguyen",
    "email": "longnguyen@ltcpartners.com"
  },
  "plugins": [
    {
      "name": "memory-vault",
      "source": "./plugins/memory-vault",
      "description": "Cross-session memory for Claude Code",
      "version": "1.0.0"
    }
  ]
}
```

## 5. File Structure

```
OPS_OE.6.4.LTC-PROJECT-TEMPLATE/          # repo root
├── .claude-plugin/
│   └── marketplace.json                   # registers memory-vault for discovery
├── plugins/
│   └── memory-vault/                      # plugin root
│       ├── .claude-plugin/
│       │   └── plugin.json                # manifest: name, description, author
│       ├── hooks/
│       │   ├── hooks.json                 # auto-wired hook definitions
│       │   ├── session-reconstruct.sh     # SessionStart → injects git state
│       │   ├── session-summary.sh         # Stop → writes session log, refreshes qmd
│       │   ├── state-saver.sh             # PostToolUse (Write|Edit|MultiEdit)
│       │   ├── strategic-compact.sh       # PreToolUse → counts calls, nudges save
│       │   └── lib/
│       │       └── config.sh              # vault path resolution (shared)
│       ├── skills/
│       │   ├── session-start/SKILL.md     # brief recall ≤10 lines
│       │   ├── compress/SKILL.md          # save session context to vault
│       │   ├── resume/SKILL.md            # load previous session context
│       │   ├── session-end/SKILL.md       # WMS sync, git commit, vault save
│       │   └── setup/SKILL.md             # first-run: create vault, configure qmd
│       └── README.md                      # A-Z install & reference guide
├── rules/                                 # template's own rules (unchanged)
├── docs/                                  # template's own docs (unchanged)
└── CLAUDE.md                              # template config (unchanged)
```

## 6. Vault Path Resolution

All hook scripts source `${CLAUDE_PLUGIN_ROOT}/hooks/lib/config.sh` which resolves the vault path through a priority chain:

```
Priority 1: Source ~/.config/memory-vault/config.sh
            (written by /setup — contains MEMORY_VAULT_PATH=...)

Priority 2: Check $MEMORY_VAULT_PATH environment variable
            (allows override via shell profile)

Priority 3: Scan candidate directories:
            - $HOME/Library/CloudStorage/GoogleDrive-*/My Drive/Long-Memory-Vault
            - $HOME/Long-Memory-Vault

Priority 4: If none found → exit 0 silently (graceful degradation)
```

### config.sh implementation

```bash
#!/usr/bin/env bash
# config.sh — vault path resolution for memory-vault plugin
# Source this file in every hook script:
#   source "${CLAUDE_PLUGIN_ROOT}/hooks/lib/config.sh"
# After sourcing, $VAULT is set or the script has exited.

resolve_vault() {
  # Priority 1: config file (user-controlled, written by /setup)
  # Trust boundary: this file is on the user's own machine, created by the
  # setup skill. It contains only MEMORY_VAULT_PATH="...".
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
```

## 7. hooks.json

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"${CLAUDE_PLUGIN_ROOT}/hooks/session-reconstruct.sh\"",
            "timeout": 5
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"${CLAUDE_PLUGIN_ROOT}/hooks/strategic-compact.sh\"",
            "timeout": 5
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"${CLAUDE_PLUGIN_ROOT}/hooks/state-saver.sh\"",
            "timeout": 15
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash \"${CLAUDE_PLUGIN_ROOT}/hooks/session-summary.sh\"",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

Note: `matcher` omitted where all events match (equivalent to `".*"`). Only PostToolUse uses an explicit matcher to scope to file-write tools. No top-level `description` field — plugin metadata belongs in plugin.json.

## 8. plugin.json

```json
{
  "name": "memory-vault",
  "description": "Cross-session memory for Claude Code — auto-exports sessions, indexes with QMD, recalls context at startup",
  "author": {
    "name": "Long Nguyen",
    "email": "longnguyen@ltcpartners.com"
  }
}
```

## 9. /setup Flow

The `/setup` command is a skill that runs on first install. It:

1. **Check prerequisites**
   - Verify `node` (v18+), `git`, `claude` are available
   - Check if `qmd` is installed; if not, prompt `npm install -g @tobilu/qmd`

2. **Determine vault path**
   - Scan Google Drive candidates first
   - If found, confirm with user: "Found Google Drive at {path}. Use this?"
   - If not found, ask user for path
   - Offer default: `$HOME/Long-Memory-Vault`

3. **Create folder structure**
   ```
   $VAULT/07-Claude/sessions/
   $VAULT/07-Claude/conversations/
   $VAULT/07-Claude/state/
   $VAULT/data/processed/daily/
   $VAULT/decisions/
   ```

4. **Write config file**
   ```bash
   mkdir -p ~/.config/memory-vault
   echo "MEMORY_VAULT_PATH=\"$VAULT\"" > ~/.config/memory-vault/config.sh
   ```

5. **Configure QMD collections**
   Write `~/.config/qmd/index.yml` with 4 scoped collections pointing to the vault subfolders.

6. **Index and embed**
   ```bash
   qmd update && qmd embed
   ```

7. **Verify**
   - `qmd collection list` shows 4 collections
   - `qmd status` shows hasVectorIndex: true
   - Print success message with vault path and collection counts

## 10. Migration from Manual Setup

Members who already have the manual setup need to:

1. Enable the `memory-vault` plugin
2. Remove manual hook entries from `~/.claude/settings.json`:
   - `PostToolUse` → state-saver.sh
   - `Stop` → session-summary.sh
   - `PreToolUse` → strategic-compact.sh
   - (SessionStart hook if wired)
3. Skills in `~/.claude/skills/` (session-start, compress, resume, session-end) will be shadowed by plugin versions — remove the old ones to avoid confusion
4. Vault folder, QMD config, and config file are unchanged — `/setup` detects existing setup and skips

The `/setup` command should detect existing manual installations and guide the migration.

## 11. Skills (moved from ~/.claude/skills/)

### session-start (v2.0.0)
Brief recall at session start. Queries `-c sessions` collection, outputs ≤10 lines. No standup, no WMS queries.

### compress
Saves session context to vault at `07-Claude/sessions/YYYY-MM-DD-{topic}.md`. Frontmatter schema: type, date, project, topics, outcome, importance.

### resume
Loads context from previous sessions. Mode 1 (standalone): outputs context brief. Mode 2 (vault sweep): deprecated.

### session-end
Universal session close: WMS sync → git commit → ask before push → /compress. All steps in order.

### setup
First-run configuration. Creates vault, installs qmd, configures collections. See section 9.

## 12. Hook Scripts (moved from ~/.claude/hooks/scripts/)

All scripts are taken from the currently deployed versions with one change: hardcoded vault paths replaced by `source "${CLAUDE_PLUGIN_ROOT}/hooks/lib/config.sh"`.

### session-reconstruct.sh
- Event: SessionStart (all matchers)
- Function: Collects git state (branch, recent commits, working tree) and emits as JSON with `hookSpecificOutput.additionalContext` for Claude Code context injection. Matches the superpowers plugin pattern.
- Output format: JSON (required for plugin SessionStart hooks)
  ```json
  {
    "hookSpecificOutput": {
      "hookEventName": "SessionStart",
      "additionalContext": "## Git State\nBranch: `main`\n..."
    }
  }
  ```
  Markdown content is JSON-escaped inside `additionalContext`. For Cursor compatibility, detect `CURSOR_PLUGIN_ROOT` and emit `additional_context` instead.
- Constraints: <1s execution, no external dependencies

### session-summary.sh
- Event: Stop
- Function: Writes auto-summary to vault sessions directory. Refreshes QMD index (`qmd update && qmd embed`). Skips if /session-end already wrote a file in the last 10 min.
- Constraints: 30s timeout, graceful degradation if vault unreachable

### state-saver.sh
- Event: PostToolUse (Write|Edit|MultiEdit)
- Function: Saves git status + diff stats + recent commits to vault state directory. Mid-session recovery point.
- Constraints: 15s timeout

### strategic-compact.sh
- Event: PreToolUse (all matchers)
- Function: Counts heavy tool calls (Read, Bash, WebFetch, WebSearch, Agent). At threshold (200), triggers state-saver then outputs /compress nudge.
- Constraints: 5s timeout, never blocks tool execution

## 13. README.md Contents

The README serves as the single-source install guide (replaces Notion WIKI page):

1. **What is memory-vault** — 1 paragraph
2. **Prerequisites** — Claude Code, Node.js v18+, Git
3. **Install** — enable plugin + `/setup`
4. **What it does** — hook/skill table
5. **Vault folder structure** — diagram
6. **QMD collections** — 4 scoped collections explained
7. **Configuration** — vault path resolution chain
8. **Troubleshooting** — common failures table
9. **Architecture diagram** — ASCII art showing hook → vault → qmd flow
10. **Known limitation** — no PreCompact hook in Claude Code API
11. **Migration from manual setup** — steps to remove old hooks/skills

## 14. Acceptance Criteria

| AC | Description | Verification |
|----|-------------|-------------|
| AC-1 | Plugin enables via `memory-vault@ltc-plugins` | Enable in settings, verify skills appear |
| AC-2 | `/setup` creates vault + qmd config in <5 min | Run on clean machine, time it |
| AC-3 | Hooks auto-wire without manual settings.json edits | Check `/hooks` UI shows 4 hooks after enable |
| AC-4 | Session file appears in vault after Claude stops | Work in git repo, stop Claude, check vault |
| AC-5 | `/session-start` produces ≤10 line brief recall | Run in repo with prior sessions |
| AC-6 | No double-firing with manual hooks removed | Verify only plugin hooks appear in `/hooks` |
| AC-7 | Graceful degradation if vault path not found | Remove config, verify hooks exit 0 silently |
| AC-8 | README covers A-Z setup | New member reads README only, completes install |

## 15. Implementation Order

1. Create `plugins/memory-vault/.claude-plugin/plugin.json` (plugin manifest)
2. Create `plugins/memory-vault/hooks/lib/config.sh` (vault path resolution)
3. Port 4 hook scripts → `plugins/memory-vault/hooks/` (replace hardcoded paths with config.sh, add JSON output for session-reconstruct.sh)
4. Create `plugins/memory-vault/hooks/hooks.json`
5. Move 5 skills → `plugins/memory-vault/skills/`
6. Create `plugins/memory-vault/README.md`
7. Create `.claude-plugin/marketplace.json` at **repo root** (registers the plugin for discovery)
8. Test: enable plugin on clean profile, run `/setup`, verify all ACs
9. Migration guide: document removal of old manual hooks/skills
