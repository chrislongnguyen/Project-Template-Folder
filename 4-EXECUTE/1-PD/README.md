---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 4-EXECUTE
stage: build
type: template
sub_system: 1-PD
iteration: 2
---

# 4-EXECUTE / 1-PD — Problem Diagnosis Execution

Code and tooling that operationalizes the diagnostic frameworks designed in 3-PLAN/1-PD. This subsystem validates whether problems are correctly identified before analytical resources are committed downstream.

## Cascade Position

Depends on:
- `3-PLAN/1-PD/` — diagnostic frameworks, risk register, UBS entries
- `1-ALIGN/1-PD/` — success criteria for problem scoping

Feeds into:
- `4-EXECUTE/2-DP/` — confirmed problem scope drives what data gets ingested

## Contents

| Directory | Contains | Examples |
|-----------|----------|---------|
| `src/` | Source code | Diagnostic scripts, portfolio risk models, principle validation modules |
| `tests/` | Test files | Unit tests for diagnostic logic, validation fixtures |
| `config/` | Configuration | Problem scope definitions, threshold configs, model params |
| `docs/` | Technical docs | Diagnostic tool API docs, architecture notes, runbook |
