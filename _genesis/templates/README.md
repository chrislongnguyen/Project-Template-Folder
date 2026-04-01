---
version: "1.2"
status: Draft
last_updated: 2026-03-31
owner: Long Nguyen
---
# _genesis/templates/ — Document & Process Templates

**Purpose:** FORMATS — reusable document and process templates for LTC project workstreams.

**Cascade position:** Derived from `_genesis/frameworks/`. Templates instantiate framework patterns into concrete document structures.

**Usage:** Copy template → fill placeholders → commit as workstream artifact. Never edit originals in this directory.

---

## Contents

| Template | Purpose |
|----------|---------|
| `DESIGN_TEMPLATE.md` | DSBV Phase 1 artifact — workstream design contract with Scope Check + Execution Strategy |
| `DSBV_PROCESS.md` | DSBV sub-process definition — 4-stage workflow (Design, Sequence, Build, Validate) |
| `DSBV_CONTEXT_TEMPLATE.md` | Context package structure for launching DSBV agents |
| `DSBV_EVAL_TEMPLATE.md` | Evaluation rubric for comparing multi-agent outputs |
| `ADR_TEMPLATE.md` | Architecture Decision Record — decision + rationale + alternatives |
| `FEEDBACK_TEMPLATE.md` | Feedback capture for template-level improvement issues |
| `RESEARCH_METHODOLOGY.md` | Research phase methodology and source evaluation criteria |
| `RESEARCH_TEMPLATE.md` | Research output structure |
| `RETRO_TEMPLATE.md` | Workstream retrospective — lessons learned, root cause, mitigation |
| `REVIEW_PACKAGE_TEMPLATE.md` | Review package for human approval gates |
| `REVIEW_TEMPLATE.md` | Peer review structure |
| `RISK_ENTRY_TEMPLATE.md` | UBS risk register entry format |
| `SOP_TEMPLATE.md` | Standard Operating Procedure |
| `SPIKE_TEMPLATE.md` | Time-boxed exploration / research spike |
| `STANDUP_TEMPLATE.md` | Daily standup format |
| `VANA_SPEC_TEMPLATE.md` | VANA requirements spec (Value, Acceptance, Needs, Assumptions) |
| `WIKI_PAGE_TEMPLATE.md` | Wiki / reference page |
| `CHARTER_TEMPLATE.md` (new) | Project charter — EO, stakeholders, scope, VANA criteria (T1) |
| `ARCHITECTURE_TEMPLATE.md` (new) | Overall architecture doc — components, interfaces, data flows (T2) |
| `OKR_TEMPLATE.md` (new) | OKR register — Objective + KRs with baseline, target, formula (T3) |
| `FORCE_ANALYSIS_TEMPLATE.md` (new) | Force analysis session — driving/restraining forces + UBS/UDS routing (T4) |
| `DRIVER_ENTRY_TEMPLATE.md` (new) | UDS driver register entry — parallel to RISK_ENTRY_TEMPLATE (T5) |
| `ROADMAP_TEMPLATE.md` (new) | Roadmap — milestones, dependencies, iteration mapping (T6) |
| `METRICS_BASELINE_TEMPLATE.md` (new) | Quantitative metrics baseline — current value, target, measurement method (T7) |
| `TEST_PLAN_TEMPLATE.md` (new) | Test plan — cases, expected/actual, pass/fail, AC coverage (T8) |

---

## Workstream×Phase Index

> Look up the right template by ALPEI workstream (row) and DSBV phase (column).
> "(new)" = added in A2 gap-fill. Use this table before reading the full Process Map.
> Full context: `_genesis/frameworks/ALPEI_DSBV_PROCESS_MAP.md`

| Workstream | Design (ltc-planner) | Sequence (ltc-planner) | Build (ltc-builder) | Validate (ltc-reviewer) |
|------|----------------------|------------------------|---------------------|-------------------------|
| **1-ALIGN** | CHARTER_TEMPLATE.md (new)<br>FORCE_ANALYSIS_TEMPLATE.md (new) | OKR_TEMPLATE.md (new) | CHARTER_TEMPLATE.md (new) | REVIEW_TEMPLATE.md |
| **2-LEARN** | _(see §P4 LEARN Pipeline)_ | _(see §P4 LEARN Pipeline)_ | `/learn pipeline` — entry: `/learn {slug}` → produces P0–P7 pages per topic | `/learn:review` — all P-pages reach `status: approved` |
| **3-PLAN** | FORCE_ANALYSIS_TEMPLATE.md (new)<br>RISK_ENTRY_TEMPLATE.md | ROADMAP_TEMPLATE.md (new)<br>DRIVER_ENTRY_TEMPLATE.md (new) | ARCHITECTURE_TEMPLATE.md (new) | REVIEW_TEMPLATE.md |
| **4-EXECUTE** | DESIGN_TEMPLATE.md | DSBV_CONTEXT_TEMPLATE.md | _(artifact-specific per SEQUENCE.md)_ | DSBV_EVAL_TEMPLATE.md |
| **5-IMPROVE** | METRICS_BASELINE_TEMPLATE.md (new) | RETRO_TEMPLATE.md | TEST_PLAN_TEMPLATE.md (new)<br>FEEDBACK_TEMPLATE.md | REVIEW_PACKAGE_TEMPLATE.md |

> Full LEARN pipeline: `_genesis/frameworks/ALPEI_DSBV_PROCESS_MAP.md` §P4 LEARN Pipeline
