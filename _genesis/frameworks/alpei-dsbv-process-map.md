---
version: "1.6"
status: draft
last_updated: 2026-04-10
owner: ""

# ALPEI-DSBV Process Map

## 1. Introduction

This document is the authoritative reference for how the LTC ALPEI framework and DSBV sub-process work together to produce workstream artifacts. It serves three consumers:


| Consumer                  | Use                                                                                               |
| ------------------------- | ------------------------------------------------------------------------------------------------- |
| **PM / Team member**      | Orientation: understand what workstream you are in, what phase is active, what gate you are approaching |
| **Agent (Sonnet / Opus)** | Context load: verify correct template, agent, and AC before producing any artifact                |
| **Training deck author**  | Slide content: each P-section maps to one or more training slides                                 |


Source of truth for version behaviors: `_genesis/frameworks/ues-version-behaviors.md`.
Skill entry point: `/dsbv` — guided flow for Design → Sequence → Build → Validate.
Template index: `_genesis/templates/README.md`.

---

## 2. P1 — 5×4 Matrix: ALPEI Workstreams × DSBV Phases

Every workstream in the ALPEI system produces artifacts through the same four-phase DSBV sub-process: **Design → Sequence → Build → Validate**. The 5×4 matrix below makes that structure explicit — each cell names the template used, the deliverable path, the assigned agent, and the binary acceptance criterion for that workstream-phase intersection. 

**Problem Diagnosis (PD)** serves as the worked example sub-system with all 20 cells filled; all other sub-systems (DP, DA, IDM) follow the identical pattern, substituting their own deliverable paths and domain-specific content.

---

### Matrix Table 1 — Design + Sequence (ltc-planner: Opus)

> Phases owned by **ltc-planner** (model: Opus). Produces DESIGN.md and SEQUENCE.md artifacts.


| Workstream          | Design (ltc-planner)                                                                                                                                                            | Sequence (ltc-planner)                                                                                                                                                                  |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1-ALIGN**   | **Template:** charter-template.md (T1) + force-analysis-template.md (T4) **Deliverable:** `1-ALIGN/charter/CHARTER.md` **AC:** Charter has EO, stakeholders, and VANA criteria. | **Template:** okr-template.md (T3) **Deliverable:** `1-ALIGN/okrs/OKR_REGISTER.md` **AC:** All objectives have ≥1 KR with baseline and target.                                          |
| **2-LEARN**   | *LEARN uses the `/learn` pipeline — not DSBV phases.* Entry: `/learn {slug}` See §P4 LEARN Pipeline for state machine and skill dispatch.                                       | *See §P4 LEARN Pipeline*                                                                                                                                                                |
| **3-PLAN**    | **Template:** force-analysis-template.md (T4) + risk-entry-template.md **Deliverable:** `3-PLAN/risks/UBS_REGISTER.md` **AC:** Every UBS entry has a mitigation.                | **Template:** roadmap-template.md (T6) + driver-entry-template.md (T5) **Deliverable:** `3-PLAN/roadmap/ROADMAP.md` **AC:** Milestones map to iteration. Drivers have leverage actions. |
| **4-EXECUTE** | **Template:** design-template.md **Deliverable:** `4-EXECUTE/DESIGN.md` **AC:** All artifacts have binary ACs. No orphan conditions.                                             | **Template:** sequence-template.md **Deliverable:** `4-EXECUTE/SEQUENCE.md` **AC:** Tasks ordered by dependency with input/output/AC/token estimate.                                 |
| **5-IMPROVE** | **Template:** metrics-baseline-template.md (T7) **Deliverable:** `5-IMPROVE/metrics/METRICS_BASELINE.md` **AC:** Each metric has current value, target, and measurement method. | **Template:** sequence-template.md **Deliverable:** `5-IMPROVE/retrospectives/RETRO-PLAN.md` **AC:** Retro format defined; participants identified.                                                |


---

### Matrix Table 2 — Build + Validate (ltc-builder: Sonnet / ltc-reviewer: Opus)

> Build owned by **ltc-builder** (model: Sonnet). Validate owned by **ltc-reviewer** (model: Opus).


| Workstream          | Build (ltc-builder)                                                                                                                                                                                                                                                           | Validate (ltc-reviewer)                                                                                                                                                 |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1-ALIGN**   | **Template:** charter-template.md (T1) **Deliverable:** `1-ALIGN/charter/CHARTER.md` (final) **AC:** Signed off by PM; version frontmatter present.                                                                                                                           | **Template:** review-template.md **Deliverable:** `1-ALIGN/VALIDATE.md` **AC:** All DESIGN.md criteria PASS or have a documented exception.                            |
| **2-LEARN**   | *LEARN uses the `/learn` pipeline — not DSBV phases.* Pipeline: `/learn:input` → `/learn:research` → `/learn:structure` → `/learn:review` → `/learn:spec` Outputs: `2-LEARN/output/{SUB}-UBS-UDS.md` · `2-LEARN/output/{SUB}-EFFECTIVE-PRINCIPLES.md` · P0–P7 pages per topic | *Validation via `/learn:review` per topic — all P-pages reach `status: validated` before pipeline advances*                                                              |
| **3-PLAN**    | **Template:** architecture-template.md (T2) **Deliverable:** `3-PLAN/architecture/ARCHITECTURE.md` **AC:** Components, interfaces, and data flows present.                                                                                                                    | **Template:** review-template.md **Deliverable:** `3-PLAN/VALIDATE.md` **AC:** Architecture references UBS mitigations. No orphaned components.                  |
| **4-EXECUTE** | **Template:** (artifact-specific per SEQUENCE.md) **Deliverable:** Workstream artifacts per `4-EXECUTE/SEQUENCE.md` **AC:** Each artifact passes its SEQUENCE.md AC before the next task begins.                                                                                     | **Template:** dsbv-eval-template.md **Deliverable:** `4-EXECUTE/VALIDATE.md` **AC:** All SEQUENCE.md ACs addressed. No FAIL without a documented exception.              |
| **5-IMPROVE** | **Template:** test-plan-template.md (T8) + feedback-template.md **Deliverable:** `5-IMPROVE/metrics/FEEDBACK_REGISTER.md` **AC:** Feedback has category, severity, and status per entry.                                                                                      | **Template:** review-package-template.md **Deliverable:** `5-IMPROVE/reviews/VERSION-REVIEW.md` **AC:** Three Pillars scored. Version advancement decision: GO / NO-GO. |


