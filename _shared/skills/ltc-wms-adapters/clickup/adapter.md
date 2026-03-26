# ClickUp Adapter — .exec/ ↔ ClickUp Sync Protocol

> This document defines how the LTC Execution Pipeline (.exec/ files) maps to the ClickUp
> work management system. Derived from spec §2.5 (WMS Sync Contract).

---

## Role of This Adapter

The ClickUp adapter translates .exec/ operations into ClickUp MCP API calls. It is the
implementation layer between the platform-agnostic LEP Execution Layer and the ClickUp
Display Layer. The adapter:

1. Reads .exec/status.json and task files
2. Creates or updates ClickUp tasks using the field-map.md UUIDs
3. Maintains .wms-sync.json as an idempotency cache
4. Pulls comments back from ClickUp at session start
5. Never treats ClickUp as authoritative — .exec/ is the source of truth

**Load before using:** `field-map.md` (UUIDs), `task-protocol.md` (hierarchy + MECE), `gotchas.md` (known issues)

### Sync Script Execution Model

The sync scripts (`_shared/scripts/wms-sync/sync-to-clickup.sh`, `_shared/scripts/wms-sync/pull-comments.sh`) are **coordination wrappers**, not autonomous executors. They:

1. Read `.exec/status.json` and compute the required ClickUp operations
2. Output `MCP_ACTION:` lines describing each operation (create, update, comment)
3. The **agent** (not the script) then executes these actions via the ClickUp MCP server tools

This design is intentional: shell scripts cannot invoke MCP tools directly — only the LLM agent can. The scripts compute the plan; the agent executes it. In `--dry-run` mode, the agent reviews the plan without executing.

---

## 1. Status Field Mapping (.exec/ → ClickUp)

| .exec/ status | ClickUp Status | Notes |
|---|---|---|
| `ready` | `ready/prioritized` | Task created, dependencies met |
| `blocked` | `blocked` | Blocked by/Blocker fields populated |
| `in_progress` | `in progress` | Agent working |
| `done` | `review` | Agent marks "review" — Human Director approves `done` in ClickUp |
| `rework` | `do again (review failed)` | Rework reason added as task comment |
| `failed` | `blocked` | Error log in comments; Blocker field populated |

**Critical rule:** The adapter NEVER sets ClickUp status to `done`. Only the Human Director
approves completion in ClickUp. When .exec/ status = `done`, the adapter sets ClickUp to
`review` and presents the review package.

---

## 2. Field Mapping (.exec/ → ClickUp Custom Fields)

| .exec/ Field | ClickUp Field | Field UUID | Notes |
|---|---|---|---|
| Task ID (D{n}-T{m}) | `ID / Short Name` | `d640d685-262f-46bd-b166-c9c546796a61` | Primary lookup key for idempotent sync |
| Task Name | Task name (native) | — | |
| Deliverable ID | Parent task (native) | — | ClickUp uses parent-child hierarchy |
| VANA sentence | `DESIRED OUTCOMES` | `a382a103-456b-41a8-9b2a-8fa15a657ce4` | Not in description |
| Acceptance Criteria | `ACCEPTANCE CRITERIA` | `b74bfd0e-f112-4849-af6d-132e65e59b46` | Not in description |
| Definition of Done | `DEFINITION OF DONE` | `5bde1429-9a92-47a8-8345-0dd0b3dc9035` | |
| Dependencies (blocked_by) | Task dependency (native) | — | Via `clickup_add_task_dependency` |
| Dependencies (blocks) | Task dependency (native) | — | Via `clickup_add_task_dependency` |
| Agent Model | Tags (native) | — | Informational only |
| Status | Status (native) | — | Per mapping in §1 |
| Rework reason | Task comment | — | Append-only via `clickup_create_task_comment` |

---

## 3. Sync Triggers and Direction

