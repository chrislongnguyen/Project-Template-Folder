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
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
  - so_what_benefit
  - now_what_next
  - what_is_it_not
  - how_does_it_not_work
---

# Plugin System Overview

Plugins are the shareable, versioned packaging format for Claude Code extensions. They solve the distribution problem: standalone `.claude/` config works for one project; plugins let the same skills, agents, hooks, and servers travel across projects and teams.

## L1: What It Is

A **plugin** is a self-contained directory recognized by a `.claude-plugin/plugin.json` manifest. Claude Code scans that manifest to register all components inside the plugin.

Components a plugin can ship:

| Directory / File    | What it provides                                        |
| :------------------ | :------------------------------------------------------ |
| `skills/`           | Agent Skills (`SKILL.md` files), model-invoked          |
| `commands/`         | Legacy slash-commands as plain `.md` files              |
| `agents/`           | Specialized subagents Claude can spawn                  |
| `hooks/hooks.json`  | Event handlers (PostToolUse, SessionStart, etc.)        |
| `.mcp.json`         | MCP server definitions                                  |
| `.lsp.json`         | Language Server Protocol configs for code intelligence  |
| `bin/`              | Executables added to Bash tool PATH                     |
| `settings.json`     | Default settings applied when plugin is enabled         |

**Key naming rule:** skill and command names are namespaced by the plugin `name` field. A skill folder `hello/` in plugin `my-tool` becomes `/my-tool:hello`. This prevents conflicts when multiple plugins share common names.

## L2: Plugin vs. Standalone Config

| Dimension            | Standalone (`.claude/`)                  | Plugin (`.claude-plugin/plugin.json`)     |
| :------------------- | :--------------------------------------- | :---------------------------------------- |
| Scope                | Single project                           | Any project, any team                     |
| Skill names          | `/hello`                                 | `/plugin-name:hello`                      |
| Sharing              | Manual copy                              | Install with `/plugin install`            |
| Version control      | Implicit (repo commits)                  | Explicit `version` field + marketplace    |
| Conflict prevention  | None                                     | Namespace prefix enforced                 |
| Distribution channel | None                                     | Plugin marketplaces                       |

**Choose standalone when:** experimenting, single-project use, short skill names matter.

**Choose plugins when:** sharing with team, reuse across projects, need versioned releases, distributing publicly.

## L3: Architecture — How the Plugin System Works

```
Plugin directory (any path)
├── .claude-plugin/
│   └── plugin.json          ← manifest (optional but recommended)
├── skills/
│   └── <skill-name>/SKILL.md
├── agents/
│   └── <agent-name>.md
├── hooks/hooks.json
├── .mcp.json
├── .lsp.json
├── bin/
└── settings.json
```

**Discovery flow:**
1. Claude Code reads `.claude-plugin/plugin.json` → extracts `name`, component paths.
2. If no manifest, auto-discovers components at default locations; derives name from directory name.
3. Skills + commands registered under namespace `{plugin-name}:{component-name}`.
4. MCP servers start automatically when plugin is enabled.
5. Hooks subscribe to lifecycle events globally for that session.

**Manifest is optional.** Omit it and Claude Code still discovers all components from default directories. Use a manifest when you need metadata (version, author, keywords) or non-default paths.

**Installation scopes** — where a plugin is registered:

| Scope     | Settings file                  | Availability                          |
| :-------- | :----------------------------- | :------------------------------------ |
| `user`    | `~/.claude/settings.json`      | All projects for this user (default)  |
| `project` | `.claude/settings.json`        | Team-shared via version control       |
| `local`   | `.claude/settings.local.json`  | Project-specific, gitignored          |
| `managed` | Managed settings               | Read-only, admin-controlled           |

**Caching:** Installed marketplace plugins are copied to `~/.claude/plugins/cache` — not used in-place. Plugins cannot reference files outside their directory (no `../` path traversal). Symlinks inside the plugin directory are honored.

**Environment variables available inside plugins:**

| Variable              | Resolves to                                               |
| :-------------------- | :-------------------------------------------------------- |
| `${CLAUDE_PLUGIN_ROOT}` | Absolute path to plugin installation directory (changes on update) |
| `${CLAUDE_PLUGIN_DATA}` | Persistent state directory at `~/.claude/plugins/data/{id}/` (survives updates) |

Use `${CLAUDE_PLUGIN_ROOT}` for referencing bundled scripts and configs. Use `${CLAUDE_PLUGIN_DATA}` for installed dependencies (e.g. `node_modules`) that should persist across plugin versions.

## L3: What It Is Not

- Not a replacement for `.claude/` standalone config — both coexist; use the right tool for scope.
- Not a build system or package manager — plugins ship source files, not compiled artifacts.
- Not a sandbox — plugins run with the same permissions as the user's Claude Code session.
- Not version-locked to Claude Code itself — semver in `plugin.json` tracks plugin releases, not Claude Code compatibility.

## L3: How It Does Not Work

- Components placed **inside** `.claude-plugin/` (other than `plugin.json`) are invisible — hooks, agents, commands must be at the plugin root.
- Absolute paths in plugin configs break after installation — all paths must be relative and start with `./`, or use `${CLAUDE_PLUGIN_ROOT}`.
- Path traversal (`../shared-utils`) fails after caching — use symlinks inside the plugin directory instead.
- Bumping plugin code without bumping `version` in `plugin.json` means existing users will not receive the update (caching).

## Sources

- https://code.claude.com/docs/en/plugins (lines 21981–22412)
- https://code.claude.com/docs/en/plugins-reference (lines 22414–23248)

## Links

- [[quickstart]] — step-by-step first plugin creation
- [[developing-plugins]] — skills, agents, hooks, MCP, LSP inside plugins
- [[manifest-reference]] — complete plugin.json schema
- [[cli-reference]] — plugin CLI commands and debugging
- [[distribution]] — versioning, sharing, marketplace submission
- [[skills]] — Agent Skills authoring
- [[hooks]] — hook event system
- [[mcp]] — MCP server integration
- [[agents]] — subagent configuration
