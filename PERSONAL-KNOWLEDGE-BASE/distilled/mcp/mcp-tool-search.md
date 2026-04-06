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
---

# MCP Tool Search

> Tool Search keeps MCP context usage near-zero at session start by deferring tool schema loading — only tool names enter context, schemas load on demand when Claude uses them.

## L1 — Knowledge

### So What? (Relevance)

Before Tool Search, adding 10 MCP servers with 50 tools each could consume thousands of context tokens upfront. Tool Search makes MCP context cost proportional to actual usage, not installed capacity. For LTC sessions with multiple MCP servers, this is the difference between a lean and a bloated context window.

### What Is It?

Tool Search is Claude Code's default mechanism for managing MCP tool definitions in context. Instead of loading all tool schemas at session start, only tool _names_ are indexed. Claude uses a built-in `ToolSearch` tool to look up relevant tool definitions when a task requires them.

### What Else?

**ENABLE_TOOL_SEARCH values:**
| Value | Behavior |
|-------|----------|
| (unset) | All MCP tools deferred. Falls back to upfront loading if `ANTHROPIC_BASE_URL` is non-Anthropic |
| `true` | Force deferral even for non-Anthropic base URL |
| `auto` | Threshold mode: load upfront if fits in 10% of context window, defer overflow |
| `auto:<N>` | Custom threshold percentage (0-100), e.g., `auto:5` |
| `false` | Disable — load all schemas upfront |

**Model requirement:** Sonnet 4+, Opus 4+. Haiku does not support tool search.

**Disabling `ToolSearch` specifically:**
```json
{
  "permissions": {
    "deny": ["ToolSearch"]
  }
}
```

### How Does It Work?

1. Session starts: Claude Code connects to all MCP servers, gets tool names only
2. Claude receives a task: if it needs MCP capabilities, it calls `ToolSearch` with a description
3. Tool Search returns matching tool definitions (schemas) for relevant tools
4. Claude calls the tool; only used tools' schemas are in context

**For MCP server authors:**
- `server instructions` field helps Claude know when to search for your tools
- Descriptions truncated at 2KB — put key details first
- Clear instructions = better Tool Search routing

**Context check:** Run `/mcp` in-session to see per-server token costs.

## L2 — Understanding

### Why Does It Work?

Tool schemas (JSON descriptions of each tool's parameters) can be large. Loading them all upfront before knowing which ones a task needs is wasteful. Tool Search applies the same lazy-loading principle that makes `.claude/rules/` path-specific rules work — only load what you actually need, when you need it.

### Why Not?

- Requires Sonnet 4+ or Opus 4+ — won't work with Haiku models
- Non-Anthropic API proxies may not forward `tool_reference` blocks — Tool Search auto-disables for non-first-party `ANTHROPIC_BASE_URL` unless explicitly enabled
- Tool Search adds a round-trip (Claude calls ToolSearch, gets schemas, then calls the real tool) — slight latency overhead per first use of an MCP tool
- Poor server instructions = Claude may not find the right tools

## Sources

- captured/claude-code-docs-full.md (lines 17973-18027)

## Links

- [[mcp-server-config]]
- [[mcp-elicitation]]
- [[claude-md-files]]
