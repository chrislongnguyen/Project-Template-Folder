---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: plugins
source: captured/claude-code-docs-full.md
review: true
review_interval: 7
questions_answered:
  - so_what_relevance
  - what_is_it
  - how_does_it_work
  - why_does_it_work
  - how_does_it_not_work
  - now_what_next
---

# Plugin CLI Reference and Debugging

CLI commands for non-interactive plugin management, plus debugging techniques and common issues.

## L1: CLI Commands

All plugin management commands follow `claude plugin <subcommand>`.

| Command                          | Purpose                                |
| :------------------------------- | :------------------------------------- |
| `claude plugin install <plugin>` | Install from marketplace               |
| `claude plugin uninstall <plugin>` | Remove plugin                        |
| `claude plugin enable <plugin>`  | Enable a disabled plugin               |
| `claude plugin disable <plugin>` | Disable without uninstalling           |
| `claude plugin update <plugin>`  | Update to latest version               |
| `claude plugin validate`         | Validate manifest and component files  |

Plugin name format: `plugin-name` or `plugin-name@marketplace-name` for a specific marketplace.

## L2: Command Details

**install**

```bash
claude plugin install formatter@my-marketplace
claude plugin install formatter@my-marketplace --scope project   # team-shared
claude plugin install formatter@my-marketplace --scope local     # gitignored
```

`--scope project` writes to `.claude/settings.json` → everyone who clones the repo gets the plugin.

**uninstall** (aliases: `remove`, `rm`)

```bash
claude plugin uninstall formatter@my-marketplace
claude plugin uninstall formatter@my-marketplace --keep-data     # preserve ${CLAUDE_PLUGIN_DATA}
```

Default: deletes `${CLAUDE_PLUGIN_DATA}` directory when uninstalling from last scope. Use `--keep-data` when reinstalling to test a new version.

**enable / disable**

```bash
claude plugin enable formatter@my-marketplace --scope user
claude plugin disable formatter@my-marketplace --scope project
```

Disable preserves the plugin installation; re-enable restores without reinstalling.

**update**

```bash
claude plugin update formatter@my-marketplace
claude plugin update formatter@my-marketplace --scope managed
```

Scope options for update: `user`, `project`, `local`, `managed`.

## L2: In-Session Commands

```
/reload-plugins        ← hot-reload all plugins (no restart)
/plugin validate       ← validate manifest + component files
/agents                ← list registered agents including plugin agents
/help                  ← list all commands including plugin skills
```

## L2: Debugging

**Enable debug output:**

```bash
claude --debug
```

Shows: which plugins are loading, manifest parse errors, command/agent/hook registration, MCP server initialization.

**Common issues table:**

| Symptom                          | Cause                           | Fix                                                    |
| :------------------------------- | :------------------------------ | :----------------------------------------------------- |
| Plugin not loading               | Invalid `plugin.json`           | Run `claude plugin validate` — check JSON syntax       |
| Commands not appearing           | Wrong directory structure       | Move `commands/` to plugin root, not inside `.claude-plugin/` |
| Hooks not firing                 | Script not executable           | `chmod +x scripts/your-script.sh`                      |
| MCP server fails to start        | Missing `${CLAUDE_PLUGIN_ROOT}` | Replace absolute paths with the variable               |
| Path errors                      | Absolute paths in config        | All paths must be relative, starting with `./`         |
| LSP `Executable not found`       | Binary not installed            | `npm install -g typescript-language-server typescript` |
| Components missing after load    | Files inside `.claude-plugin/`  | Move to plugin root                                    |
| Users not receiving updates      | Version not bumped              | Increment `version` in `plugin.json`                   |

## L2: How Debugging Works (Why This Approach)

Plugins fail silently by design — a broken plugin should not crash Claude Code. This means errors surface only in:
1. `--debug` output at startup
2. `/plugin validate` output
3. The `/plugin` Errors tab in the UI
4. Hook script stderr (visible in debug mode)

Debug checklist for missing components:
1. `claude --debug` → look for "loading plugin" messages and which directories are scanned
2. Verify each component directory appears in debug output
3. Check file permissions allow reading
4. Confirm no path traversal (`../`) in component configs

## L2: How It Does Not Work

- `claude --debug` output is session-level — it does not persist or write to a log file.
- `/reload-plugins` reloads all active plugins but does not reinstall marketplace plugins.
- `claude plugin validate` checks schema and syntax but does not execute scripts or verify binary availability.
- Hook troubleshooting: event names are case-sensitive. `PostToolUse` works; `postToolUse` does not.
- MCP servers that fail to start do not block the session — they are silently unavailable.

## Sources

- https://code.claude.com/docs/en/plugins-reference (lines 22992–23203)

## Links

- [[overview]] — plugin scopes and installation
- [[developing-plugins]] — hook and MCP troubleshooting details
- [[manifest-reference]] — plugin.json schema validation
- [[distribution]] — versioning and update mechanics
