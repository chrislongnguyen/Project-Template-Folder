---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 1-ALIGN
sub_system: _cross
---

# 1-ALIGN / _cross — Cross-Cutting Alignment Artifacts

> **You are here:** `1-ALIGN/_cross/` — Project-wide artifacts shared across all 4 subsystems: stakeholder map and RACI.

## What Goes Here

Cross-cutting alignment artifacts that no single subsystem owns but all subsystems depend on: a stakeholder map (`cross-stakeholder-map.md`) covering all project stakeholders and their roles, and a RACI matrix (`cross-stakeholder-raci.md`) assigning Responsible, Accountable, Consulted, and Informed roles for key alignment decisions. These must exist before subsystems diverge into specialized work.

## How to Create Artifacts

```
/dsbv design align _cross      # Step 1: Design cross-cutting scope
/dsbv sequence align _cross    # Step 2: Sequence the build tasks
/dsbv build align _cross       # Step 3: Agent produces stakeholder map and RACI
/dsbv validate align _cross    # Step 4: Review against acceptance criteria
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

Start `_cross` early in the ALIGN workstream — ideally alongside or before PD. Subsystem charters in PD, DP, DA, and IDM all reference stakeholders that must be identified here first.

## Why _cross Exists

If each subsystem defines its own stakeholder list independently, the lists diverge — IDM decisions contradict inputs gathered in DP. `_cross` is the single source of truth for who is involved and who is accountable.

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Stakeholder map | `charter-template.md` | `../../_genesis/templates/charter-template.md` |
| Force analysis | `force-analysis-template.md` | `../../_genesis/templates/force-analysis-template.md` |

## Links

- [[charter]]
- [[project]]
- [[workstream]]
