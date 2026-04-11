---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 5-IMPROVE
sub_system: _cross
---

# 5-IMPROVE / _cross — Cross-Cutting Improvement Artifacts

> **You are here:** `5-IMPROVE/_cross/` — Workstream-level health artifacts: aggregated metrics and feedback that span all 4 subsystems.

## What Goes Here

Cross-cutting improvement artifacts that no single subsystem can produce alone: `cross-changelog.md` (workstream-level narrative aggregated across PD, DP, DA, IDM), `cross-metrics-baseline.md` (aggregated health metrics — workstream-level targets and actuals), and `cross-feedback-register.md` (feedback from stakeholders and users spanning all subsystems).

## How to Create Artifacts

```
/dsbv design improve _cross      # Step 1: Define workstream-level feedback scope
/dsbv sequence improve _cross    # Step 2: Design aggregation methodology
/dsbv build improve _cross       # Step 3: Produce cross-changelog, metrics rollup, feedback register
/dsbv validate improve _cross    # Step 4: Verify rollup covers all 4 subsystems
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

Individual subsystem improvement work (PD, DP, DA, IDM) should produce metrics before `_cross` aggregates them. `cross-metrics-baseline.md` rolls up from all four subsystem metrics files.

## Why _cross Exists

Subsystem metrics reveal component-level issues. Workstream-level metrics reveal systemic patterns — a signal that looks minor in DP and minor in DA might be significant when seen together. `_cross` is where cross-subsystem failure patterns become visible.

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Metrics baseline | `metrics-baseline-template.md` | `../../_genesis/templates/metrics-baseline-template.md` |
| Feedback | `feedback-template.md` | `../../_genesis/templates/feedback-template.md` |

## Links

- [[CHANGELOG]]
- [[iteration]]
- [[workstream]]
