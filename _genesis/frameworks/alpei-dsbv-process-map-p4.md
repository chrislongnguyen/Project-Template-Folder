---
version: "1.2"
status: draft
last_updated: 2026-04-10
owner: ""
---

# P4 — LEARN Workstream: Cross-Workstream Data Flows

## Overview

LEARN (LEARN workstream) is the research engine of the ALPEI system. It converts raw stakeholder input and framework analysis into structured artifacts — UBS threat inventories, UDS driver inventories, and Effective Principles — that every downstream workstream consumes. LEARN does not produce decisions or plans; it produces the evidence base that makes decisions and plans defensible. Two flows are upstream (LEARN feeds ALIGN and PLAN directly) and one is bidirectional (ALIGN charter scopes what LEARN researches; LEARN findings refine the charter).

---

## ASCII Data Flow Diagram

```
  ┌─────────────────────────────────────────────────────────────────────┐
  │                        2-LEARN (LEARN workstream)                             │
  │                                                                     │
  │  1-PD/                            1-PD/                             │
  │  ├── pd-ubs-uds.md                ├── pd-research-spec.md           │
  │  │   (threat + driver inventory)  │   (research findings/evidence)  │
  │  └── pd-effective-principles.md  └── pd-research-spec.md            │
  │      (validated EPs)                  (methodology + scope)          │
  └──────────┬──────────────────────┬──────────────────────────────────┘
             │                      │
    ┌────────▼────────┐    ┌────────▼────────┐
    │ 1-ALIGN (ALIGN workstream)│    │ 3-PLAN (PLAN workstream) │
    │                 │◄──►│                 │
    │ 1-PD/           │ ^  │ risks/          │
    │ pd-charter.md   │ │  │ UBS_REGISTER.md │
    │ (§Design Princ) │ │  │                 │
    │                 │ │  │ drivers/        │
    │ decisions/      │ │  │ UDS_REGISTER.md │
    │ ADR_*.md        │ │  │                 │
    │ (rationale)     │ │  │ 1-PD/           │
    └────────┬────────┘ │  │ pd-architecture │
             │          │  │                 │
             │          │  │ 1-PD/           │
             │          │  │ pd-roadmap.md   │
             └──────────┘  └────────┬────────┘
          Bidirectional:            │
          Charter scopes LEARN;     │ (feeds forward)
          LEARN refines Charter     ▼
                              4-EXECUTE (EXECUTE workstream)
                              (inherits all upstream constraints)
```

**Flow legend:**
- `──►` = unidirectional data flow (LEARN produces → workstream consumes)
- `◄──►` = bidirectional dependency (Charter scopes LEARN; LEARN refines Charter)
- `▼` = downstream inheritance (PLAN constraints propagate to EXECUTE)

---

## Cross-Workstream Flow Table

| Flow | Source Artifact | Data Type | Target Artifact | How Consumed |
|------|----------------|-----------|----------------|--------------|
| F1 | `2-LEARN/1-PD/pd-ubs-uds.md` | UBS threat inventory (layered root-cause analysis) | `3-PLAN/risks/UBS_REGISTER.md` | Each UBS entry expands into a register row: blocker, root cause, mitigation action, owner |
| F2 | `2-LEARN/1-PD/pd-ubs-uds.md` | UDS driver inventory (root enabler analysis) | `3-PLAN/drivers/UDS_REGISTER.md` | Each UDS entry expands into a register row: driver, root enabler, leverage action, owner |
| F3 | `2-LEARN/1-PD/pd-effective-principles.md` | Validated Effective Principles (safety-checked) | `1-ALIGN/1-PD/pd-charter.md` | Charter §Design Principles section is populated from EPs; each principle traces back to a LEARN finding |
| F4 | `2-LEARN/1-PD/pd-effective-principles.md` | Validated Effective Principles | `3-PLAN/1-PD/pd-architecture.md` | Architecture component constraints derive from EPs — each design decision must cite the EP that governs it |
| F5 | `2-LEARN/1-PD/pd-research-spec.md` | Research evidence and findings | `1-ALIGN/decisions/ADR_*.md` | ADR rationale cites research findings as evidence; decisions not backed by LEARN findings are flagged as assumptions |
| F6 | `2-LEARN/1-PD/pd-research-spec.md` | Research methodology (validated approach) | `3-PLAN/1-PD/pd-architecture.md` | Architecture records which research methods validated each structural decision (research-backed vs. assumption-based) |
| F7 | `2-LEARN/1-PD/pd-research-spec.md` | Scoped problem domain boundaries | `3-PLAN/1-PD/pd-roadmap.md` | Roadmap iteration inputs inherit problem domain scope from LEARN — prevents planning work outside the researched boundary |

---

## What Stays in LEARN vs. What Crosses Boundaries

| Category | Stays in 2-LEARN/ | Crosses to Other Workstreams |
|----------|-------------------|----------------------|
| Raw input | `input/raw/` — unprocessed transcripts, photos, recordings | No — raw data does not cross; only synthesized output does |
| Research methodology | `1-PD/pd-research-spec.md` | Partial — methodology rationale cross-references into `3-PLAN/1-PD/pd-architecture.md` |
| Structured analysis | `1-PD/pd-ubs-uds.md` | Yes — full inventory crosses to `3-PLAN/risks/` and `3-PLAN/drivers/` |
| Effective Principles | `1-PD/pd-effective-principles.md` | Yes — crosses to `1-ALIGN/1-PD/pd-charter.md` and `3-PLAN/1-PD/pd-architecture.md` |
| Research evidence | `1-PD/pd-research-spec.md` | Yes — crosses to `1-ALIGN/decisions/ADR_*.md` as decision rationale |
| VANA specifications | `specs/` | No — VANA specs are internal to LEARN; they define what research must validate |
| Archive / superseded | `archive/` | No — completed research stays archived in LEARN; downstream workstreams retain only what they consumed |

