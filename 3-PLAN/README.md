---
version: "1.0"
last_updated: 2026-03-30
---
# PLAN workstream (Minimize Risks via Design)

> "What can go wrong? What should we leverage? In what order?"

**Workstreams:** WS2 (Risk Management), WS4 (Thinking), WS5 (Decision Making)
**Derived From:** Ultimate Truth #5 (Risk > Output); UT#7 Work Streams 2, 4-5; Agile SOPs 2.3-2.4

---

## Purpose

No code is written until the top risks are identified and mitigated.
This workstream translates learning + alignment from `1-ALIGN/` into actionable architecture and roadmaps.
It operationalizes the core equation: **Success = Efficient & Scalable Management of Failure Risks**.

```
  1-ALIGN/                    3-PLAN/                      4-EXECUTE/
  ┌──────────────┐           ┌──────────────────┐          ┌────────────┐
  │ charter/     │──────────►│ risks/           │          │            │
  │ okrs/        │           │ drivers/         │─────────►│ src/       │
  │ decisions/   │◄──────────│ architecture/    │          │ tests/     │
  │ learning/    │──────────►│ roadmap/         │          │ config/    │
  │   specs/     │           │ learning/        │          │ docs/      │
  └──────────────┘           └──────────────────┘          └────────────┘
```

## Contents

| Subfolder | Work Stream | Contains | Key Question |
|-----------|-------------|----------|--------------|
| `risks/` | WS2: Risk Mgmt | UBS Register, Assumptions, Mitigations | What can go wrong? |
| `drivers/` | WS2: Risk Mgmt | UDS Register, Leverage Plan | What can we exploit? |
| `architecture/` | WS4: Thinking | System Design (7-component model), ADRs, Diagrams | How should we build it? |
| `roadmap/` | WS5: Decisions | Master Plan, Execution Plan, Dependencies | In what order? |
| `learning/` | WS3: Learning | Targeted research during planning, Technical spikes | What else do we need to know? |

## Planning Checklist
- [ ] UBS_REGISTER.md has top risks identified with root-cause traces
- [ ] ASSUMPTIONS.md lists all assumptions that could invalidate the plan
- [ ] MITIGATIONS.md has a strategy for each high-impact risk
- [ ] UDS_REGISTER.md identifies key drivers to leverage
- [ ] Research/spikes completed for unknown domains
- [ ] SYSTEM_DESIGN.md covers all 7 effective system components
- [ ] ADRs written for all non-trivial architectural choices
- [ ] MASTER_PLAN.md prioritized by MoSCoW
- [ ] EXECUTION_PLAN.md has tasks with acceptance criteria

## Pre-Flight — 3 Pillars Check

### Sustainability — Does our plan manage failure risks?
- [ ] Top 3 failure modes identified with mitigations
- [ ] Assumptions are explicit and testable
- [ ] Fallback plans exist for high-impact risks

### Efficiency — Is our plan lean?
- [ ] No analysis paralysis — research is time-boxed
- [ ] Plan focuses on highest risk-adjusted value items first
- [ ] Dependencies are minimized where possible

### Scalability — Does our plan handle growth?
- [ ] Architecture supports 3x and 10x scale
- [ ] Plan accommodates iterative refinement
- [ ] Knowledge artifacts are reusable across projects

## Links

- [[DESIGN]]
- [[workstream]]
