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
  - what_is_it_not
  - how_does_it_not_work
---

# Persistence and Enforcement — Synthesis

> Four mechanisms — CLAUDE.md, rules system, auto memory, and hooks — form a layered architecture: context injection (soft) vs. process-level enforcement (hard), and human-written vs. Claude-written knowledge.

## L1 — Knowledge

### So What? (Relevance)

Understanding which tool to use for which problem prevents the most common Claude Code configuration mistakes: putting enforcement rules in CLAUDE.md (they get ignored), trying to use hooks for instructional content (over-engineered), or relying on conversation for anything persistent (lost on compact).

### What Is It?

A cross-cutting pattern synthesized from four entities: [[claude-md-files]], [[rules-system]], [[auto-memory]], and [[hooks-lifecycle]]. The pattern is: **choose the layer that matches your guarantee requirement**.

### What Else?

**Four-layer decision matrix:**

| Mechanism | Who writes | When loads | Enforcement | Best for |
|-----------|-----------|------------|-------------|----------|
| CLAUDE.md | Human | Every session (eager) | Soft (context) | Persistent instructions, standards |
| .claude/rules/ | Human | Eager or lazy (path-triggered) | Soft (context) | Modular/scoped instructions |
| Auto memory | Claude | Every session (200 lines) | Soft (context) | Discovered patterns, preferences |
| Hooks | Human (scripts) | Every matching event | Hard (process) | Non-negotiable policy |

**The two axes:**

```
                SOFT (context)          HARD (process)
Human-written:  CLAUDE.md / rules       Hooks
Claude-written: Auto memory             (none)
```

**When each fails and the correct alternative:**
| "I need Claude to always X" → | If X is verifiable by script → Hook. If not → CLAUDE.md with specific wording |
| "Claude forgot after /compact" → | Put it in CLAUDE.md (survives compact) |
| "Claude ignores my rule" → | Make it more specific, or move to Hook if it must be guaranteed |
| "I keep repeating the same context" → | Let auto memory capture it, or add to CLAUDE.md |

### How Does It Work?

**Load order at session start:**
1. Managed policy CLAUDE.md (always, cannot exclude)
2. User CLAUDE.md (`~/.claude/CLAUDE.md`)
3. Auto memory MEMORY.md (first 200 lines)
4. Project CLAUDE.md + `.claude/CLAUDE.md`
5. `.claude/rules/*.md` (no `paths:` frontmatter = eager)
6. CLAUDE.local.md (personal, local)
7. Subdirectory CLAUDE.md + path-scoped rules = on demand

**Hooks run** outside this chain — triggered by events, not load order.

**The specificity gradient:**
```
Most specific enforcement         Least specific enforcement
├── Hooks (process-level)
├── Managed policy CLAUDE.md (cannot be excluded)
├── Project CLAUDE.md (team-shared)
├── .claude/rules/ (modular, path-scoped)
├── Auto memory (Claude-decided, session-limited)
└── User CLAUDE.md / CLAUDE.local.md (personal)
```

## L2 — Understanding

### Why Does It Work?

The system separates two fundamentally different problems:
1. **What should Claude know?** → Context layer (CLAUDE.md, rules, memory)
2. **What must happen regardless of Claude's decision?** → Hook layer

The context layer relies on the model following instructions — works 95% of the time with specific rules. The hook layer is process-level — works 100% of the time because it bypasses the model entirely. Using the right layer for the right problem keeps each layer clean and effective.

### Why Not?

- Putting non-negotiable rules in CLAUDE.md creates false confidence (looks like enforcement, isn't)
- Putting instructional content in hooks over-engineers the solution and makes configuration brittle
- Auto memory can drift — Claude may save incorrect learnings that persist across sessions
- Rules files without `paths:` load every session — don't put large topic-specific rules there

## L3 — Wisdom

### So What? (Benefit)

The four-layer architecture is the answer to "how do I make Claude reliable?" The answer is not more instructions — it is choosing the right layer for each type of requirement. Instructions belong in CLAUDE.md. Enforcement belongs in hooks. Discovery belongs in auto memory. Modularity belongs in rules.

### Now What? (Next)

Audit your current CLAUDE.md using this filter:
- "Must always happen, scriptable" → extract to Hook
- "Should always happen, but judgment involved" → keep in CLAUDE.md with specific wording
- "Relevant only to TypeScript files" → move to `.claude/rules/` with `paths: ["**/*.ts"]`
- "Claude already knows this from past work" → check if auto memory has it, delete from CLAUDE.md

### What Is It Not?

- CLAUDE.md is NOT a settings/enforcement file — it is read as context, not parsed as config
- Hooks are NOT for instructions — they are for deterministic process-level control
- Auto memory is NOT a replacement for CLAUDE.md — it captures discovered patterns, not designed rules

### How Does It Not Work?

- CLAUDE.md does not guarantee compliance — the model can deviate, especially on vague instructions
- Hooks cannot provide instructional context — they run outside the LLM, cannot influence reasoning, only decisions
- Auto memory does not load all topic files at start — only the MEMORY.md index loads; topic files require a conscious read

## Sources

- captured/claude-code-docs-full.md (lines 18298-18689 for memory/CLAUDE.md; 12504-15718 for hooks)

## Links

- [[claude-md-files]]
- [[rules-system]]
- [[auto-memory]]
- [[hooks-lifecycle]]
- [[hook-input-output]]
