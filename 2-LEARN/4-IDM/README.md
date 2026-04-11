---
version: "2.3"
status: draft
last_updated: 2026-04-11
work_stream: 2-LEARN
sub_system: 4-IDM
---

# 2-LEARN / 4-IDM — Insights & Decision Making

> **You are here:** `2-LEARN/4-IDM/` — Convert analytical findings into actionable recommendations that 3-PLAN can consume directly. The LEARN pipeline ends here.

## What Goes Here

Pipeline content organized by stage: `input/` (findings from DA), `research/` (insight synthesis), `output/` (recommendations as P-pages), `specs/` (IDM Effective Principles and the final validated learning package), `archive/` (exploratory drafts). Also DSBV meta-artifacts governing workstream management.

## How to Create Artifacts

```
/learn:input       # S1: Scope insight criteria (what counts as actionable?)
/learn:research    # S2: Synthesize DA findings into recommendations — no new sources
/learn:structure   # S3: Organize into P-pages with delivery-specific UBS/UDS analysis
/learn:review      # S4: YOU review and approve — this gate is human-only
/learn:spec        # S5: Agent derives IDM Effective Principles + validated learning package
```

## What's Here Now

This directory is empty — pipeline content is generated on-demand when you run the commands above.

## Prerequisites

`2-LEARN/3-DA/` must have validated output before starting IDM. Each recommendation here must trace to a finding in DA — no unsupported insights.

## Cascade Position

```
[3-DA validated findings]  →  [4-IDM]  →  [3-PLAN]
                                    ↓
         Validated learning package (specs/) is what 3-PLAN consumes
```

IDM closes the LEARN pipeline. The `specs/` output is the validated learning package that unlocks 3-PLAN.

## Pipeline Subdirs

| Directory | Pipeline State | What lives here |
|-----------|---------------|-----------------|
| `input/` | S1 — Scope | Insight criteria, `learn-input-{slug}.md` |
| `research/` | S2 — Research | Insight synthesis working docs |
| `output/` | S3+S4 — Structure + Review | P0–P5 recommendation pages |
| `specs/` | S5 — Spec | `vana-spec.md`, IDM Effective Principles, validated learning package |
| `archive/` | — | Exploratory insight drafts |

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
