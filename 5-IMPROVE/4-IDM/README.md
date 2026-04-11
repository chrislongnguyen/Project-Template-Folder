---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 5-IMPROVE
sub_system: 4-IDM
type: template
iteration: 1
---

# 4-IDM — Insights & Decision Making | IMPROVE Workstream

> "A delivery system that stakeholders do not use has not improved — adoption is the metric, not deployment."

IDM-IMPROVE measures whether insights are actually driving decisions — usage rates, decision outcomes, stakeholder satisfaction, and the gap between what was delivered and what changed behavior. It is the final subsystem in the IMPROVE cascade and the primary input to the next iteration's 1-ALIGN scoping.

## Cascade Position

```
[3-DA (Data Analysis)]  ──►  [4-IDM]  ──►  [(workstream output)]
```

Receives from upstream: deployed delivery layer from `4-EXECUTE/4-IDM`; delivery SLAs from `1-ALIGN/4-IDM`; analytical improvement insights from `5-IMPROVE/3-DA`.
Produces for downstream: full improvement package — consumed by 1-ALIGN (next iteration) as the primary re-scoping input; closes the ALPEI loop.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design stage — scope, ACs, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |
| idm-retro.md | `idm-retro.md` | Delivery retrospective — adoption gaps, format failures, decision-support misses |
| satisfaction-metrics.md | `satisfaction-metrics.md` | Stakeholder satisfaction scores, usage rates, decision outcome tracking |
| idm-feedback.md | `idm-feedback.md` | Decision-maker feedback — what they used, what they ignored, what they need instead |

## Pre-Flight Checklist

- [ ] Delivery system in production for at least one decision cycle
- [ ] Usage data collected — not assumed from deployment logs
- [ ] At least one decision outcome tracked (did the insight change a decision?)
- [ ] `idm-retro.md` includes concrete delivery changes — format, cadence, or scope
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream (next-iteration scope → 1-ALIGN)

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| idm-retro.md | `retro-template.md` | `../../_genesis/templates/retro-template.md` |
| satisfaction-metrics.md | `metrics-baseline-template.md` | `../../_genesis/templates/metrics-baseline-template.md` |
| idm-feedback.md | `feedback-template.md` | `../../_genesis/templates/feedback-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
