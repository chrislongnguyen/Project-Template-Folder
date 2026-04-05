---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 3-PLAN
stage: build
type: readme
sub_system: _cross
iteration: 2
---

# 3-PLAN / _cross — Cross-Cutting Planning

Planning artifacts that span multiple subsystems: shared dependency maps, system-level
architecture decisions, and integrated roadmaps that cannot be owned by a single subsystem.

## Cascade Position

```
UPSTREAM:   3-PLAN/1-PD/, 2-DP/, 3-DA/, 4-IDM/   (subsystem plans)
            2-LEARN/_cross/                         (cross-cutting research)
THIS:       3-PLAN/_cross/  (dependency maps, shared architecture, integrated roadmap)
DOWNSTREAM: 4-EXECUTE/_cross/ (shared infrastructure, integration layers)
```

## Contents

| Artifact                  | Naming Pattern                | Description                                              |
|---------------------------|-------------------------------|----------------------------------------------------------|
| Filesystem Blueprint      | `filesystem-blueprint.md`     | Canonical directory structure — ALREADY EXISTS (I2 plan) |
| Cross-Dependency Map      | `cross-dependency-map.md`     | Subsystem dependency matrix, coupling levels, critical path |
| System Architecture       | `system-architecture.md`      | End-to-end system view across all 4 subsystems           |
| Integrated Roadmap        | `integrated-roadmap.md`       | Cross-subsystem milestone sequence and sequencing rules  |

`filesystem-blueprint.md` is the approved I2 blueprint — do not modify without a new DSBV cycle.
Naming convention: `{scope}-{artifact-type}.md` — all lowercase, hyphen-joined.
