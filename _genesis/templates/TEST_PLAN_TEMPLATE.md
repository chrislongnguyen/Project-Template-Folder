---
version: "1.1"
status: Draft
last_updated: 2026-03-31
owner: "Long Nguyen"
---
# TEST PLAN TEMPLATE (T8)
> Stub template — populate during IMPROVE Build phase (for EXECUTE Validate gate).
> Cell(s) enabled: 4-EXECUTE × Validate, 5-IMPROVE × Build
> Gap justification: REVIEW_TEMPLATE structures peer review. No template structures a test plan (cases, expected/actual, pass/fail, coverage).

<!-- TODO: Fill in during IMPROVE Build phase or before EXECUTE Validate gate -->

## Test Plan Identity

| Field | Value |
|-------|-------|
| Sub-system | _[name]_ |
| Artifact(s) under test | _[list of deliverable paths]_ |
| Iteration | _[I1 / I2 / I3 / I4]_ |
| Test owner | _[name]_ |
| Date | _[YYYY-MM-DD]_ |

## Scope

| In scope | Out of scope |
|----------|-------------|
| _[what is tested]_ | _[what is explicitly not tested]_ |

## Test Cases

| # | Case | Input / Setup | Expected Output | Actual Output | Pass / Fail | Notes |
|---|------|--------------|----------------|---------------|-------------|-------|
| TC-01 | _[description]_ | _[input or precondition]_ | _[expected]_ | _[actual — fill during execution]_ | _[P / F]_ | _[notes]_ |
| TC-02 | _[description]_ | _[input or precondition]_ | _[expected]_ | _[actual]_ | _[P / F]_ | _[notes]_ |
| TC-03 | _[description]_ | _[input or precondition]_ | _[expected]_ | _[actual]_ | _[P / F]_ | _[notes]_ |

## SEQUENCE.md Acceptance Criteria Coverage

> Every AC from `{workstream}/SEQUENCE.md` must map to at least one test case.

| SEQUENCE.md AC | Test Case(s) | Covered? |
|----------------|-------------|---------|
| _[AC text]_ | TC-01, TC-02 | Yes / No |
| _[AC text]_ | TC-03 | Yes / No |

## Coverage Summary

| Dimension | Count | Notes |
|-----------|-------|-------|
| Total ACs from SEQUENCE.md | _[n]_ | |
| ACs with ≥1 test case | _[n]_ | |
| Coverage % | _[n%]_ | Must be 100% before GO |

## Pass / Fail Summary

| Result | Count |
|--------|-------|
| PASS | _[n]_ |
| FAIL | _[n]_ |
| BLOCKED | _[n]_ |

## FAIL Log

> Every FAIL must have a documented exception or a fix plan before VALIDATE can pass.

| TC # | Failure description | Fix plan | Owner | Resolution date |
|------|-------------------|---------|-------|----------------|
| _[TC-##]_ | _[what failed]_ | _[fix or exception]_ | _[name]_ | _[YYYY-MM-DD]_ |

## Sign-Off

| Role | Name | Decision | Date |
|------|------|---------|------|
| Test owner | _[name]_ | _[GO / NO-GO]_ | _[YYYY-MM-DD]_ |
| Human gate (G4) | _[name]_ | _[APPROVE / REJECT]_ | _[YYYY-MM-DD]_ |
