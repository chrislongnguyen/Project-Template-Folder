---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 5-IMPROVE
stage: build
type: readme
sub_system: 4-IDM
iteration: 2
---

# 5-IMPROVE / 4-IDM — Insight Delivery & Management Improvement

## Purpose

Captures improvement artifacts for the Insight Delivery and Management subsystem: decision quality metrics, reporting retrospectives, stakeholder feedback, and changelogs for delivery format or process changes.

IDM is the terminal subsystem in the chain — it delivers analytical outputs to decision-makers and stakeholders. Improvement findings here address decision support quality, reporting timeliness, and stakeholder adoption. IDM retros that surface root causes in upstream subsystems must route findings back through DA, DP, or PD as appropriate.

## Cascade Position

```
5-IMPROVE/3-DA  ──►  5-IMPROVE/4-IDM
                         │
                         ▼ (root-cause routing back upstream)
              5-IMPROVE/3-DA | 5-IMPROVE/2-DP | 5-IMPROVE/1-PD
```

IDM is the primary point of stakeholder feedback collection. Issues that trace upstream must be re-filed in the appropriate subsystem's improvement artifacts.

## Contents

| Artifact Type     | Naming Pattern               | Description                                             |
|-------------------|------------------------------|---------------------------------------------------------|
| Changelog         | `idm-changelog.md`           | Versioned record of delivery format and process changes |
| Metrics           | `idm-metrics.md`             | Decision quality, report adoption, stakeholder NPS      |
| Retrospective     | `idm-retro-{YYYY-QN}.md`     | Quarterly retro for delivery quality and process        |
| Feedback          | `idm-feedback-{YYYY-MM}.md`  | Structured stakeholder feedback on insight delivery     |

## Notes

- Stakeholder feedback is the primary improvement input for IDM — prioritize collection cadence over analysis cadence.
- Decision quality metrics require post-decision review data; allow a lag of one quarter before measuring.
- Any IDM retro action that changes upstream subsystems must create a corresponding entry in that subsystem's changelog.
