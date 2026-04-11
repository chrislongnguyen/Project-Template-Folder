---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 3-PLAN
sub_system: 3-DA
type: template
iteration: 1
---

# 3-DA — Data Analysis | PLAN Workstream

> "If DA architecture is chosen before pipeline constraints are known, the analysis will be designed for an idealized dataset that may never exist."

DA-PLAN architects the analysis layer — approved methods, tooling selection, validation approach, and the mapping from pipeline outputs to insight outputs. It is bounded by PD + DP architectural constraints.

## Cascade Position

```
[2-DP (Data Pipeline)]  ──►  [3-DA]  ──►  [4-IDM (Insights & Decision Making)]
```

Receives from upstream: `3-PLAN/2-DP/dp-architecture.md` + data quality SLAs (what data is available, in what form, at what quality); Effective Principles from PD and DA LEARN (`2-LEARN/3-DA/specs/`).
Produces for downstream: `da-architecture.md` + insight quality spec — consumed by 4-IDM (Insights & Decision Making) as constraints on delivery format, refresh cadence, and confidence bounds.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design stage — scope, ACs, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |
| da-architecture.md | `da-architecture.md` | Analysis design — approved methods, tooling, pipeline-to-insight mapping, validation approach |
| da-risk-register.md | `da-risk-register.md` | Analysis-specific risks — bias, method misfit, data quality propagation |
| da-roadmap.md | `da-roadmap.md` | Sequenced DA build plan — ordered by analytical complexity and data readiness |

## Pre-Flight Checklist

- [ ] DP architecture and data quality SLAs received
- [ ] Analytical methods approved — each maps to a problem question from pd-charter.md
- [ ] Tooling selected and validated against infrastructure constraints
- [ ] Bias risks from 2-LEARN research addressed in da-architecture.md
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| da-architecture.md | `architecture-template.md` | `../../_genesis/templates/architecture-template.md` |
| da-risk-register.md | `risk-entry-template.md` | `../../_genesis/templates/risk-entry-template.md` |
| da-roadmap.md | `roadmap-template.md` | `../../_genesis/templates/roadmap-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
