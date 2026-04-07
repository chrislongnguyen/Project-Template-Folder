---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 4-EXECUTE
sub_system: 3-DA
type: template
iteration: 1
---

# 3-DA — Data Analysis | EXECUTE Workstream

> "Without DA-EXECUTE, IDM has no computed results to present — decisions and reports are built on manual summaries instead of reproducible analysis."

DA-EXECUTE applies analytical logic to the pipeline outputs from DP: it runs models, computes metrics, and produces validated result sets that IDM can package into decisions and reports. All analytical logic must be reproducible via tested source code and versioned notebooks.

## Cascade Position

```
[2-DP (Data Pipeline)]  ──►  [3-DA]  ──►  [4-IDM (Insights & Decision Making)]
```

Receives from upstream: pipeline outputs and schema contracts from `4-EXECUTE/2-DP/src/` and `4-EXECUTE/2-DP/config/`.
Produces for downstream: `src/` analytical modules, `notebooks/` reproducible analyses, `tests/` result validation — consumed by 4-IDM as verified computed outputs for presentation and decision packaging.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| Source code | `src/` | Analytical logic — models, metrics, aggregations, transformations |
| Notebooks | `notebooks/` | Reproducible analysis — exploratory and documentation-grade notebooks |
| Tests | `tests/` | Result validation — expected output ranges, regression checks |
| Config | `config/` | Analysis parameters, model configuration, threshold definitions |
| Docs | `docs/` | Methodology documentation, metric definitions, result interpretation guide |

## Pre-Flight Checklist

- [ ] Confirm all analytical inputs are sourced exclusively from `4-EXECUTE/2-DP/` outputs
- [ ] Verify every metric in `src/` has a corresponding test in `tests/`
- [ ] Confirm notebooks are reproducible — run clean from top to bottom without errors
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to downstream
