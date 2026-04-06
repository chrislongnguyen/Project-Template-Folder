---
version: "1.1"
last_updated: 2026-04-05
owner: "Long Nguyen"
name: ltc-clickup-planner
description: >
  Plan and log work to ClickUp within the LTC workspace. Creates PJ Projects, PJ Workstreams (iterations),
  PJ Deliverables, Tasks, PJ Increments, PJ Documentation, and PJ Blockers with proper hierarchy,
  VANA outcomes in dedicated custom fields, UNG naming, time estimation, dependency links, and
  completion cascade. Drafts the full plan on screen first, then discusses placement with the user
  before writing. Use when the user says "plan this on ClickUp", "create ClickUp tasks", "log to
  ClickUp", or when work needs to be tracked on ClickUp. Do NOT use for Notion (use notion-planner).
argument-hint: [task description or context]
model: sonnet
allowed-tools: Read, Glob, Grep, mcp__claude_ai_ClickUp__clickup_get_workspace_hierarchy, mcp__claude_ai_ClickUp__clickup_search, mcp__claude_ai_ClickUp__clickup_get_task, mcp__claude_ai_ClickUp__clickup_create_task, mcp__claude_ai_ClickUp__clickup_update_task, mcp__claude_ai_ClickUp__clickup_filter_tasks, mcp__claude_ai_ClickUp__clickup_get_list, mcp__claude_ai_ClickUp__clickup_get_folder, mcp__claude_ai_ClickUp__clickup_get_custom_fields, mcp__claude_ai_ClickUp__clickup_add_tag_to_task, mcp__claude_ai_ClickUp__clickup_add_task_dependency, mcp__claude_ai_ClickUp__clickup_add_task_link, mcp__claude_ai_ClickUp__clickup_find_member_by_name, mcp__claude_ai_ClickUp__clickup_create_task_comment, mcp__claude_ai_ClickUp__clickup_get_workspace_members, mcp__claude_ai_ClickUp__clickup_remove_task_dependency
---
# /clickup-plan — ClickUp Work Planner

Plans and logs work to the LTC ClickUp workspace across the task type hierarchy with VANA outcomes, time estimation, and dependency management.

## 7-CS Component Mapping

This skill is an **EOP (C3)** — a reusable procedure that orchestrates the agent through planning. It compensates for specific LLM limitations:

