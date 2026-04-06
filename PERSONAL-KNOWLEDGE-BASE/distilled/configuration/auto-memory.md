---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: configuration
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

# Auto Memory

> Auto memory lets Claude accumulate project learnings across sessions without any user effort — Claude writes notes to a per-project MEMORY.md when it discovers something worth remembering.

## L1 — Knowledge

### So What? (Relevance)

Without auto memory, every new session starts blind. Claude knows your project from CLAUDE.md but not from the lessons learned in past sessions — your preferred test commands, debugging patterns that worked, architecture decisions made in conversation. Auto memory closes this gap. LTC's `~/.claude/projects/.../memory/` directory is the auto memory location for this project.

### What Is It?

A per-project memory system where Claude writes its own notes as it works. At session start, the first 200 lines of `MEMORY.md` (or 25KB, whichever comes first) load automatically. Claude creates and updates topic files (e.g., `debugging.md`, `api-conventions.md`) and keeps `MEMORY.md` as an index.

### What Else?

**Storage location:** `~/.claude/projects/<project>/memory/`
- `<project>` derived from git repository root — all worktrees and subdirectories share one directory
- Outside git repo: project root used instead

**Default load:** First 200 lines of `MEMORY.md` or 25KB, whichever comes first. Content beyond threshold not loaded at start.

**Topic files** (e.g., `debugging.md`, `patterns.md`): NOT loaded at startup. Claude reads them on demand using file tools when needed.

**Toggle:**
- `/memory` in-session → toggle auto memory on/off
- `{"autoMemoryEnabled": false}` in project settings
- `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1` env var

**Custom storage location:**
```json
{
  "autoMemoryDirectory": "~/my-custom-memory-dir"
}
```
Accepted from policy, local, and user settings. NOT from project settings (prevents shared project redirecting writes to sensitive locations).

**Subagents** can maintain their own auto memory — see subagent configuration docs.

### How Does It Work?

1. Session ends or pause: Claude evaluates what's worth remembering (not every session, it decides)
2. Claude reads/writes files in the memory directory using its standard file tools
3. `MEMORY.md` stays concise (index); detailed notes go in topic files
4. Next session: `MEMORY.md` loads automatically (up to 200 lines/25KB)
5. Topic files loaded on demand when Claude needs specifics

**What Claude saves:** Build commands, debugging insights, architecture notes, code style preferences, workflow habits. Claude doesn't save trivia — only information that would be useful in a future conversation.

**Audit trail:** Everything is plain markdown. `/memory` in-session → link to memory folder → open any file.

**"Writing memory" / "Recalled memory"** in UI = Claude actively updating or reading `~/.claude/projects/<project>/memory/`.

**Machine-local:** Not synced across machines or cloud environments.

## L2 — Understanding

### Why Does It Work?

The tiered design (MEMORY.md index + topic files) solves the context budget problem: the index loads cheaply at session start, topic files pay context cost only when relevant. Claude maintaining its own notes (rather than users writing them) removes the friction that causes manual note-taking to fail — Claude updates memory as a natural consequence of working, not as a separate effort.

### Why Not?

- Claude decides what to save — it may skip things you'd want remembered. If you want something saved, ask explicitly ("remember that...")
- 200-line/25KB limit on `MEMORY.md` means the index itself needs curation for long-running projects
- Machine-local: switching machines loses auto memory context (unless you sync `~/.claude/projects/`)
- Worktrees share one memory directory — if worktrees have divergent contexts, memory may reflect mixed state

## L3 — Wisdom

### So What? (Benefit)

Auto memory makes Claude an accumulating collaborator rather than a stateless tool. The first session in a project Claude learned from feels different from the first session in a new project — Claude already knows your patterns.

### Now What? (Next)

- Run `/memory` to see what's been saved so far — delete stale entries
- Ask Claude to remember specific things: "remember that we use pnpm, not npm"
- For explicit persistent rules: use CLAUDE.md. For discovered learnings: let auto memory do it
- Check `MEMORY.md` is under 200 lines if you've been working in a project for a while

## Sources

- captured/claude-code-docs-full.md (lines 18580-18681)

## Links

- [[claude-md-files]]
- [[rules-system]]
