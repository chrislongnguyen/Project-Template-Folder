---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---
# Notion Field Map — LEP Task Board Property Mapping

> Maps LEP .exec/ fields to Notion Task Board and Master Plan database properties.
> Derived from OE.6.3 notion-planner schema (live workspace, 2026-03-22).

---

## Task Board Database Properties

### Always Set (on CREATE)

| Property | Type | LEP Source | Valid Values / Format |
|---|---|---|---|
| **Name** | title | Task Name (formatted per naming-rules.md) | `[{DISPLAY}]_{FA}.{ID}. {Title}` |
| **Canonical Key** | text | Task ID (D{n}-T{m}) | Primary idempotency key. Format: `{SCOPE}_{FA}.{ID}.{SLUG}` |
| **Item Level** | select | .exec/ task level | `Deliverable` · `Task` · `Sub-task` |
| **Function** | multi_select | Project function area | `LTC` · `OPS` · `INV` · `INVTECH` |
| **Status** | status | .exec/ status (mapped) | `Ideas` · `To Do` · `In Progress` · `Blocked` · `Done` · `Canceled` |
| **Priority** | select | .exec/ agent_model + urgency | `URGENT` · `HIGH` · `NORMAL` · `LOW` |
| **Owner** | person | Assigned agent / human | Notion user ID |
| **Tags** | multi_select | MoSCoW + Agent Model | `Must Have` · `Should Have` · `Could Have` · model tags |

### Conditional (set when applicable)

| Property | Type | LEP Source | Condition |
|---|---|---|---|
| **Master Plan Item** | relation | Deliverable → Iteration link | Always for Deliverables |
| **Parent Task** | relation | .exec/ parent deliverable/task | Item Level = Task or Sub-task |
| **Parent item** | relation | Same as Parent Task | **Must mirror Parent Task exactly** |
| **Blocked by** | relation | .exec/ blocked_by dependencies | When task is blocked |
| **Blocking** | relation | .exec/ blocks dependencies | When this task blocks others |
| **Completed Date** | date | .exec/ completed_at | When Status → Done |
| **Target Date** | date | Plan deadline | When deadline is known |
| **Estimate** | number | .exec/ time estimate | Hours as decimal |
| **Sub-task Type** | select | .exec/ task type | `Increment` · `Blocker 🔴` · `Documentation` |
| **Blocker** | text | .exec/ blocked reason | When Status = Blocked |
| **Blocker Solution** | text | Proposed resolution | When Blocker is set |
| **Action Plan** | text | .exec/ Increments list | Steps from INC-1, INC-2, etc. |
| **References** | text | .exec/ References section | Input docs and spec sections |
| **Artifacts** | text | .exec/ outputs | Links to produced files (on Done) |

### Recommended

| Property | Type | LEP Source | Format |
|---|---|---|---|
| **Desired Outcomes** | text | .exec/ VANA sentence | `{User} {Verb} {Adverb} {Noun} that is {Adjective}.` |
| **Acceptance Criteria** | text | .exec/ AC checkboxes | `- [ ] AC-1: {criterion}` |

### Never Set Manually

| Property | Reason |
|---|---|
| **Linear ID** | Only on items migrated from Linear |
| **Last Edited Time** | Auto-managed by Notion |

---

## .exec/ Status → Notion Status Mapping

| .exec/ status | Notion Status | Notes |
|---|---|---|
| `ready` | `To Do` | |
| `blocked` | `Blocked` | Set Blocker + Blocker Solution + Blocked by |
| `in_progress` | `In Progress` | |
| `done` | `In Progress` | Agent finishes; stays In Progress until Human approves |
| `rework` | `In Progress` | Rework reason in comment |
| `failed` | `Blocked` | Error in Blocker property |

---

## Master Plan Database Properties

Used for Iteration-level items (LEP Deliverable group / phase).

| Property | Type | LEP Source |
|---|---|---|
| **Name** | title | Iteration name (Iteration 1 Concept, Iteration 2 Prototype, etc.) |
| **Parent Task** | relation | Parent Project page in Master Plan |
| **Parent item** | relation | Same as Parent Task |
| **Status** | status | Aggregate status of child Deliverables |

---

## Notion Database IDs (fill in at runtime)

| Database | ID |
|---|---|
| Task Board | `{task_board_db_id}` — retrieve via notion-fetch or workspace search |
| Master Plan | `{master_plan_db_id}` — retrieve via notion-fetch or workspace search |

---

## Key Rules (from notion-task-protocol.md)

1. **Parent item MUST mirror Parent Task.** If only Parent Task is set, nesting silently fails.
2. **Deliverables connect to Iterations via Master Plan Item** (not Parent Task — those stay empty at Deliverable level).
3. **Canonical Key is the idempotency key** — search by Canonical Key before creating.
4. **Tags for MoSCoW** — Deliverables default to `Must Have`; Tasks/Sub-tasks require explicit MoSCoW tag.
5. **Desired Outcomes and Acceptance Criteria** go in dedicated Notion properties, not just page body.

## Links

- [[blocker]]
- [[deliverable]]
- [[documentation]]
- [[increment]]
- [[iteration]]
- [[naming-rules]]
- [[notion-task-protocol]]
- [[project]]
- [[schema]]
- [[task]]
