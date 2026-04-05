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
  - so_what_benefit
  - now_what_next
---

# Custom Subagents — Overview

Subagents are the primary mechanism for extending Claude Code with specialized, isolated AI assistants. Understanding them is prerequisite to building any multi-agent workflow in Claude Code.

## L1 — Knowledge

### So What? (Relevance)

Every non-trivial Claude Code workflow eventually hits one of three walls: context bloat from verbose tool output, tool-access sprawl (everything can do everything), or no way to reuse a specialized prompt across tasks. Subagents solve all three simultaneously. For LTC, this is the foundation of the 4-agent MECE roster (ltc-planner / ltc-builder / ltc-reviewer / ltc-explorer).

### What Is It?

A **subagent** is a specialized AI assistant that runs in its own context window with:
- A custom system prompt (the markdown body of its definition file)
- Specific tool access (allowlist or denylist)
- Independent permissions (can be more or less permissive than parent)
- Its own model choice

Claude delegates to a subagent when the task matches the agent's `description` field. The subagent works independently and returns results to the main conversation.

Subagents are defined as **Markdown files with YAML frontmatter**, stored in one of these locations:

| Location | Scope | Priority |
|---|---|---|
| Managed settings | Organization-wide | 1 (highest) |
| `--agents` CLI flag | Current session only | 2 |
| `.claude/agents/` | Current project | 3 |
| `~/.claude/agents/` | All your projects | 4 |
| Plugin `agents/` dir | Where plugin enabled | 5 (lowest) |

When multiple subagents share the same name, higher-priority location wins.

### What Else?

**Built-in subagents** (no configuration needed):

| Agent | Model | Tools | Purpose |
|---|---|---|---|
| Explore | Haiku | Read-only | File discovery, codebase search |
| Plan | Inherits | Read-only | Codebase research during plan mode |
| General-purpose | Inherits | All | Complex multi-step tasks |
| statusline-setup | Sonnet | — | `/statusline` command |
| Claude Code Guide | Haiku | — | Feature questions |

**Subagents are NOT agent teams.** Agent teams coordinate across separate sessions with separate context windows. Subagents work within a single session. Subagents also cannot spawn other subagents — nesting is flat.

**Disabling a subagent**: Add to `permissions.deny` in settings:
```json
{ "permissions": { "deny": ["Agent(Explore)", "Agent(my-agent)"] } }
```

Or use the CLI flag: `claude --disallowedTools "Agent(Explore)"`.

### How Does It Work?

1. Claude reads all subagent `description` fields at session start.
2. When a task matches a description, Claude invokes the Agent tool with that subagent type.
3. A new context window opens with only the subagent's system prompt (plus basic env info like working directory — not the full Claude Code system prompt).
4. The subagent executes using its tool set and permission mode.
5. Results return to the main conversation context.

**Invocation patterns** (escalating from suggestion to guaranteed):
- Natural language: "Use the code-reviewer subagent..." (Claude decides)
- @-mention: `@"code-reviewer (agent)"` (guarantees that specific agent)
- Session-wide: `claude --agent code-reviewer` (replaces main thread system prompt)

**Creating subagents**: `/agents` command (interactive, recommended) or manual markdown file creation. CLI flag `--agents` accepts JSON for session-only agents.

Subagents are loaded at session start — if you add a file manually, restart or use `/agents` to load immediately.

## L2 — Understanding

### Why Does It Work?

The isolation is the key mechanism. Each subagent gets a fresh context window, so:
- Verbose exploration output (test runs, log analysis, documentation fetches) never pollutes the main conversation
- Tool restrictions are enforced at the invocation boundary — the subagent literally cannot call tools not in its allowlist
- Model routing is per-task: expensive Opus for design, cheap Haiku for search, Sonnet for building

The `description` field functions as a routing rule — Claude reads it to decide delegation. This is why a precise, action-oriented description is more important than the system prompt for reliable delegation behavior.

### Why Not?

**When not to use subagents:**
- Tasks requiring frequent back-and-forth or iterative refinement (subagents start fresh each invocation — no continuity unless explicitly resumed)
- Multi-phase work where phases share significant context (planning → implementation → testing)
- Quick, targeted changes (subagent startup latency adds overhead)
- When results from many subagents return to main conversation simultaneously — each result consumes main context, defeating the isolation benefit

**When subagents are the wrong tool:**
- Reusable prompts that run in main conversation context → use **Skills** instead
- Quick side questions without tool access → use `/btw` instead
- Sustained parallelism or tasks that exceed context window → use **agent teams** instead

## L3 — Application

### So What Benefit?

For LTC specifically: the 4-agent roster pattern (explorer/planner/builder/reviewer) maps directly to subagent definitions. Each can be scoped with precise tool restrictions (ltc-explorer: read-only, ltc-builder: write-enabled, ltc-reviewer: read-only). Project-level `.claude/agents/` files version-controlled in the template repo = portable, team-shareable behavior.

### Now What? (Next Actions)

1. Audit existing `.claude/agents/` files against the 4-agent MECE roster
2. Add `description` field language with "use proactively" for agents meant to trigger automatically
3. Consider `project` scope `memory` field for ltc-reviewer to accumulate codebase patterns across sessions
4. Read: [[subagent-frontmatter-fields]] for full config reference

## Sources

- `captured/claude-code-docs-full.md` lines 27970–28898
- Source URL: https://code.claude.com/docs/en/sub-agents

## Links

- [[subagent-frontmatter-fields]]
- [[subagent-model-selection]]
- [[subagent-tool-restrictions]]
- [[subagent-mcp-scoping]]
- [[subagent-permission-modes]]
- [[subagent-skills-preloading]]
- [[subagent-persistent-memory]]
- [[subagent-hooks]]
