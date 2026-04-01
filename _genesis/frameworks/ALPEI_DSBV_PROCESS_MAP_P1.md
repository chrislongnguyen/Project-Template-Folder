---
version: "1.2"
status: Draft
last_updated: 2026-03-31
---

# P1 — 5×4 Matrix: ALPEI Workstreams × DSBV Phases

## Overview

Every workstream in the ALPEI system produces artifacts through the same four-phase DSBV sub-process: **Design → Sequence → Build → Validate**. The 5×4 matrix below makes that structure explicit — each cell names the template used, the deliverable path, the assigned agent, and the binary acceptance criterion for that workstream-phase intersection. 

**Problem Diagnosis (PD)** serves as the worked example sub-system with all 20 cells filled; all other sub-systems (DP, DA, IDM) follow the identical pattern, substituting their own deliverable paths and domain-specific content.

---

## Matrix Table 1 — Design + Sequence (ltc-planner: Opus)

> Phases owned by **ltc-planner** (model: Opus). Produces DESIGN.md and SEQUENCE.md artifacts.


| Workstream          | Design (ltc-planner)                                                                                                                                                            | Sequence (ltc-planner)                                                                                                                                                                  |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1-ALIGN**   | **Template:** CHARTER_TEMPLATE.md (T1) + FORCE_ANALYSIS_TEMPLATE.md (T4) **Deliverable:** `1-ALIGN/charter/CHARTER.md` **AC:** Charter has EO, stakeholders, and VANA criteria. | **Template:** OKR_TEMPLATE.md (T3) **Deliverable:** `1-ALIGN/okrs/OKR_REGISTER.md` **AC:** All objectives have ≥1 KR with baseline and target.                                          |
| **2-LEARN**   | *LEARN uses the `/learn` pipeline — not DSBV phases.*<br>Entry: `/learn {slug}`<br>See §P4 LEARN Pipeline for state machine and skill dispatch. | *See §P4 LEARN Pipeline* |
| **3-PLAN**    | **Template:** FORCE_ANALYSIS_TEMPLATE.md (T4) + RISK_ENTRY_TEMPLATE.md **Deliverable:** `3-PLAN/risks/UBS_REGISTER.md` **AC:** Every UBS entry has a mitigation.                | **Template:** ROADMAP_TEMPLATE.md (T6) + DRIVER_ENTRY_TEMPLATE.md (T5) **Deliverable:** `3-PLAN/roadmap/ROADMAP.md` **AC:** Milestones map to iteration. Drivers have leverage actions. |
| **4-EXECUTE** | **Template:** DESIGN_TEMPLATE.md **Deliverable:** `4-EXECUTE/DESIGN.md` **AC:** All artifacts have binary ACs. No orphan conditions.                                             | **Template:** DSBV_CONTEXT_TEMPLATE.md **Deliverable:** `4-EXECUTE/SEQUENCE.md` **AC:** Tasks ordered by dependency with input/output/AC/token estimate.                                 |
| **5-IMPROVE** | **Template:** METRICS_BASELINE_TEMPLATE.md (T7) **Deliverable:** `5-IMPROVE/metrics/METRICS_BASELINE.md` **AC:** Each metric has current value, target, and measurement method. | **Template:** RETRO_TEMPLATE.md **Deliverable:** `5-IMPROVE/retros/RETRO-PLAN.md` **AC:** Retro format defined; participants identified.                                                |


---

## Matrix Table 2 — Build + Validate (ltc-builder: Sonnet / ltc-reviewer: Opus)

> Build owned by **ltc-builder** (model: Sonnet). Validate owned by **ltc-reviewer** (model: Opus).


