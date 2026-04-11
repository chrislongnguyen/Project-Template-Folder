---
version: "1.4"
status: draft
last_updated: 2026-04-11
---

# P1 — 5×4 Matrix: ALPEI Workstreams × DSBV stages

## Overview

Every workstream in the ALPEI system produces artifacts through the same four-stage DSBV sub-process: **Design → Sequence → Build → Validate**. The 5×4 matrix below makes that structure explicit — each cell names the template used, the deliverable path, the assigned agent, and the binary acceptance criterion for that workstream-stage intersection. 

**Problem Diagnosis (PD)** serves as the worked example sub-system with all 20 cells filled; all other sub-systems (DP, DA, IDM) follow the identical pattern, substituting their own deliverable paths and domain-specific content.

---

## Matrix Table 1 — Design + Sequence (ltc-planner: Opus)

> Stages owned by **ltc-planner** (model: Opus). Produces DESIGN.md and SEQUENCE.md artifacts.


| Workstream          | Design (ltc-planner)                                                                                                                                                            | Sequence (ltc-planner)                                                                                                                                                                  |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1-ALIGN**   | **Template:** charter-template.md (T1) + force-analysis-template.md (T4) **Deliverable:** `1-ALIGN/1-PD/pd-charter.md` (pattern: `{ws}/{N}-{SUB}/{sub}-charter.md` for all 4 subsystems) **AC:** Charter has EO, stakeholders, and VANA criteria. | **Template:** okr-template.md (T3) **Deliverable:** `1-ALIGN/1-PD/pd-okr-register.md` **AC:** All objectives have ≥1 KR with baseline and target.                                          |
| **2-LEARN**   | *LEARN uses the `/learn` pipeline — not DSBV stages.*<br>Entry: `/learn {slug}`<br>See §P4 LEARN Pipeline for state machine and skill dispatch. | *See §P4 LEARN Pipeline* |
| **3-PLAN**    | **Template:** force-analysis-template.md (T4) + risk-entry-template.md **Deliverable:** `3-PLAN/risks/UBS_REGISTER.md` **AC:** Every UBS entry has a mitigation.                | **Template:** roadmap-template.md (T6) + driver-entry-template.md (T5) **Deliverable:** `3-PLAN/1-PD/pd-roadmap.md` (pattern: `{ws}/{N}-{SUB}/{sub}-roadmap.md` for all 4 subsystems) **AC:** Milestones map to iteration. Drivers have leverage actions. |
| **4-EXECUTE** | **Template:** design-template.md **Deliverable:** `4-EXECUTE/1-PD/DESIGN.md` (pattern: `{ws}/{N}-{SUB}/DESIGN.md` for all 4 subsystems) **AC:** All artifacts have binary ACs. No orphan conditions.                                             | **Template:** dsbv-context-template.md **Deliverable:** `4-EXECUTE/1-PD/SEQUENCE.md` (pattern: `{ws}/{N}-{SUB}/SEQUENCE.md`) **AC:** Tasks ordered by dependency with input/output/AC/token estimate.                                 |
| **5-IMPROVE** | **Template:** metrics-baseline-template.md (T7) **Deliverable:** `5-IMPROVE/_cross/cross-metrics-baseline.md` **AC:** Each metric has current value, target, and measurement method. | **Template:** retro-template.md **Deliverable:** `5-IMPROVE/1-PD/pd-retro-template.md` (pattern: `{ws}/{N}-{SUB}/{sub}-retro-template.md` for all 4 subsystems) **AC:** Retro format defined; participants identified.                                                |


---

## Matrix Table 2 — Build + Validate (ltc-builder: Sonnet / ltc-reviewer: Opus)

> Build owned by **ltc-builder** (model: Sonnet). Validate owned by **ltc-reviewer** (model: Opus).


