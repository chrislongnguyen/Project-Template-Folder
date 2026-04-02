---
version: "1.0"
status: Draft
last_updated: 2026-04-02
workstream: PLAN
owner: "{{OWNER}}"
---
# ROADMAP — PLAN Workstream

> Milestone table and iteration mapping for project delivery.
> Source template: `_genesis/templates/ROADMAP_TEMPLATE.md`
> Scope inherited from LEARN — do not plan work outside the researched boundary.
> Driver alignment required: milestones must trace to `3-PLAN/drivers/UDS_REGISTER.md`.

<!-- TODO: Fill in during PLAN Sequence phase -->

---

## Roadmap Identity

| Field | Value |
|-------|-------|
| Sub-system | _[name]_ |
| Iteration scope | _[I1 / I2 / I3 / I4]_ |
| Owner | _[name]_ |
| Research scope inherited from | `2-LEARN/research/[SUBSYSTEM]-RESEARCH-SCOPE.md` |

---

## Iteration Map

> Each iteration = one ALPEI cycle (ALIGN → LEARN → PLAN → EXECUTE → IMPROVE).
> Scope inherited from LEARN — do not plan work outside the researched boundary.

| Iteration | Focus | Key Milestone | Done When |
|-----------|-------|--------------|-----------|
| I1 | _[theme]_ | _[milestone name]_ | _[binary test]_ |
| I2 | _[theme]_ | _[milestone name]_ | _[binary test]_ |
| I3 | _[theme]_ | _[milestone name]_ | _[binary test]_ |
| I4 | _[theme]_ | _[milestone name]_ | _[binary test]_ |

---

## Current Iteration Detail — _[I1 / I2 / ...]_

### Milestones

| # | Milestone | Owner | Target date | Depends on | Done when |
|---|-----------|-------|-------------|------------|-----------|
| M1 | _[name]_ | _[role]_ | _[YYYY-MM-DD]_ | [M0 / none] | _[binary test]_ |
| M2 | _[name]_ | _[role]_ | _[YYYY-MM-DD]_ | M1 | _[binary test]_ |
| M3 | _[name]_ | _[role]_ | _[YYYY-MM-DD]_ | M2 | _[binary test]_ |

### Critical Path

```
M1 ──► M2 ──► M3 ──► Release
```

### Dependency Map

| Milestone | Upstream dependency | Risk if delayed |
|-----------|-------------------|----------------|
| M1 | _[what must exist before M1 can start]_ | _[impact]_ |
| M2 | M1 complete | _[impact]_ |

---

## Driver Alignment

> Milestones must align to drivers in `3-PLAN/drivers/UDS_REGISTER.md`.

| Milestone | Leverages Driver | Driver ID |
|-----------|----------------|-----------|
| M1 | _[driver name]_ | _[UDS-###]_ |
| M2 | _[driver name]_ | _[UDS-###]_ |
