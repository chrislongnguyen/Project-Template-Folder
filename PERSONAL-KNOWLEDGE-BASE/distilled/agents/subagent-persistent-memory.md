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

# Subagent Persistent Memory

Persistent memory allows a subagent to accumulate knowledge across conversations — codebase patterns, recurring issues, architectural decisions — and apply that knowledge to future invocations without re-discovering it.

## L1 — Knowledge

### So What? (Relevance)

Each subagent invocation starts fresh. Without persistent memory, a code reviewer that identified 10 anti-patterns in a codebase last week starts from zero next week. The `memory` field is the mechanism to make subagents progressively smarter about a specific codebase or domain over time.

### What Is It?

The `memory` frontmatter field gives a subagent a persistent directory that survives across conversations:

```yaml
---
name: code-reviewer
description: Reviews code for quality and best practices
memory: user
---

You are a code reviewer. As you review code, update your agent memory with
patterns, conventions, and recurring issues you discover.
```

Three scope values control where the memory directory lives:

| Scope | Location | Use when |
|---|---|---|
| `user` | `~/.claude/agent-memory/<agent-name>/` | Knowledge applies across all projects |
| `project` | `.claude/agent-memory/<agent-name>/` | Knowledge is project-specific and shareable via version control |
| `local` | `.claude/agent-memory-local/<agent-name>/` | Knowledge is project-specific but must NOT be committed |

### What Else?

**What happens when memory is enabled:**
1. The subagent's system prompt is augmented with instructions for reading and writing to the memory directory.
2. The first 200 lines or 25KB of `MEMORY.md` in the memory directory (whichever comes first) is included in the system prompt at startup. The agent is instructed to curate `MEMORY.md` if it exceeds this limit.
3. Read, Write, and Edit tools are automatically enabled (even if not in the `tools` allowlist) so the agent can manage its memory files.

**Memory is a directory, not a single file.** The agent can create multiple files in its memory directory. `MEMORY.md` is the primary index — the only file automatically included in the system prompt at startup.

**Example use cases for accumulated knowledge:**
- Codebase conventions discovered during reviews
- Recurring bugs and their root causes
- Library locations and key architectural decisions
- Debugging patterns that worked for specific error types

### How Does It Work?

At subagent startup (when memory is enabled):
1. Claude Code locates the memory directory based on scope.
2. If `MEMORY.md` exists, reads first 200 lines / 25KB and injects into system prompt.
3. System prompt is augmented with memory read/write instructions.
4. Read, Write, Edit tools are added to the effective tool set.

During execution, the agent can freely read, write, and update files in its memory directory. Writes there persist after the subagent invocation completes.

On next invocation, the accumulated `MEMORY.md` content is available from turn 1.

**Recommended working pattern:**
- At task start: "Review this PR, and check your memory for patterns you've seen before."
- At task end: "Now that you're done, save what you learned to your memory."

## L2 — Understanding

### Why Does It Work?

The `MEMORY.md` injection at startup makes accumulated knowledge immediately available without requiring the agent to issue tool calls to read its memory first. The 200-line / 25KB cap prevents unbounded context growth — the agent is instructed to curate its own MEMORY.md as it grows, creating a natural compression loop.

The scope choices map to a sharing model: `project` scope checked into version control means the entire team benefits from one agent's learnings. `local` scope prevents proprietary or sensitive discoveries from being committed. `user` scope is for knowledge that spans projects (e.g., a code style preference agent).

### Why Not?

- Memory files consume startup context on every invocation. An agent with a large, un-curated MEMORY.md pays the context cost even for simple tasks.
- The automatic addition of Read/Write/Edit tools is a side effect of enabling memory — even if your `tools` allowlist excluded Write, it will be available for memory file operations. Design your security model accordingly.
- `project` scope memory files committed to version control can expose internal knowledge in public repos. Use `local` scope if the repo is public.
- There is no expiry or automatic pruning — the agent is responsible for curating its own memory. Without explicit instructions to maintain MEMORY.md, it can grow unchecked.

## L3 — Application

### So What Benefit?

For LTC: ltc-reviewer is the natural candidate for project-scope memory. Over multiple review sessions, it builds a codebase-specific knowledge base of conventions, common mistakes, and decisions. This compounds over time — the reviewer gets better without additional instruction.

### Now What? (Next Actions)

1. Add `memory: project` to ltc-reviewer definition — set up project-scope accumulation
2. Add explicit memory maintenance instructions to the reviewer's system prompt body
3. After first few review sessions, prime the agent: "Save what you learned to your memory"
4. Check `.claude/agent-memory/` for the accumulated files after sessions

## Sources

- `captured/claude-code-docs-full.md` lines 28350–28392
- Source URL: https://code.claude.com/docs/en/sub-agents#enable-persistent-memory

## Links

- [[custom-subagents-overview]]
- [[subagent-frontmatter-fields]]
- [[subagent-skills-preloading]]
- [[subagent-hooks]]
