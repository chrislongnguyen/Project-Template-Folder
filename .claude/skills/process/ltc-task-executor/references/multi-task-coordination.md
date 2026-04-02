# Multi-Task Coordination

> How to handle dependencies, blocked tasks, and failures when executing multiple tasks.

## Task Dependencies

Before starting any task, check its `blocked_by` field in the task file:
1. Look up each dependency in `status.json`
2. ALL dependencies must show `"done"` status
3. If any dependency is not `done`, the task is `blocked` — do NOT start it

## Handling Blocked Tasks

When a task is blocked:
1. Set its status to `blocked` in `status.json`
2. Report the blocker to the user: which task is blocked, by which upstream task(s)
3. Skip to the next unblocked task in dependency order
4. Do NOT wait or poll — move forward with available work

## Handling Task Failure

When a task fails (increment verify fails after max retries):
1. Set status to `failed` in `status.json`
2. Preserve all completed increments (do NOT roll back)
3. Log the failure reason in a WMS comment
4. Create a follow-up task entry if the failure is recoverable
5. Do NOT retry silently — escalate to the Human Director
6. Continue with other independent tasks that are not blocked by the failed task

## Links

- [[blocker]]
- [[increment]]
- [[task]]
