---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 5-IMPROVE
stage: build
type: readme
sub_system: _cross
iteration: 2
---

# 5-IMPROVE / _cross — Cross-Cutting Improvement

## Purpose

Captures system-wide improvement artifacts that span multiple subsystems or apply to the IMPROVE workstream as a whole: cross-subsystem metrics, shared feedback registers, iteration changelogs, and retrospectives that cannot be cleanly assigned to a single subsystem.

Cross-cutting artifacts aggregate signals from all four subsystem improvement tracks. They are the synthesis layer — not a replacement for subsystem-level detail.

## Cascade Position

```
5-IMPROVE/1-PD  ──┐
5-IMPROVE/2-DP  ──┤──►  5-IMPROVE/_cross  (aggregate + synthesize)
5-IMPROVE/3-DA  ──┤
5-IMPROVE/4-IDM ──┘
```

Cross artifacts are produced after subsystem artifacts, not before. They summarize and surface patterns that individual subsystems cannot see in isolation.

## Contents

| Artifact Type      | Naming Pattern                    | Description                                              |
|--------------------|-----------------------------------|----------------------------------------------------------|
| Feedback Register  | `cross-feedback-register.md`      | Shared feedback triage across all subsystems             |
| Iteration Changelog| `cross-changelog-{YYYY-QN}.md`    | Quarterly summary of changes across all subsystems       |
| Cross Retro        | `cross-retro-{YYYY-QN}.md`        | System-wide retrospective spanning all subsystems        |
| System Metrics     | `cross-metrics.md`                | Aggregate health metrics across the 4-subsystem chain    |

## Notes

- The feedback register (`cross-feedback-register.md`) is the first stop for feedback that cannot be immediately attributed to a subsystem. Triage assigns it downstream.
- Cross changelogs summarize — they do not replace subsystem changelogs. Both must exist for a complete record.
- Cross retros are quarterly. Subsystem retros may run more frequently.
