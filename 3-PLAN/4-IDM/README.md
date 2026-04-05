---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 3-PLAN
stage: build
type: readme
sub_system: 4-IDM
iteration: 2
---

# 3-PLAN / 4-IDM — Insight Delivery & Management Planning

Planning artifacts for the Insight Delivery and Management subsystem. IDM architecture
is constrained by DA output format and must satisfy decision-maker latency requirements
from ALIGN.

## Cascade Position

```
UPSTREAM:   3-PLAN/3-DA/    (DA output format and cadence)
            3-PLAN/1-PD/    (PD decision taxonomy)
            2-LEARN/4-IDM/  (reporting research, integration specs)
THIS:       3-PLAN/4-IDM/   (reporting architecture, decision latency risks, integration drivers)
DOWNSTREAM: 4-EXECUTE/4-IDM/ (implements this plan)
```

## Contents

| Artifact           | Naming Pattern             | Description                                            |
|--------------------|----------------------------|--------------------------------------------------------|
| Architecture       | `idm-architecture.md`      | Reporting layer, delivery channels, access control     |
| Risk Register      | `idm-risk-register.md`     | Decision latency risks, integration risks, mitigations |
| Driver Register    | `idm-driver-register.md`   | Integration and platform forces available              |
| Roadmap            | `idm-roadmap.md`           | Delivery build sequence, dependencies, owners          |

Naming convention: `{subsystem}-{artifact-type}.md` — all lowercase, hyphen-joined.
