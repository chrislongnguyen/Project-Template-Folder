---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 4-EXECUTE
sub_system: 2-DP
type: template
iteration: 1
---

# 2-DP — Data Pipeline | EXECUTE Workstream

> "A pipeline that runs without failing is not the same as a pipeline that produces correct data — test the output, not just the process."

DP-EXECUTE builds the data pipeline against dp-architecture.md. The pipeline must be tested at every stage boundary (ingestion quality, transformation correctness, output quality) before DA can integrate against it.

## Cascade Position

```
[1-PD (Problem Diagnosis)]  ──►  [2-DP]  ──►  [3-DA (Data Analysis)]
```

Receives from upstream: 4-EXECUTE/1-PD → validated PD system (defines what data the pipeline must support); 3-PLAN/2-DP → dp-architecture.md.
Produces for downstream: validated pipeline with tested interfaces + test data for DA integration — consumed by 3-DA (Data Analysis) as the authoritative data source for all analytical methods.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design — ACs for pipeline correctness and quality |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| VALIDATE.md | `VALIDATE.md` | DSBV Validate stage — review all subsystem ACs before advancing to next subsystem |
| src/ | `src/` | Pipeline code — ingestion connectors, transformation logic, quality validators |
| tests/ | `tests/` | Pipeline test suite — data quality tests, transformation unit tests, integration tests |
| config/ | `config/` | Pipeline configuration — source credentials structure, environment variables |
| pipeline-test-plan.md | `pipeline-test-plan.md` | Test strategy — quality thresholds, test data management, rollback procedure |

## Pre-Flight Checklist

- [ ] PD system validated — data requirements confirmed
- [ ] Test data set available — representative of production range
- [ ] Data quality thresholds from dp-architecture.md encoded in tests
- [ ] Pipeline can be run idempotently — re-runs produce same output
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| pipeline-test-plan.md | `test-plan-template.md` | `../../_genesis/templates/test-plan-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
