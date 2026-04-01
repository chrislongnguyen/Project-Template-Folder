---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
name: ltc-notion-planner
description: >
  Plan and log work to the LTC Notion Task Board and Master Plan. Creates Iterations, Deliverables,
  Tasks, and Sub-tasks with proper 5-level hierarchy, VANA outcomes, linkage, and standardized naming
  across all Functions. Also handles status transitions (Done, Blocked, Canceled) with completion
  cascade enforcement. Use when the user says "plan this", "log this to Notion", "create a task",
  "mark X done", or when a conversation reaches alignment and needs to become trackable work.
  Do NOT use for session-end logging (/session-end) or standup queries (/session-start).
argument-hint: [task description or context]
model: sonnet
allowed-tools: Read, Glob, mcp__claude_ai_Notion__notion-search, mcp__claude_ai_Notion__notion-fetch, mcp__claude_ai_Notion__notion-create-pages, mcp__claude_ai_Notion__notion-update-page, mcp__claude_ai_Notion__notion-get-users
---
# /plan — Notion Work Planner

Converts conversation alignment into structured, linked Notion entries. Supports all LTC Functions and scopes. Creates entries across the 5-level hierarchy: Project → Iteration → Deliverable → Task → Sub-task.

## Injected Context

**Operator:** !`git config user.name`
**Date:** !`date +%Y-%m-%d`
**Repo:** !`basename $(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null || echo "unknown"`
**Task Board DB:** `collection://e4874bc4-9cea-4304-b512-43fdaf9c36cc`

---

## Step 0 — Load Context

Before any mode-specific work:

1. **Read MEMORY.md** (auto-loaded, first 200 lines) — extract active project state, recent decisions, and scope context.
2. **Query Task Board** — fetch the 5 most recent items in the target Function for ID sequence continuity and duplicate detection.
3. If the target Function is ambiguous — **ask, do not assume**.

This step compensates for agent amnesia. Every invocation starts from shared state.

---

## Modes

| Trigger                                       | Mode       | What happens                             |
| --------------------------------------------- | ---------- | ---------------------------------------- |
| `/plan` or "plan this" or "create task for X" | **CREATE** | Scope → Draft → Preview → Log → Validate |
| "mark X done" / "block X" / status change     | **UPDATE** | Find → Transition → Validate             |

---

## Mode Dispatch

- **CREATE mode** — Load [create-flow.md](./references/create-flow.md) and follow it end-to-end.
- **UPDATE mode** — Load [update-flow.md](./references/update-flow.md) and follow it end-to-end.

Before marking **any** item Done, verify the completion cascade per [protocol §0.5](./references/notion-task-protocol.md).

---

## Anti-Bloat Rules

- **Single-session work with no artefact → don't log.** Period.
- **VANA test:** If you can't write the Desired Outcome in one sentence, decompose or merge.
- **No placeholder items.** Every item needs VANA + AC. Exception: `Ideas` status (no VANA required).
- **No duplicate work.** Search Notion first — if similar work exists, update it instead of creating new.

## Halt Conditions

| Situation                               | Action                              |
| --------------------------------------- | ----------------------------------- |
| Canonical Key collision                 | **HALT** — ask user                 |
| Function not in existing DB options     | **HALT** — schema change needed     |
| SCOPE not in UNG Table 3a               | **HALT** — governance change needed |
| Unsure about any select/status/relation | **HALT** — ask user, never guess    |

Full edge cases: [protocol §7](./references/notion-task-protocol.md)

## Rules

1. **Always preview before writing.** Step 3 gate is not optional.
2. **Linkage is mandatory.** Iterations need parent Project (Parent Task + Parent item, same-DB nesting). Deliverables need parent Iteration (Master Plan Item, cross-DB). Tasks need parent Deliverable. Sub-tasks need parent Task. `Parent item` must always mirror `Parent Task`.
3. **IDs are sequential within a Function** — shared across all sub-scopes.
4. **Never invent Tags or Status values.** Use only existing DB options.
5. **Owner must be a real Notion user ID.** Resolve via `notion-get-users`.
6. **Function is never assumed.** Ask if context is ambiguous.
7. **Use templates.** Every page body follows the matching Item Level template.
8. **Completion cascade.** Never mark a parent Done if any `Must Have` child is unresolved.

## Related Skills

- **session-end** — logs session summary to vault; does NOT create Notion tasks
- **session-start** — reads Notion standup view; does NOT modify tasks
- **learn-build-cycle** — may trigger `/plan` at State A exit to log planned tasks

## Links

- [[SEQUENCE]]
- [[VALIDATE]]
- [[create-flow]]
- [[deliverable]]
- [[iteration]]
- [[project]]
- [[task]]
- [[update-flow]]
