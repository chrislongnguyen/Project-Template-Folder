---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 5-IMPROVE
sub_system: _cross
type: template
iteration: 2
---

# _cross — Cross-Cutting | IMPROVE Workstream

> "Without _cross-IMPROVE, workstream-level health is invisible — subsystem metrics exist but no one can see the aggregate system performance or cross-cutting failure patterns."

_cross-IMPROVE holds improvement artifacts that aggregate across all four subsystems or that track workstream-level health that no single subsystem owns. Without it, feedback patterns that span multiple subsystems go undetected.

## Scope

Cross-cutting artifacts in IMPROVE capture what no single subsystem can see alone: workstream-wide changelog narrative, aggregated metrics baseline, and feedback signals collected across PD, DP, DA, and IDM. In this workstream, cross-cutting means any improvement artifact that requires comparing or combining results across subsystems.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Cross changelog | `cross-changelog.md` | Workstream-level change history — aggregated narrative across all subsystems |
| Cross metrics baseline | `cross-metrics-baseline.md` | Aggregated health metrics — workstream-level targets and actuals |
| Feedback register | `cross-feedback-register.md` | Captured feedback from stakeholders and users spanning all subsystems |

## Pre-Flight Checklist

- [ ] Confirm cross-metrics-baseline.md rolls up from all four subsystem metrics files
- [ ] Verify feedback-register captures signals from both human users and agent outputs
- [ ] Confirm no artifact here duplicates content already owned by a single subsystem
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to downstream
