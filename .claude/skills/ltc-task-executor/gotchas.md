# /ltc-task-executor — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Skipping increment verification

**What happens:** Agent executes an increment's Action but doesn't run its Verify command, then moves to the next increment. Errors compound — later increments build on unverified state.

**How to detect:** After each increment, check whether the Verify command was actually run and its output confirmed. A missing verify step means the agent jumped ahead.

**Fix:** Enforce Meta-Rule 2 — run EVERY increment's Verify command before proceeding. If verify fails, retry with error context (max 2 retries), then escalate. Never skip.

---

## 2. Scope drift beyond I/O contract

**What happens:** Agent starts implementing features not in the task's I/O contract or Increments list. The Scope Exclusions section exists to prevent this — but the agent doesn't read it before starting.

**How to detect:** Compare what the agent is building against the task's I/O contract outputs and Increments list. If the work doesn't map to a listed increment, scope has drifted.

**Fix:** Read the task's Scope Exclusions section BEFORE starting execution. If you find yourself building something not in the I/O contract, STOP and escalate to the Human Director.

---

## 3. Marking done without evidence

**What happens:** Agent sets status → "done" without running the task-level Verify command or confirming all AC checkboxes. Meta-Rule 4 (Verify Before Done) requires evidence for every assertion.

**How to detect:** Check whether the task-level Verify command was run AND all AC checkboxes were confirmed before the status transition to "done."

**Fix:** Before setting status → "done": (a) run the task-level Verify command, (b) confirm all AC checkboxes can be checked, (c) confirm no [INCOMPLETE] tags remain, (d) confirm outputs match the I/O contract schema.

---

## 4. status.json drift

**What happens:** status.json shows a task as "in_progress" but the task file shows "completed". This happens when sessions crash mid-update.

**How to detect:** Compare status.json state against actual task file frontmatter.

**Fix:** Always verify against task file state — task files are authoritative. Update status.json to match.

---

## 5. Multi-task context management

**What happens:** Agent loads 2+ task files into context simultaneously. Context pollutes (LT-2) and acceptance criteria cross-contaminate between tasks.

**How to detect:** Check tool calls — if multiple task files were Read in the same session without clearing context.

**Fix:** Never load more than 1 task file into context at a time. Complete one task fully before loading the next.

---

## 6. Task file corruption

**What happens:** Task file YAML frontmatter becomes malformed (truncated write, encoding issue).

**How to detect:** YAML parser fails or returns unexpected fields.

**Fix:** Do NOT attempt to fix frontmatter inline. Copy the file, fix the copy, validate, then replace. Direct editing of corrupted YAML risks losing the task definition.

## Links

- [[SKILL]]
- [[VALIDATE]]
- [[increment]]
- [[task]]