| Workstream          | Build (ltc-builder)                                                                                                                                                                                               | Validate (ltc-reviewer)                                                                                                                                                 |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1-ALIGN**   | **Template:** charter-template.md (T1) **Deliverable:** `1-ALIGN/1-PD/pd-charter.md` (final) (pattern: `{ws}/{N}-{SUB}/{sub}-charter.md` for all 4 subsystems) **AC:** Signed off by PM; version frontmatter present.                                                               | **Template:** review-template.md **Deliverable:** `1-ALIGN/VALIDATE.md` **AC:** All DESIGN.md criteria PASS or have a documented exception.                            |
| **2-LEARN**   | *LEARN uses the `/learn` pipeline — not DSBV stages.*<br>Pipeline: `/learn:input` → `/learn:research` → `/learn:structure` → `/learn:review` → `/learn:spec`<br>Outputs: `2-LEARN/1-PD/pd-ubs-uds.md` · `2-LEARN/1-PD/pd-effective-principles.md` · P0–P7 pages per topic (pattern: `2-LEARN/{N}-{SUB}/{sub}-effective-principles.md`) | *Validation via `/learn:review` per topic — all P-pages reach `status: validated` before pipeline advances* |
| **3-PLAN**    | **Template:** architecture-template.md (T2) **Deliverable:** `3-PLAN/1-PD/pd-architecture.md` (pattern: `{ws}/{N}-{SUB}/{sub}-architecture.md` for all 4 subsystems) **AC:** Components, interfaces, and data flows present.                                                        | **Template:** review-template.md **Deliverable:** `3-PLAN/VALIDATE.md` **AC:** Architecture references UBS mitigations. No orphaned components.                  |
| **4-EXECUTE** | **Template:** (artifact-specific per SEQUENCE.md) **Deliverable:** Workstream artifacts per `4-EXECUTE/1-PD/SEQUENCE.md` (pattern: `{ws}/{N}-{SUB}/SEQUENCE.md`) **AC:** Each artifact passes its SEQUENCE.md AC before the next task begins.                         | **Template:** dsbv-eval-template.md **Deliverable:** `4-EXECUTE/1-PD/VALIDATE.md` (pattern: `{ws}/{N}-{SUB}/VALIDATE.md`) **AC:** All SEQUENCE.md ACs addressed. No FAIL without a documented exception.              |
| **5-IMPROVE** | **Template:** test-plan-template.md (T8) + feedback-template.md **Deliverable:** `5-IMPROVE/_cross/cross-feedback-register.md` **AC:** Feedback has category, severity, and status per entry.                          | **Template:** review-package-template.md **Deliverable:** `5-IMPROVE/_cross/cross-version-review.md` **AC:** Three Pillars scored. Version advancement decision: GO / NO-GO. |


---

## Pre-DSBV stage — Research (ltc-explorer: Haiku)

> Before Design begins, **ltc-explorer** runs wide-net discovery. This is not a DSBV stage — it feeds the Design stage as input.


| Role             | Scope                                                                                                                                          |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **ltc-explorer** | Codebase exploration, existing template inventory, UBS/UDS signal gathering, source evaluation. Produces input notes only — no workstream artifacts. |


---

## Sub-System Inheritance Table

PD is the first sub-system and sets the version ceiling. DP, DA, and IDM follow the same 5×4 matrix pattern but may not exceed the version of their upstream sub-system.


| Sub-system | Full Name                | Inherits From           | Version Ceiling Rule                        |
| ---------- | ------------------------ | ----------------------- | ------------------------------------------- |
| **PD**     | Problem Diagnosis        | — (first in chain)      | Sets ceiling for all downstream sub-systems |
| **DP**     | Data Pipeline            | PD Effective Principles | DP version ≤ PD version                     |
| **DA**     | Data Analytics           | DP Effective Principles | DA version ≤ DP version                     |
| **IDM**    | Informed Decision Making | DA Effective Principles | IDM version ≤ DA version                    |


**Inheritance rule:** Each sub-system's Effective Principles (produced in LEARN workstream Build) are inherited by the next sub-system as validated inputs. A downstream sub-system may not advance to a higher version than its upstream dependency. If PD is at v1.2, DP may not exceed v1.2.

> PD is the worked example showing all 20 cells. DP, DA, and IDM follow the identical workstream × stage structure with their own deliverable paths and domain content.

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[UBS_REGISTER]]
- [[VALIDATE]]
- [[architecture]]
- [[architecture-template]]
- [[charter]]
- [[charter-template]]
- [[deliverable]]
- [[design-template]]
- [[driver-entry-template]]
- [[dsbv-context-template]]
- [[dsbv-eval-template]]
- [[feedback-template]]
- [[force-analysis-template]]
- [[iteration]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[metrics-baseline-template]]
- [[okr-template]]
- [[retro-template]]
- [[review-package-template]]
- [[review-template]]
- [[risk-entry-template]]
- [[roadmap]]
- [[roadmap-template]]
- [[task]]
- [[test-plan-template]]
- [[workstream]]
