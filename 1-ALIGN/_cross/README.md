---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 1-ALIGN
stage: build
type: template
sub_system: _cross
iteration: 2
---

# _cross — Cross-Subsystem Alignment

Alignment artifacts that span two or more subsystems (PD, DP, DA, IDM) and cannot live in a single subsystem directory. If an artifact applies to exactly one subsystem, it belongs there — not here. If it governs the interaction between subsystems or applies to all four, it belongs here.

## Cascade Position

```
         _cross
        /  |  |  \
    [1-PD][2-DP][3-DA][4-IDM]
```

Receives from upstream: project-level charter (`1-ALIGN/charter/`).
Produces for downstream: shared stakeholder map, cross-subsystem decisions, shared OKRs — all subsystems reference these as horizontal constraints.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Cross Stakeholder Map | `cross-stakeholder-map.md` | All stakeholders across subsystems, RACI, UBS/UDS |
| Shared OKR Register | `cross-okr.md` | OKRs with outcomes spanning multiple subsystems |
| Cross-Subsystem Decisions | `ADR-{id}_cross_{slug}.md` | Decisions affecting 2+ subsystems (e.g., shared data contracts) |
| Integration Principles | `cross-principles.md` | Governing rules for subsystem-to-subsystem handoffs |
