---
version: "2.5"
status: draft
last_updated: 2026-04-11
work_stream: 2-LEARN
sub_system: _root
---

# 2-LEARN — Understand Before You Act

> **You are here:** `2-LEARN/` — Research blocking and driving forces before committing to any architecture or plan.

## What Goes Here

LEARN uses a **6-state pipeline** (not DSBV). Each subsystem directory contains pipeline stage subdirs: `input/`, `research/`, `output/`, `specs/`, `archive/`. The pipeline produces Effective Principles — the evidence-backed rules that govern every decision in 3-PLAN and 4-EXECUTE.

**HARD CONSTRAINT:** `DESIGN.md`, `SEQUENCE.md`, and `VALIDATE.md` files NEVER belong in `2-LEARN/`. LEARN uses the 6-state pipeline, not DSBV.

## How to Create Artifacts

```
/learn:input       # S1: Define what to research (creates input/learn-input-{slug}.md)
/learn:research    # S2: Deep research with cited sources
/learn:structure   # S3: Organize into P-pages (P0–P5 structured format)
/learn:review      # S4: Human review gate — you approve before pipeline continues
/learn:spec        # S5: Derive Effective Principles from validated findings
```

## What's Here Now

This directory is empty — pipeline content is generated on-demand when you run the commands above.

## Prerequisites

1-ALIGN must have at least one validated artifact before LEARN begins. The chartered problem definition from `1-ALIGN/4-IDM/` is the required input for S1.

## Subsystem Sequence

```
1-PD  →  2-DP  →  3-DA  →  4-IDM
 ↓
PD derives Effective Principles that govern DP, DA, and IDM research
```

| Directory | Subsystem | What it researches |
|-----------|-----------|-------------------|
| `1-PD/` | Problem Diagnosis | Blocking and driving forces for the problem space; derives governing Effective Principles |
| `2-DP/` | Data Pipeline | Source availability, data quality risks, transformation constraints |
| `3-DA/` | Data Analysis | Analytical methods, bias risks, validation approaches |
| `4-IDM/` | Insights & Decision Making | Delivery formats, adoption risks, decision-maker context |
| `_cross/` | Cross-cutting | Shared pipeline infrastructure: templates, scripts, references |

## Pipeline State Map

```
S1 input/  →  S2 research/  →  S3 output/  →  S4 review  →  S5 specs/  →  Complete
```

| State | Location | What the PM does |
|-------|----------|-----------------|
| S1 — Scope | `{subsystem}/input/` | Define research questions, boundaries |
| S2 — Research | `{subsystem}/research/` | Gather evidence, cite sources |
| S3 — Structure | `{subsystem}/output/` | Organize into P0–P5 pages |
| S4 — Review | status on output pages | Human approves or rejects — this gate is yours |
| S5 — Spec | `{subsystem}/specs/` | Agent derives Effective Principles |

## Templates

| Pipeline State | Template | Location |
|---------------|----------|----------|
| S1 — Scope | `learn-input-template.md` | `../_genesis/templates/learn-input-template.md` |
| S2 — Research | `research-template.md` | `../_genesis/templates/research-template.md` |
| S2 — Spike | `spike-template.md` | `../_genesis/templates/spike-template.md` |
| S5 — Spec | `vana-spec-template.md` | `../_genesis/templates/vana-spec-template.md` |

## Links

- [[SKILL]]
- [[methodology]]
- [[workstream]]
