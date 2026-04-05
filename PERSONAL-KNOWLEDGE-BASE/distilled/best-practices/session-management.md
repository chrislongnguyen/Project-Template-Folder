---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: best-practices
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

# Session Management in Claude Code

Context is the fundamental constraint in every Claude Code session. Managing it deliberately — clearing, compacting, checkpointing, and resuming — determines whether output quality holds over time or degrades under accumulated noise.

## L1 — Knowledge

### So What? (Relevance)

Long sessions with mixed tasks produce worse output than short, focused sessions. The tools for managing this (Esc, /clear, /rewind, /compact, checkpoints, --continue) exist precisely because Anthropic observed this failure mode at scale. Ignoring them means accepting degraded performance as sessions lengthen.

### What Is It?

A set of five distinct practices for controlling Claude Code session state:

| Practice | Primary tool | When to use |
|---|---|---|
| Course-correct early | `Esc`, `/rewind`, `/clear` | Wrong direction detected |
| Context management | `/clear`, `/compact`, `/btw` | Between tasks; approaching limits |
| Subagents for investigation | `"use subagents to investigate X"` | Research that would flood context |
| Checkpoints | `Esc+Esc` / `/rewind` | Before risky changes |
| Resume sessions | `claude --continue` / `--resume` | Multi-session tasks |

### What Else?

- `Esc` stops Claude mid-action while preserving context — you can redirect without losing work
- `Esc+Esc` (double-tap) opens the rewind menu to restore conversation, code, or both to any prior checkpoint
- Checkpoints are created automatically before every Claude action — no manual step required
- Checkpoints persist across terminal sessions — you can close and still rewind later
- Checkpoints do NOT track changes made by external processes (e.g., running `npm install` yourself)
- `/btw` answers a side question in a dismissible overlay that never enters conversation history
- Sessions can be named with `/rename` and treated like git branches for parallel workstreams
- `CLAUDE.md` can specify compaction instructions: e.g., "always preserve the full list of modified files"

### How Does It Work?

**Course-correcting:**
- `Esc` — interrupt mid-action; context preserved
- `/rewind` — open rewind menu; choose restore conversation, restore code, restore both, or summarize from here
- `"Undo that"` — natural language revert
- `/clear` — wipe context entirely; use between unrelated tasks
- Rule: if you've corrected Claude on the same issue twice, `/clear` and rewrite the prompt

**Context management:**
- `/clear` — full reset
- `/compact` — auto-summarize; Claude keeps code patterns, file states, key decisions
- `/compact Focus on the API changes` — targeted compaction
- `/btw <question>` — side question without context growth
- CLAUDE.md instruction: `"When compacting, always preserve the full list of modified files and any test commands"`

**Subagents for investigation:**
```
Use subagents to investigate how our authentication system handles token
refresh, and whether we have any existing OAuth utilities I should reuse.
```
Subagents run in separate context windows. They read files, explore code, and return summaries — main conversation stays clean.

Also useful post-implementation:
```
use a subagent to review this code for edge cases
```

**Checkpoints:**
- Auto-created before every Claude action
- `Esc+Esc` or `/rewind` to access
- Options: restore conversation only, restore code only, restore both, summarize from checkpoint
- Strategy: try risky things freely; rewind if wrong rather than planning defensively

**Resume sessions:**
```bash
claude --continue    # Resume most recent session
claude --resume      # Choose from recent sessions
```
Use `/rename` for descriptive session names: `"oauth-migration"`, `"debugging-memory-leak"`.

## L2 — Understanding

### Why Does It Work?

Context window degradation is real: as irrelevant conversation, file contents, and failed corrections accumulate, Claude's attention distributes across more noise and less signal. `/clear` restores full signal capacity. `/compact` preserves signal (decisions, patterns) while discarding noise (redundant file contents, discarded approaches).

Checkpoints work because they separate the cost of exploration from the cost of mistakes — you can take risks without permanently committing to wrong directions. This is analogous to git branches for code; Claude's checkpoint system does the same for conversation+code state.

Subagent isolation works because reading many files is the primary context budget drain during investigation. Offloading this to a subagent with its own context window means the main session's budget is spent on implementation, not research.

### Why Not?

- `/clear` loses all conversation history — use only between truly unrelated tasks, not mid-task
- Checkpoints only track Claude's changes, not yours or external tool changes — git is still required for code persistence
- Subagents add latency and API cost; for small lookups, `@file` mention is faster
- Auto-compaction can drop context you needed — customize CLAUDE.md compaction instructions proactively
- `--continue` resumes even stale sessions where the code has diverged from conversation — verify alignment after resuming

## L3 — Application

### So What Benefit?

Deliberate session hygiene is the difference between 2-hour productive sessions and 30-minute effective windows. Proper checkpointing makes risky refactors low-stakes. Session naming turns Claude into a multi-workstream tool, not just a single-task assistant.

### Now What? (Next Actions)

1. Add compaction instructions to `CLAUDE.md` now: what must survive compaction for your current project
2. Before any risky refactor, explicitly verify you're at a checkpoint (you are — Claude auto-creates them)
3. Run `/rename` at the start of each new workstream so sessions are findable later
4. Establish a personal rule: corrected twice = `/clear` and rewrite the prompt

## Sources

- `captured/claude-code-docs-full.md` lines 1444–1528 ("Manage your session")
- `captured/claude-code-docs-full.md` lines 1627–1641 ("Avoid common failure patterns")

## Links

[[communicating-with-claude-code]]
[[automation-and-scaling]]
[[skills-and-subagents]]
