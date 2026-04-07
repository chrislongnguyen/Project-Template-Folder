---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 3-PLAN
sub_system: 4-IDM
type: template
iteration: 1
---

# 4-IDM — Insights & Decision Making | PLAN Workstream

> "Without IDM, the plan stays in analysis — no approved architecture, no committed roadmap, no decision record for 4-EXECUTE to build from."

IDM-PLAN synthesizes the analysis from DA into committed decisions: it selects the architecture, locks the risk mitigations, finalizes the roadmap, and produces the approved planning package that 4-EXECUTE consumes as its build contract.

## Cascade Position

```
[3-DA (Data Analysis)]  ──►  [4-IDM]  ──►  [4-EXECUTE (workstream output)]
```

Receives from upstream: `da-architecture.md`, `da-risk-register.md`, `da-driver-register.md`, `da-roadmap.md` from `3-PLAN/3-DA/`.
Produces for downstream: `idm-architecture.md`, `idm-risk-register.md`, `idm-driver-register.md`, `idm-roadmap.md` — consumed by 4-EXECUTE as the approved build constraints, resource plan, and delivery sequence.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Architecture spec | `idm-architecture.md` | Final selected architecture with decision rationale |
| Risk register | `idm-risk-register.md` | Approved UBS register — mitigations committed and owned |
| Driver register | `idm-driver-register.md` | Finalized UDS register — constraints locked for the iteration |
| Roadmap | `idm-roadmap.md` | Approved delivery roadmap — sequenced milestones for 4-EXECUTE |

## Pre-Flight Checklist

- [ ] Confirm each architectural decision has a rationale traceable to DA analysis
- [ ] Verify every high-priority risk has an approved mitigation and named owner
- [ ] Confirm the roadmap is achievable within iteration scope — no scope creep
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to downstream
