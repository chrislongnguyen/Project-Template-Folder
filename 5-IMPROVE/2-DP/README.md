---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 5-IMPROVE
sub_system: 2-DP
---

# 5-IMPROVE / 2-DP — Data Pipeline

> **You are here:** `5-IMPROVE/2-DP/` — Collect evidence on pipeline health: latency, completeness, schema drift, and source reliability failures.

## What Goes Here

Improvement artifacts scoped to the Data Pipeline: `dp-changelog.md` (version history and change narrative), `dp-metrics.md` (pipeline health measurements against the PD baseline), and retrospective data capturing reliability failures and process gaps. Also DSBV process files.

## How to Create Artifacts

```
/dsbv design improve dp      # Step 1: Define DP feedback collection plan
/dsbv sequence improve dp    # Step 2: Design metric analysis methodology
/dsbv build improve dp       # Step 3: Produce changelog, metrics, retro report
/dsbv validate improve dp    # Step 4: Verify metrics measured against PD baseline
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`5-IMPROVE/1-PD/pd-metrics.md` must exist — it defines the baseline that DP metrics are measured against. `4-EXECUTE/2-DP/` must have deployed artifacts to evaluate.

## Cascade Position

```
[1-PD pd-metrics.md baseline]  →  [2-DP]  →  [3-DA]
                                         ↑
              Metrics here feed 3-DA as raw evidence for trend analysis
```

Focus on reliability failures before efficiency improvements: a pipeline that occasionally drops data is more dangerous than one that is slow.

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
