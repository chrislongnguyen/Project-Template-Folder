---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 4-EXECUTE
stage: build
type: template
sub_system: 3-DA
iteration: 2
---

# 4-EXECUTE / 3-DA — Data Analysis Execution

Analytical models, statistical computations, and visualization code that produce investment insights. Operationalizes the analytical design in 3-PLAN/3-DA.

## Cascade Position

Depends on:
- `3-PLAN/3-DA/` — analytical methodology, factor definitions, model specs
- `4-EXECUTE/2-DP/` — validated datasets as inputs

Feeds into:
- `4-EXECUTE/4-IDM/` — analysis outputs consumed by decision support tools and dashboards

## Contents

| Directory | Contains | Examples |
|-----------|----------|---------|
| `src/` | Source code | Factor analysis modules, statistical computations, visualization renderers |
| `tests/` | Test files | Model unit tests, regression baselines, output shape validators |
| `config/` | Configuration | Model hyperparameters, factor weights, visualization themes |
| `docs/` | Technical docs | Model methodology docs, output schema, interpretation guide |
| `notebooks/` | Jupyter/Colab notebooks | Exploratory analysis, model prototyping, result review |
