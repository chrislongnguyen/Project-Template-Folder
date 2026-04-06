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
  - now_what_next
---

# Developing Plugins — Components In Depth

Beyond a basic skill: how to add agents, hooks, MCP servers, LSP servers, and default settings to a plugin. Each component is independent — add only what the plugin needs.

## L1: Component Map

```
my-plugin/
├── .claude-plugin/plugin.json   ← manifest
├── skills/<name>/SKILL.md       ← model-invoked capabilities
├── commands/<name>.md           ← user-invoked slash commands (legacy)
├── agents/<name>.md             ← specialized subagents
├── hooks/hooks.json             ← lifecycle event handlers
├── .mcp.json                    ← external tool/service servers
├── .lsp.json                    ← language server configs
├── bin/                         ← executables on Bash PATH
└── settings.json                ← default config when plugin enabled
```

Critical constraint: **everything except `plugin.json` must be at the plugin root, not inside `.claude-plugin/`.**

## L2: Skills

Skills are model-invoked: Claude decides to use them based on task context. Each skill is a directory with a `SKILL.md`:

```
skills/
└── code-review/
    └── SKILL.md
```

`SKILL.md` requires `name` and `description` frontmatter:

```yaml
---
name: code-review
description: Reviews code for best practices and potential issues. Use when reviewing code, checking PRs, or analyzing code quality.
---

When reviewing code, check for:
1. Code organization and structure
2. Error handling
3. Security concerns
4. Test coverage
```

After installing, run `/reload-plugins` to activate new skills. Skills can include supporting files (reference docs, scripts) alongside `SKILL.md`.

## L2: Agents

Plugins can ship specialized subagents that Claude invokes automatically or users call manually:

```markdown
---
name: security-reviewer
description: Audits code for security vulnerabilities and OWASP risks
model: sonnet
effort: medium
maxTurns: 20
disallowedTools: Write, Edit
---

You are a security specialist. Audit code systematically for...
```

Supported agent frontmatter: `name`, `description`, `model`, `effort`, `maxTurns`, `tools`, `disallowedTools`, `skills`, `memory`, `background`, `isolation` (only valid value: `"worktree"`).

**Restricted fields** (security — not allowed in plugin-shipped agents): `hooks`, `mcpServers`, `permissionMode`.

Agents appear in `/agents` and can be set as the default agent via `settings.json`.

## L2: Hooks

Hooks subscribe to Claude Code lifecycle events. Config lives in `hooks/hooks.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format-code.sh"
          }
        ]
      }
    ]
  }
}
```

**Hook types:** `command`, `http`, `prompt`, `agent`

**Key events for plugins:**

| Event              | When                                      | Common use                          |
| :----------------- | :---------------------------------------- | :---------------------------------- |
| `SessionStart`     | Session begins or resumes                 | Install dependencies, environment   |
| `PostToolUse`      | After tool call succeeds                  | Lint, format, audit                 |
| `PreToolUse`       | Before tool call (can block)              | Guard rails, validation             |
| `UserPromptSubmit` | Before Claude processes prompt            | Context injection, thinking modes   |
| `Stop`             | Claude finishes responding                | Notifications, summaries            |
| `FileChanged`      | Watched file changes on disk              | Reactive environment management     |

Always use `${CLAUDE_PLUGIN_ROOT}` for script paths — absolute paths break after installation.

Hook scripts must be executable (`chmod +x`) and have a shebang line. Event names are case-sensitive (`PostToolUse`, not `postToolUse`).

## L2: MCP Servers

Bundle Model Context Protocol servers to connect Claude to external tools and services:

```json
{
  "mcpServers": {
    "plugin-database": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
      "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
      "env": {
        "DB_PATH": "${CLAUDE_PLUGIN_ROOT}/data"
      }
    }
  }
}
```

Place config in `.mcp.json` at plugin root. MCP servers start automatically when the plugin is enabled. They appear as standard MCP tools in Claude's toolkit, indistinguishable from user-configured servers.

## L2: LSP Servers

LSP plugins give Claude real-time code intelligence (diagnostics, go-to-definition, hover). Add `.lsp.json` at plugin root:

```json
{
  "go": {
    "command": "gopls",
    "args": ["serve"],
    "extensionToLanguage": {
      ".go": "go"
    }
  }
}
```

**Required fields:** `command`, `extensionToLanguage`.

**Optional fields:** `args`, `transport` (`stdio`|`socket`), `env`, `initializationOptions`, `settings`, `workspaceFolder`, `startupTimeout`, `shutdownTimeout`, `restartOnCrash`, `maxRestarts`.

The language server binary must be installed on the user's machine — the plugin only configures the connection, not the binary itself.

Pre-built official LSP plugins exist for Python (pyright), TypeScript, and Rust. Create custom LSP plugins only for unsupported languages.

## L2: Default Settings

`settings.json` at plugin root sets defaults when the plugin is enabled. Currently only `agent` key is supported:

```json
{
  "agent": "security-reviewer"
}
```

This activates a plugin-defined agent as the main thread, applying its system prompt, tool restrictions, and model. Settings from `settings.json` override `settings` declared in `plugin.json`. Unknown keys are silently ignored.

## L2: Why Each Component Works This Way

- **Namespacing** prevents conflicts: multiple plugins can define a `deploy` skill without collision.
- **`${CLAUDE_PLUGIN_ROOT}` substitution** makes scripts portable — the plugin cache path changes on update, so hardcoded paths would break.
- **`${CLAUDE_PLUGIN_DATA}` persistence** lets plugins install heavy dependencies once (e.g., `node_modules`) and reuse them across sessions and plugin versions.
- **Manifest-optional design** lowers the barrier to entry — directory structure alone is sufficient for Claude Code to discover components.

## L2: Why Not (Tradeoffs)

- Plugin agents cannot use `hooks`, `mcpServers`, or `permissionMode` — these are restricted to prevent privilege escalation through distributed plugins.
- Plugin hooks share the same event bus as user hooks but cannot override user-defined hooks.
- LSP plugins require the binary to be pre-installed — no auto-install mechanism.
- `settings.json` only supports `agent` today — other settings keys are silently ignored.

## Sources

- https://code.claude.com/docs/en/plugins (lines 22151–22295)
- https://code.claude.com/docs/en/plugins-reference (lines 22427–22900)

## Links

- [[overview]] — plugin architecture and directory structure
- [[manifest-reference]] — complete plugin.json schema including component path overrides
- [[cli-reference]] — testing and debugging commands
- [[hooks]] — full hook event reference
- [[mcp]] — MCP server integration details
- [[agents]] — subagent frontmatter options