---

### Pre-DSBV Phase — Research (ltc-explorer: Haiku)

> Before Design begins, **ltc-explorer** runs wide-net discovery. This is not a DSBV phase — it feeds the Design phase as input.


| Role             | Scope                                                                                                                                          |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **ltc-explorer** | Codebase exploration, existing template inventory, UBS/UDS signal gathering, source evaluation. Produces input notes only — no workstream artifacts. |


---

### Sub-System Inheritance Table

PD is the first sub-system and sets the version ceiling. DP, DA, and IDM follow the same 5×4 matrix pattern but may not exceed the version of their upstream sub-system.


| Sub-system | Full Name                | Inherits From           | Version Ceiling Rule                        |
| ---------- | ------------------------ | ----------------------- | ------------------------------------------- |
| **PD**     | Problem Diagnosis        | — (first in chain)      | Sets ceiling for all downstream sub-systems |
| **DP**     | Diagnosis Protocol       | PD Effective Principles | DP version ≤ PD version                     |
| **DA**     | Diagnostic Analysis      | DP Effective Principles | DA version ≤ DP version                     |
| **IDM**    | Informed Decision Making | DA Effective Principles | IDM version ≤ DA version                    |


**Inheritance rule:** Each sub-system's Effective Principles (produced in LEARN workstream Build) are inherited by the next sub-system as validated inputs. A downstream sub-system may not advance to a higher version than its upstream dependency. If PD is at v1.2, DP may not exceed v1.2.

> PD is the worked example showing all 20 cells. DP, DA, and IDM follow the identical workstream × phase structure with their own deliverable paths and domain content.

---

## 3. P2 — Version Progression: What Each Workstream Produces at Each Depth

The ALPEI framework defines 5 version levels. Each level sets a ceiling on what any workstream is allowed to produce — building deeper than your current version is waste; building shallower is a gap. This section maps those version levels to LTC iteration naming (Iteration 0–Iteration 4) and shows exactly what "done" looks like at every workstream-version intersection.

Source of truth for all 25 cells: `_genesis/frameworks/ues-version-behaviors.md`.

---

### Version Naming Map


| LTC Name | Original UES Name               | Three Pillars Alignment                      | One-Line Summary                              |
| -------- | ------------------------------- | -------------------------------------------- | --------------------------------------------- |
| **Iteration 0**   | Logic Scaffold                  | Pre-build (no pillar yet)                    | Map scope and logic only — no implementation  |
| **Iteration 1**   | Concept                         | Sustainability only                          | Prove correctness and safety — nothing breaks |
| **Iteration 2**   | Prototype                       | Sustainability + Efficiency                  | Work on real data and outperform alternatives |
| **Iteration 3**   | MVE (Minimum Viable Experience) | Sustainability + Efficiency (fully realized) | Production-grade — reliable at current scale  |
| **Iteration 4**   | Leadership                      | Sustainability + Efficiency + Scalability    | Self-improving, self-executing, predictive    |


> **Reading rule:** Iteration 0 is pre-build framing. Iteration 1 adds the first pillar (Safety/Sustainability). Each subsequent level adds capability, not replaces it — Iteration 4 assumes everything from Iteration 0–Iteration 3 is complete and stable.

---

### 25-Cell Version-Depth Matrix

> Rows = version level (Iteration 0–Iteration 4). Columns = ALPEI workstream. Each cell = what that workstream produces AT that version level.
> Source: `ues-version-behaviors.md` § per-work-stream tables.
> **Traceability:** Each column maps to a work stream section in ues-version-behaviors.md:
> 1-ALIGN → §ALIGN WORK STREAM | 2-LEARN → §LEARN WORK STREAM | 3-PLAN → §PLAN WORK STREAM | 4-EXECUTE → §EXECUTE WORK STREAM | 5-IMPROVE → §IMPROVE WORK STREAM


