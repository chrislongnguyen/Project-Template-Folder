---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 3-PLAN
sub_system: _cross
---

# 3-PLAN / _cross — Cross-Cutting Planning Artifacts

> **You are here:** `3-PLAN/_cross/` — Project-wide planning artifacts shared across all 4 subsystems: dependency map and filesystem blueprint.

## What Goes Here

Cross-cutting planning artifacts that describe relationships between subsystems or apply project-wide: `cross-dependency-map.md` (input/output dependency graph across PD, DP, DA, IDM) and `filesystem-blueprint.md` (canonical directory structure and routing rules). These cannot be owned by a single subsystem.

## How to Create Artifacts

```
/dsbv design plan _cross      # Step 1: Design cross-cutting planning scope
/dsbv sequence plan _cross    # Step 2: Sequence the build tasks
/dsbv build plan _cross       # Step 3: Agent produces dependency map, blueprint
/dsbv validate plan _cross    # Step 4: Verify coverage across all 4 subsystems
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

Start `_cross` after at least PD planning is complete — the dependency map requires knowing PD outputs to document what DP, DA, and IDM depend on.

## Why _cross Exists

If subsystem plans are created without a shared dependency map, planning silos form — DP assumes inputs PD didn't commit to providing, or DA plans logic that requires data DP hasn't scoped. `_cross` makes cross-subsystem dependencies explicit and forces conflicts to surface during planning, not during build.

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Architecture (for blueprint) | `architecture-template.md` | `../../_genesis/templates/architecture-template.md` |

## Links

- [[alpei-blueprint]]
- [[architecture]]
- [[project]]
- [[workstream]]
