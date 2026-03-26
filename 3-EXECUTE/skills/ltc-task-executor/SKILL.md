---
name: ltc-task-executor
description: Stage 5 L2 defense — re-injects critical meta-rules when executing .exec/ task files. Load this skill before executing any task.
---

# Task Executor

## When to Use

Load this skill when executing a task from an .exec/ task file. This is Stage 5 of the LTC Execution Pipeline.

## Meta-Rules (re-injected — do NOT rely on CLAUDE.md for these)

Before executing ANY task increment, apply these rules:

1. **SECURITY FIRST:** Never hardcode secrets (API keys, tokens, passwords,
   connection strings) in source code. All secrets via environment variables
   only. Scan your output for secret-like patterns before completing.
   _(Derived from: security-rules.md)_

2. **TEST EVERY INCREMENT:** Each increment's Verify command must pass before
   proceeding to the next. Do not skip verification. Do not mark an
   increment complete without running its verify command.
   _(Derived from: agent-system.md Principle 1 — derisk first)_

3. **SCOPE DISCIPLINE:** Read the task's Scope Exclusions section BEFORE
   starting. If you find yourself building something not in the I/O
   contract or Increments list, STOP. You are drifting.
   _(Derived from: general-system.md §6 — boundary enforcement)_

4. **VERIFY BEFORE DONE:** Before setting status → "done":
   a. Run the task-level Verify command
   b. Confirm all AC checkboxes can be checked
   c. Confirm no [INCOMPLETE] tags remain
   d. Confirm outputs match the I/O contract schema
   _(Derived from: agent-system.md Principle 3 — evidence before assertion)_

5. **EXISTING PATTERNS FIRST:** Follow existing codebase patterns before
   inventing new abstractions. Read adjacent files before writing new ones.
   _(Derived from: CLAUDE.md — "Follow existing patterns before inventing")_

## Execution Protocol

For each task in dependency order:

0. Load this skill (you're reading it now — L2 re-injection complete)
1. Read the task .exec/ file
2. Verify Environment prerequisites (run verify commands in Environment table)
3. Check Dependencies (all `blocked_by` tasks are "done" in status.json)
4. Set status → `in_progress` in status.json
5. Execute Increments sequentially:
   a. Perform INC-{n} Action
   b. Run INC-{n} Verify
   c. If verify fails: retry with error context (max 2 retries), then escalate
6. Run task-level Verify command
7. Set status → `done` in status.json
8. Sync WMS (per spec §2.5 — update status, add comment if rework/failed)

## Failure Behavior

| Scenario | Action |
|---|---|
| Increment verify fails | Retry with error context (max 2). If still fails: mark task `failed`, escalate to Human Director |
| Task verify fails | Re-run from the failed increment |
| Environment prereq fails | Mark task `blocked`, log the missing prerequisite |
| Dependency not done | Mark task `blocked`, wait for upstream |
| Partial completion (task fails mid-execution) | Completed increments preserved. Parallel tasks on other deliverables continue unaffected |
