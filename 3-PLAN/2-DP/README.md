---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 3-PLAN
sub_system: 2-DP
type: template
iteration: 1
---

# 2-DP — Data Pipeline | PLAN Workstream

> "A pipeline architected without knowing the diagnosis system's requirements will be rebuilt when the real constraints surface."

DP-PLAN architects the data pipeline — source integration, transformation logic, quality gates, and failure-recovery patterns. It is bounded by PD architecture constraints and DP Effective Principles from 2-LEARN.

## Cascade Position

```
[1-PD (Problem Diagnosis)]  ──►  [2-DP]  ──►  [3-DA (Data Analysis)]
```

Receives from upstream: `3-PLAN/1-PD/pd-architecture.md` (PD constraints on what data is needed and in what form); `2-LEARN/2-DP/specs/` (DP Effective Principles on source reliability, quality, and latency requirements).
Produces for downstream: `dp-architecture.md` + data quality SLAs — consumed by 3-DA (Data Analysis) as constraints on what analytical methods are feasible given actual data availability and quality.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design stage — scope, ACs, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |
| dp-architecture.md | `dp-architecture.md` | Pipeline design — sources, ingestion, transformation, storage, quality gates |
| dp-risk-register.md | `dp-risk-register.md` | Pipeline-specific UBS — data quality failures, source outages, schema drift |
| dp-roadmap.md | `dp-roadmap.md` | Sequenced DP build plan — ordered by data availability and dependency risks |

## Pre-Flight Checklist

- [ ] pd-architecture.md received — data requirements understood
- [ ] DP Effective Principles from 2-LEARN applied as design constraints
- [ ] Data quality SLAs defined per source (completeness, accuracy, timeliness thresholds)
- [ ] dp-risk-register.md complete — schema drift, source outage, and quality failure risks covered
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| dp-architecture.md | `architecture-template.md` | `../../_genesis/templates/architecture-template.md` |
| dp-risk-register.md | `risk-entry-template.md` | `../../_genesis/templates/risk-entry-template.md` |
| dp-roadmap.md | `roadmap-template.md` | `../../_genesis/templates/roadmap-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
