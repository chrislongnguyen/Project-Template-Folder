---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 5-IMPROVE
sub_system: _cross
type: template
iteration: 1
---

# _cross — Cross-Cutting | IMPROVE Workstream

> "An iteration without a CHANGELOG is an iteration without a record — future teams inherit the outcome but not the reasoning."

Cross-cutting IMPROVE artifacts aggregate the full iteration's learnings into project-level records that no single subsystem can own.

## Scope

Cross-cutting artifacts span all 4 subsystems (PD, DP, DA, IDM) within the IMPROVE workstream.
These cannot be owned by a single subsystem — they govern or support all of them.

In IMPROVE, cross-cutting means synthesizing: CHANGELOG.md captures every change across all workstreams; the project-metrics dashboard gives leadership a single view; next-iteration-scope.md translates all subsystem retros into a coherent re-alignment input for 1-ALIGN. These artifacts must be written last — after all 4 subsystem retros are complete.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design stage — scope, ACs, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| CHANGELOG.md | `CHANGELOG.md` | Iteration changelog — all changes across workstreams, with type, scope, and rationale |
| project-metrics-dashboard.md | `project-metrics-dashboard.md` | Project-level metrics — aggregated from all subsystem baselines |
| team-feedback.md | `team-feedback.md` | Team retrospective — process improvements, tooling gaps, collaboration learnings |
| next-iteration-scope.md | `next-iteration-scope.md` | Draft scope for next iteration — derived from all retros and metrics, input to 1-ALIGN |

## Pre-Flight Checklist

- [ ] All 4 subsystem retros completed before cross-cutting retro — aggregate, don't invent
- [ ] `CHANGELOG.md` reflects all iteration changes — no undocumented changes
- [ ] `next-iteration-scope.md` drafted — specific enough for 1-ALIGN to scope against
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Loop explicitly closed: `next-iteration-scope.md` handed to 1-ALIGN owner

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| project-metrics-dashboard.md | `metrics-baseline-template.md` | `../../_genesis/templates/metrics-baseline-template.md` |
| team-feedback.md | `feedback-template.md` | `../../_genesis/templates/feedback-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
