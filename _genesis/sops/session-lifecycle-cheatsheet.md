---
version: "1.0"
status: Draft
last_updated: 2026-04-02
type: sop
work_stream: govern
stage: build
sub_system: session-lifecycle
---

# Session Lifecycle Cheatsheet

## Canonical Workflow

1. `/compress` — save session to Memory Vault
2. `/clear` — clear context window
3. `/resume` — reload from vault (new session)

Never use session-start or session-end — both are deprecated.

## Command Reference

| Command | What it does | When to use | Token cost |
|---------|-------------|-------------|-----------|
| `/compress` | Saves session: rich frontmatter (goal, state, open_items, next_action) + body ≤20 lines. Auto-updates MEMORY.md Briefing Card. | End of working session or when context fills | ~500 tokens |
| `/clear` | Clears the context window entirely | After `/compress`, before starting fresh | 0 tokens |
| `/resume` | 2-pass recall: frontmatter scan (3 files, ~500 tokens) + body of 1 most relevant file (~2K tokens) | Start of any new session | 3–5K tokens |

## Deprecated Commands

| Command | Status | Use instead |
|---------|--------|-------------|
| `/session-start` | DEPRECATED | `/resume` |
| `/session-end` | DEPRECATED | `/compress` then `/clear` |

## Token Savings

| Metric | Old (`/resume` pre-Cycle 1) | New (`/resume` post-Cycle 1) |
|--------|---------------------------|------------------------------|
| Context loaded per session | ~35K tokens | 3–5K tokens |
| % of 200K window consumed | 15–20% | 2–3% |
| Savings | — | ~30K tokens per session |

### What changed

Before Cycle 1, `/resume` loaded every session file in full. After the refactor, it uses a 2-pass approach: frontmatter scan first (~500 tokens to identify the 3 most relevant sessions), then body load of 1 file (~2K tokens). The other 30K tokens stay available for actual work.
