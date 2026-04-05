---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: agents
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
---

# Subagent MCP Server Scoping

MCP servers can be scoped to a single subagent, keeping specialized tool descriptions out of the main conversation context and reducing tool-list noise for all other agents.

## L1 — Knowledge

### So What? (Relevance)

MCP tool descriptions consume tokens in every context where the server is connected. A Playwright browser-automation server connected to the main session inflates every agent's context with tool descriptions they don't need. Scoping MCP servers to specific subagents keeps those tokens isolated to the one agent that actually uses them.

### What Is It?

The `mcpServers` frontmatter field configures which MCP servers are available to a subagent. Two entry types:

**Inline definition** — server is connected only when this subagent runs:
```yaml
mcpServers:
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
```

**String reference** — reuses an already-configured server from the parent session:
```yaml
mcpServers:
  - github
```

Both types can be mixed in the same `mcpServers` list.

### What Else?

Inline definitions use the same schema as `.mcp.json` server entries. Supported transport types: `stdio`, `http`, `sse`, `ws`. The key is the server name.

Full example mixing both types:
```yaml
---
name: browser-tester
description: Tests features in a real browser using Playwright
mcpServers:
  - playwright:
      type: stdio
      command: npx
      args: ["-y", "@playwright/mcp@latest"]
  - github
---

Use the Playwright tools to navigate, screenshot, and interact with pages.
```

**Plugin subagents:** `mcpServers` is ignored for security when loading from a plugin. Copy the agent file to `.claude/agents/` to use MCP scoping.

### How Does It Work?

When Claude Code invokes a subagent with `mcpServers` defined:
1. **Inline servers:** New MCP connections are opened at subagent start.
2. **String references:** The parent session's existing connection is shared (no new connection opened).
3. The subagent's tool set includes only the tools from its scoped MCP servers (plus any inherited or allowlisted internal tools).
4. When the subagent finishes, inline connections are closed and cleaned up. Shared connections remain open in the parent session.

The main conversation never sees the inline server's tool descriptions — they are only visible to the subagent's context.

## L2 — Understanding

### Why Does It Work?

The inline/reference distinction maps to a connection lifecycle choice:
- **Inline:** Full isolation. Server exists only for the duration of one subagent invocation. Zero cost to other contexts.
- **Reference:** Shared connection. Avoids the overhead of starting a new process for every invocation, but the server's tools remain in the parent session's context.

The scoping capability is particularly valuable for heavyweight MCP servers (browser automation, database connectors) that have many tool descriptions. Keeping them out of the main conversation prevents context bloat and avoids confusing the main Claude instance with tools it should never call directly.

### Why Not?

- Inline MCP servers incur startup latency on every subagent invocation. For high-frequency agents, a referenced (shared) server is faster.
- `mcpServers` is not available in plugin subagents — silently ignored. If you rely on this for a plugin-distributed agent, it won't work without moving the file to `.claude/agents/`.
- String references depend on the server already being configured in the session. If the user's environment doesn't have the referenced server, the subagent starts without it — no error is thrown at definition time.

## Sources

- `captured/claude-code-docs-full.md` lines 28283–28306
- Source URL: https://code.claude.com/docs/en/sub-agents#scope-mcp-servers-to-a-subagent

## Links

- [[custom-subagents-overview]]
- [[subagent-frontmatter-fields]]
- [[subagent-tool-restrictions]]
- [[subagent-permission-modes]]