| Version                 | 1-ALIGN                                                                                            | 2-LEARN                                                                                                    | 3-PLAN                                                                                                       | 4-EXECUTE                                                                               | 5-IMPROVE                                                                                                |
| ----------------------- | -------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| **Iteration 0** (Logic Scaffold) | Project Charter (conceptual), Stakeholder map (draft), VANA criteria (initial)                     | UBS inventory (draft), UDS inventory (draft), Research questions list                                      | Iteration Scope (draft), Task list (conceptual), Dependency map (initial)                                    | No artifacts — execution is out of scope at this level                                  | Improvement areas list, Gap analysis (conceptual), Success criteria (initial)                            |
| **Iteration 1** (Concept)        | Project Charter (validated), Master Plan (safety-focused), VANA criteria (sustainability-verified) | UBS analysis (validated), UDS analysis (validated), Effective Principles (derived, safety-checked)         | Iteration Scope (risk-assessed), Task breakdown (safety-sequenced), UBS Risk Register (populated)            | Simulated deliverables, Manual workflows, Safety-verified outputs                       | Feedback collection (structured), Retrospective notes (safety-focused), Validated improvement hypotheses |
| **Iteration 2** (Prototype)      | OKRs (efficiency metrics), Master Plan (efficiency-optimized), Resource allocation (benchmarked)   | UBS/UDS tested against real data, Effective Principles (efficiency-proven), Research methodology (refined) | Task breakdown (effort-estimated), UDS Driver Register (populated), Critical path (optimized)                | Working deliverables (limited scope), Automated where efficient, Performance benchmarks | Feedback analysis (quantified), Sprint Review (efficiency-benchmarked), Prioritized improvement backlog  |
| **Iteration 3** (MVE)            | Full OKR set, Locked Master Plan, Stakeholder sign-off, Budget commitment                          | UBS/UDS analysis (production-validated), Effective Principles (locked), Learning audit (complete)          | Locked Execution Plan, RACI assignments (final), Sprint schedule (committed), Risk/Driver entries (complete) | Production-grade deliverables, Reliable automated workflows, Cost-effective operations  | Feedback Register (production-grade), Sprint Review (comprehensive), Implemented improvements (verified) |
| **Iteration 4** (Leadership)     | Automated alignment checks, Predictive resource planning, Self-adjusting OKRs                      | Automated UBS/UDS detection, Self-updating Effective Principles, Predictive blocker identification         | Auto-generated sprint plans, Predictive effort estimation, Dynamic re-planning on blocker detection          | Self-executing workflows, Predictive issue prevention, Auto-scaling operations          | Automated feedback detection, Predictive issue identification, Self-optimizing processes                 |


---

### Practical Calibration Guide

Use this to sanity-check deliverables before starting or reviewing work.

**Iteration 0 — Logic Scaffold (Pre-build)**
DO: Scope definitions, structural maps, dependency diagrams, VANA criteria (initial), stakeholder lists (draft), UBS/UDS inventories (identified, not yet analyzed), conceptual task lists.
DO NOT: Working code, automated pipelines, validated principles, signed-off plans, locked registers, any executed output.

**Iteration 1 — Concept (Sustainability)**
DO: Validated charters and safety-checked designs, simulated or manual-but-correct workflows, Risk Registers with populated entries, structured feedback collection.
DO NOT: Efficiency benchmarks, optimized systems, production-grade automation, real-data testing, locked or committed plans.

**Iteration 2 — Prototype (Sustainability + Efficiency)**
DO: Working tools using real data (limited scope), efficiency comparisons vs. Iteration 1 manual approach, benchmarked performance, populated Driver Registers, optimized critical paths.
DO NOT: Fully scaled systems, production-grade reliability, self-healing automation, comprehensive audit trails.

**Iteration 3 — MVE (Full S+E)**
DO: Production-grade deliverables reliable at current scale, locked plans, final RACI, committed sprint schedules, stakeholder sign-off, closed-loop improvement tracking.
DO NOT: Self-optimizing systems, predictive analytics, auto-scaling infrastructure, anything that adjusts itself without human trigger.

**Iteration 4 — Leadership (S+E+Scalability)**
DO: Self-executing workflows, auto-scaling operations, predictive models (issues, blockers, resource needs), self-adjusting OKRs, systems that learn and update Effective Principles autonomously.
DO NOT: New foundational work — Iteration 4 presumes Iteration 0–Iteration 3 are complete and stable. Manual workarounds — a manual step at Iteration 4 is a gap, not a feature.

---

### Sub-System Inheritance Note

When a project has multiple sub-systems (e.g., PD → DP → DA → IDM), the **Problem Diagnosis (PD) version sets the ceiling** for all downstream sub-systems.


| PD Version | DP ceiling                                        | DA ceiling                              | IDM ceiling                                |
| ---------- | ------------------------------------------------- | --------------------------------------- | ------------------------------------------ |
| Iteration 0         | Pipeline design is conceptual only                | Analysis methodology is mapped only     | Decision framework is theoretical only     |
| Iteration 1         | Pipeline must handle data safely and correctly    | Analysis must produce validated results | Decisions must be provably safe            |
| Iteration 2         | Pipeline must be more efficient than alternatives | Analysis must outperform prior methods  | Decisions must demonstrate better outcomes |
| Iteration 3         | Pipeline must be production-reliable              | Analysis must be production-reliable    | Decisions must be reliably actionable      |
| Iteration 4         | Pipeline self-optimizes and scales                | Analysis auto-detects patterns          | Decisions are predictive and prescriptive  |


**Rule:** If a downstream sub-system's design conflicts with PD's Effective Principles, PD wins. Downstream sub-systems cannot exceed their upstream dependency's version level.

---

## 4. P3 — ALIGN Workstream Walkthrough: How It Actually Works

When you run `/dsbv design align`, a structured sequence of agents, rules, and human gates activates — not a chat. Every artifact is produced under contract (DESIGN.md), every phase transition requires your approval, and five always-on rules enforce quality at every step. The walkthrough below traces exactly what happens, from the moment you type the command to the moment ALIGN is marked complete.

