---
version: "1.0"
status: Draft
last_updated: 2026-04-02
workstream: PLAN
owner: "{{OWNER}}"
---
# ARCHITECTURE — PLAN Workstream

> Overall architecture document: components, interfaces, data flows.
> Source template: `_genesis/templates/ARCHITECTURE_TEMPLATE.md`
> Reference: P4 cross-workstream flow table in `_genesis/frameworks/ALPEI_DSBV_PROCESS_MAP.md`.
> UBS mitigations must trace to `3-PLAN/risks/UBS_REGISTER.md`.

<!-- TODO: Fill in during PLAN Build phase -->

---

## Architecture Identity

| Field | Value |
|-------|-------|
| Sub-system | _[name]_ |
| Version | _[I1 / I2 / I3 / I4]_ |
| Owner | _[name]_ |
| Last reviewed | _[YYYY-MM-DD]_ |

---

## Architecture Summary

> One paragraph describing the overall structure and governing design principle.

<!-- TODO: Describe the architecture here. -->

---

## Components

| Component | Responsibility | Owner |
|-----------|---------------|-------|
| _[name]_ | _[what it does]_ | _[role]_ |
| _[name]_ | _[what it does]_ | _[role]_ |

---

## Interfaces

| From | To | Data / Signal | Protocol |
|------|----|---------------|----------|
| _[component]_ | _[component]_ | _[what crosses]_ | _[how]_ |

---

## Data Flows

> ASCII or table form. Reference P4 cross-workstream flow table in ALPEI_DSBV_PROCESS_MAP.md.

```
[Component A] ──► [Component B] ──► [Component C]
```

---

## Effective Principle Mapping

> Each design decision must cite the EP that governs it. Source: `2-LEARN/output/[SUBSYSTEM]-EFFECTIVE-PRINCIPLES.md`.

| Decision | Governing EP | Source |
|----------|-------------|--------|
| _[decision]_ | _[EP name]_ | _[path]_ |

---

## UBS Mitigation References

> Architecture must reference UBS mitigations from `3-PLAN/risks/UBS_REGISTER.md`.

| UBS Entry | Mitigation in Architecture | Register Ref |
|-----------|---------------------------|-------------|
| _[blocker]_ | _[how architecture addresses it]_ | _[UBS-###]_ |

---

## Open Questions

<!-- TODO: question 1 -->
<!-- TODO: question 2 -->
