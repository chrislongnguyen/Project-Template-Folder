---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 1-ALIGN
stage: build
type: template
sub_system: 1-PD
iteration: 2
---

# 1-PD — Problem Diagnosis | ALIGN Workstream

Alignment artifacts for the Problem Diagnosis subsystem: charter, OKRs, and decisions that define what problem PD is solving, for whom, and under what constraints. PD governs all downstream subsystems — its charter and principles constrain DP, DA, and IDM scope.

## Cascade Position

```
[1-PD] ──► [2-DP] ──► [3-DA] ──► [4-IDM]
  ↑
  Anchors all subsystems. No downstream charter may contradict PD's scope.
```

Receives from upstream: project-level charter (`1-ALIGN/charter/`), stakeholder map (`_cross/`).
Produces for downstream: PD effective principles, PD scope boundaries, PD success criteria — all consumed by DP and DA as hard constraints.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| PD Charter | `pd-charter.md` | Purpose, scope, stakeholders, success criteria, constraints for PD |
| PD OKR Register | `pd-okr.md` | Objectives and key results scoped to PD |
| PD Decisions | `ADR-{id}_{slug}.md` | Architecture/scope decisions for PD subsystem |
| PD Effective Principles | `pd-principles.md` | Derived principles that constrain DP/DA/IDM |
