---
version: "2.7"
status: draft
last_updated: 2026-04-13
work_stream: 2-LEARN
type: template
iteration: 1
---

# 2-LEARN — Understand Before You Act

> "What are the blockers? What are the drivers? What principles govern this system?"

## Purpose

Without LEARN, teams plan and execute based on assumptions rather than evidence — the architecture reflects what the team believed, not what the domain requires. LEARN forces each subsystem to research its blocking and driving forces before any planning begins, producing Effective Principles that serve as hard constraints on 3-PLAN. Its output — validated Effective Principles + a DSBV Readiness Package per subsystem — is the gate that 3-PLAN cannot open without it.

## The Learning Pipeline

LEARN does **NOT** use DSBV. It uses a 6-state pipeline:

```
Input  →  Research  →  Specs  →  Output  →  Archive  →  Complete
(S1)       (S2)        (S3)      (S4)       (S5)
```

| Stage | Purpose | Key Output |
|-------|---------|-----------|
| **Input** (S1) | Capture raw material — stakeholder input, external research, observations | Timestamped capture files |
| **Research** (S2) | Analyze, synthesize, compare — produce structured knowledge | Research documents, analysis |
| **Specs** (S3) | Formalize requirements, constraints, specifications | Formal specs for downstream |
| **Output** (S4) | Publish refined learning artifacts for PLAN consumption | Validated learning outputs |
| **Archive** (S5) | Preserve completed/superseded research for reference | Archived materials |

> **HARD CONSTRAINT:** DESIGN.md, SEQUENCE.md, and VALIDATE.md must NEVER exist in 2-LEARN/.
> Enforced by: `scripts/dsbv-skill-guard.sh` (hook) + `.claude/rules/filesystem-routing.md` (Mode B).

## 3 Types of Effective Principles

LEARN produces Effective Principles that govern all downstream workstreams:

| Type | Formula | Focus |
|------|---------|-------|
| **S-Principle** | Derived from UBS analysis | Minimize failure risks |
| **E-Principle** | Derived from UDS analysis | Maximize output efficiency |
| **Sc-Principle** | Combined UBS + UDS at Iteration 4 | Scalability constraints |

## Subsystem Flow

```
PD-LEARN  →  DP-LEARN  →  DA-LEARN  →  IDM-LEARN
```

| Subsystem | Focus | Key Inputs | Key Outputs |
|-----------|-------|-----------|------------|
| **PD** | Research the problem space — identify blocking forces (UBS), driving forces (UDS), and derive governing Effective Principles | 1-ALIGN pd-charter.md + project mandate | P0–P5 pages validated; vana-spec.md with Effective Principles → govern all downstream research |
| **DP** | Research data sources, quality risks, and pipeline constraints using PD Effective Principles as bounds | **Principles from PD** + dp-charter.md from 1-ALIGN | P0–P5 pages validated; vana-spec.md with pipeline constraints → 3-PLAN/2-DP |
| **DA** | Research analytical methods, bias risks, and validation approaches — bounded by PD principles and DP constraints | **Principles from PD** + pipeline constraints from DP-LEARN | P0–P5 pages validated; vana-spec.md with analytical constraints → 3-PLAN/3-DA |
| **IDM** | Research delivery formats, adoption risks, and decision-maker context | **Principles from all upstream** + analytical constraints from DA-LEARN | P0–P5 pages validated; vana-spec.md with delivery constraints → 3-PLAN/4-IDM |

## Structure

| Folder | Contents |
|--------|---------|
| `1-PD/` | PD research pipeline: input/, output/ (P0–P5 pages), specs/ (Effective Principles) |
| `2-DP/` | DP research pipeline: input/, output/ (P0–P5 pages), specs/ (pipeline constraints) |
| `3-DA/` | DA research pipeline: input/, output/ (P0–P5 pages), specs/ (analytical constraints) |
| `4-IDM/` | IDM research pipeline: input/, output/ (P0–P5 pages), specs/ (delivery constraints) |
| `_cross/` | Shared pipeline infrastructure: learn-input files, research/ per subsystem, methodology, scripts |

## Templates

| Pipeline Stage | Template | Location |
|---------------|----------|----------|
| S1 — Scope (Input) | `learn-input-template.md` | [`learn-input-template.md`](../_genesis/templates/learn-input-template.md) |
| S2 — Research | `research-template.md` | [`research-template.md`](../_genesis/templates/research-template.md) |
| S2 — Spike (hypothesis test) | `spike-template.md` | [`spike-template.md`](../_genesis/templates/spike-template.md) |
| S5 — Spec | `vana-spec-template.md` | [`vana-spec-template.md`](../_genesis/templates/vana-spec-template.md) |

## Pre-Flight Checklist

### Before Starting Any Subsystem Pipeline
- [ ] 1-ALIGN has at least one validated artifact for this subsystem (chartered scope received)
- [ ] Research questions extracted from subsystem charter
- [ ] Research domains agreed: UBS analysis, UDS analysis, relevant domain knowledge

### Before Advancing S1 → S2 (Research)
- [ ] `learn-input-{slug}.md` written and scope locked
- [ ] Topics list finalized — not modified mid-research

### Before Advancing S2 → S3 (Structure)
- [ ] All research files have `status: completed` (not partial)
- [ ] Every factual claim has a cited source — no uncited claims

### Before Advancing S4 → S5 (Spec)
- [ ] All P0–P5 pages have `status: validated` — human reviewer approved each
- [ ] No P-page marked `needs-revision` without a re-run

### Before Handing Off to 3-PLAN
- [ ] `vana-spec.md` exists for each subsystem with ≥3 Effective Principles
- [ ] `DSBV-READY-{slug}.md` confirms 3-PLAN can begin

## How LEARN Connects

```
                  [validated output]
1-ALIGN  ─────────────────────>  2-LEARN
                                      │
                                 [output]
                                      │
                                      ▼
                                 3-PLAN

2-LEARN ──"scope changed"──> 1-ALIGN  (re-align)
```

> **Note:** `/organise` and `/capture` write to PKB dirs (Mode C), NOT to 2-LEARN/.

## DASHBOARDS

![[09-learning-overview.base]]

## Links

- [[SKILL]]
- [[methodology]]
- [[workstream]]
- [[alpei-blueprint]]
- [[learn-input-template]]
- [[vana-spec-template]]
