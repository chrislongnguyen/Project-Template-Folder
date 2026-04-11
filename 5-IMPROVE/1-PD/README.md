---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 5-IMPROVE
sub_system: 1-PD
type: template
iteration: 1
---

# 1-PD — Problem Diagnosis | IMPROVE Workstream

> "If PD improvement is skipped, the next iteration's diagnosis will be built on the same flawed assumptions — we will be faster at solving the wrong problem."

PD-IMPROVE measures the problem-diagnosis system's actual performance against the baseline KPIs from 1-ALIGN, runs a structured retrospective on the PD architecture and build decisions, and produces improvement insights for the next iteration's 1-ALIGN.

## Cascade Position

```
[(workstream-level inputs)]  ──►  [1-PD]  ──►  [2-DP (Data Pipeline)]
```

Receives from upstream: validated PD system + test results from `4-EXECUTE/1-PD`; baseline KPIs from `1-ALIGN/1-PD/pd-okr.md`.
Produces for downstream: `pd-retro.md` + improvement insights — consumed by 1-ALIGN (next iteration) as re-scoping input; PD Effective Principles govern all downstream subsystem improvements.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design stage — scope, ACs, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |
| pd-retro.md | `pd-retro.md` | PD retrospective — what worked, what failed, what changes next iteration |
| pd-metrics-baseline.md | `pd-metrics-baseline.md` | Actual vs. target comparison for all PD KPIs from `pd-okr.md` |
| pd-feedback.md | `pd-feedback.md` | Stakeholder and team feedback on PD system utility and usability |

## Pre-Flight Checklist

- [ ] PD system deployed and running — enough signal to measure
- [ ] `pd-okr.md` KPIs retrieved from `1-ALIGN/1-PD` — baseline comparison ready
- [ ] Feedback collected from at least 2 sources (team + stakeholder)
- [ ] `pd-retro.md` has at least 1 "stop doing" and 1 "start doing" — not just "do more of the same"
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| pd-retro.md | `retro-template.md` | `../../_genesis/templates/retro-template.md` |
| pd-metrics-baseline.md | `metrics-baseline-template.md` | `../../_genesis/templates/metrics-baseline-template.md` |
| pd-feedback.md | `feedback-template.md` | `../../_genesis/templates/feedback-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
