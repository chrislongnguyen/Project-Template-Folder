---
version: "1.2"
status: draft
last_updated: 2026-04-11
work_stream: 4-EXECUTE
sub_system: _root
---

# 4-EXECUTE — Deliver with Effective Process

> **You are here:** `4-EXECUTE/` — Build and deliver artifacts against the approved plan, sustainability-first.

## What Goes Here

Execution artifacts: source code (`src/`), tests, configuration, documentation, and DSBV (Design, Sequence, Build, Validate) process files. Each subsystem directory holds deliverables organized by type. PD establishes build scope and principles; DP, DA, and IDM deliver within those constraints.

## How to Create Artifacts

This directory is empty by design. Run DSBV to generate content:

```
/dsbv design execute pd      # Step 1: Confirm sprint scope and prerequisites
/dsbv sequence execute pd    # Step 2: Technical design for each deliverable
/dsbv build execute pd       # Step 3: Produce the artifacts (agent builds)
/dsbv validate execute pd    # Step 4: Verify against VANA acceptance criteria
```

Repeat for each subsystem: `pd` → `dp` → `da` → `idm`. PD DESIGN.md must be approved before DP, DA, or IDM build work begins.

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

3-PLAN must have at least one validated artifact (approved architecture + roadmap) before EXECUTE begins. The PLAN package is the build contract: every deliverable must trace to a decision in 3-PLAN.

## Subsystem Sequence

```
1-PD  →  2-DP  →  3-DA  →  4-IDM
```

| Directory | Subsystem | What it delivers |
|-----------|-----------|-----------------|
| `1-PD/` | Problem Diagnosis | Build scope, Effective Principles, design constraints for downstream |
| `2-DP/` | Data Pipeline | Source connectors, transformation logic, schema contracts, tests |
| `3-DA/` | Data Analysis | Analytical modules, notebooks, validated result sets |
| `4-IDM/` | Insights & Decision Making | Dashboards, reports, APIs, user-facing documentation |
| `_cross/` | Cross-cutting | Shared config, integration tests, deployment orchestration |

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Design spec | `design-template.md` | `../_genesis/templates/design-template.md` |
| Sequence plan | `sequence-template.md` | `../_genesis/templates/sequence-template.md` |
| Test plan | `test-plan-template.md` | `../_genesis/templates/test-plan-template.md` |
| Review | `review-template.md` | `../_genesis/templates/review-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[deliverable]]
- [[dsbv-process]]
- [[workstream]]
