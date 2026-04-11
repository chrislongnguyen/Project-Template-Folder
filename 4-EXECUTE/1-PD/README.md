---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 4-EXECUTE
sub_system: 1-PD
type: template
iteration: 1
---

# 1-PD — Problem Diagnosis | EXECUTE Workstream

> "If PD is built without tests, the diagnosis system will produce results that look correct but cannot be verified — and errors will compound through DP, DA, and IDM."

PD-EXECUTE builds the problem-diagnosis system against the pd-architecture.md contract from 3-PLAN. Every build decision must trace to an acceptance criterion in DESIGN.md, which traces to a VANA outcome, which traces to a PD Effective Principle.

## Cascade Position

```
[(workstream-level inputs)]  ──►  [1-PD]  ──►  [2-DP (Data Pipeline)]
```

Receives from upstream: 3-PLAN/1-PD → pd-architecture.md (build contract); DESIGN.md ACs.
Produces for downstream: validated PD system + tested interfaces that DP integrates with — consumed by 2-DP (Data Pipeline) as hard integration contracts; 5-IMPROVE/1-PD → artifacts to measure.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design — ACs mapped to VANA outcomes, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |
| src/ | `src/` | PD implementation code — diagnosis logic, data models, interfaces |
| tests/ | `tests/` | PD test suite — unit, integration, and acceptance tests |
| docs/ | `docs/` | PD documentation — API docs, operational guides, architecture notes |
| pd-test-plan.md | `pd-test-plan.md` | Test strategy — coverage targets, test types, pass/fail criteria |

## Pre-Flight Checklist

- [ ] pd-architecture.md received and DESIGN.md ACs written against it
- [ ] Test environment set up — no external dependencies unconfigured
- [ ] All ACs are testable — not subjective or unmeasurable
- [ ] No secrets hardcoded — environment variables confirmed
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| pd-test-plan.md | `test-plan-template.md` | `../../_genesis/templates/test-plan-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
