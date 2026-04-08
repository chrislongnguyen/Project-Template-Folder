---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 5-IMPROVE
sub_system: 3-DA
type: template
iteration: 1
---

# 3-DA — Data Analysis | IMPROVE Workstream

> "Without DA-IMPROVE, the retrospective loop produces feelings instead of findings — IDM cannot recommend prioritized improvements without analyzed evidence."

DA-IMPROVE interprets the metrics and retrospective data from DP: it identifies trends, surfaces root causes, and produces prioritized improvement findings that IDM can act on. Without this analysis, improvement decisions are driven by recency bias rather than systemic pattern.

## Cascade Position

```
[2-DP (Data Pipeline)]  ──►  [3-DA]  ──►  [4-IDM (Insights & Decision Making)]
```

Receives from upstream: `dp-metrics.md`, `dp-changelog.md`, `dp-retro-template.md` from `5-IMPROVE/2-DP/`.
Produces for downstream: `da-metrics.md`, `da-changelog.md`, `da-retro-template.md` — consumed by 4-IDM as analyzed findings with priority rankings for the next iteration's improvement backlog.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Changelog | `da-changelog.md` | Version history and analytical change narrative for the DA subsystem |
| Metrics | `da-metrics.md` | Analyzed metrics — trends, deviations, and root cause notes |
| Retro template | `da-retro-template.md` | Structured retrospective template scoped to DA analytical processes |

## Pre-Flight Checklist

- [ ] Confirm every metric deviation has a root cause hypothesis — not just a number
- [ ] Verify trend analysis spans at least two comparable data points (current vs. prior iteration)
- [ ] Confirm retro findings are categorized by subsystem — PD, DP, DA, or IDM
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to downstream

## Links

- [[CHANGELOG]]
- [[da-changelog]]
- [[da-metrics]]
- [[da-retro-template]]
- [[dp-changelog]]
- [[dp-metrics]]
- [[dp-retro-template]]
- [[iteration]]
- [[workstream]]