| Trigger | Direction | Scope | Mechanism |
|---|---|---|---|
| Stage 4 .exec/ generation | .exec/ → ClickUp | All tasks (bulk create) | Create in parent-before-child order |
| Stage 5 task status change | .exec/ → ClickUp | Single task | `clickup_update_task` |
| Stage 6 AC results | .exec/ → ClickUp | Tasks with results | Update AC field + comment with pass/fail |
| Stage 7 approval | .exec/ → ClickUp | All tasks | Human approves `done`; agent triggers completion cascade |
| Session start | ClickUp → .exec/ | Unprocessed comments | Pull via `clickup_get_task_comments`, create rework entries |
| Human status override | ClickUp → .exec/ | Single task | Detected on next sync; conflict resolution per §5 |

---

## 4. Idempotency Protocol (.wms-sync.json)

Every .exec/ directory that has been synced contains a `.wms-sync.json` that caches ClickUp
task IDs. This enables safe re-runs without duplicates.

**Cache file format:**
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

**Idempotency rules:**

| Operation | Rule |
|---|---|
| CREATE | Search by `ID / Short Name` field first. If found: ADOPT (update fields), don't create duplicate |
| UPDATE | Update by cached wms_id. If not found: re-run CREATE flow |
| DELETE | Never delete. Cancelled items get status change only |
| COMMENT | Check existing comments for same rework_log entry ID before adding |
| DEPENDENCIES | Set in second pass after all items exist. Re-running clears and re-creates (idempotent by design) |

---

## 5. Conflict Resolution (ClickUp Wins on Human Override)

When .exec/ and ClickUp disagree on status:

| .exec/ Status | ClickUp Status | Resolution |
|---|---|---|
| `in_progress` | Human changed to `blocked` | ClickUp wins — set .exec/ to `blocked`, pull blocker reason |
| `in_progress` | Human changed to `done` | ClickUp wins — set .exec/ to `done`, skip Stage 6 eval |
| `done` | Human changed to `do again` | ClickUp wins — set .exec/ to `rework`, pull comment for reason |
| `done` | Still `review` | No conflict — waiting for human approval |
| `blocked` | Human changed to `ready/prioritized` | ClickUp wins — set .exec/ to `ready`, clear blocker |
| Any | Human changed to `cancelled` | ClickUp wins — set .exec/ to `failed`, reason: "Cancelled by Human Director" |

**Master rule:** When a human explicitly changes ClickUp status, ClickUp wins. Log the
reconciliation in rework_log.

---

## 6. Failure Recovery

| Failure | Recovery | Escalation |
|---|---|---|
| ClickUp API timeout | Retry with exponential backoff (2s/4s/8s, max 3) | Log error, continue with remaining items |
| 502 Bad Gateway | Retry once immediately | If still fails: back off and alert user |
| Rate limit | Wait for reset (read Retry-After header) | If > 60s wait: log and skip remaining sync |
| Partial sync | Re-run full sync — idempotency ensures no duplicates | If 3 consecutive full-sync failures: escalate to Human |
| Item not found (deleted externally) | Re-create via CREATE flow | Log warning: external deletion detected |
| Auth failure | Prompt user to re-authenticate | Cannot proceed without auth; block sync |

---

## 7. Creation Order Protocol

When bulk-creating tasks during Stage 4:

1. Create the ClickUp Project item (if not exists)
2. Create PJ Deliverable items (parent = Project)
3. Create Task items (parent = Deliverable)
4. Set dependencies on all items via `clickup_add_task_dependency` (second pass)
5. Cache all created IDs in .wms-sync.json

**Discuss-Before-Write Rule (inherited from task-protocol.md §1):** Before writing to
ClickUp, draft the full plan on screen and confirm the target List with the user.

---

## 8. Task Type Mapping (.exec/ → ClickUp)

| .exec/ Level | ClickUp Task Type |
|---|---|
| LEP Project | `PJ Project` |
| LEP Deliverable | `PJ Deliverable` |
| LEP Task | `null` (built-in default, custom_item_id: 0) |

Note: LEP does not use PJ Workstream (that's an OE.6.3 ClickUp concept). LEP Deliverables
map directly under PJ Projects in the ClickUp hierarchy.