| Workstream          | Build (ltc-builder)                                                                                                                                                                                               | Validate (ltc-reviewer)                                                                                                                                                 |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1-ALIGN**   | **Template:** CHARTER_TEMPLATE.md (T1) **Deliverable:** `1-ALIGN/charter/CHARTER.md` (final) **AC:** Signed off by PM; version frontmatter present.                                                               | **Template:** REVIEW_TEMPLATE.md **Deliverable:** `1-ALIGN/VALIDATE.md` **AC:** All DESIGN.md criteria PASS or have a documented exception.                            |
| **2-LEARN**   | *LEARN uses the `/learn` pipeline — not DSBV phases.*<br>Pipeline: `/learn:input` → `/learn:research` → `/learn:structure` → `/learn:review` → `/learn:spec`<br>Outputs: `2-LEARN/output/{SUB}-UBS-UDS.md` · `2-LEARN/output/{SUB}-EFFECTIVE-PRINCIPLES.md` · P0–P7 pages per topic | *Validation via `/learn:review` per topic — all P-pages reach `status: approved` before pipeline advances* |
| **3-PLAN**    | **Template:** ARCHITECTURE_TEMPLATE.md (T2) **Deliverable:** `3-PLAN/architecture/ARCHITECTURE.md` **AC:** Components, interfaces, and data flows present.                                                        | **Template:** REVIEW_TEMPLATE.md **Deliverable:** `3-PLAN/VALIDATE.md` **AC:** Architecture references UBS mitigations. No orphaned components.                  |
| **4-EXECUTE** | **Template:** (artifact-specific per SEQUENCE.md) **Deliverable:** Workstream artifacts per `4-EXECUTE/SEQUENCE.md` **AC:** Each artifact passes its SEQUENCE.md AC before the next task begins.                         | **Template:** DSBV_EVAL_TEMPLATE.md **Deliverable:** `4-EXECUTE/VALIDATE.md` **AC:** All SEQUENCE.md ACs addressed. No FAIL without a documented exception.              |
| **5-IMPROVE** | **Template:** TEST_PLAN_TEMPLATE.md (T8) + FEEDBACK_TEMPLATE.md **Deliverable:** `5-IMPROVE/metrics/FEEDBACK_REGISTER.md` **AC:** Feedback has category, severity, and status per entry.                          | **Template:** REVIEW_PACKAGE_TEMPLATE.md **Deliverable:** `5-IMPROVE/reviews/VERSION-REVIEW.md` **AC:** Three Pillars scored. Version advancement decision: GO / NO-GO. |


---

## Pre-DSBV Phase — Research (ltc-explorer: Haiku)

> Before Design begins, **ltc-explorer** runs wide-net discovery. This is not a DSBV phase — it feeds the Design phase as input.


| Role             | Scope                                                                                                                                          |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **ltc-explorer** | Codebase exploration, existing template inventory, UBS/UDS signal gathering, source evaluation. Produces input notes only — no workstream artifacts. |


---

## Sub-System Inheritance Table

PD is the first sub-system and sets the version ceiling. DP, DA, and IDM follow the same 5×4 matrix pattern but may not exceed the version of their upstream sub-system.


| Sub-system | Full Name                | Inherits From           | Version Ceiling Rule                        |
| ---------- | ------------------------ | ----------------------- | ------------------------------------------- |
| **PD**     | Problem Diagnosis        | — (first in chain)      | Sets ceiling for all downstream sub-systems |
| **DP**     | Diagnosis Protocol       | PD Effective Principles | DP version ≤ PD version                     |
| **DA**     | Diagnostic Analysis      | DP Effective Principles | DA version ≤ DP version                     |
| **IDM**    | Informed Decision Making | DA Effective Principles | IDM version ≤ DA version                    |


**Inheritance rule:** Each sub-system's Effective Principles (produced in LEARN workstream Build) are inherited by the next sub-system as validated inputs. A downstream sub-system may not advance to a higher version than its upstream dependency. If PD is at v1.2, DP may not exceed v1.2.

> PD is the worked example showing all 20 cells. DP, DA, and IDM follow the identical workstream × phase structure with their own deliverable paths and domain content.

