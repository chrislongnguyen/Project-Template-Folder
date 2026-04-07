---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 1-ALIGN
sub_system: 3-DA
type: template
iteration: 1
---

# 3-DA — Data Analysis | ALIGN Workstream

> "If the analysis stage is skipped, the project moves into decision-making with raw inputs but no synthesis — OKRs become guesses and decisions lack a reasoned basis."

DA synthesizes the inputs gathered in 2-DP into structured analysis: force analysis, gap assessment, and prioritized insights. It is constrained by the effective principles from 1-PD and produces analyzed findings ready for IDM to convert into decisions and chartered direction.

## Cascade Position

```
[2-DP (Data Pipeline)]  ──►  [3-DA]  ──►  [4-IDM (Insights & Decision Making)]
                                  ↑
              Effective principles from 1-PD govern analytical scope and rigor
```

Receives from upstream: organized stakeholder inputs, requirements baseline from `2-DP/dp-charter.md`.
Produces for downstream: `da-charter.md`, analytical findings and prioritized insights — consumed by 4-IDM as the evidenced basis for decisions, OKRs, and chartered direction.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Charter | `da-charter.md` | Defines scope, objectives, and success criteria for this subsystem |
| OKR register | `da-okr.md` | Objectives and key results for the analysis subsystem |
| Decision log template | `da-decision-adr-template.md` | ADR template for decisions made during analysis |
| DSBV Design | `DESIGN.md` | Design spec for how DA work is structured in this project |
| DSBV Sequence | `SEQUENCE.md` | Ordered build plan for DA artifacts |
| DSBV Validate | `VALIDATE.md` | Acceptance criteria and validation evidence for DA |

## Pre-Flight Checklist

- [ ] Confirm all inputs from 2-DP are accounted for — no stakeholder or requirement left unanalyzed
- [ ] Verify analytical conclusions are traceable to evidence, not assumption
- [ ] Confirm force analysis (blocking vs. driving forces) is complete before passing to IDM
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to 4-IDM
