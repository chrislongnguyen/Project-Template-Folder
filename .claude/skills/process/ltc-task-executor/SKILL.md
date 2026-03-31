---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
name: ltc-task-executor
description: Stage 5 L2 defense — re-injects critical meta-rules when executing .exec/ task files. Use when executing any task from the .exec/ pipeline. Load this skill before starting task execution.
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
6. HARD-GATE: Run task-level Verify command. ALL acceptance criteria must pass before proceeding. If any AC fails, stop and fix.
7. HARD-GATE: Verify all outputs exist per the I/O contract. If any output is missing, do NOT mark task complete.
8. Set status → `done` in status.json
9. Sync WMS (per spec §2.5 — update status, add comment if rework/failed)

## Gotchas

- **Skipping increment verify** — run EVERY increment's Verify command before proceeding. Unverified state compounds downstream.
- **Scope drift** — read the task's Scope Exclusions BEFORE starting. If you're building something not in the I/O contract, STOP.
- **Done without evidence** — never set status → "done" without running task-level Verify AND confirming all AC checkboxes.

Full list: [gotchas.md](gotchas.md)

## Failure Behavior

| Scenario | Action |
|---|---|
| Increment verify fails | Retry with error context (max 2). If still fails: mark task `failed`, escalate to Human Director |
| Task verify fails | Re-run from the failed increment |
| Environment prereq fails | Mark task `blocked`, log the missing prerequisite |
| Dependency not done | Mark task `blocked`, wait for upstream |
| Partial completion (task fails mid-execution) | Completed increments preserved. Parallel tasks on other deliverables continue unaffected |

**GATE — Verify:** Before setting status to "done": (1) read status.json and confirm the task entry shows "done", (2) re-run the task-level Verify command one final time, (3) confirm no `[INCOMPLETE]` tags remain in any output file. If any check fails, revert status to "in_progress" and report the specific failure.

If an increment verify command is missing or malformed (command not found, syntax error): Do NOT skip verification. Mark the increment as "unverified", continue to the next increment, and report all unverified increments to the user at task completion. Do NOT mark the task "done" if any increment is unverified.

## Gotchas

- **LT-1 Status assertion without execution:** Agent updates status.json to "done" without actually running verify commands, inferring success from code inspection alone. Always execute the verify command via Bash tool and check its exit code. Reading the code is not the same as running it.
