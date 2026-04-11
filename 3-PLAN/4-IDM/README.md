---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 3-PLAN
sub_system: 4-IDM
type: template
iteration: 1
---

# 4-IDM — Insights & Decision Making | PLAN Workstream

> "If the delivery system is architected without knowing how decisions actually get made, insights will be accurate but unused."

IDM-PLAN architects the insight delivery system — dashboards, reports, alerts, and APIs that translate analysis outputs into decision support. It closes the PLAN cascade and its roadmap becomes the primary input for 4-EXECUTE.

## Cascade Position

```
[3-DA (Data Analysis)]  ──►  [4-IDM]  ──►  [(workstream output)]
```

Receives from upstream: `3-PLAN/3-DA/da-architecture.md` + insight quality spec (what insights are produced, at what confidence, on what cadence); all upstream Effective Principles from `2-LEARN/` for each subsystem.
Produces for downstream: `idm-architecture.md` — consumed by 4-EXECUTE/4-IDM as the build contract; `roadmap.md` — governs sequencing for all 4 subsystems within 4-EXECUTE.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design stage — scope, ACs, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |
| idm-architecture.md | `idm-architecture.md` | Delivery design — format, tooling, API spec, refresh cadence, access control |
| roadmap.md | `roadmap.md` | Project-wide execution roadmap — all subsystems, sequenced by risk and dependency |
| idm-risk-register.md | `idm-risk-register.md` | Delivery risks — adoption failures, stakeholder misalignment, tool limitations |

## Pre-Flight Checklist

- [ ] DA architecture received — insight format and quality spec understood
- [ ] Target delivery formats approved by decision-makers
- [ ] Adoption risks from 2-LEARN research addressed in architecture
- [ ] roadmap.md approved by sponsor — all subsystems covered, sequenced by risk
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| idm-architecture.md | `architecture-template.md` | `../../_genesis/templates/architecture-template.md` |
| idm-risk-register.md | `risk-entry-template.md` | `../../_genesis/templates/risk-entry-template.md` |
| roadmap.md | `roadmap-template.md` | `../../_genesis/templates/roadmap-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