**Boundary rule:** Only artifacts in `2-LEARN/output/` and `2-LEARN/research/` cross workstream boundaries. Raw input and internal specs are consumed within LEARN and do not propagate.

---

## LEARN ↔ ALIGN Bidirectional Relationship

LEARN and ALIGN have a two-way dependency that is intentional and bounded:

```
  1-ALIGN/1-PD/pd-charter.md
         │
         │  (1) Charter defines the research scope:
         │      "What problem are we solving for whom?"
         │      → scopes 2-LEARN/1-PD/pd-research-spec.md
         ▼
  2-LEARN (research + analysis)
         │
         │  (2) LEARN findings refine the charter:
         │      Validated EPs update §Design Principles
         │      Research evidence surfaces assumptions in the charter
         │      UBS analysis may reveal charter scope gaps
         ▼
  1-ALIGN/1-PD/pd-charter.md (updated)
  1-ALIGN/decisions/ADR_*.md (new decisions added)
```

**Constraint:** ALIGN sets the initial scope boundary. LEARN cannot expand scope unilaterally — scope changes discovered during LEARN must be surfaced as ADR entries in `1-ALIGN/decisions/` and approved by the human before the charter is updated. LEARN refines; it does not redefine.

---

## LEARN → PLAN → EXECUTE Chain

LEARN outputs do not skip workstreams. The propagation path is strictly sequential:

```
2-LEARN/1-PD/pd-ubs-uds.md
    └──► 3-PLAN/risks/UBS_REGISTER.md       (mitigations defined)
              └──► 4-EXECUTE/                (mitigations implemented as checkpoints and validation gates)

2-LEARN/1-PD/pd-effective-principles.md
    └──► 3-PLAN/1-PD/pd-architecture.md     (constraints codified)
              └──► 4-EXECUTE/src/            (implementation must comply with architecture constraints)
```

EXECUTE workstream inherits from PLAN workstream, which inherits from LEARN workstream. EXECUTE does not read LEARN artifacts directly — it reads PLAN artifacts that were populated from LEARN. This one-hop indirection keeps EXECUTE focused on building, not researching.

---

### LEARN Pipeline — The 6-Skill Mechanism

LEARN is pre-DSBV research infrastructure. It does not use DSBV phases (Design → Sequence → Build → Validate) internally — instead, it uses a dedicated `/learn` pipeline that is state-aware, file-system-driven, and skill-dispatched. The entry point is `/learn {slug}`, which derives the current state from what files already exist in `2-LEARN/` and invokes the appropriate sub-skill. When the pipeline reaches State 5 (complete), the correct next step is `/dsbv design` for the downstream workstream — LEARN hands off to DSBV, it does not replace it. Templates for all P-page types are project-local: `2-LEARN/templates/page-{n}-*.md`.

#### State Machine

| State | Trigger condition | Skill invoked | Output produced |
|-------|-------------------|---------------|-----------------|
| S1 | No input file exists for slug | `/learn:input` | `2-LEARN/input/learn-input-{slug}.md` |
| S2 | Input exists; no research dir for slug | `/learn:research {slug}` | `2-LEARN/research/{slug}/` — raw research files per topic |
| S3 | Research dir exists; ≥1 topic missing validated P-pages | `/learn:structure {slug} {topic}` then `/learn:review {slug} {topic}` | `2-LEARN/research/{slug}/{topic}/P0–P7.md` all with `status: validated` |
| S4 | All topics validated; no vana-spec exists | `/learn:spec {slug}` | `2-LEARN/specs/{slug}/vana-spec.md` + `DSBV-READY-{slug}.md` |
| S5 | Pipeline complete (vana-spec exists, all topics validated) | _(no skill — pipeline done)_ | Run `/dsbv design` for the target downstream workstream |

#### P0–P7 Page Structure (per topic)

| Page | Type | Content |
|------|------|---------|
| P0 | Overview & Summary | Problem definition, scope boundaries, key concepts |
| P1 | Ultimate Blockers | UBS entries — threats, root causes, failure modes |
| P2 | Ultimate Drivers | UDS entries — enablers, leverage points, success factors |
| P3 | Effective Principles | Governing rules derived from P0–P2 analysis |
| P4 | Components | System elements, structural breakdown, taxonomy |
| P5 | Steps to Apply | Operational procedure — how to use the knowledge |
| P7 | Topic Distilled Understanding | Synthesis: what this topic means for the project |

#### Workstream-Crossing Outputs

| Output file | Consumed by |
|-------------|-------------|
| `2-LEARN/{N}-{SUB}/{sub}-ubs-uds.md` | `3-PLAN/risks/UBS_REGISTER.md` (UBS entries) · `3-PLAN/drivers/UDS_REGISTER.md` (UDS entries) |
| `2-LEARN/{N}-{SUB}/{sub}-effective-principles.md` | `1-ALIGN/{N}-{SUB}/{sub}-charter.md` (§Design Principles) · `3-PLAN/{N}-{SUB}/{sub}-architecture.md` (component constraints) |
| `2-LEARN/specs/{slug}/vana-spec.md` | Downstream DSBV Design phases — initializes Design context for the consuming workstream |

LEARN completes (S5) → run `/dsbv design` for the target downstream workstream.

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[UBS_REGISTER]]
- [[UDS_REGISTER]]
- [[VALIDATE]]
- [[adr]]
- [[architecture]]
- [[blocker]]
- [[charter]]
- [[iteration]]
- [[methodology]]
- [[pd-effective-principles]]
- [[project]]
- [[roadmap]]
- [[workstream]]
