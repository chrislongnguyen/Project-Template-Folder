# Task Status Transitions

Valid status transitions during Stage 5 execution:

## State Machine

```
ready → in_progress → done
ready → blocked (dependency not met)
blocked → ready (dependency resolved)
in_progress → failed (increment verify fails after 2 retries)
in_progress → blocked (environment prereq fails mid-execution)
failed → in_progress (rework — Human Director approval)
```

## Transition Rules

| From | To | Trigger | WMS Sync |
|---|---|---|---|
| ready | in_progress | Task execution begins (Protocol step 4) | Update status |
| in_progress | done | Task-level verify passes + all ACs checked (Protocol step 7) | Update status + comment |
| in_progress | failed | Increment verify fails after 2 retries | Update status + comment with error |
| in_progress | blocked | Environment prereq fails mid-execution | Update status + log prereq |
| ready | blocked | Dependency task not "done" | Update status |
| blocked | ready | Upstream dependency completes | Update status |

## Rules

- Only "done" tasks satisfy downstream dependencies
- "failed" tasks require Human Director approval before retry
- Completed increments within a failed task are preserved (no rollback)
- WMS sync happens on EVERY status change

## Links

- [[increment]]
- [[task]]
