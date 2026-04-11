---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 5-IMPROVE
sub_system: 3-DA
---

# 5-IMPROVE / 3-DA — Data Analysis

> **You are here:** `5-IMPROVE/3-DA/` — Interpret metrics and retrospective data: identify trends, surface root causes, and produce prioritized findings for IDM to act on.

## What Goes Here

Improvement artifacts scoped to Data Analysis: `da-changelog.md` (analytical change narrative), `da-metrics.md` (analyzed metrics — trends, deviations, root cause hypotheses), and retrospective analysis distinguishing accuracy failures from methodology gaps. Also DSBV process files.

## How to Create Artifacts

```
/dsbv design improve da      # Step 1: Define analytical approach for improvement data
/dsbv sequence improve da    # Step 2: Sequence analysis (accuracy issues before scale issues)
/dsbv build improve da       # Step 3: Produce trend analysis, root cause findings
/dsbv validate improve da    # Step 4: Verify every deviation has a root cause hypothesis
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`5-IMPROVE/2-DP/dp-metrics.md` and `5-IMPROVE/2-DP/dp-changelog.md` must exist. DA synthesizes DP's raw evidence — it does not collect new data.

## Cascade Position

```
[2-DP raw metrics + changelog]  →  [3-DA]  →  [4-IDM]
                                          ↑
         Trend analysis must span at least 2 comparable data points (current vs. prior)
```

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Retrospective | `retro-template.md` | `../../_genesis/templates/retro-template.md` |
| Metrics baseline | `metrics-baseline-template.md` | `../../_genesis/templates/metrics-baseline-template.md` |
| Design spec | `design-template.md` | `../../_genesis/templates/design-template.md` |

## Links

- [[CHANGELOG]]
- [[iteration]]
- [[workstream]]
