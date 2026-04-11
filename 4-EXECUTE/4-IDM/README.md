---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 4-EXECUTE
sub_system: 4-IDM
type: template
iteration: 1
---

# 4-IDM — Insights & Decision Making | EXECUTE Workstream

> "A dashboard no one uses is not a delivery artifact — it is a cost. Build for the decision, not for the demo."

IDM-EXECUTE builds the insight delivery layer — dashboards, reports, APIs, and alerts — against idm-architecture.md. Every delivery artifact must be validated against a real decision use case from idm-charter.md, not just a technical spec.

## Cascade Position

```
[3-DA (Data Analysis)]  ──►  [4-IDM]  ──►  [(workstream output)]
```

Receives from upstream: 4-EXECUTE/3-DA → validated analytical outputs; 3-PLAN/4-IDM → idm-architecture.md + delivery spec.
Produces for downstream: deployed delivery layer — consumed by 5-IMPROVE/4-IDM as the artifact set to measure, monitor, and improve; closes the 4-EXECUTE cascade.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design — ACs for delivery quality and adoption readiness |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |
| src/ | `src/` | Delivery code — dashboard components, API endpoints, report templates |
| tests/ | `tests/` | Acceptance tests — user scenario tests, format compliance, access control |
| docs/ | `docs/` | User documentation — how to read, interact with, and act on each delivery artifact |
| idm-test-plan.md | `idm-test-plan.md` | Test strategy — user acceptance scenarios, performance requirements |

## Pre-Flight Checklist

- [ ] DA outputs validated and in agreed format
- [ ] Delivery format approved by target decision-makers (not just technical review)
- [ ] Access control tested — right people see right data
- [ ] At least one real user scenario tested end-to-end
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| idm-test-plan.md | `test-plan-template.md` | `../../_genesis/templates/test-plan-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
