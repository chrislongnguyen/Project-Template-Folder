---
version: "2.1"
status: draft
last_updated: 2026-04-06
work_stream: 1-ALIGN
sub_system: 2-DP
type: template
iteration: 2
---

# 2-DP — Data Pipeline | ALIGN Workstream

> "Without a scoped stakeholder map and requirements input, the analysis stage works from incomplete data — producing alignment artifacts that miss the people or constraints that matter most."

DP gathers the structured inputs that alignment analysis depends on: stakeholder context, requirements, and any domain data needed to validate the problem diagnosis. It is bounded by the effective principles from 1-PD and passes organized, scoped inputs to 3-DA for synthesis into decisions and OKRs.

## Cascade Position

```
[1-PD (Problem Diagnosis)]  ──►  [2-DP]  ──►  [3-DA (Data Analysis)]
                                      ↑
                  Effective principles from 1-PD constrain what is in scope here
```

Receives from upstream: `pd-effective-principles.md`, scoped problem statement from `1-PD/pd-charter.md`.
Produces for downstream: `dp-charter.md`, stakeholder inputs, requirements baseline — consumed by 3-DA as the structured data set for analysis and decision-making.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Charter | `dp-charter.md` | Defines scope, objectives, and success criteria for this subsystem |
| OKR register | `dp-okr.md` | Objectives and key results for the data pipeline subsystem |
| Decision log template | `dp-decision-adr-template.md` | ADR template for decisions made during input gathering |
| DSBV Design | `DESIGN.md` | Design spec for how DP work is structured in this project |
| DSBV Sequence | `SEQUENCE.md` | Ordered build plan for DP artifacts |
| DSBV Validate | `VALIDATE.md` | Acceptance criteria and validation evidence for DP |

## Pre-Flight Checklist

- [ ] Confirm all key stakeholders identified in `_cross/cross-stakeholder-map.md` are represented in DP inputs
- [ ] Verify requirements are traceable to the problem statement in `1-PD/pd-charter.md`
- [ ] Confirm no data gathering is in scope that contradicts PD's effective principles
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to 3-DA
