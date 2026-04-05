---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 3-PLAN
stage: build
type: readme
sub_system: 1-PD
iteration: 2
---

# 3-PLAN / 1-PD — Problem Diagnosis Planning

Planning artifacts for the Problem Diagnosis subsystem. PD's architecture is the master
constraint for all downstream subsystems (DP, DA, IDM).

## Cascade Position

```
UPSTREAM:   2-LEARN/1-PD/   (research, specs, problem model)
            1-ALIGN/1-PD/   (charter, decisions)
THIS:       3-PLAN/1-PD/    (architecture, risk register, driver register, roadmap)
DOWNSTREAM: 3-PLAN/2-DP/    (inherits PD component boundaries)
            3-PLAN/3-DA/    (inherits PD data contract)
            3-PLAN/4-IDM/   (inherits PD output schema)
            4-EXECUTE/1-PD/ (implements this plan)
```

## Contents

| Artifact           | Naming Pattern            | Description                                      |
|--------------------|---------------------------|--------------------------------------------------|
| Architecture       | `pd-architecture.md`      | System context, component design, key decisions  |
| Risk Register      | `pd-risk-register.md`     | UBS-categorized risks, heat map, mitigations     |
| Driver Register    | `pd-driver-register.md`   | Forces available to accelerate PD delivery       |
| Roadmap            | `pd-roadmap.md`           | Milestone sequence, dependencies, owners         |

Naming convention: `{subsystem}-{artifact-type}.md` — all lowercase, hyphen-joined.
