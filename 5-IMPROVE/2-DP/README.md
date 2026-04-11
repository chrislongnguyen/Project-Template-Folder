---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 5-IMPROVE
sub_system: 2-DP
type: template
iteration: 1
---

# 2-DP — Data Pipeline | IMPROVE Workstream

> "A pipeline measured only on uptime will be optimized for uptime — measure data quality or you will not improve it."

DP-IMPROVE measures pipeline performance — data quality, latency, error rates, and operational costs — against the SLAs from 3-PLAN. Pipeline improvements are the highest-leverage IMPROVE activities because quality issues here propagate to DA and IDM.

## Cascade Position

```
[1-PD (Problem Diagnosis)]  ──►  [2-DP]  ──►  [3-DA (Data Analysis)]
```

Receives from upstream: deployed pipeline + operational logs from `4-EXECUTE/2-DP`; data quality SLAs from `3-PLAN/2-DP`; PD Effective Principles from `5-IMPROVE/1-PD`.
Produces for downstream: `dp-retro.md` + pipeline improvement insights — consumed by 1-ALIGN (next iteration) as re-scoping input; updated data quality baseline consumed by `5-IMPROVE/3-DA` as upstream constraint.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design stage — scope, ACs, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |
| dp-retro.md | `dp-retro.md` | Pipeline retrospective — quality incidents, performance surprises, architecture gaps |
| dp-metrics-baseline.md | `dp-metrics-baseline.md` | Actual vs. target: data quality rates, latency P50/P95, error rates, uptime |
| dp-feedback.md | `dp-feedback.md` | DA team feedback on data quality and pipeline reliability |

## Pre-Flight Checklist

- [ ] Pipeline has been running with production-representative data
- [ ] Data quality metrics collected per source (not just aggregate)
- [ ] At least one quality incident analyzed with root cause
- [ ] `dp-retro.md` includes concrete pipeline changes for next iteration
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| dp-retro.md | `retro-template.md` | `../../_genesis/templates/retro-template.md` |
| dp-metrics-baseline.md | `metrics-baseline-template.md` | `../../_genesis/templates/metrics-baseline-template.md` |
| dp-feedback.md | `feedback-template.md` | `../../_genesis/templates/feedback-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