---

### Step-by-Step Walkthrough


| #   | Phase      | Command                            | Agent                                                   | Produces                                                                                    | Rules That Fire                                                                                                                                                                                                                                                             | Gate                                                                                                                                               |
| --- | ---------- | ---------------------------------- | ------------------------------------------------------- | ------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0   | Pre-flight | *(auto — fires before every task)* | ltc-explorer (Haiku) can assist with pre-DSBV discovery | GREEN / RED status report                                                                   | **alpei-pre-flight** (6 checks: workstream, alignment, risks, drivers, learning, version consistency) · **alpei-chain-of-custody** (upstream workstream dependency check)                                                                                                               | RED on any check = STOP. Fix before proceeding.                                                                                                    |
| 1   | Design     | `/dsbv design align`               | **ltc-planner** (Opus)                                  | `1-ALIGN/DESIGN.md` — artifact inventory, per-artifact purpose, binary ACs, alignment table | **versioning** (new file → version 1.0 / status Draft) · **agent-dispatch** (5-field context package required)                                                                                                                                                              | **G1:** Human reviews DESIGN.md. Approves → Sequence unlocks. Requests changes → planner revises and re-presents.                                  |
| 2   | Sequence   | `/dsbv sequence align`             | **ltc-planner** (Opus)                                  | `1-ALIGN/SEQUENCE.md` — ordered task list, dependencies, sizing, session plan               | **dsbv** (hard gate: approved DESIGN.md must exist) · **agent-dispatch** (5-field context package)                                                                                                                                                                          | **G2:** Human reviews SEQUENCE.md. Approves → Build unlocks. No approved DESIGN.md = error, not warning.                                           |
| 3   | Build      | `/dsbv build align`                | **ltc-builder** (Sonnet)                                | Workstream artifacts per SEQUENCE.md: charter, OKRs, decisions, stakeholder map                   | **versioning** (bump version + update last_updated on every file edit) · **alpei-chain-of-custody** (upstream check per task — GOVERN workstream must have ≥1 validated artifact) · **agent-dispatch** (5-field context package; cost estimate shown before multi-agent launch) | **G3:** Human reviews Build output. Approves → Validate unlocks. ltc-builder does NOT approve its own work.                                        |
| 4   | Validate   | `/dsbv validate align`             | **ltc-reviewer** (Opus)                                 | `1-ALIGN/VALIDATE.md` — per-criterion PASS / FAIL / PARTIAL with file-path evidence         | **dsbv** (hard gate: Validate must complete before workstream is marked done) · **agent-dispatch** (5-field context package)                                                                                                                                                      | **G4:** Human reviews VALIDATE.md. All PASS → ALIGN marked complete. Any FAIL → ltc-builder fixes, re-validates. Human ONLY sets status: validated. |


---

### Gate Summary


| Gate | Trigger condition                                        | Blocks what                                        |
| ---- | -------------------------------------------------------- | -------------------------------------------------- |
| G1   | Human approves `1-ALIGN/DESIGN.md`                       | Sequence cannot start                              |
| G2   | Human approves `1-ALIGN/SEQUENCE.md`                     | Build cannot start                                 |
| G3   | Human approves Build output                              | Validate cannot start                              |
| G4   | Human approves `1-ALIGN/VALIDATE.md` (all criteria PASS) | LEARN workstream cannot start; ALIGN not marked complete |


Gates are decision points, not labels. The system does not advance automatically — it stops and waits.

---

### Always-On Rules (Every Phase)

Five rules load at session start and fire continuously. They cannot be disabled per-command.


| Rule                       | File                                      | What it enforces                                                                                                                                                                                                                                              |
| -------------------------- | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **alpei-pre-flight**       | `scripts/pre-flight.sh`                   | 9 checks before every task: workstream, alignment, risks, drivers, templates, learning, version, S>E>Sc, decisions. RED = stop.                                                                                                                                     |
| **alpei-chain-of-custody** | `.claude/rules/alpei-chain-of-custody.md` | Workstream N cannot build until Workstream N-1 has ≥1 validated artifact. Phase ordering: Design → Sequence → Build → Validate, no skips.                                                                                                                                 |
| **versioning**             | `.claude/rules/versioning.md`             | Every edited `.md` file must have `version`, `status`, `last_updated` frontmatter. Iteration 1 files = 1.x. Agent sets Draft/Review. Human ONLY sets Approved.                                                                                                         |
| **dsbv**                   | `.claude/skills/dsbv/SKILL.md`            | No artifact produced outside DSBV. Phase ordering enforced with hard gates. Workstream N cannot reach Review until Workstream N-1 has ≥1 Approved artifact.                                                                                                               |
| **agent-dispatch**         | `.claude/rules/agent-dispatch.md`         | Every Agent() call must: (1) name one of the 4 MECE agents, (2) use 5-field context package (EO → INPUT → EP → OUTPUT → VERIFY), (3) match model to agent file, (4) use absolute paths in worktrees. Enforced via PreToolUse hook — ad-hoc calls are blocked. |


---

### Agent Roster


| Agent        | Model  | DSBV Phase        | Scope boundary                                                     |
| ------------ | ------ | ----------------- | ------------------------------------------------------------------ |
| ltc-explorer | Haiku  | Pre-DSBV          | Read-only research and discovery. Does NOT produce workstream artifacts. |
| ltc-planner  | Opus   | Design + Sequence | Defines WHAT to build and in what order. Does NOT write artifacts. |
| ltc-builder  | Sonnet | Build             | Produces artifacts per SEQUENCE.md. Does NOT design or review.     |
| ltc-reviewer | Opus   | Validate          | Reviews against DESIGN.md criteria. Does NOT fix — reports only.   |


