---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 4-EXECUTE
sub_system: 3-DA
type: template
iteration: 1
---

# 3-DA — Data Analysis | EXECUTE Workstream

> "Analysis code that produces a result is not analysis code that produces the right result — validate the method, not just the execution."

DA-EXECUTE implements the analytical methods approved in da-architecture.md against the validated pipeline output from DP-EXECUTE. Each method must produce verifiable results that trace to problem questions from pd-charter.md.

## Cascade Position

```
[2-DP (Data Pipeline)]  ──►  [3-DA]  ──►  [4-IDM (Insights & Decision Making)]
```

Receives from upstream: 4-EXECUTE/2-DP → validated pipeline + test data; 3-PLAN/3-DA → da-architecture.md.
Produces for downstream: validated analytical outputs in agreed format — consumed by 4-IDM (Insights & Decision Making) as the source truth for all delivery artifacts; 5-IMPROVE/3-DA.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design — ACs for analytical correctness |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |
| src/ | `src/` | Analysis code — statistical methods, ML models, aggregation logic |
| tests/ | `tests/` | Analysis test suite — statistical validation, bias tests, regression tests |
| notebooks/ | `notebooks/` | Exploratory analysis and method validation notebooks |
| da-test-plan.md | `da-test-plan.md` | Test strategy — method validation criteria, bias test coverage |

## Pre-Flight Checklist

- [ ] DP pipeline validated and test data received
- [ ] Each analytical method traced to a problem question in pd-charter.md
- [ ] Bias tests written and passing
- [ ] Analytical outputs in format agreed by idm-architecture.md
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| da-test-plan.md | `test-plan-template.md` | `../../_genesis/templates/test-plan-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
