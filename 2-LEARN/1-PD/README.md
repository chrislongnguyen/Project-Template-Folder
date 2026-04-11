---
version: "2.4"
status: draft
last_updated: 2026-04-11
work_stream: 2-LEARN
sub_system: 1-PD
---

# 2-LEARN / 1-PD — Problem Diagnosis

> **You are here:** `2-LEARN/1-PD/` — Research the blocking and driving forces in your problem space. The Effective Principles derived here govern DP, DA, and IDM research.

## What Goes Here

Pipeline content organized by stage: `input/` (research scope), `research/` (evidence), `output/` (structured P-pages), `specs/` (Effective Principles), `archive/` (rejected drafts).

## How to Create Artifacts

```
/learn:input       # S1: Scope research questions for PD (creates input/learn-input-{slug}.md)
/learn:research    # S2: Gather evidence on blocking and driving forces
/learn:structure   # S3: Organize into P-pages with UBS/UDS analysis
/learn:review      # S4: YOU review and approve — this gate is human-only
/learn:spec        # S5: Agent derives Effective Principles from your approved findings
```

Or run `/learn` and the skill auto-detects where you are in the pipeline.

## What's Here Now

This directory is empty — pipeline content is generated on-demand when you run the commands above.

## Prerequisites

`1-ALIGN/4-IDM/` must have a validated charter. The chartered problem definition is the required input for `/learn:input` at S1.

## Cascade Position

```
[1-ALIGN chartered direction]  →  [1-PD]  →  [2-DP]
                                       ↓
              Effective Principles scope the entire LEARN pipeline
```

PD is the most consequential LEARN subsystem. The S-Principles and E-Principles derived here set boundaries that DP, DA, and IDM cannot contradict.

## Pipeline Subdirs

| Directory | Pipeline State | What lives here |
|-----------|---------------|-----------------|
| `input/` | S1 — Scope | `learn-input-{slug}.md`, research questions |
| `research/` | S2 — Research | Evidence files, cited sources |
| `output/` | S3+S4 — Structure + Review | P0–P5 pages per topic |
| `specs/` | S5 — Spec | `vana-spec.md`, Effective Principles |
| `archive/` | — | Rejected hypotheses, superseded drafts |

## Templates

| Pipeline State | Template | Location |
|---------------|----------|----------|
| S1 — Scope | `learn-input-template.md` | `../../_genesis/templates/learn-input-template.md` |
| S2 — Research | `research-template.md` | `../../_genesis/templates/research-template.md` |
| S5 — Spec | `vana-spec-template.md` | `../../_genesis/templates/vana-spec-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[methodology]]
- [[workstream]]
