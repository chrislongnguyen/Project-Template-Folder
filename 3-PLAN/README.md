---
version: "1.2"
status: draft
last_updated: 2026-04-11
work_stream: 3-PLAN
sub_system: _root
---

# 3-PLAN — Minimize Failure Risks

> **You are here:** `3-PLAN/` — Translate research findings into a derisked architecture, risk register, and ordered roadmap.

## What Goes Here

Planning artifacts: architecture specs (system design decisions), risk registers (UBS — Ultimate Blocking System — the organized set of forces that will stop you), driver registers (UDS — Ultimate Driving System — forces that produce success), and roadmaps. Organized by subsystem (PD, DP, DA, IDM) plus `_cross/` for project-wide planning artifacts.

## How to Create Artifacts

This directory is empty by design. Run DSBV (Design, Sequence, Build, Validate) to generate content:

```
/dsbv design plan pd      # Step 1: Design what you'll build for Problem Diagnosis planning
/dsbv sequence plan pd    # Step 2: Plan the work order
/dsbv build plan pd       # Step 3: Produce the artifacts (agent builds)
/dsbv validate plan pd    # Step 4: Review against acceptance criteria
```

Repeat for each subsystem: `pd` → `dp` → `da` → `idm`. PD must be validated before starting DP.

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

2-LEARN must have at least one validated artifact (Effective Principles from the learning pipeline) before PLAN begins. The Effective Principles are the primary input for architecture design.

## Subsystem Sequence

```
1-PD  →  2-DP  →  3-DA  →  4-IDM
```

| Directory | Subsystem | What it produces |
|-----------|-----------|-----------------|
| `1-PD/` | Problem Diagnosis | Foundation architecture and principles constraining all downstream planning |
| `2-DP/` | Data Pipeline | Pipeline architecture, source risk register, build sequence |
| `3-DA/` | Data Analysis | Analytical architecture, methodology risk register |
| `4-IDM/` | Insights & Decision Making | Delivery architecture, approved roadmap for 4-EXECUTE |
| `_cross/` | Cross-cutting | Project-wide UBS/UDS registers, dependency map, filesystem blueprint |

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Architecture spec | `architecture-template.md` | `../_genesis/templates/architecture-template.md` |
| Risk entry (UBS) | `risk-entry-template.md` | `../_genesis/templates/risk-entry-template.md` |
| Driver entry (UDS) | `driver-entry-template.md` | `../_genesis/templates/driver-entry-template.md` |
| Roadmap | `roadmap-template.md` | `../_genesis/templates/roadmap-template.md` |
| Design spec | `design-template.md` | `../_genesis/templates/design-template.md` |
| Review | `review-template.md` | `../_genesis/templates/review-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[architecture]]
- [[dsbv-process]]
- [[roadmap]]
- [[workstream]]
