---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 3-PLAN
sub_system: _cross
type: template
iteration: 1
---

# _cross — Cross-Cutting | PLAN Workstream

> "Without _cross, subsystem boundaries in PLAN become silos — dependency maps, filesystem blueprints, and workstream-wide coordination artifacts have no home."

_cross holds PLAN artifacts that cannot be assigned to a single subsystem because they describe relationships between all four subsystems or between this workstream and the broader project structure.

## Scope

Cross-cutting artifacts in PLAN span all 4 subsystems (PD, DP, DA, IDM). In this workstream, that means structural maps and coordination artifacts: how subsystems depend on each other, how the physical filesystem is organized, and what constraints apply project-wide rather than subsystem-specific.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Dependency map | `cross-dependency-map.md` | Subsystem-to-subsystem input/output dependency graph for PLAN |
| Filesystem blueprint | `filesystem-blueprint.md` | Canonical directory structure and routing rules for the full project |

## Pre-Flight Checklist

- [ ] Confirm dependency map covers all four subsystems — no orphaned inputs
- [ ] Verify filesystem blueprint is consistent with the actual repo structure
- [ ] Confirm no artifact here duplicates content owned by a single subsystem
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to downstream
