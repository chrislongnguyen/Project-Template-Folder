---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 5-IMPROVE
sub_system: 4-IDM
type: template
iteration: 1
---

# 4-IDM — Insights & Decision Making | IMPROVE Workstream

> "Without IDM-IMPROVE, the improvement cycle never closes — findings stay in analysis and the next iteration starts without committed change decisions."

IDM-IMPROVE converts DA's analyzed findings into committed improvement actions: it selects which risks to address next, updates the metrics baseline, and produces the approved backlog entries that feed into the next iteration's 1-ALIGN and 3-PLAN workstreams.

## Cascade Position

```
[3-DA (Data Analysis)]  ──►  [4-IDM]  ──►  [next iteration: 1-ALIGN + 3-PLAN]
```

Receives from upstream: `da-metrics.md`, `da-retro-template.md` from `5-IMPROVE/3-DA/`; cross-workstream metrics from `5-IMPROVE/_cross/`.
Produces for downstream: `idm-changelog.md`, `idm-metrics.md`, `idm-retro-template.md` — consumed by the next iteration's 1-ALIGN as approved improvement decisions and 3-PLAN as updated risk and driver inputs.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Changelog | `idm-changelog.md` | Approved change decisions and version narrative for the IDM subsystem |
| Metrics | `idm-metrics.md` | Updated metrics baseline — targets reset for the next iteration |
| Retro template | `idm-retro-template.md` | Structured retrospective template scoped to IDM delivery processes |

## Pre-Flight Checklist

- [ ] Confirm each improvement action has an owner and a target iteration
- [ ] Verify the updated metrics baseline is consistent with the DA trend analysis
- [ ] Confirm improvement decisions are recorded as ADRs in `1-ALIGN/decisions/` if they affect architecture
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to downstream

## Links

- [[CHANGELOG]]
- [[architecture]]
- [[da-metrics]]
- [[da-retro-template]]
- [[idm-changelog]]
- [[idm-metrics]]
- [[idm-retro-template]]
- [[iteration]]
- [[workstream]]
