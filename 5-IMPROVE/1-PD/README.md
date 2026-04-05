---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 5-IMPROVE
stage: build
type: readme
sub_system: 1-PD
iteration: 2
---

# 5-IMPROVE / 1-PD — Problem Diagnosis Improvement

## Purpose

Captures improvement artifacts for the Problem Diagnosis subsystem: changelogs tracking what changed and why, retrospectives surfacing what broke or slowed PD cycles, metrics measuring diagnostic accuracy and cycle time, and feedback from consumers of PD outputs.

PD is the upstream anchor of the 4-subsystem chain. Improvement findings here may require re-alignment across all downstream subsystems (DP, DA, IDM). Any retro that changes a PD principle, framework, or template must trigger a cascade review.

## Cascade Position

```
5-IMPROVE/1-PD  ──►  5-IMPROVE/2-DP
                 ──►  5-IMPROVE/3-DA
                 ──►  5-IMPROVE/4-IDM
```

PD improvement artifacts are inputs to downstream retros when PD-level changes are detected.

## Contents

| Artifact Type     | Naming Pattern              | Description                                      |
|-------------------|-----------------------------|--------------------------------------------------|
| Changelog         | `pd-changelog.md`           | Versioned record of PD subsystem changes         |
| Metrics           | `pd-metrics.md`             | Baseline and current measurements for PD health  |
| Retrospective     | `pd-retro-{YYYY-QN}.md`     | Quarterly retro for PD cycle quality             |
| Feedback          | `pd-feedback-{YYYY-MM}.md`  | Collected feedback from PD output consumers      |

## Notes

- Retros follow the 3-pillar lens: Sustainability first, then Efficiency, then Scalability.
- Changes to PD frameworks or templates must be logged in `pd-changelog.md` before propagating downstream.
- Metrics targets are set in PLAN workstream (`3-PLAN/`) and referenced here — do not redefine targets in this directory.
