---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---
# Notion Adapter — STUB (Iteration 2)

> **Status: DEFERRED — Iteration 2**
>
> This adapter is deferred per spec §9.3 and §9.5. The interface contract below defines
> what must be implemented. For MVP (Iteration 1), use the OE.6.3 notion-planner skill
> directly for manual WMS sync.
>
> **Iteration 2 prerequisite:** notion-planner needs an Iteration Item Level refactor
> (per project memory: project_notion-planner-iteration-refactor.md) before bidirectional
> sync can be implemented here.

---

## Interface Contract (to be implemented in Iteration 2)

This adapter must conform to the same sync contract as the ClickUp adapter (spec §2.5).
The interface below defines the shape; implementation is deferred.

---

## 1. Status Field Mapping (.exec/ → Notion)

| .exec/ status | Notion Status | Notes |
|---|---|---|
| `ready` | `To Do` | Task created, dependencies met |
| `blocked` | `Blocked` | Blocked by/Blocker Solution properties populated |
| `in_progress` | `In Progress` | Agent working |
| `done` | `In Progress` | Agent marks complete — Human Director approves in Notion |
| `rework` | `In Progress` | Rework reason in page comment |
| `failed` | `Blocked` | Error log in Blocker property |

**Critical rule (same as ClickUp):** Agent NEVER sets Notion status to `Done`. Only
the Human Director approves completion. When .exec/ status = `done`, keep Notion at
`In Progress` and message the user for review.

---

## 2. Field Mapping (.exec/ → Notion Properties)

| .exec/ Field | Notion Property | Property Type | Notes |
|---|---|---|---|
| Task ID (D{n}-T{m}) | `Canonical Key` | text | Primary lookup key for idempotent sync |
| Task Name | Page title (Name) | title | |
| Deliverable ID | `Parent Task` + `Parent item` relations | relation | Both must be set (see task-protocol.md §0.3) |
| VANA sentence | Page body (structured section) | rich_text | In Desired Outcomes section |
| Acceptance Criteria | Page body (checklist) | rich_text | In AC Verification section |
| Definition of Done | Page body (section) | rich_text | |
| Dependencies (blocked_by) | `Blocked by` relation | relation | |
| Dependencies (blocks) | `Blocking` relation | relation | |
| Agent Model | `Tags` multi-select | multi_select | Informational only |
| Status | `Status` (native) | status | Per mapping in §1 |
| Rework reason | Page comment | comment | Append-only via notion-create-comment |
| Master Plan Item | `Master Plan Item` relation | relation | Links Task Board → Master Plan (Iteration) |
| Item Level | `Item Level` select | select | `Deliverable` · `Task` · `Sub-task` |
| MoSCoW | `Tags` multi-select | multi_select | `Must Have` · `Should Have` · `Could Have` |

---

## 3. Sync Triggers (same as ClickUp adapter §3)

| Trigger | Direction | Scope |
|---|---|---|
| Stage 4 .exec/ generation | .exec/ → Notion | All tasks (bulk create in Task Board) |
| Stage 5 task status change | .exec/ → Notion | Single task |
| Stage 6 AC results | .exec/ → Notion | Tasks with results |
| Session start | Notion → .exec/ | Unprocessed comments via notion-get-comments |
| Human status override | Notion → .exec/ | Single task |

---

## 4. Idempotency Protocol (same pattern as ClickUp)

Use `.wms-sync.json` with `"platform": "notion"` format:

```json
{
  "platform": "notion",
  "database_id": "{task_board_db_id}",
  "master_plan_db_id": "{master_plan_db_id}",
  "items": {
    "D1-T1": { "wms_id": "{notion_page_id}", "last_synced": "2026-03-22T10:00:00Z" },
    "D1-T2": { "wms_id": "{notion_page_id}", "last_synced": "2026-03-22T10:05:00Z" }
  }
}
```

**Lookup rule:** Search by `Canonical Key` property value. If found: update, don't create.

---

## 5. Conflict Resolution

Same rules as ClickUp adapter §5. Notion wins on human override.

---

## 6. Iteration 2 Requirements Checklist

Before implementing this adapter, the following must be in place:

- [ ] notion-planner refactored to support Iteration Item Level (project_notion-planner-iteration-refactor.md)
- [ ] Notion Task Board has `Canonical Key` property added (for idempotent sync lookup)
- [ ] Notion Task Board `Item Level` options include all LEP-relevant levels
- [ ] notion-get-comments MCP tool confirmed to support comment threading (for pull pattern)
- [ ] .wms-sync.json format validated against Notion page IDs (UUIDs, not short codes)
- [ ] Agent Pull Pattern (§2.4) tested end-to-end with Notion comment events

---

## 7. MVP Workaround (Use OE.6.3 notion-planner directly)

For Iteration 1, when you need to sync LEP tasks to Notion:

1. Load the OE.6.3 notion-planner skill
2. Manually map .exec/ task fields to Notion properties using the field-map.md in this directory
3. Create Task Board entries following task-protocol.md hierarchy rules
4. Set `Canonical Key` = task ID (D{n}-T{m}) for future idempotent sync compatibility
5. Document any discovered property gaps in this adapter's §6 checklist above

## Links

- [[SKILL]]
- [[blocker]]
- [[deliverable]]
- [[field-map]]
- [[iteration]]
- [[project]]
- [[task]]
- [[task-protocol]]
