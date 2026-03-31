# /ltc-writing-plans — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Missing HOW NOT sections

**What happens:** Agent writes deliverables without HOW NOT sections, removing the primary drift guard. During execution, sub-agents take rejected approaches because nothing told them not to.

**How to detect:** After writing each deliverable, check for a `**HOW NOT:**` heading with at least 2 entries. The Plan Validation Checklist (check 7) catches this, but only if you actually run it.

**Fix:** Before moving to the next deliverable, verify the HOW NOT section exists with ≥2 entries. Each entry must state both what NOT to do and a specific reason why. Reference `references/scope-exclusions-guide.md` for common exclusion patterns.

---

## 2. Skipping plan validation checklist (Fix 4)

**What happens:** Agent presents the plan directly to the human without running the 7-check validation. Unmapped ACs, scope creep, and impossible file paths slip through. The human approves a plan with structural defects that surface during execution.

**How to detect:** Look for the Plan Validation Report block in the output before the plan is presented. If it is missing, the checklist was skipped.

**Fix:** Always run all 7 checks from `references/plan-validation-checklist.md` BEFORE presenting the plan. Generate the validation report table and include it in the output. If any check fails, fix and re-check (max 2 retries).

---

## 3. Agent architecture mismatch

**What happens:** Agent assigns "Single Agent" to a deliverable with 8+ high-complexity tasks, or "Agent Team" to a 2-task deliverable. The agent overwhelms or under-utilizes resources, causing either context degradation or unnecessary coordination overhead.

**How to detect:** Cross-reference each deliverable's task count and complexity against the 2D decision matrix in `references/agent-arch-decision-tree.md`. The Plan Validation Checklist (check 3) catches this.

**Fix:** Look up the correct pattern using the decision tree before writing the Agent Architecture line. Count tasks, assess complexity, then pick the matching cell. Do not default to "Single Agent" out of convenience.

---

## 4. Orphan tasks not mapped to ACs

**What happens:** Agent adds tasks that do not map to any VANA-SPEC AC (scope creep) or leaves ACs with no covering task (coverage gap). Both are validation check failures that lead to wasted effort or unmet requirements.

**How to detect:** Build the AC Coverage table for each deliverable. Any task row without an AC reference is an orphan. Any AC not appearing in any task row is unmapped. The Plan Validation Checklist (checks 5 and 6) catch these.

**Fix:** Before finalizing a deliverable, verify bidirectional mapping: every task covers at least one AC, and every AC is covered by at least one task. Remove orphan tasks or reclassify them. Add tasks for unmapped ACs.

---

## 5. Not running plan review loop

**What happens:** Agent skips dispatching the plan-document-reviewer subagent after writing the plan. The reviewer catches structural issues (missing HOW NOTs, AC gaps, implausible file paths) that the writing agent misses due to self-review blindness.

**How to detect:** After the plan passes validation, check whether a reviewer subagent was dispatched. If the plan goes directly to the human without a review loop, this gotcha has fired.

**Fix:** Always dispatch the plan-document-reviewer after validation passes. Provide the reviewer with the plan path and spec path only — never your session history. See `references/review-and-handoff.md` for the full dispatch protocol. Max 3 review iterations before escalating to the human.

---

## 6. EP-10 Verification Gate

**GATE — Verify:** Before presenting the plan for human review, confirm: (1) the plan file exists at the expected path, (2) it contains all required sections (Plan Document Header, File Structure, at least 1 Task with HOW NOT + Agent Architecture + AC Coverage), (3) the Plan Validation Checklist (7 checks) has been run and results are included in the plan. If any section is missing, the plan is incomplete — do not present it.

---

## 7. Escape Hatch — Plan Validation Loop

If the Plan Validation Checklist fails the same check 3 times in a row: Stop attempting fixes. Present the plan to the user with the failing checks clearly marked as WARN. Explain what you tried and why it is not resolving. User decides whether to accept, modify scope, or provide guidance. Do NOT silently lower the passing threshold or skip the check.

---

## 8. LT-1 Phantom file paths

Agent generates plausible file paths in the plan (e.g., `src/auth/middleware.py:45-60`) that do not exist in the codebase. Before finalizing the plan, run Glob or Read on every "Modify" file path. If the file does not exist, either change it to "Create" or fix the path. Observed: agents frequently reference files by guessing from project structure rather than checking.
