# WMS Sync Protocol

> Defines the sync contract between .exec/ files and external WMS platforms (ClickUp, Notion).
> Source: LTC Execution Pipeline Design Spec §2.5.

## Core Principle

**.exec/ is the source of truth.** WMS platforms are the Display Layer — they render .exec/ state for human consumption. Primary flow is .exec/ -> WMS. The one exception: **human feedback flows UP** from WMS to .exec/ via the Agent Pull Pattern.

**Critical rule:** Agent NEVER sets WMS status to `done`/`Done`. Only the Human Director approves completion in WMS. When .exec/ status = `done`, the agent sets WMS to `review`/`In Progress` and presents the review package.

## Status Field Mapping

| .exec/ status | ClickUp Status | Notion Status | Notes |
|---|---|---|---|
| `ready` | `ready/prioritized` | `To Do` | Task created, dependencies met |
| `blocked` | `blocked` | `Blocked` | Blocked by/Blocker fields populated |
| `in_progress` | `in progress` | `In Progress` | Agent working |
| `done` | `review` | `In Progress` | Agent marks "review" — only Human can approve `done` in WMS |
| `rework` | `do again (review failed)` | `In Progress` | Rework reason in comments |
| `failed` | `blocked` | `Blocked` | Error log in comments; Blocker field populated |

## Field Mapping Schema

| .exec/ Field | ClickUp Field | Notion Property | Notes |
|---|---|---|---|
| Task ID (D{n}-T{m}) | `ID / Short Name` custom field | `Canonical Key` (text) | Primary lookup key for idempotent sync |
| Task Name | Task name | Page title (Name) | |
| Deliverable ID | Parent task relation | `Parent Task` + `Parent item` relations | ClickUp uses parent-child; Notion uses dual relations |
| VANA sentence | `DESIRED OUTCOMES` custom field | Page body (structured) | ClickUp: dedicated field. Notion: body text |
| Acceptance Criteria | `ACCEPTANCE CRITERIA` custom field | Page body (checklist) | ClickUp: dedicated field. Notion: checklist in body |
| Definition of Done | `DEFINITION OF DONE` custom field | Page body (section) | |
| Dependencies (blocked_by) | Task dependency (native) | `Blocked by` relation | |
| Dependencies (blocks) | Task dependency (native) | `Blocking` relation | |
| Agent Model | Tag or comment | `Tags` multi-select | Informational only |
| Status | Status (native) | Status (native) | Per mapping above |
| Rework reason | Task comment | Task comment | Append-only |

## Sync Direction and Triggers

| Trigger | Direction | Scope | Mechanism |
|---|---|---|---|
| Stage 4 .exec/ generation | .exec/ -> WMS | All tasks (bulk create) | Create WMS items in parent-before-child order |
| Stage 5 task status change | .exec/ -> WMS | Single task | Update status + add comment if rework/failed |
| Stage 6 AC results | .exec/ -> WMS | Tasks with results | Update AC fields + comment with pass/fail summary |
| Stage 7 approval | .exec/ -> WMS | All tasks | Human approves `done` in WMS; agent triggers completion cascade |
| Session start | WMS -> .exec/ | Unprocessed comments | Pull comments, create rework entries |
| Human status override | WMS -> .exec/ | Single task | Detected on next sync; conflict resolution per rules below |

## Conflict Resolution

When .exec/ and WMS disagree on status:

| .exec/ Status | WMS Status | Resolution | Rationale |
|---|---|---|---|
| `in_progress` | Human changed to `blocked` | **WMS wins** — set .exec/ to `blocked`, add Blocker reason | Human override takes precedence |
| `in_progress` | Human changed to `done` | **WMS wins** — set .exec/ to `done`, skip Stage 6 eval | Human approved directly |
| `done` | Human changed to `do again` / `In Progress` | **WMS wins** — set .exec/ to `rework`, pull comment for reason | Human requested rework |
| `done` | Still `review` / `In Progress` | **No conflict** — waiting for human approval | Normal flow |
| `blocked` | Human changed to `ready/prioritized` / `To Do` | **WMS wins** — set .exec/ to `ready`, clear blocker | Human resolved externally |
| Any | Human changed to `cancelled` / `Canceled` | **WMS wins** — set .exec/ to `failed`, reason: "Cancelled by Human Director" | Human decision is final |

**Master rule:** When a human explicitly changes WMS status, WMS wins. The agent detects divergence at session start (or next sync) and reconciles .exec/ to match. The agent logs the reconciliation in rework_log.

## Idempotency Guarantees

Sync operations must be safe to re-run without creating duplicates or losing state.

| Operation | Idempotency Rule |
|---|---|
| **CREATE** | Before creating a WMS item, search by `ID / Short Name` (ClickUp) or `Canonical Key` (Notion). If found: ADOPT (update fields), don't create duplicate |
| **UPDATE** | Update by WMS item ID (cached in .exec/ after first sync). If item not found: log error, re-run CREATE flow |
| **DELETE** | Never delete WMS items. Cancelled items get status change, not deletion |
| **Comment** | Before adding a comment, check if a comment with the same rework_log entry ID already exists. If found: skip |
| **Dependencies** | Set in a second pass after all items exist. Re-running clears and re-creates dependencies (idempotent by design) |

## Sync State File

Each .exec/ directory contains a `.wms-sync.json` that caches WMS item IDs:

```json
{
  "platform": "clickup",
  "space_id": "{space}",
  "list_id": "{list}",
  "items": {
    "D1-T1": { "wms_id": "abc123", "last_synced": "2026-03-22T10:00:00Z" },
    "D1-T2": { "wms_id": "def456", "last_synced": "2026-03-22T10:05:00Z" }
  }
}
```

## Sync Failure Recovery

| Failure | Recovery | Escalation |
|---|---|---|
| WMS API timeout | Retry with exponential backoff (max 3 retries, 2s/4s/8s) | Log error, continue with remaining items |
| WMS API rate limit | Wait for rate limit reset (read `Retry-After` header) | If > 60s wait, log and skip remaining sync |
| Partial sync (some items created, others failed) | Re-run full sync — idempotency ensures no duplicates | If 3 consecutive full-sync failures, escalate to Human |
| WMS item not found (deleted externally) | Re-create via CREATE flow | Log warning: external deletion detected |
| Authentication failure | Prompt user to re-authenticate (MCP session issue) | Cannot proceed without auth; block sync |

## Bulk Create Order

When creating WMS items during Stage 4 generation:

1. Create deliverable-level items first (parent items)
2. Create task-level items second (child items)
3. Set parent-child relationships
4. Set inter-task dependencies (blocked_by/blocks)
5. Cache all WMS IDs in `.wms-sync.json`

This order ensures parent items exist before children reference them.
