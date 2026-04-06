---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 4-EXECUTE
sub_system: 4-IDM
type: template
iteration: 2
---

# 4-IDM — Insights & Decision Making | EXECUTE Workstream

> "Without IDM-EXECUTE, analytical results stay locked in code — stakeholders cannot act on outputs that were never packaged into a usable interface or decision artifact."

IDM-EXECUTE packages DA's computed results into the form that end users and decision-makers consume: dashboards, reports, APIs, or decision support tools. It is the delivery surface of the EXECUTE workstream and must satisfy the acceptance criteria defined in PD's DESIGN.md.

## Cascade Position

```
[3-DA (Data Analysis)]  ──►  [4-IDM]  ──►  [5-IMPROVE (workstream output)]
```

Receives from upstream: validated result sets from `4-EXECUTE/3-DA/src/` and `4-EXECUTE/3-DA/tests/`.
Produces for downstream: `src/` delivery layer (dashboards, reports, APIs), `config/` presentation config, `docs/` user-facing documentation — consumed by 5-IMPROVE as the deployed artifact that metrics and retrospectives evaluate.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Source code | `src/` | Delivery layer — dashboards, report generators, API endpoints |
| Tests | `tests/` | Acceptance tests verifying output correctness and user-facing behavior |
| Config | `config/` | Presentation configuration, routing rules, access controls |
| Docs | `docs/` | User guide, output interpretation, known limitations |

## Pre-Flight Checklist

- [ ] Confirm every acceptance criterion from `4-EXECUTE/1-PD/DESIGN.md` has a corresponding test
- [ ] Verify all outputs are traceable to DA result sets — no direct data access from IDM
- [ ] Confirm user-facing docs cover interpretation and known edge cases
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to downstream