---

### Example: PM ↔ Agent Interaction

This is what the ALIGN Design → Sequence transition looks like in practice.

---

**PM:** `/dsbv design align`

**ltc-planner:** Pre-flight check — all 6 conditions GREEN. Loading dsbv-context-template.md. What do you want ALIGN to accomplish for the PD sub-system? Give me 1-3 sentences.

**PM:** ALIGN should define success for the PD sub-system: stakeholders, OKRs, and the decision log for why we chose this scope.

**ltc-planner:** Drafting DESIGN.md now.

> Artifact inventory: charter (PD scope + stakeholders), OKR register (3 OKRs, binary ACs), decision log (ADR-001 scope choice). Alignment table: 3 completion conditions, 3 artifacts, 0 orphans. Versioning: version 1.0 / status Draft / last_updated 2026-03-30.
>
> **G1 — Design complete.** I produced: `1-ALIGN/DESIGN.md` (3 artifacts, 0 orphan conditions). Ready to proceed to Sequence?

**PM:** Looks good. Proceed.

**ltc-planner:** G1 approved. Running `/dsbv sequence align`.

> Reading approved DESIGN.md. Task order: (1) Draft charter — 45 min, inputs: stakeholder list; (2) Draft OKR register — 30 min, inputs: charter §Objectives; (3) Draft ADR-001 — 20 min, inputs: charter §Scope. Total: ~95 min.
>
> **G2 — Sequence complete.** Task order above, sizes confirmed. Ready to proceed to Build?

**PM:** Approved. Launch Build.

**ltc-planner:** G2 approved. Dispatching ltc-builder with 5-field context package. Cost estimate: single-agent Build ~$3-5. Proceed? [y/n]

---

The PM makes three decisions in this exchange: approve Design, approve Sequence, authorize Build cost. The agents do not advance on their own.

---

## 5. P4 — LEARN Workstream: Cross-Workstream Data Flows

LEARN (LEARN workstream) is the research engine of the ALPEI system. It converts raw stakeholder input and framework analysis into structured artifacts — UBS threat inventories, UDS driver inventories, and Effective Principles — that every downstream workstream consumes. LEARN does not produce decisions or plans; it produces the evidence base that makes decisions and plans defensible. Two flows are upstream (LEARN feeds ALIGN and PLAN directly) and one is bidirectional (ALIGN charter scopes what LEARN researches; LEARN findings refine the charter).

---

### ASCII Data Flow Diagram

