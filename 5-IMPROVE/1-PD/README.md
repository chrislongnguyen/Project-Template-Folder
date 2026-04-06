---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 5-IMPROVE
sub_system: 1-PD
type: template
iteration: 2
---

# 1-PD — Problem Diagnosis | IMPROVE Workstream

> "Without PD-IMPROVE, retrospectives measure the wrong things — the improvement loop has no agreed definition of what 'better' looks like for this subsystem."

PD-IMPROVE defines what improvement means for the PD subsystem: it sets the baseline, identifies what deterioration looks like, and establishes the criteria that DP, DA, and IDM will use to measure and report subsystem health across iterations.

## Cascade Position

```
[4-EXECUTE/1-PD outputs + iteration results]  ──►  [1-PD]  ──►  [2-DP (Data Pipeline)]
```

Receives from upstream: deployed artifacts from `4-EXECUTE/1-PD/`; DSBV validate results and any post-iteration signals.
Produces for downstream: `pd-changelog.md`, `pd-metrics.md`, `pd-retro-template.md` — consumed by 2-DP as the baseline definitions and improvement criteria for the full IMPROVE cycle.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Changelog | `pd-changelog.md` | Version history and change narrative for the PD subsystem |
| Metrics | `pd-metrics.md` | Baseline measurements and improvement targets for PD |
| Retro template | `pd-retro-template.md` | Structured retrospective template scoped to PD artifacts and processes |

## Pre-Flight Checklist

- [ ] Confirm metrics are traceable to PD acceptance criteria in `4-EXECUTE/1-PD/DESIGN.md`
- [ ] Verify changelog entries cover every committed version change in the iteration
- [ ] Confirm retro template distinguishes process failures from artifact quality failures
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to downstream
