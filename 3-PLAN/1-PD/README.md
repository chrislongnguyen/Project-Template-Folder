---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 3-PLAN
sub_system: 1-PD
type: template
iteration: 1
---

# 1-PD — Problem Diagnosis | PLAN Workstream

> "If PD architecture is not locked before DP starts, the pipeline will be built without knowing what diagnosis it must support."

PD-PLAN translates the PD Effective Principles from 2-LEARN into a concrete system architecture — what the problem diagnosis system is, how it works, and what constraints it places on DP, DA, and IDM. Its architecture decisions cascade as hard constraints to all downstream subsystems.

## Cascade Position

```
[(workstream-level inputs)]  ──►  [1-PD]  ──►  [2-DP (Data Pipeline)]
```

Receives from upstream: `2-LEARN/1-PD/specs/vana-spec.md` (PD Effective Principles); `1-ALIGN/1-PD/pd-charter.md` (problem scope and success criteria).
Produces for downstream: `pd-architecture.md` — consumed by 2-DP (Data Pipeline) as the authoritative constraint source defining what data the pipeline must supply; consumed by 4-EXECUTE/1-PD as the build contract.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design stage — scope, ACs, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |
| pd-architecture.md | `pd-architecture.md` | System design decisions — what the PD system is, how it processes inputs, what it produces |
| UBS_REGISTER.md | `UBS_REGISTER.md` | PD-scoped blocking force register — every identified risk with mitigation |
| UDS_REGISTER.md | `UDS_REGISTER.md` | PD-scoped driving force register — success enablers with activation strategies |
| pd-roadmap.md | `pd-roadmap.md` | Sequenced work plan for PD execution — milestones ordered by failure risk |

## Pre-Flight Checklist

- [ ] PD Effective Principles received from `2-LEARN/1-PD/specs/`
- [ ] Architecture scope agreed — what the PD system does and does not do
- [ ] pd-architecture.md reviewed for contradictions with Effective Principles
- [ ] Every UBS risk has a mitigation — no open risks without owner
- [ ] pd-roadmap.md approved and constraints cascade documented for DP
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| pd-architecture.md | `architecture-template.md` | `../../_genesis/templates/architecture-template.md` |
| UBS_REGISTER.md | `risk-entry-template.md` | `../../_genesis/templates/risk-entry-template.md` |
| UDS_REGISTER.md | `driver-entry-template.md` | `../../_genesis/templates/driver-entry-template.md` |
| pd-roadmap.md | `roadmap-template.md` | `../../_genesis/templates/roadmap-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
