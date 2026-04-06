# /learn:review — Gotchas

Known failure patterns. Update when new issues are discovered.

---

## 1. Reviewing multiple topics at once

**What happens:** Agent batches all topics into one review session instead of one topic per invocation.

**How to detect:** The causal spine table contains rows from T1, T2, T3... in a single output. Each invocation should show only T{n}.

**Fix:** This skill is per-topic. /learn (the orchestrator) calls /learn:review once per topic. Each invocation scopes to the single topic passed as argument.

---

## 2. Skipping comprehension questions

**What happens:** Agent presents the causal spine table and jumps straight to the approval question, bypassing Active Learning.

**How to detect:** No P0–P5 comprehension questions appear in the output before the "Approve all / revise?" prompt.

**Fix:** Comprehension questions are a HARD-GATE. Ask all 6 (one per pending P-page) and wait for learner answers before presenting the approval prompt.

---

## 3. Skipping seed checks

**What happens:** Agent runs structural validation only (Step 1) and skips the P1/P2 seed consistency check (Step 2).

**How to detect:** Validation Summary shows "N/A" for Seed Check on P1 and P2. Those cells should show PASS or FAIL.

**Fix:** Seed checks on P1 and P2 are mandatory even if structural validation passes. The HARD-GATE enforces this.

---

## 4. Not writing status to file

**What happens:** Agent reports "Approved" in the output but doesn't update the page frontmatter. `/spec:extract` checks frontmatter, not conversation history.

**How to detect:** After approval, read the page file and check for `status: validated` in YAML frontmatter. If absent, approval was display-only.

**Fix:** Approval = frontmatter update. Use Edit/Write to update YAML. Display-only approval doesn't satisfy the gate.

---

## 5. Invalid status values

**What happens:** Agent writes `status: pending`, `status: complete`, or other non-standard values to frontmatter.

**How to detect:** Page frontmatter contains any status other than `validated` or `needs-revision`.

**Fix:** Only two valid values exist: `validated` or `needs-revision`. Any other value is invalid and will break downstream `/spec:extract` checks.

---

## 6. Not handling escape hatch correctly

**What happens:** Agent blocks indefinitely when learner can't answer a comprehension question, or silently skips without noting in frontmatter.

**How to detect:** After 2 failed attempts, review stalls. Or skipped questions have no `comprehension_q: skipped` in frontmatter.

**Fix:** After 2 failed attempts, add `comprehension_q: skipped` to that P-page's frontmatter and move to the next question. Review can complete with skipped Qs.

## Links

- [[SKILL]]
