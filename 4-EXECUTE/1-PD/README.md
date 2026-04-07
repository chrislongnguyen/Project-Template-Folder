---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 4-EXECUTE
sub_system: 1-PD
type: template
iteration: 1
---

# 1-PD — Problem Diagnosis | EXECUTE Workstream

> "Without PD-EXECUTE, the build has no agreed scope — developers produce code against unvalidated requirements and the subsystem boundary stays ambiguous."

PD-EXECUTE translates the approved plan into an executable build contract for this subsystem. It defines what is being built, the sustainability-first principles that govern all implementation choices, and the success criteria that DP, DA, and IDM will build toward.

## Cascade Position

```
[3-PLAN/4-IDM approved package]  ──►  [1-PD]  ──►  [2-DP (Data Pipeline)]
```

Receives from upstream: `idm-architecture.md`, `idm-roadmap.md` from `3-PLAN/4-IDM/`; validated design from `4-EXECUTE/1-PD/DESIGN.md`.
Produces for downstream: DSBV design artifacts and execution principles — consumed by 2-DP as the agreed scope boundary and build constraints for source code and configuration.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DSBV Design | `DESIGN.md` | Approved build spec — what to deliver, acceptance criteria, constraints |
| DSBV Sequence | `SEQUENCE.md` | Ordered task list — dependencies and delivery order for this subsystem |
| DSBV Validate | `VALIDATE.md` | Validation criteria and evidence checklist for PD deliverables |
| Docs | `docs/` | Reference documentation scoped to the PD subsystem |
| Config | `config/` | Configuration files governing PD subsystem behavior |

## Pre-Flight Checklist

- [ ] Confirm DESIGN.md traces every acceptance criterion to a 3-PLAN/4-IDM decision
- [ ] Verify SEQUENCE.md respects the Sustainability > Efficiency > Scalability priority order
- [ ] Confirm no build work starts in DP/DA/IDM until PD's DESIGN.md is approved
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to downstream
