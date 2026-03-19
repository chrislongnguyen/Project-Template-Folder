# memory-vault

Cross-session memory for Claude Code. Auto-exports sessions, indexes with QMD, recalls context at startup.

## What is memory-vault?

A Claude Code plugin that gives your agent persistent memory across sessions. When Claude stops, a session log is saved to your vault. When Claude starts, it recalls what you were working on. QMD (a local search engine) makes everything searchable — keyword and semantic search across your entire work history.

> **New here?** Start with the [A-Z Install Guide](INSTALL.md) — it walks through everything step by step.

## Prerequisites

- **Claude Code** installed and working (`claude --version`)
- **Node.js** v18+ (`node --version`)
- **Git** installed (`git --version`)
- **Google Drive for Desktop** (recommended) or a local folder for vault storage

## Install

### Step 1 — Enable the plugin

Add to `~/.claude/settings.json`:

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

Then enable: `memory-vault@ltc-plugins`

### Step 2 — Run setup

In any Claude Code session:
```
/setup
```

This creates your vault folder, installs QMD, configures collections, and verifies everything works. Takes <5 minutes.

## What it does

### Hooks (automatic)

| Hook | Event | What it does |
|------|-------|-------------|
| session-reconstruct | SessionStart | Injects git state into Claude's context |
| strategic-compact | PreToolUse | Counts heavy tool calls, nudges /compress at threshold |
| state-saver | PostToolUse (Write/Edit) | Saves git state to vault as recovery point |
| session-summary | Stop | Writes session log to vault, refreshes QMD index |

### Skills (on-demand)

| Skill | Trigger | What it does |
|-------|---------|-------------|
| /session-start | "Start session" | Brief recall (≤10 lines) from vault |
| /compress | "compress" or "/compress" | Saves full session context to vault |
| /resume | "resume" or "load context" | Loads previous session context |
| /session-end | "Session end" | WMS sync → git commit → vault save |
| /setup | "setup" or first run | First-run configuration wizard |

## Vault folder structure

```
$MEMORY_VAULT_PATH/
├── 07-Claude/
│   ├── sessions/        ← session logs (auto + manual)
│   ├── conversations/   ← conversation exports
│   └── state/           ← live git snapshots
├── data/processed/
│   └── daily/           ← daily digests
└── decisions/           ← decision records
```

## QMD collections

4 scoped collections — each maps to a vault subfolder:

| Collection | Path | Purpose |
|-----------|------|---------|
| sessions | 07-Claude/sessions/ | Session logs from /compress and auto-summary |
| conversations | 07-Claude/conversations/ | Parsed conversation exports |
| daily | data/processed/daily/ | Daily digest files |
| decisions | decisions/ | Decision records |

Search example: `qmd query -c sessions "memory vault setup" -n 5`

## Configuration

Vault path is resolved through a priority chain:

1. **Config file** — `~/.config/memory-vault/config.sh` (written by /setup)
2. **Environment variable** — `$MEMORY_VAULT_PATH`
3. **Auto-scan** — Google Drive candidates, then `$HOME/Long-Memory-Vault`
4. **Not found** — hooks exit silently (graceful degradation)

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| Vault path not found | Google Drive folder name mismatch | `ls ~/Library/CloudStorage/` — use exact folder name |
| `qmd: command not found` | npm global bin not in PATH | `npm config get prefix` then add `{prefix}/bin` to `$PATH` |
| `qmd embed` hangs | First run downloads ~300MB models | Wait for initial download; subsequent runs are fast |
| Hook not firing | Script not executable or JSON syntax error | Check `/hooks` UI; validate hooks.json |
| No session files after stopping | Not in a git repo or no changes made | session-summary only fires in git repos with changes |
| QMD search returns 0 results | Index not built or embeddings missing | `qmd update && qmd embed` |
| Session-start slow (>10 sec) | Searching all collections | Use scoped: `qmd query -c sessions "..."` |

## Architecture

```
┌─────────────────────────────────────────────────┐
│  Claude Code Session                            │
│                                                 │
│  SessionStart ──► session-reconstruct.sh        │
│                   (injects git state)           │
│                                                 │
│  PreToolUse ────► strategic-compact.sh          │
│                   (counts calls, nudges save)   │
│                                                 │
│  PostToolUse ───► state-saver.sh                │
│  (Write|Edit)     (saves git state to vault)    │
│                                                 │
│  Stop ──────────► session-summary.sh            │
│                   (writes session log)          │
│                   (refreshes qmd index)         │
└───────────────────────┬─────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────┐
│  Memory Vault (Google Drive / local)            │
│                                                 │
│  07-Claude/sessions/    ← session logs          │
│  07-Claude/conversations/ ← conversation exports│
│  07-Claude/state/       ← live git snapshots    │
│  data/processed/daily/  ← daily digests         │
│  decisions/             ← decision records      │
└───────────────────────┬─────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────┐
│  QMD (local search engine)                      │
│                                                 │
│  4 scoped collections → low-noise search        │
│  MCP server → agents query vault via tool calls │
│  /session-start → brief recall in ≤10 lines     │
└─────────────────────────────────────────────────┘
```

## Known limitation

Claude Code does not offer a `PreCompact` hook. The `strategic-compact.sh` script approximates context tracking by counting heavy tool calls (Read, Bash, WebFetch, WebSearch, Agent) and nudging `/compress` at a configurable threshold (default: 200 calls). This is a heuristic, not exact.

## Migration from manual setup

If you previously installed Memory Vault manually:

1. Enable the `memory-vault` plugin
2. Remove manual hook entries from `~/.claude/settings.json`:
   - SessionStart → session-reconstruct.sh
   - PostToolUse → state-saver.sh
   - Stop → session-summary.sh
   - PreToolUse → strategic-compact.sh
3. Remove old skills from `~/.claude/skills/`:
   - session-start, compress, resume, session-end
4. Run `/setup` — it detects existing vault and config, skips what's already done
5. Vault folder and QMD config are unchanged

## Importing old conversations

Import chat history from other platforms into your vault for QMD search.

### Gemini (Google Takeout)

1. Go to [Google Takeout](https://takeout.google.com), select "Gemini Apps Activity", download archive
2. Extract the ZIP
3. Run:
```bash
python3 plugins/memory-vault/scripts/import-gemini.py <takeout-dir> <vault>/07-Claude/conversations/
```

### Cursor

Reads directly from Cursor's local SQLite database:
```bash
python3 plugins/memory-vault/scripts/import-cursor.py <vault>/07-Claude/conversations/
```
Default db: `~/Library/Application Support/Cursor/User/globalStorage/state.vscdb`

### Claude web (claude.ai)

1. Go to claude.ai → Settings → Privacy & Data → Export Data
2. Download the `.dms` file (or extract it)
3. Run:
```bash
python3 plugins/memory-vault/scripts/import-claude-web.py <export-path> <vault>/07-Claude/conversations/
```

### Shared flags

| Flag | What it does |
|------|-------------|
| `--dry-run` | Preview what would be imported without writing |
| `--force` | Overwrite existing files |

After importing, refresh QMD: `qmd update && qmd embed`

## Version

1.0.0
