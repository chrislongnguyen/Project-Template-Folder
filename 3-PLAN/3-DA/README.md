---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 3-PLAN
sub_system: 3-DA
type: template
iteration: 2
---

# 3-DA — Data Analysis | PLAN Workstream

> "Without DA, the plan reaches IDM with unexamined risks — decisions get made without force analysis, and the roadmap lacks a priority rationale."

DA-PLAN applies logic and structured analysis to the inputs defined in DP: it stress-tests the architecture, prioritizes risks by blocking force, and validates that drivers are internally consistent. The analysis output gives IDM an evidence-grounded basis for its decisions.

## Cascade Position

```
[2-DP (Data Pipeline)]  ──►  [3-DA]  ──►  [4-IDM (Insights & Decision Making)]
```

Receives from upstream: `dp-architecture.md`, `dp-risk-register.md`, `dp-driver-register.md` from `3-PLAN/2-DP/`.
Produces for downstream: `da-architecture.md`, `da-risk-register.md`, `da-driver-register.md`, `da-roadmap.md` — consumed by 4-IDM as analyzed risk priorities and validated architectural options.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Architecture spec | `da-architecture.md` | Analysis of structural options — trade-offs and selection rationale |
| Risk register | `da-risk-register.md` | UBS register with blocking force analysis and priority scores |
| Driver register | `da-driver-register.md` | UDS register with consistency check — conflicting drivers flagged |
| Roadmap | `da-roadmap.md` | Analysis-informed sequencing of planning deliverables |

## Pre-Flight Checklist

- [ ] Confirm every risk has a blocking force score and a named mitigation owner
- [ ] Verify architectural options were evaluated against PD's problem framing
- [ ] Confirm driver conflicts are surfaced — not silently resolved
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to downstream
