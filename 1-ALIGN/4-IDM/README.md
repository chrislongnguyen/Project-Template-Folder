---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 1-ALIGN
sub_system: 4-IDM
type: template
iteration: 1
---

# 4-IDM — Insights & Decision Making | ALIGN Workstream

> "Without documented decisions and chartered direction, the project proceeds on verbal agreements — 2-LEARN and 3-PLAN inherit ambiguity and will re-litigate alignment at every turn."

IDM converts analysis into explicit, recorded decisions: the project charter, approved OKRs, key ADRs, and the signed-off direction that unlocks downstream workstreams. It is the final gate before ALIGN output is consumed by 2-LEARN and 3-PLAN.

## Cascade Position

```
[3-DA (Data Analysis)]  ──►  [4-IDM]  ──►  [workstream output → 2-LEARN / 3-PLAN]
                                   ↑
             Effective principles from 1-PD + analysis from 3-DA constrain all decisions
```

Receives from upstream: analytical findings and prioritized insights from `3-DA/da-charter.md`.
Produces for downstream: `idm-charter.md`, approved OKRs (`idm-okr.md`), recorded decisions (`idm-decision-adr-template.md`) — consumed by 2-LEARN as the problem definition input and by 3-PLAN as the chartered constraints for risk and architecture work.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Charter | `idm-charter.md` | Final chartered scope, objectives, and success criteria for this subsystem |
| OKR register | `idm-okr.md` | Approved objectives and key results for the decision-making subsystem |
| Decision log template | `idm-decision-adr-template.md` | ADR template for decisions made at the IDM stage |
| DSBV Design | `DESIGN.md` | Design spec for how IDM work is structured in this project |
| DSBV Sequence | `SEQUENCE.md` | Ordered build plan for IDM artifacts |
| DSBV Validate | `VALIDATE.md` | Acceptance criteria and validation evidence for IDM |

## Pre-Flight Checklist

- [ ] Confirm all analytical findings from 3-DA are addressed — no open question left undecided
- [ ] Verify each decision is recorded as an ADR with rationale, not just an outcome
- [ ] Confirm approved OKRs are measurable and time-bound before handing off to downstream
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to 2-LEARN and 3-PLAN
