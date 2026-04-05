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

# Subagent Skills Preloading

Skills can be injected into a subagent's context at startup, giving it domain knowledge without requiring the agent to discover and load skill files during execution.

## L1 — Knowledge

### So What? (Relevance)

A subagent starts with a blank context — it does not inherit skills from the parent conversation. If an agent needs to follow a specific convention (API patterns, error handling, team style), those conventions must be explicitly injected. The `skills` field is the mechanism.

### What Is It?

The `skills` frontmatter field lists skill names to inject at startup:

```yaml
---
name: api-developer
description: Implement API endpoints following team conventions
skills:
  - api-conventions
  - error-handling-patterns
---

Implement API endpoints. Follow the conventions and patterns from the preloaded skills.
```

The **full content** of each named skill is injected into the subagent's context — not just a reference or summary. The skill is present as part of the system context from the first turn.

### What Else?

**Skill inheritance rule:** Subagents do NOT inherit skills from the parent conversation. Skills must be listed explicitly in the `skills` field to be available.

**Relationship to `context: fork` in skills:** This is the inverse pattern.
- `skills` in a subagent: the subagent definition controls which skills are loaded, injecting content at startup.
- `context: fork` in a skill: the skill itself specifies that it should run in a new subagent context with injected content.

Both patterns use the same underlying injection mechanism.

**Skills vs on-demand invocation:** Skills listed here are injected unconditionally at startup. They are always present in context. This is different from a skill that the agent discovers and invokes during execution — preloaded skills are available from turn 1 without any `/skill-name` invocation.

### How Does It Work?

When Claude Code prepares to invoke a subagent:
1. Each skill named in the `skills` list is located (searched in the session's skill paths).
2. The full content of each skill file is read.
3. Content is injected into the subagent's system context before the first turn.
4. The subagent begins execution with skill content already in context.

The agent does not need to know the skill files exist or their paths — the content is just there.

## L2 — Understanding

### Why Does It Work?

The preloading pattern solves a bootstrapping problem: a subagent that needs conventions to do its job correctly shouldn't have to spend turns discovering those conventions. Preloading front-loads the context cost at startup instead of paying it mid-execution when the agent might already be mid-reasoning.

This is particularly effective for agents with narrow, repeatable tasks (API implementation, code review against style guide, database query patterns) where the domain knowledge is stable and always relevant.

### Why Not?

- Skills content is injected unconditionally — it consumes tokens on every invocation, even for tasks where the skill content is irrelevant. Only preload skills that are needed for the agent's core function.
- Large skills with many sections can significantly inflate the subagent's startup context. Prefer lean, focused skill files for preloading; use on-demand invocation for reference material.
- Subagents don't inherit parent skills — this is the right default (prevents implicit coupling), but it means any skill you want available must be explicitly listed. There is no wildcard or "inherit all" option.

## Sources

- `captured/claude-code-docs-full.md` lines 28328–28348
- Source URL: https://code.claude.com/docs/en/sub-agents#preload-skills-into-subagents

## Links

- [[custom-subagents-overview]]
- [[subagent-frontmatter-fields]]
- [[subagent-persistent-memory]]
