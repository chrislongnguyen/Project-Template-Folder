---
version: "1.0"
status: draft
last_updated: 2026-04-05
owner: ""
type: template
work_stream: 3-PLAN
stage: build
sub_system: 2-DP
iteration: 1
---
# ROADMAP TEMPLATE (T6)
> Stub template — populate during PLAN Sequence stage.
> Cell(s) enabled: 3-PLAN × Sequence
> Gap justification: SOP_TEMPLATE structures a procedure. No template structures a roadmap (milestones, dependencies, iteration mapping).

<!-- TODO: Fill in during PLAN Sequence stage -->

## Roadmap Identity

| Field | Value |
|-------|-------|
| Sub-system | _[name]_ |
| Iteration scope | _[Iteration 1 / Iteration 2 / Iteration 3 / Iteration 4]_ |
| Owner | _[name]_ |
| Research scope inherited from | `2-LEARN/research/[SUBSYSTEM]-RESEARCH-SCOPE.md` |

## Iteration Map

> Each iteration = one ALPEI cycle (ALIGN → LEARN → PLAN → EXECUTE → IMPROVE).
> Scope inherited from LEARN — do not plan work outside the researched boundary.

| Iteration | Focus | Key Milestone | Done When |
|-----------|-------|--------------|-----------|
| Iteration 1 | _[theme]_ | _[milestone name]_ | _[binary test]_ |
| Iteration 2 | _[theme]_ | _[milestone name]_ | _[binary test]_ |
| Iteration 3 | _[theme]_ | _[milestone name]_ | _[binary test]_ |
| Iteration 4 | _[theme]_ | _[milestone name]_ | _[binary test]_ |

## Current Iteration Detail — [Iteration 1 / Iteration 2 / ...]

### Milestones

| # | Milestone | Owner | Target date | Depends on | Done when |
|---|-----------|-------|-------------|------------|-----------|
| M1 | _[name]_ | _[role]_ | _[YYYY-MM-DD]_ | _[M0 / none]_ | _[binary test]_ |
| M2 | _[name]_ | _[role]_ | _[YYYY-MM-DD]_ | _[M1]_ | _[binary test]_ |
| M3 | _[name]_ | _[role]_ | _[YYYY-MM-DD]_ | _[M2]_ | _[binary test]_ |

### Critical Path

```
M1 ──► M2 ──► M3 ──► Release
```

### Dependency Map

| Milestone | Upstream dependency | Risk if delayed |
|-----------|-------------------|----------------|
| M1 | _[what must exist before M1 can start]_ | _[impact]_ |
| M2 | M1 complete | _[impact]_ |

## Driver Alignment

> Milestones must align to drivers in `3-PLAN/drivers/UDS_REGISTER.md`.

| Milestone | Leverages Driver | Driver ID |
|-----------|----------------|-----------|
| M1 | _[driver name]_ | _[UDS-###]_ |
| M2 | _[driver name]_ | _[UDS-###]_ |

## Links

- [[SEQUENCE]]
- [[UDS_REGISTER]]
- [[iteration]]
- [[roadmap]]
