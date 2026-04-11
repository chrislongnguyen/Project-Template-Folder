---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 5-IMPROVE
sub_system: 3-DA
type: template
iteration: 1
---

# 3-DA — Data Analysis | IMPROVE Workstream

> "Analytical accuracy that is never measured will drift — the model that worked in Iteration 1 may be wrong by Iteration 3 without anyone noticing."

DA-IMPROVE measures the quality of analytical outputs — insight accuracy, model performance, bias drift, and method-to-problem alignment. It feeds the next iteration's analytical architecture decisions.

## Cascade Position

```
[2-DP (Data Pipeline)]  ──►  [3-DA]  ──►  [4-IDM (Insights & Decision Making)]
```

Receives from upstream: deployed analysis + validation results from `4-EXECUTE/3-DA`; insight quality SLAs from `3-PLAN/3-DA`; updated data quality baseline from `5-IMPROVE/2-DP`.
Produces for downstream: `da-retro.md` + method performance data — consumed by 4-IDM as upstream insight quality constraints; analytical improvement insights consumed by 1-ALIGN (next iteration) as re-scoping input.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design stage — scope, ACs, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |
| da-retro.md | `da-retro.md` | Analysis retrospective — method performance, bias incidents, insight-to-decision gaps |
| da-metrics-baseline.md | `da-metrics-baseline.md` | Actual vs. target: insight accuracy, model performance metrics, bias test results |
| da-feedback.md | `da-feedback.md` | IDM team and stakeholder feedback on insight quality and relevance |

## Pre-Flight Checklist

- [ ] Analysis has been running on production data — enough samples for statistical validity
- [ ] Insight accuracy validated against at least one verifiable ground truth
- [ ] Bias tests re-run on production data (not just test data from EXECUTE)
- [ ] `da-retro.md` includes at least 1 method change recommendation for next iteration
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| da-retro.md | `retro-template.md` | `../../_genesis/templates/retro-template.md` |
| da-metrics-baseline.md | `metrics-baseline-template.md` | `../../_genesis/templates/metrics-baseline-template.md` |
| da-feedback.md | `feedback-template.md` | `../../_genesis/templates/feedback-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
