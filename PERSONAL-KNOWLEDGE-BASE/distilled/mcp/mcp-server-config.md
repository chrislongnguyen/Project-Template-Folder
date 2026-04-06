---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: mcp
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
---

# MCP Server Configuration

> MCP (Model Context Protocol) connects Claude Code to external tools and data sources — JIRA, GitHub, PostgreSQL, Sentry — through a standardized open protocol with three transport types and three scope levels.

## L1 — Knowledge

### So What? (Relevance)

MCP is how Claude Code extends beyond local files and shell commands. Without MCP, Claude can only read/write files and run Bash. With MCP, it can query databases, create GitHub PRs, pull Sentry error data, and push messages from external events. For LTC projects, MCP is the integration layer for any workflow that touches external systems.

### What Is It?

MCP (Model Context Protocol) is an open standard for AI-tool integrations. Claude Code connects to MCP **servers** — processes or HTTP endpoints that expose tools, resources, and prompts. Claude Code is the **client**; the MCP server is the integration layer for a specific external service.

### What Else?

**Three transport types:**
| Type | Use case |
|------|----------|
| `http` | Remote cloud services (recommended, widely supported) |
| `sse` | Remote SSE servers (deprecated — prefer http) |
| `stdio` | Local processes with direct system access |

**Three scope levels:**
| Scope | Storage | Visibility |
|-------|---------|-----------|
| `local` (default) | `~/.claude.json` under project path | You only, current project |
| `project` | `.mcp.json` at project root (commit to VCS) | Team-shared |
| `user` | `~/.claude.json` global | You, all projects |

**Management commands:**
```bash
claude mcp add --transport http <name> <url>    # HTTP server
claude mcp add --transport stdio <name> -- <cmd> [args]  # stdio server
claude mcp list
claude mcp get <name>
claude mcp remove <name>
/mcp                                             # in-session status + auth
```

**Environment variable expansion in `.mcp.json`:**
- `${VAR}` and `${VAR:-default}` syntax supported in `command`, `args`, `env`, `url`, `headers`
- Required variable with no default = parse failure

### How Does It Work?

1. Add a server: `claude mcp add --transport http sentry https://mcp.sentry.dev/mcp`
2. At session start: Claude Code connects to all configured servers and loads their tool names
3. Tool definitions deferred by default (Tool Search) — only names load at start
4. When Claude needs a tool: searches tool index, loads full definition on demand
5. Tool calls use naming pattern `mcp__<server>__<tool>` internally

**Scope precedence (highest to lowest):** local > project > user
If a server is configured both locally and via claude.ai connector, local wins.

**Plugin-provided MCP servers:** Plugins can bundle MCP servers in `.mcp.json` at plugin root — auto-connected when plugin is enabled, managed through plugin lifecycle not `/mcp` commands.

## L2 — Understanding

### Why Does It Work?

MCP separates the integration concern (how to talk to Sentry/GitHub/etc.) from the Claude Code core. The open protocol means any team can build an MCP server for their internal tools. The three-scope system mirrors how settings files work — local overrides project overrides user — so organizations can enforce a curated server set while individuals add personal tools.

### Why Not?

- Third-party MCP servers carry prompt injection risk if they fetch untrusted content
- Project-scoped `.mcp.json` requires explicit approval before Claude uses it (trust dialog)
- SSE transport is deprecated — avoid for new integrations
- Windows users running stdio servers via `npx` need `cmd /c` wrapper or get "Connection closed"
- `MAX_MCP_OUTPUT_TOKENS` defaults to 25,000 tokens — large database queries may hit this

## L3 — Wisdom

### So What? (Benefit)

MCP removes the "Claude can't see my external data" barrier. The pattern is: add server → authenticate → ask Claude naturally. The protocol handles the rest — no custom prompting needed to get Claude to use the right tool.

### Now What? (Next)

- Start with `claude mcp add --transport http github https://api.githubcopilot.com/mcp/` (widely used)
- Use `--scope project` for team tools, `--scope user` for personal utilities
- Check token costs with `/mcp` in-session — use Tool Search to keep context lean
- For internal tools: build against the MCP SDK and add clear `server instructions` so Tool Search can route correctly

## Sources

- captured/claude-code-docs-full.md (lines 17124-17414)

## Links

- [[mcp-tool-search]]
- [[mcp-authentication]]
- [[mcp-elicitation]]
- [[managed-mcp]]
- [[hook-matchers]]
