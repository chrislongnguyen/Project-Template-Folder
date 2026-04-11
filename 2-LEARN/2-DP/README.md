---
version: "2.4"
status: draft
last_updated: 2026-04-11
work_stream: 2-LEARN
sub_system: 2-DP
---

# 2-LEARN / 2-DP — Data Pipeline

> **You are here:** `2-LEARN/2-DP/` — Research data source availability, collection obstacles, and transformation constraints. Bounded by PD's Effective Principles.

## What Goes Here

Pipeline content organized by stage: `input/` (research scope), `research/` (evidence), `output/` (structured P-pages), `specs/` (DP Effective Principles), `archive/` (rejected drafts).

## How to Create Artifacts

```
/learn:input       # S1: Scope DP research questions (data sources, collection risks)
/learn:research    # S2: Investigate source availability, format constraints, quality issues
/learn:structure   # S3: Organize into P-pages with DP-specific UBS/UDS analysis
/learn:review      # S4: YOU review and approve — this gate is human-only
/learn:spec        # S5: Agent derives DP Effective Principles
```

## What's Here Now

This directory is empty — pipeline content is generated on-demand when you run the commands above.

## Prerequisites

`2-LEARN/1-PD/` must have validated Effective Principles before starting DP. PD principles constrain which data sources and collection methods are in scope here.

## Cascade Position

```
[1-PD Effective Principles]  →  [2-DP]  →  [3-DA]
                                      ↑
               Only sources allowed by PD principles enter the pipeline
```

## Pipeline Subdirs

| Directory | Pipeline State | What lives here |
|-----------|---------------|-----------------|
| `input/` | S1 — Scope | Source criteria, `learn-input-{slug}.md` |
| `research/` | S2 — Research | Source evaluation notes, evidence files |
| `output/` | S3+S4 — Structure + Review | P0–P5 pages per data source topic |
| `specs/` | S5 — Spec | `vana-spec.md`, DP Effective Principles |
| `archive/` | — | Out-of-scope sources, superseded drafts |

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
