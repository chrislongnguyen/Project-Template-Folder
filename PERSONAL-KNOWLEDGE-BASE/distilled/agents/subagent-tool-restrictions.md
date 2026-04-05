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
  - what_is_it_not
---

# Subagent Tool Restrictions

Tool restrictions are the primary safety boundary for subagents. They enforce the principle of least privilege at the invocation level — an agent that can't write files can't corrupt them, regardless of what its system prompt says.

## L1 — Knowledge

### So What? (Relevance)

Without tool restrictions, every subagent inherits the full tool set of the main conversation, including MCP tools. A research agent with Write access is a liability. Tool fields are the mechanism to make "read-only" a hard constraint, not a behavioral suggestion.

### What Is It?

Two frontmatter fields control tool access:

**`tools` (allowlist):** Only the listed tools are available. Everything else is denied.
```yaml
tools: Read, Grep, Glob, Bash
```

**`disallowedTools` (denylist):** Inherits all tools from the parent, then removes the listed ones.
```yaml
disallowedTools: Write, Edit
```

If both are set: `disallowedTools` is applied first (removes from the inherited pool), then `tools` is resolved against the remaining pool. A tool in both lists is removed.

### What Else?

**Restricting which subagents can be spawned** (only relevant when an agent runs as the main thread via `claude --agent`):

Use `Agent(agent-name)` syntax inside the `tools` field as an allowlist:
```yaml
tools: Agent(worker, researcher), Read, Bash
```
This agent can only spawn `worker` and `researcher` subagents. Any other spawn attempt fails.

To allow spawning any subagent: `Agent` without parentheses.
To block spawning entirely: omit `Agent` from the `tools` list.

Note: `Agent(agent_type)` has no effect in regular subagent definitions — subagents cannot spawn other subagents. It only applies when the agent runs as the main thread.

**Available internal tools** (Claude Code built-in): Read, Write, Edit, Grep, Glob, Bash, and MCP tools. By default, subagents inherit all tools from the main conversation including MCP tools.

**`Task(...)` is an alias for `Agent(...)`** (renamed in v2.1.63). Existing `Task(...)` references still work.

### How Does It Work?

At invocation time, Claude Code resolves the effective tool set:
1. Start with the parent session's tool set (all permitted tools).
2. If `disallowedTools` is set, remove those tools.
3. If `tools` is set, intersect with the remaining pool (anything not in the allowlist is removed).
4. The resulting set is what the agent can call.

The restriction is enforced at the tool call boundary — the subagent's system prompt cannot override it. If the agent tries to call Write and it's not in the resolved set, the call fails.

## L2 — Understanding

### Why Does It Work?

The allowlist/denylist duality handles two different authoring scenarios:
- **Allowlist (`tools`):** You know exactly what the agent needs. Start from nothing, add only what's required. Best for narrow, well-defined agents.
- **Denylist (`disallowedTools`):** You want the agent to inherit most capabilities but exclude specific dangerous ones. Best for general-purpose agents where you want to block writes specifically.

The intersection behavior when both are set prevents contradictions: if you accidentally list a tool in both, it's removed (denylist wins).

### Why Not?

- Tool restrictions only control which tools are callable. They don't control what the agent does with permitted tools. A Bash-enabled agent can still run destructive shell commands unless you pair it with a `PreToolUse` hook that validates commands.
- MCP tools are inherited by default. If the main session has a GitHub MCP server, a "read-only" agent specified with `tools: Read, Grep, Glob` still can't call GitHub tools (not in allowlist) — but if you use `disallowedTools: Write, Edit`, MCP tools remain available.
- Plugin subagents: `hooks` and `permissionMode` fields are ignored for security. Tool restrictions still work.

### What Is It Not?

Tool restrictions are not a substitute for `permissionMode`. `permissionMode: dontAsk` auto-denies permission prompts — it governs user confirmation, not tool availability. You can restrict tools AND set a permissionMode; they are orthogonal controls.

Tool restrictions are not hooks. Hooks (`PreToolUse`) can validate the content of a tool call (e.g., block specific SQL keywords within Bash). Tool restrictions can only allow or deny the tool call entirely.

## Sources

- `captured/claude-code-docs-full.md` lines 28229–28281
- Source URL: https://code.claude.com/docs/en/sub-agents#control-subagent-capabilities

## Links

- [[custom-subagents-overview]]
- [[subagent-frontmatter-fields]]
- [[subagent-permission-modes]]
- [[subagent-hooks]]
