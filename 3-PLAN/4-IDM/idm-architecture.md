---
version: "1.0"
status: draft
last_updated: 2026-04-05
owner: "Long Nguyen"
type: template
work_stream: 3-PLAN
stage: build
sub_system: 4-IDM
iteration: 1
---
# ARCHITECTURE TEMPLATE (T2)
> Stub template — populate during PLAN Build phase.
> Cell(s) enabled: 3-PLAN × Build
> Gap justification: ADR_TEMPLATE records one decision. No template produces an overall architecture doc (components, interfaces, data flows).

<!-- TODO: Fill in during PLAN Build phase -->

## Architecture Identity

| Field | Value |
|-------|-------|
| Sub-system | _[name]_ |
| Version | _[I1 / I2 / I3 / I4]_ |
| Owner | _[name]_ |
| Last reviewed | _[YYYY-MM-DD]_ |

## Architecture Summary

> One paragraph describing the overall structure and governing design principle.

_[Describe the architecture here.]_

## Components

| Component | Responsibility | Owner |
|-----------|---------------|-------|
| _[name]_ | _[what it does]_ | _[role]_ |
| _[name]_ | _[what it does]_ | _[role]_ |

## Interfaces

| From | To | Data / Signal | Protocol |
|------|----|---------------|----------|
| _[component]_ | _[component]_ | _[what crosses]_ | _[how]_ |

## Data Flows

> ASCII or table form. Reference P4 cross-workstream flow table in alpei-dsbv-process-map.md.

```
[Component A] ──► [Component B] ──► [Component C]
```

## Effective Principle Mapping

> Each design decision must cite the EP that governs it. Source: `2-LEARN/output/[SUBSYSTEM]-EFFECTIVE-PRINCIPLES.md`.

| Decision | Governing EP | Source |
|----------|-------------|--------|
| _[decision]_ | _[EP name]_ | _[path]_ |

## UBS Mitigation References

> Architecture must reference UBS mitigations from `3-PLAN/risks/UBS_REGISTER.md`.

| UBS Entry | Mitigation in Architecture | Register Ref |
|-----------|---------------------------|-------------|
| _[blocker]_ | _[how architecture addresses it]_ | _[UBS-###]_ |

## Open Questions

- _[question 1]_
- _[question 2]_

## Links

- [[adr-template]]
- [[alpei-dsbv-process-map]]
- [[DESIGN]]
- [[blocker]]
