---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 5-IMPROVE
sub_system: 2-DP
type: template
iteration: 1
---

# 2-DP — Data Pipeline | IMPROVE Workstream

> "Without DP-IMPROVE, the retrospective loop has no data — DA receives opinions instead of measurements and cannot identify real improvement signals."

DP-IMPROVE collects and organizes the raw evidence for the improvement cycle: metrics collected from the deployed pipeline, changelog entries recording what changed, and retrospective data from the DP build. It feeds DA with structured, comparable data across iterations.

## Cascade Position

```
[1-PD (Problem Diagnosis)]  ──►  [2-DP]  ──►  [3-DA (Data Analysis)]
```

Receives from upstream: improvement criteria and baseline definitions from `5-IMPROVE/1-PD/pd-metrics.md`.
Produces for downstream: `dp-changelog.md`, `dp-metrics.md`, `dp-retro-template.md` — consumed by 3-DA as the raw evidence set for trend analysis and improvement prioritization.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Changelog | `dp-changelog.md` | Version history and change narrative for the DP subsystem |
| Metrics | `dp-metrics.md` | Pipeline health measurements — latency, completeness, schema drift |
| Retro template | `dp-retro-template.md` | Structured retrospective template scoped to DP processes and artifacts |

## Pre-Flight Checklist

- [ ] Confirm metrics are collected against the baselines defined in `5-IMPROVE/1-PD/pd-metrics.md`
- [ ] Verify changelog is consistent with actual commits in the DP source history
- [ ] Confirm retro captures pipeline reliability failures — not just feature gaps
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to downstream
