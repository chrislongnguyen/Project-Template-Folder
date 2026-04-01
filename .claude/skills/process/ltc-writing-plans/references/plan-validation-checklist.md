---
version: "1.0"
last_updated: 2026-03-30
---
# Plan Validation Checklist

> Source: LTC Execution Pipeline Design Spec §4.3 (Fix 4 — Plan Validation Checklist)
> This is the mandatory inner derisk mechanism for Stage 3 (Implementation Plan).
> All 7 checks MUST run BEFORE the plan is presented to the Human Director for approval.

---

## The 7-Point Quality Gate

| # | Check | Flag Threshold | Rationale |
|---|---|---|---|
| 1 | Total critical path duration | > 8 hours | Risk of session context loss (LT-6) |
| 2 | Max tasks per deliverable | > 6 tasks | Risk of reasoning degradation managing too many (LT-3) |
| 3 | Agent architecture matches 2D decision tree | Any mismatch | Inconsistency = downstream failure |
| 4 | All referenced file paths are plausible | Any non-existent parent dir | Prevents agent confusion during execution |
| 5 | Every VANA-SPEC AC maps to at least one task | Any unmapped AC | Coverage gap = untested requirement |
| 6 | Every task maps to at least one VANA-SPEC AC | Any orphan task | Scope creep = wasted effort |
| 7 | HOW NOT sections present for every deliverable | Any missing | Drift prevention |

---

## How to Run Each Check

### Check 1: Critical Path Duration

1. Identify all deliverables and their dependency chain (blocked_by relationships)
2. Find the longest path through the dependency graph (the critical path)
3. Estimate total hours for tasks on that path (use: Low task = 30 min, Medium = 1 hr, High = 2+ hr)
4. Flag if total > 8 hours

**Pass condition:** Critical path ≤ 8 hours estimated
**Fail action:** Split long deliverables into phased milestones, or move non-critical tasks to parallel paths

### Check 2: Max Tasks Per Deliverable

1. Count tasks in each deliverable
2. Flag any deliverable with > 6 tasks

**Pass condition:** All deliverables have ≤ 6 tasks
**Fail action:** Split the deliverable or promote sub-tasks to their own deliverable

### Check 3: Agent Architecture vs. 2D Matrix

1. For each deliverable, note: task count and estimated complexity level (Low/Medium/High)
2. Look up the expected pattern in `references/agent-arch-decision-tree.md`
3. Compare to the stated Agent Architecture in the plan
4. Flag any mismatch

**Pass condition:** Every deliverable's stated pattern matches the matrix result
**Fail action:** Update the Agent Architecture section to match the matrix, or justify the deviation explicitly

### Check 4: File Path Plausibility

1. List every file path referenced in the plan (Create/Modify/Test sections)
2. For each path, verify the parent directory either:
   a. Already exists in the repo, OR
   b. Is created in an earlier task (by index, not by assumption)
3. Flag any path where the parent directory is neither existing nor scheduled to be created

**Pass condition:** All file paths have plausible parent directories
**Fail action:** Add a directory creation step to an earlier task, or correct the file path

### Check 5: AC → Task Coverage

1. Extract all Acceptance Criteria IDs from the VANA-SPEC (§2 Noun ACs, §3 Verb ACs, §4 SustainAdv ACs, §5 Constraint ACs)
2. For each AC, find at least one task in the plan that covers it (via AC Coverage table)
3. List any AC with zero task coverage

**Pass condition:** Every VANA-SPEC AC appears in at least one AC Coverage table entry
**Fail action:** Add a task covering the unmapped AC, or document why the AC is handled implicitly (with explicit reference)

### Check 6: Task → AC Coverage

1. For each task in the plan, check its AC Coverage table entry
2. Verify at least one AC is listed
3. Flag any task with an empty or missing AC entry

**Pass condition:** Every task has at least one AC in its coverage entry
**Fail action:** Map the task to its corresponding AC, or remove the task if it genuinely covers nothing in the spec (scope creep)

### Check 7: HOW NOT Present

1. List every deliverable in the plan
2. Check each has a **HOW NOT** section with at least one entry
3. Flag any deliverable missing the section or with an empty section

**Pass condition:** Every deliverable has a non-empty HOW NOT section
**Fail action:** Write the HOW NOT section. Reference `references/scope-exclusions-guide.md` for patterns.

---

## Validation Report Template

After running all 7 checks, produce this report and include it at the end of the plan before human review:

```markdown
## Plan Validation Report

| Check | Result | Notes |
|---|---|---|
| 1. Critical path duration | PASS / WARN / FAIL | {estimated hours, e.g. "~6h"} |
| 2. Max tasks/deliverable | PASS / FAIL | {worst case, e.g. "D3: 7 tasks"} |
| 3. Agent arch vs. matrix | PASS / FAIL | {mismatches, e.g. "D5: stated Single, matrix says Sub-Agents"} |
| 4. File path plausibility | PASS / FAIL | {invalid paths, e.g. "skills/foo/bar.md (skills/foo/ not created)"} |
| 5. AC → task coverage | PASS / FAIL | {unmapped ACs, e.g. "Noun-AC3 not covered"} |
| 6. Task → AC coverage | PASS / FAIL | {orphan tasks, e.g. "Task 4.3 has no AC"} |
| 7. HOW NOT present | PASS / FAIL | {missing deliverables, e.g. "D2 missing HOW NOT"} |

**Overall: PASS / WARN / FAIL**

{If WARN or FAIL: brief summary of issues and whether they were resolved or escalated}
```

---

## Failure Behavior

| Scenario | Action |
|---|---|
| 1 or more checks FAIL | Fix the plan, re-run all 7 checks |
| Still FAIL after 2 retries | Present plan to Human Director with WARN status and validation report |
| Human Director approves with warnings | Document the accepted risks in the plan header |
| Human Director rejects | Return to plan writing with specific failure notes |

**Timeout:** 45 min wall-clock for plan generation; 15 min for validation. If validation takes longer, the plan is likely too large — split it.

---

## Stage Integration

This checklist is embedded in the Stage 3 → Stage 4 transition. The `validate-plan-coverage.py` script at `4-EXECUTE/tests/quality-gates/stage-validators/validate-plan-coverage.py` runs these checks deterministically. Manual checklist use is the fallback when the script is not yet built.

## Links

- [[DESIGN]]
- [[agent-arch-decision-tree]]
- [[deliverable]]
- [[scope-exclusions-guide]]
- [[task]]