| Component | Role | LTs Compensated |
|---|---|---|
| **This skill (EOP)** | Step-by-step procedure with validation gates | LT-3 (complex planning → steps), LT-8 (gates prevent drift) |
| **Parallel sub-agents** | One agent per Deliverable, not 28 items in one context | LT-3 (0.9^5 per agent ≫ 0.9^28 in one), LT-2 (smaller context per agent) |
| **Execution topology** | Dependency diagram in PJ Project description | LT-6 (new context reads diagram → knows what to parallelize) |
| **Field map reference** | Structured lookup for custom fields | LT-4 (precision), LT-2 (don't load all 69 fields) |
| **Templates** | Structured output per item level | LT-5 (truth over plausible freeform), LT-1 (prevents hallucinated fields) |
| **Preview + discuss gate** | Human Director approval before writes | LT-8 (alignment), LT-1 (catches errors before persist) |
| **ClickUp MCP (Tool)** | External persistent state | LT-6 (memory across sessions) |

### Derisk-First Ordering (Principle 1)

1. **Step 0 (Load)** — derisks LT-6 by loading existing state
2. **Step 1 (Scope)** — derisks LT-3 by classifying + assigning Deliverables to Iterations
3. **Step 2a (Extract VANA)** — extracts Project VANA + AC table from plan
4. **Step 2b (Assign ACs)** — assigns ACs to Workstreams → Deliverables → Tasks → Increments
5. **Step 2c (I/O Contracts)** — generates Input/Output schema chains from dependencies
6. **Step 2.5 (Quality Gate)** — derisks LT-5 with MECE AC coverage verification
7. **Step 3 (Preview + Discuss)** — derisks LT-8 with Human Director review of VANA + AC assignments at Project/Workstream/Deliverable level
8. **Step 4 (Log — parallel sub-agents)** — one sub-agent per Workstream (not per Deliverable)
9. **Step 5 (Validate)** — confirms correctness including time estimates, task types, AC coverage

Full system design: [system-design.md](./references/system-design.md)

---

## Injected Context

**Operator:** !`git config user.name`
**Date:** !`date +%Y-%m-%d`
**Repo:** !`basename $(git rev-parse --show-toplevel 2>/dev/null) 2>/dev/null || echo "unknown"`

---

## Step 0 — Load Context

Compensate for LT-6 (no persistent memory):

1. **Read MEMORY.md** — extract active project state, recent decisions, scope context.
2. **Load field map** — read [clickup-field-map.md](./references/clickup-field-map.md) for exact custom field IDs.
3. **Query ClickUp** — search for existing items in the target scope (duplicate detection + hierarchy).
4. **Resolve assignee** — `get_workspace_members` + client-side filter (NOT `find_member_by_name`).
5. If target scope is ambiguous — **ask, do not assume**.

---

## Hierarchy

```
PJ Project
  └─ PJ Workstream (iteration: I1 Concept / I2 Prototype / I3 MVE / I4 Leadership)
      └─ PJ Deliverable
          └─ Task
              ├─ PJ Increment (the testable work, 1..N)
              ├─ PJ Blocker   (impediments, 0..N, created reactively)
              └─ PJ Documentation (reference doc, 1 per Task)
```

Task types: `PJ Project` · `PJ Workstream` · `PJ Deliverable` · `null` (Task) · `PJ Increment` · `PJ Documentation` · `PJ Blocker`

Full definitions: [protocol §0](./references/clickup-task-protocol.md)

---

## Modes

| Trigger | Mode |
|---|---|
| `/clickup-plan` or "plan on ClickUp" | **CREATE** — Scope → Draft → Preview → Discuss → Log → Validate |
| "mark X done on ClickUp" / status change | **UPDATE** — Find → Transition → Cascade → Validate |
| Agent hits a blocker during execution | **BLOCKER** — Auto-create PJ Blocker under blocked Task |

- **CREATE** → [create-flow.md](./references/create-flow.md)
- **UPDATE** → [update-flow.md](./references/update-flow.md)
- **BLOCKER** → See [field-map.md § PJ Blocker](./references/clickup-field-map.md)

---

## Always/Ask/Never

| Category | Operations |
|---|---|
| **Always** (no approval) | Read/search ClickUp. Draft plan on screen. Auto-create PJ Blocker when blocked. |
| **Ask** (Human Director) | Write items to ClickUp (preview + discuss List). Mark Done. Change assignees. |
| **Never** (hard stop) | Write without preview. Write without confirming List placement. Mark parent Done with unresolved Must Have children. Guess custom field IDs. |

---

## Where Content Lives

```
VANA sentence + breakdown → Custom field: 🌐 DESIRED OUTCOMES (a382a103-456b-41a8-9b2a-8fa15a657ce4)
Acceptance criteria       → Custom field: 🌐 ACCEPTANCE CRITERIA (b74bfd0e-f112-4849-af6d-132e65e59b46)
Completion criteria       → Custom field: 🌐 DEFINITION OF DONE (5bde1429-9a92-47a8-8345-0dd0b3dc9035)
MoSCoW importance         → Custom field: 🌐 RISK-BASED IMPORTANCE (1da92ea7-e200-4d60-84d8-e8b6148ba7dd) [DROPDOWN]
Blocker details           → Custom fields: 🌐 BLOCKER(S) + 🌐 SOLUTION FOR BLOCKER

Implementation details    → Description (native field)
Links to specs/docs       → Description + 🌐 URL Link
```

**NEVER put VANA or ACs in the description.**

---

## Time Estimation

Every PJ Increment MUST have a time estimate (native field, in milliseconds).
Tasks and Deliverables get totals from their children.

Formula: `estimated_minutes × 60 × 1000` (milliseconds). Set via `update_task` AFTER creation (not available on `create_task`).

Time estimates are all-in: agent execution + overhead + user review.

---

## Discuss-Before-Write Rule

**Before writing ANYTHING to ClickUp:**
1. Draft the full plan on screen (preview format)
2. Ask the user: "Which List should this go in?" or "Which parent task?"
3. The user may provide: a List name, a parent task name, a screenshot, or "create new"
4. Confirm the exact placement before any `clickup_create_task` call

**Never assume the List.**

---

## Anti-Bloat Rules

- Single-session work with no artefact → don't log
- VANA test: one sentence or decompose
- Search ClickUp first — update existing items, don't duplicate
- Group Increments by **logical layer**, not by file

---

## PJ Blocker — Auto-Create

When the agent encounters a blocker (or user reports one):
1. Create `PJ Blocker` as subtask of the blocked Task
2. Set: name (short), status `blocked`, priority (match parent), MoSCoW `Must Have`
3. Fill `BLOCKER(S)` and `SOLUTION FOR BLOCKER` custom fields
4. Set dependency: blocked Increment `blocked by` this Blocker
5. When resolved: status → `done`, add resolution comment

---

## Rules

1. **Preview + discuss before writing.** Draft on screen → confirm List → then write.
2. **Parallel sub-agent creation is mandatory** when >1 Workstream. One agent per Workstream. Compensates LT-3.
3. **Execution topology diagram mandatory** in every PJ Project description. Shows parallel/sequential lanes + critical path.
4. **Task types are mandatory.** Use `null` for Task level (NOT `task_type: 'Task'`). Correct type on every other item.
5. **UNG naming** at Project (2-part) and Deliverable (3-part). Free text below.
6. **VANA in custom fields**, not description. Use field IDs from [field-map](./references/clickup-field-map.md).
7. **Hierarchy:** Documentation and Blockers are siblings of Increments (all children of Task).
8. **1 PJ Documentation per Task.** The reference doc for that Task's subsystem.
9. **Time estimates on every PJ Increment.** Native field, milliseconds.
10. **Dependencies at creation time** via `clickup_add_task_dependency`.
11. **Completion cascade.** Must Have children + Blockers must be resolved before parent Done.
12. **Assignees resolved via `get_workspace_members` + filter (NOT `find_member_by_name`).**
13. **Skip irrelevant fields.** Only use fields in the [field map](./references/clickup-field-map.md).
14. **VANA cascade is mandatory.** Every child item traces to specific parent AC IDs.
15. **Input/Output contracts mandatory on every item.** Dependencies follow I/O chains.
16. **Use `description` parameter (NOT `markdown_description`).** ClickUp auto-renders markdown.
17. **Status `ready/prioritized` for all items** when plan is approved.

## Halt Conditions

| Situation | Action |
|---|---|
| UNG name collision | **HALT** — ask user |
| Target List not confirmed by user | **HALT** — discuss first |
| SCOPE not in UNG Table 3a | **HALT** — governance change needed |
| Custom field ID not in field map | **HALT** — never guess |

## Related Skills

- **notion-planner** — plans on Notion (different WMS, same VANA principles)
- **compress** (`/compress`) — vault logging, not ClickUp
- **resume** (`/resume`) — reads tasks, doesn't modify ClickUp

## Links

- [[DESIGN]]
- [[VALIDATE]]
- [[blocker]]
- [[create-flow]]
- [[deliverable]]
- [[documentation]]
- [[field-map]]
- [[increment]]
- [[iteration]]
- [[project]]
- [[subtask]]
- [[system-design]]
- [[task]]
- [[update-flow]]
- [[workstream]]
