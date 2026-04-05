---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: platform
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

# Claude Code Context Costs by Feature

Every Claude Code extension consumes some portion of the context window. Too much context degrades quality — skills may not trigger correctly, conventions may get lost in noise, and the window can fill before the task is complete. Understanding how each feature loads and what it costs lets you design an extension set that stays effective.

## L1 — Knowledge

### So What? (Relevance)

Context window space is the primary resource constraint in any Claude Code session. You cannot add extensions freely without consequence. Knowing the cost profile of each feature — what loads, when, and how much — directly controls session quality and task completion rate.

### What Is It?

Each extension feature has a distinct loading trigger and context footprint:

| Feature | When it loads | What loads | Context cost |
|---------|--------------|-----------|--------------|
| **CLAUDE.md** | Session start | Full content of all CLAUDE.md files (managed + user + project) | Every request — always present |
| **Skills** | Session start (descriptions) + when used (full content) | Descriptions always; full content on invocation | Low at rest; full content cost when invoked |
| **MCP servers** | Session start | Tool names only; full JSON schemas deferred until Claude needs a specific tool | Low (tool search on by default); grows when tools are used |
| **Subagents** | On demand, when spawned | Fresh isolated context: system prompt, preloaded skills, CLAUDE.md + git status, caller-provided prompt | Isolated — does not affect main session |
| **Hooks** | On trigger event | Nothing (runs as external script) | Zero, unless hook returns output added as messages |

### What Else?

**Skill cost control:** Set `disable-model-invocation: true` in a skill's frontmatter to hide it from Claude entirely until you invoke it manually. This drops skill cost to zero for skills that have side effects or that you always trigger yourself. Without this flag, skill descriptions are present in every request.

**MCP reliability note:** MCP connections can fail silently mid-session. If a server disconnects, its tools disappear without warning. Claude may attempt to use a tool that no longer exists. Run `/mcp` to check connection status and token cost per server.

**Subagent isolation:** Subagents do not inherit your conversation history or skills that were invoked in the main session. Skills must be declared explicitly in the subagent's `skills:` field to be preloaded. The system prompt is shared with the parent for cache efficiency.

### How Does It Work?

**CLAUDE.md** is fully loaded at session start and present on every request. Nested CLAUDE.md files in subdirectories load as you access those directories. No on-demand option — it is always-on by design.

**Skills** use a two-stage load:
1. At session start: names and descriptions of all model-invocable skills load into context.
2. When invoked (by you via `/<name>` or by Claude matching a task to a skill): full content loads into the conversation.

Skills with `disable-model-invocation: true` skip stage 1 entirely — zero cost until explicit invocation.

**In subagents**, skills work differently: they are fully preloaded at subagent launch rather than loaded on demand. Subagents cannot discover and load skills autonomously.

**MCP** loads tool names at session start via tool search (on by default). Full JSON schemas stay deferred until Claude needs a specific tool. Tool search keeps idle MCP servers cheap. Run `/mcp` to see per-server token cost.

**Hooks** run as external scripts outside the loop. They consume no context by default. If a hook script returns output, that output can be injected as messages — which does cost context.

## L2 — Understanding

### Why Does It Work?

The loading strategies match each feature's usage pattern. CLAUDE.md is always needed so it always loads. Skill descriptions need to be visible so Claude can match tasks to skills, but full content is deferred to avoid loading reference material that may not be needed. MCP tool schemas are large and numerous — deferring them until a specific tool is called keeps idle servers cheap. Hooks are side effects, so keeping them off the context by default prevents them from polluting the model's reasoning.

The design creates a natural cost gradient: zero (hooks) → deferred-until-used (MCP schemas, skill content) → always-low (skill descriptions, MCP tool names) → always-full (CLAUDE.md).

### Why Not?

**CLAUDE.md bloat is the most common failure:** Every line of CLAUDE.md costs context on every request. Reference material, API docs, and infrequently-needed conventions should be skills. The 200-line guideline exists because beyond that, CLAUDE.md degrades session quality measurably.

**Too many model-invocable skills:** Every skill description loads at session start. A large library of skills with vague or overlapping descriptions creates two problems: context noise (descriptions crowd out task-relevant content) and skill misfire (Claude loads the wrong skill or fails to load the right one).

**Unchecked MCP servers:** Multiple connected MCP servers with large tool sets add up. Disconnect servers not actively in use. The `/mcp` command shows per-server cost.

**Hook output injection:** Hooks that return substantial output on every event (e.g., ESLint output after every file edit) can silently accumulate context. Design hooks to return output only when there is a problem worth surfacing, or to summarize rather than dump raw output.

## Sources

- Claude Code docs — "Extend Claude Code" context costs section: `captured/claude-code-docs-full.md` lines 10540–10627
- Direct URL: https://code.claude.com/docs/en/features-overview

## Links

[[claude-code-extensibility-taxonomy]]
[[claude-code-fullscreen-rendering]]
[[claude-code-skills]]
[[claude-code-hooks]]
[[claude-code-mcp]]
