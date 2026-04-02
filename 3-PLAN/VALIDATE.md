---
version: "1.0"
status: Draft
last_updated: 2026-04-02
workstream: PLAN
iteration: "{{ITERATION}}"
owner: "{{OWNER}}"
---
# VALIDATE.md — PLAN Workstream

> DSBV Phase 4 artifact. Validates all PLAN artifacts against acceptance criteria in DESIGN.md.
> Source template: `_genesis/templates/REVIEW_TEMPLATE.md`
> Full sprint/execution review template: `5-IMPROVE/reviews/REVIEW_TEMPLATE.md`

<!-- TODO: Fill in during PLAN Validate phase -->

## Validation Scope

| Field | Value |
|-------|-------|
| Workstream | PLAN |
| Iteration | _[e.g., I1]_ |
| Reviewer | _[name]_ |
| Review date | _[YYYY-MM-DD]_ |
| DESIGN.md version reviewed against | _[version]_ |

---

## Artifact Checklist

> For each artifact in DESIGN.md Artifact Inventory, verify all acceptance conditions.

| # | Artifact | Path | AC | Status | Notes |
|---|----------|------|----|--------|-------|
| A1 | [artifact name] | [path] | AC-1: [condition] | PASS / FAIL | [notes] |
| A2 | [artifact name] | [path] | AC-2: [condition] | PASS / FAIL | [notes] |

---

## Blocking Issues

> List any FAIL items that must be resolved before G4 approval.

| # | Artifact | Issue | Owner | Resolution |
|---|----------|-------|-------|------------|
| 1 | _[artifact]_ | _[issue description]_ | _[owner]_ | _[resolution]_ |

---

## Gate Recommendation

| Gate | Condition | Recommendation |
|------|-----------|---------------|
| G4 | All ACs PASS, blocking issues = 0 | APPROVE / HOLD |

**Reviewer sign-off:** _[Human Director approves G4 — agents NEVER self-approve]_