```
  ┌─────────────────────────────────────────────────────────────────────┐
  │                        2-LEARN (LEARN workstream)                             │
  │                                                                     │
  │  output/                          research/                         │
  │  ├── PD-UBS-UDS.md                ├── PD-RESEARCH-SCOPE.md          │
  │  │   (threat + driver inventory)  │   (research findings/evidence)  │
  │  └── PD-EFFECTIVE-PRINCIPLES.md  └── PD-RESEARCH-PLAN.md            │
  │      (validated EPs)                  (methodology)                  │
  └──────────┬──────────────────────┬──────────────────────────────────┘
             │                      │
    ┌────────▼────────┐    ┌────────▼────────┐
    │ 1-ALIGN (ALIGN workstream)│    │ 3-PLAN (PLAN workstream) │
    │                 │◄──►│                 │
    │ charter/        │ ^  │ risks/          │
    │ CHARTER.md      │ │  │ UBS_REGISTER.md │
    │ (§Design Princ) │ │  │                 │
    │                 │ │  │ drivers/        │
    │ decisions/      │ │  │ UDS_REGISTER.md │
    │ ADR_*.md        │ │  │                 │
    │ (rationale)     │ │  │ architecture/   │
    └────────┬────────┘ │  │ ARCHITECTURE.md │
             │          │  │                 │
             │          │  │ roadmap/        │
             │          │  │ ROADMAP.md      │
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

### Cross-Workstream Flow Table


| Flow | Source Artifact                             | Data Type                                          | Target Artifact                         | How Consumed                                                                                                              |
| ---- | ------------------------------------------- | -------------------------------------------------- | --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| F1   | `2-LEARN/output/PD-UBS-UDS.md`              | UBS threat inventory (layered root-cause analysis) | `3-PLAN/risks/UBS_REGISTER.md`          | Each UBS entry expands into a register row: blocker, root cause, mitigation action, owner                                 |
| F2   | `2-LEARN/output/PD-UBS-UDS.md`              | UDS driver inventory (root enabler analysis)       | `3-PLAN/drivers/UDS_REGISTER.md`        | Each UDS entry expands into a register row: driver, root enabler, leverage action, owner                                  |
| F3   | `2-LEARN/output/PD-EFFECTIVE-PRINCIPLES.md` | Validated Effective Principles (safety-checked)    | `1-ALIGN/charter/CHARTER.md`            | Charter §Design Principles section is populated from EPs; each principle traces back to a LEARN finding                   |
| F4   | `2-LEARN/output/PD-EFFECTIVE-PRINCIPLES.md` | Validated Effective Principles                     | `3-PLAN/architecture/ARCHITECTURE.md`   | Architecture component constraints derive from EPs — each design decision must cite the EP that governs it                |
| F5   | `2-LEARN/research/PD-RESEARCH-SCOPE.md`     | Research evidence and findings                     | `1-ALIGN/decisions/ADR_*.md`            | ADR rationale cites research findings as evidence; decisions not backed by LEARN findings are flagged as assumptions      |
| F6   | `2-LEARN/research/PD-RESEARCH-PLAN.md`      | Research methodology (validated approach)          | `3-PLAN/architecture/ARCHITECTURE.md`   | Architecture records which research methods validated each structural decision (research-backed vs. assumption-based)     |
| F7   | `2-LEARN/research/PD-RESEARCH-SCOPE.md`     | Scoped problem domain boundaries                   | `3-PLAN/roadmap/ROADMAP.md`             | Roadmap iteration inputs inherit problem domain scope from LEARN — prevents planning work outside the researched boundary |
| F8   | `4-EXECUTE/` deliverables                   | Metrics baseline + production data                 | `5-IMPROVE/metrics/METRICS_BASELINE.md` | IMPROVE measures delta from EXECUTE baseline — retros, changelog, and KR tracking require EXECUTE output as input         |


---

### What Stays in LEARN vs. What Crosses Boundaries


| Category             | Stays in 2-LEARN/                                          | Crosses to Other Workstreams                                                                           |
| -------------------- | ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| Raw input            | `input/raw/` — unprocessed transcripts, photos, recordings | No — raw data does not cross; only synthesized output does                                       |
| Research methodology | `research/PD-RESEARCH-PLAN.md`                             | Partial — methodology rationale cross-references into `3-PLAN/architecture/ARCHITECTURE.md`      |
| Structured analysis  | `output/PD-UBS-UDS.md`                                     | Yes — full inventory crosses to `3-PLAN/risks/` and `3-PLAN/drivers/`                            |
| Effective Principles | `output/PD-EFFECTIVE-PRINCIPLES.md`                        | Yes — crosses to `1-ALIGN/charter/CHARTER.md` and `3-PLAN/architecture/ARCHITECTURE.md`          |
| Research evidence    | `research/PD-RESEARCH-SCOPE.md`                            | Yes — crosses to `1-ALIGN/decisions/ADR_*.md` as decision rationale                              |
| VANA specifications  | `specs/`                                                   | No — VANA specs are internal to LEARN; they define what research must validate                   |
| Archive / superseded | `archive/`                                                 | No — completed research stays archived in LEARN; downstream workstreams retain only what they consumed |


**Boundary rule:** Only artifacts in `2-LEARN/output/` and `2-LEARN/research/` cross workstream boundaries. Raw input and internal specs are consumed within LEARN and do not propagate.

---

### LEARN ↔ ALIGN Bidirectional Relationship

LEARN and ALIGN have a two-way dependency that is intentional and bounded:

```
  1-ALIGN/charter/CHARTER.md
         │
         │  (1) Charter defines the research scope:
         │      "What problem are we solving for whom?"
         │      → scopes 2-LEARN/research/PD-RESEARCH-SCOPE.md
         ▼
  2-LEARN (research + analysis)
         │
         │  (2) LEARN findings refine the charter:
         │      Validated EPs update §Design Principles
         │      Research evidence surfaces assumptions in the charter
         │      UBS analysis may reveal charter scope gaps
         ▼
  1-ALIGN/charter/CHARTER.md (updated)
  1-ALIGN/decisions/ADR_*.md (new decisions added)
```

**Constraint:** ALIGN sets the initial scope boundary. LEARN cannot expand scope unilaterally — scope changes discovered during LEARN must be surfaced as ADR entries in `1-ALIGN/decisions/` and approved by the human before the charter is updated. LEARN refines; it does not redefine.

---

### LEARN → PLAN → EXECUTE Chain

LEARN outputs do not skip workstreams. The propagation path is strictly sequential:

```
2-LEARN/output/PD-UBS-UDS.md
    └──► 3-PLAN/risks/UBS_REGISTER.md       (mitigations defined)
              └──► 4-EXECUTE/                (mitigations implemented as checkpoints and validation gates)

2-LEARN/output/PD-EFFECTIVE-PRINCIPLES.md
    └──► 3-PLAN/architecture/ARCHITECTURE.md (constraints codified)
              └──► 4-EXECUTE/src/            (implementation must comply with architecture constraints)
