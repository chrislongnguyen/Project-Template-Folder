---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: plugins
source: captured/claude-code-docs-full.md
review: true
review_interval: 7
questions_answered:
  - what_is_it
  - how_does_it_work
  - what_else
  - why_does_it_work
  - what_if
  - now_what_better
---

# Plugin Manifest Reference

Complete `plugin.json` schema. The manifest is optional — Claude Code auto-discovers components without it — but required when you need metadata, custom paths, user config prompts, or channels.

## L1: What It Is

`plugin.json` lives at `.claude-plugin/plugin.json` inside the plugin directory. It is the single source of truth for the plugin's identity and component locations.

**Only `name` is required** when a manifest is present.

## L2: Complete Schema

```json
{
  "name": "plugin-name",
  "version": "1.2.0",
  "description": "Brief plugin description",
  "author": {
    "name": "Author Name",
    "email": "author@example.com",
    "url": "https://github.com/author"
  },
  "homepage": "https://docs.example.com/plugin",
  "repository": "https://github.com/author/plugin",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"],
  "commands": ["./custom/commands/special.md"],
  "agents": "./custom/agents/",
  "skills": "./custom/skills/",
  "hooks": "./config/hooks.json",
  "mcpServers": "./mcp-config.json",
  "outputStyles": "./styles/",
  "lspServers": "./.lsp.json",
  "userConfig": { ... },
  "channels": [ ... ]
}
```

## L2: Field Reference

**Identity fields:**

| Field         | Type   | Required | Description                                   |
| :------------ | :----- | :------- | :-------------------------------------------- |
| `name`        | string | Yes      | Unique kebab-case ID; also the namespace prefix for all components |
| `version`     | string | No       | Semver (`1.2.0`). Must bump for users to receive cache-busted updates |
| `description` | string | No       | Shown in plugin manager                       |
| `author`      | object | No       | `name`, `email`, `url` subfields              |
| `homepage`    | string | No       | Documentation URL                             |
| `repository`  | string | No       | Source code URL                               |
| `license`     | string | No       | SPDX identifier (`MIT`, `Apache-2.0`)         |
| `keywords`    | array  | No       | Discovery tags for marketplace search         |

**Component path fields** (all paths must be relative, starting with `./`):

| Field          | Type                  | Default location     | Notes                                                                               |
| :------------- | :-------------------- | :------------------- | :---------------------------------------------------------------------------------- |
| `commands`     | string\|array         | `commands/`          | Custom path **replaces** default directory                                          |
| `agents`       | string\|array         | `agents/`            | Custom path replaces default                                                        |
| `skills`       | string\|array         | `skills/`            | Custom path replaces default                                                        |
| `hooks`        | string\|array\|object | `hooks/hooks.json`   | Multiple sources merged                                                             |
| `mcpServers`   | string\|array\|object | `.mcp.json`          | Multiple sources merged                                                             |
| `outputStyles` | string\|array         | `output-styles/`     | Custom path replaces default                                                        |
| `lspServers`   | string\|array\|object | `.lsp.json`          | Multiple sources merged                                                             |

**Path behavior rule:** For `commands`, `agents`, `skills`, and `outputStyles`, specifying a custom path replaces the default directory — the default is not also scanned. To keep defaults AND add extras: `"commands": ["./commands/", "./extras/deploy.md"]`.

Hooks, MCP servers, and LSP servers have different semantics: multiple sources are merged, not replaced.

## L2: User Configuration

`userConfig` declares values Claude Code prompts the user for when the plugin is first enabled:

```json
{
  "userConfig": {
    "api_endpoint": {
      "description": "Your team's API endpoint",
      "sensitive": false
    },
    "api_token": {
      "description": "API authentication token",
      "sensitive": true
    }
  }
}
```

- Keys must be valid identifiers.
- Available as `${user_config.KEY}` in MCP/LSP configs and hook commands.
- Non-sensitive values also available in skill and agent content.
- Exported as `CLAUDE_PLUGIN_OPTION_<KEY>` env vars to plugin subprocesses.
- Non-sensitive values stored in `settings.json` under `pluginConfigs[<plugin-id>].options`.
- Sensitive values stored in system keychain (or `~/.claude/.credentials.json` fallback). Keychain limit ~2 KB — keep sensitive values small.

## L2: Channels

`channels` lets a plugin inject messages into the conversation from external sources (Telegram, Slack, Discord pattern):

```json
{
  "channels": [
    {
      "server": "telegram",
      "userConfig": {
        "bot_token": { "description": "Telegram bot token", "sensitive": true },
        "owner_id": { "description": "Your Telegram user ID", "sensitive": false }
      }
    }
  ]
}
```

`server` must match a key in the plugin's `mcpServers`. The per-channel `userConfig` follows the same schema as the top-level field.

## L2: Environment Variables

Two variables are substituted anywhere they appear in skill content, agent content, hook commands, MCP/LSP configs, and exported to subprocesses:

| Variable                | Resolves to                                                  | Use for                                        |
| :---------------------- | :----------------------------------------------------------- | :--------------------------------------------- |
| `${CLAUDE_PLUGIN_ROOT}` | Absolute install path (changes on plugin update)             | Bundled scripts, binaries, static config files |
| `${CLAUDE_PLUGIN_DATA}` | `~/.claude/plugins/data/{id}/` (persists across updates)     | Installed deps (`node_modules`), caches, state |

**Persistent data pattern** — install `node_modules` on first run, reinstall only when `package.json` changes:

```json
{
  "hooks": {
    "SessionStart": [{
      "hooks": [{
        "type": "command",
        "command": "diff -q \"${CLAUDE_PLUGIN_ROOT}/package.json\" \"${CLAUDE_PLUGIN_DATA}/package.json\" >/dev/null 2>&1 || (cd \"${CLAUDE_PLUGIN_DATA}\" && cp \"${CLAUDE_PLUGIN_ROOT}/package.json\" . && npm install) || rm -f \"${CLAUDE_PLUGIN_DATA}/package.json\""
      }]
    }]
  }
}
```

Data directory is deleted on uninstall from last scope. Use `--keep-data` flag to preserve it.

## L2: What-If — Manifest Omitted

Without `plugin.json`, Claude Code:
- Derives plugin name from directory name.
- Scans default locations for each component type.
- Does not prompt for user config values.
- Cannot register metadata fields (version, author, keywords).

Sufficient for local development. Required for marketplace distribution (version field needed for update detection).

## Sources

- https://code.claude.com/docs/en/plugins-reference (lines 22695–22900)

## Links

- [[overview]] — plugin architecture and scopes
- [[developing-plugins]] — component authoring details
- [[cli-reference]] — install, update, validate commands
- [[distribution]] — versioning strategy for manifests
