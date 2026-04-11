---
version: "2.4"
status: draft
last_updated: 2026-04-11
work_stream: 2-LEARN
sub_system: 3-DA
---

# 2-LEARN / 3-DA — Data Analysis

> **You are here:** `2-LEARN/3-DA/` — Synthesize validated sources into structured findings: force analysis, pattern identification, and gap assessment.

## What Goes Here

Pipeline content organized by stage: `input/` (validated inputs from DP), `research/` (synthesis working docs), `output/` (structured P-pages), `specs/` (DA Effective Principles), `archive/` (superseded analyses).

## How to Create Artifacts

```
/learn:input       # S1: Scope analytical questions (methods, bias risks, validation)
/learn:research    # S2: Synthesize findings from DP output — no new unvetted sources
/learn:structure   # S3: Organize into P-pages with DA-specific UBS/UDS analysis
/learn:review      # S4: YOU review and approve — this gate is human-only
/learn:spec        # S5: Agent derives DA Effective Principles
```

## What's Here Now

This directory is empty — pipeline content is generated on-demand when you run the commands above.

## Prerequisites

`2-LEARN/2-DP/` must have validated output before starting DA. All analytical inputs must originate from DP's validated source set — no unvetted sources admitted at this stage.

## Cascade Position

```
[2-DP validated output]  →  [3-DA]  →  [4-IDM]
                                  ↑
      DA synthesizes only what DP validated — conclusions must trace to cited sources
```

## Pipeline Subdirs

| Directory | Pipeline State | What lives here |
|-----------|---------------|-----------------|
| `input/` | S1 — Scope | Analytical questions, `learn-input-{slug}.md` |
| `research/` | S2 — Research | Synthesis working docs, pattern notes |
| `output/` | S3+S4 — Structure + Review | P0–P5 pages per analytical topic |
| `specs/` | S5 — Spec | `vana-spec.md`, DA Effective Principles |
| `archive/` | — | Superseded analyses, exploratory drafts |

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