```

EXECUTE workstream inherits from PLAN workstream, which inherits from LEARN workstream. EXECUTE does not read LEARN artifacts directly — it reads PLAN artifacts that were populated from LEARN. This one-hop indirection keeps EXECUTE focused on building, not researching.

---

### LEARN Pipeline — The 6-Skill Mechanism

LEARN is pre-DSBV research infrastructure. It does not use DSBV phases (Design → Sequence → Build → Validate) internally — instead, it uses a dedicated `/learn` pipeline that is state-aware, file-system-driven, and skill-dispatched. The entry point is `/learn {slug}`, which derives the current state from what files already exist in `2-LEARN/` and invokes the appropriate sub-skill. When the pipeline reaches State 5 (complete), the correct next step is `/dsbv design` for the downstream workstream — LEARN hands off to DSBV, it does not replace it. Templates for all P-page types are project-local: `2-LEARN/templates/page-{n}-*.md`.

#### State Machine


| State | Trigger condition                                         | Skill invoked                                                         | Output produced                                                        |
| ----- | --------------------------------------------------------- | --------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| S1    | No input file exists for slug                             | `/learn:input`                                                        | `2-LEARN/input/learn-input-{slug}.md`                                  |
| S2    | Input exists; no research dir for slug                    | `/learn:research {slug}`                                              | `2-LEARN/research/{slug}/` — raw research files per topic              |
| S3    | Research dir exists; ≥1 topic missing validated P-pages    | `/learn:structure {slug} {topic}` then `/learn:review {slug} {topic}` | `2-LEARN/research/{slug}/{topic}/P0–P7.md` all with `status: validated` |
| S4    | All topics validated; no vana-spec exists                  | `/learn:spec {slug}`                                                  | `2-LEARN/specs/{slug}/vana-spec.md` + `DSBV-READY-{slug}.md`           |
| S5    | Pipeline complete (vana-spec exists, all topics validated) | *(no skill — pipeline done)*                                          | Run `/dsbv design` for the target downstream workstream                      |


#### P0–P7 Page Structure (per topic)


| Page | Type                          | Content                                                  |
| ---- | ----------------------------- | -------------------------------------------------------- |
| P0   | Overview & Summary            | Problem definition, scope boundaries, key concepts       |
| P1   | Ultimate Blockers             | UBS entries — threats, root causes, failure modes        |
| P2   | Ultimate Drivers              | UDS entries — enablers, leverage points, success factors |
| P3   | Effective Principles          | Governing rules derived from P0–P2 analysis              |
| P4   | Components                    | System elements, structural breakdown, taxonomy          |
| P5   | Steps to Apply                | Operational procedure — how to use the knowledge         |
| P7   | Topic Distilled Understanding | Synthesis: what this topic means for the project         |


#### Workstream-Crossing Outputs


| Output file                                    | Consumed by                                                                                                       |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `2-LEARN/output/{SUB}-UBS-UDS.md`              | `3-PLAN/risks/UBS_REGISTER.md` (UBS entries) · `3-PLAN/drivers/UDS_REGISTER.md` (UDS entries)                     |
| `2-LEARN/output/{SUB}-EFFECTIVE-PRINCIPLES.md` | `1-ALIGN/charter/CHARTER.md` (§Design Principles) · `3-PLAN/architecture/ARCHITECTURE.md` (component constraints) |
| `2-LEARN/specs/{slug}/vana-spec.md`            | Downstream DSBV Design phases — initializes Design context for the consuming workstream                                 |


LEARN completes (S5) → run `/dsbv design` for the target downstream workstream.

---

## 6. References


| Item                                       | Path                                                                                                                                                                                                                                     |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Version Behaviors (source of truth for P2) | `_genesis/frameworks/ues-version-behaviors.md`                                                                                                                                                                                           |
| DSBV sub-process definition                | `_genesis/templates/dsbv-process.md`                                                                                                                                                                                                     |
| Template index                             | `_genesis/templates/README.md`                                                                                                                                                                                                           |
| ALPEI always-on rules                      | `scripts/pre-flight.sh` · `.claude/rules/alpei-chain-of-custody.md` · `.claude/rules/versioning.md` · `.claude/skills/dsbv/SKILL.md` · `.claude/rules/agent-dispatch.md`                                                                 |
| Agent definitions                          | `.claude/agents/ltc-planner.md` · `.claude/agents/ltc-builder.md` · `.claude/agents/ltc-reviewer.md` · `.claude/agents/ltc-explorer.md`                                                                                                  |
| DSBV skill entry point                     | `.claude/skills/dsbv/`                                                                                                                                                                                                                   |
| Gap-fill templates (T1–T8)                 | `_genesis/templates/charter-template.md` · `architecture-template.md` · `okr-template.md` · `force-analysis-template.md` · `driver-entry-template.md` · `roadmap-template.md` · `metrics-baseline-template.md` · `test-plan-template.md` |


---

## 7. Routing Tables — Agent Dispatch by Workstream × Phase

> **Purpose:** Runtime lookup for agent dispatch and template selection. To find the correct template and agent for any task, grep `## Routing: {WORKSTREAM}` in this file, then read the row matching your current DSBV phase.
>
> **Lookup syntax:** `grep "## Routing: PLAN" _genesis/frameworks/alpei-dsbv-process-map.md`
>
> **Update rule (DD-3):** When a new template is added, add a row to its Routing section and update `_genesis/templates/README.md`. No changes to rules or skill files — they reference this map by anchor.

---

## Routing: ALIGN


| Phase    | Template(s)                                      | Agent        | Deliverable Path                     | AC                                                       |
| -------- | ------------------------------------------------ | ------------ | ------------------------------------ | -------------------------------------------------------- |
| Design   | charter-template.md · force-analysis-template.md | ltc-planner  | `1-ALIGN/charter/CHARTER.md`         | Charter has EO, stakeholders, and VANA criteria          |
| Sequence | okr-template.md                                  | ltc-planner  | `1-ALIGN/okrs/OKR_REGISTER.md`       | All objectives have ≥1 KR with baseline and target       |
| Build    | charter-template.md                              | ltc-builder  | `1-ALIGN/charter/CHARTER.md` (final) | Signed off by PM; version frontmatter present            |
| Validate | review-template.md                               | ltc-reviewer | `1-ALIGN/VALIDATE.md`                | All DESIGN.md criteria PASS or have documented exception |


---

## Routing: LEARN

> LEARN does not use DSBV phase routing. Use the `/learn` pipeline instead.
> Full state machine and skill dispatch: see §P4 LEARN Pipeline.
> Lookup syntax: `/learn {slug}` — state is derived from file system on every invocation.


