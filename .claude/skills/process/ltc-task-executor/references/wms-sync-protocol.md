# WMS Sync Protocol — Task Execution Slice

> Extracted from LTC Execution Pipeline Design Spec §2.5.
> Covers Stage 5 (task execution) sync only. Full protocol: `ltc-execution-planner/references/wms-sync-protocol.md`.

## When to Sync

Sync WMS after every task status transition during execution:
- `ready` → `in_progress` — task started
- `in_progress` → `done` — task completed (WMS gets `review`, not `done`)
- `in_progress` → `failed` — task failed after retries
- `in_progress` → `blocked` — dependency or environment issue discovered

## What to Update

| Field | When | Value |
|---|---|---|
| Status | Every transition | Per status mapping below |
| Comment | On `done`, `rework`, `failed` | Summary of what happened |
| Completion date | On `done` | ISO 8601 timestamp |
| Blockers | On `blocked` or `failed` | Blocker description |

## Status Mapping

| .exec/ status | WMS (ClickUp) | WMS (Notion) |
|---|---|---|
| `in_progress` | `in progress` | `In Progress` |
| `done` | `review` | `In Progress` |
| `blocked` | `blocked` | `Blocked` |
| `failed` | `blocked` | `Blocked` |

**Critical:** Agent NEVER sets WMS to `done`/`Done`. Only the Human Director approves completion.

## Format for Status Transitions

```
**Task status changed** — {YYYY-MM-DD}

**Task:** {D{n}-T{m}} — {Task Name}
**Transition:** {old_status} → {new_status}
**Reason:** {1-line summary}
**Blockers:** {description, or "none"}
```

## Links

- [[DESIGN]]
- [[blocker]]
- [[task]]