| State | Trigger                                              | Skill                                                              | Deliverable                                                  | AC                                                              |
| ----- | ---------------------------------------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------ | --------------------------------------------------------------- |
| S1    | No `2-LEARN/input/learn-input-{slug}.md`             | `/learn:input`                                                     | `2-LEARN/input/learn-input-{slug}.md`                        | Subject, scope boundaries, and UBS/UDS signal questions defined |
| S2    | Input exists; no `2-LEARN/research/{slug}/`          | `/learn:research {slug}`                                           | `2-LEARN/research/{slug}/`                                   | Research notes present per topic; each topic named              |
| S3    | Research present; any topic missing validated P-pages | `/learn:structure {slug} {topic}` → `/learn:review {slug} {topic}` | `2-LEARN/research/{slug}/{topic}/P0–P7.md`                   | All P-pages present; all have `status: validated`                |
| S4    | All topics validated; no vana-spec                    | `/learn:spec {slug}`                                               | `2-LEARN/specs/{slug}/vana-spec.md` · `DSBV-READY-{slug}.md` | VANA spec present; DSBV-READY file present                      |
| S5    | Pipeline complete                                    | `/dsbv design [downstream workstream]`                                   | See DSBV routing for target workstream                             | LEARN outputs consumed by target workstream Design phase              |


---

## Routing: PLAN


| Phase    | Template(s)                                         | Agent        | Deliverable Path                      | AC                                                              |
| -------- | --------------------------------------------------- | ------------ | ------------------------------------- | --------------------------------------------------------------- |
| Design   | force-analysis-template.md · risk-entry-template.md | ltc-planner  | `3-PLAN/risks/UBS_REGISTER.md`        | Every UBS entry has a mitigation                                |
| Sequence | roadmap-template.md · driver-entry-template.md      | ltc-planner  | `3-PLAN/roadmap/ROADMAP.md`           | Milestones map to iteration; drivers have leverage actions      |
| Build    | architecture-template.md                            | ltc-builder  | `3-PLAN/architecture/ARCHITECTURE.md` | Components, interfaces, and data flows present                  |
| Validate | review-template.md                                  | ltc-reviewer | `3-PLAN/VALIDATE.md`                  | Architecture references UBS mitigations; no orphaned components |


---

## Routing: EXECUTE


| Phase    | Template(s)                         | Agent        | Deliverable Path                          | AC                                                                  |
| -------- | ----------------------------------- | ------------ | ----------------------------------------- | ------------------------------------------------------------------- |
| Design   | design-template.md                  | ltc-planner  | `4-EXECUTE/DESIGN.md`                      | All artifacts have binary ACs; no orphan conditions                 |
| Sequence | dsbv-context-template.md            | ltc-planner  | `4-EXECUTE/SEQUENCE.md`                    | Tasks ordered by dependency with input/output/AC/token estimate     |
| Build    | (artifact-specific per SEQUENCE.md) | ltc-builder  | Workstream artifacts per `4-EXECUTE/SEQUENCE.md` | Each artifact passes its SEQUENCE.md AC before next task begins     |
| Validate | dsbv-eval-template.md               | ltc-reviewer | `4-EXECUTE/VALIDATE.md`                    | All SEQUENCE.md ACs addressed; no FAIL without documented exception |


---

## Routing: IMPROVE


| Phase    | Template(s)                                  | Agent        | Deliverable Path                         | AC                                                             |
| -------- | -------------------------------------------- | ------------ | ---------------------------------------- | -------------------------------------------------------------- |
| Design   | metrics-baseline-template.md                 | ltc-planner  | `5-IMPROVE/metrics/METRICS_BASELINE.md`  | Each metric has current value, target, and measurement method  |
| Sequence | retro-template.md                            | ltc-planner  | `5-IMPROVE/retrospectives/RETRO-PLAN.md` | Retro format defined; participants identified                  |
| Build    | test-plan-template.md · feedback-template.md | ltc-builder  | `5-IMPROVE/metrics/FEEDBACK_REGISTER.md` | Feedback has category, severity, and status per entry          |
| Validate | review-package-template.md                   | ltc-reviewer | `5-IMPROVE/reviews/VERSION-REVIEW.md`    | Three Pillars scored; version advancement decision: GO / NO-GO |

## Links

- [[ADR-001]]
- [[AGENTS]]
- [[CHANGELOG]]
- [[CLAUDE]]
- [[DESIGN]]
- [[README]]
- [[SEQUENCE]]
- [[SKILL]]
- [[UBS_REGISTER]]
- [[UDS_REGISTER]]
- [[VALIDATE]]
- [[adr]]
- [[agent-dispatch]]
- [[alpei-chain-of-custody]]
- [[architecture]]
- [[architecture-template]]
- [[blocker]]
- [[charter]]
- [[charter-template]]
- [[deliverable]]
- [[design-template]]
- [[driver-entry-template]]
- [[dsbv-context-template]]
- [[dsbv-eval-template]]
- [[dsbv-process]]
- [[feedback-template]]
- [[force-analysis-template]]
- [[iteration]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[methodology]]
- [[metrics-baseline-template]]
- [[okr]]
- [[okr-template]]
- [[pd-effective-principles]]
- [[project]]
- [[retro-template]]
- [[review-package-template]]
- [[review-template]]
- [[risk-entry-template]]
- [[roadmap]]
- [[roadmap-template]]
- [[task]]
- [[test-plan-template]]
- [[versioning]]
- [[workstream]]
