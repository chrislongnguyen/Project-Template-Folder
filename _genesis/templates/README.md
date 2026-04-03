---
version: "1.2"
status: draft
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
| `design-template.md` | DSBV Phase 1 artifact — workstream design contract with Scope Check + Execution Strategy |
| `dsbv-process.md` | DSBV sub-process definition — 4-stage workflow (Design, Sequence, Build, Validate) |
| `dsbv-context-template.md` | Context package structure for launching DSBV agents |
| `dsbv-eval-template.md` | Evaluation rubric for comparing multi-agent outputs |
| `adr-template.md` | Architecture Decision Record — decision + rationale + alternatives |
| `feedback-template.md` | Feedback capture for template-level improvement issues |
| `research-methodology.md` | Research phase methodology and source evaluation criteria |
| `research-template.md` | Research output structure |
| `retro-template.md` | Workstream retrospective — lessons learned, root cause, mitigation |
| `review-package-template.md` | Review package for human approval gates |
| `review-template.md` | Peer review structure |
| `risk-entry-template.md` | UBS risk register entry format |
| `sop-template.md` | Standard Operating Procedure |
| `spike-template.md` | Time-boxed exploration / research spike |
| `standup-template.md` | Daily standup format |
| `vana-spec-template.md` | VANA requirements spec (Value, Acceptance, Needs, Assumptions) |
| `wiki-page-template.md` | Wiki / reference page |
| `charter-template.md` (new) | Project charter — EO, stakeholders, scope, VANA criteria (T1) |
| `architecture-template.md` (new) | Overall architecture doc — components, interfaces, data flows (T2) |
| `okr-template.md` (new) | OKR register — Objective + KRs with baseline, target, formula (T3) |
| `force-analysis-template.md` (new) | Force analysis session — driving/restraining forces + UBS/UDS routing (T4) |
| `driver-entry-template.md` (new) | UDS driver register entry — parallel to RISK_ENTRY_TEMPLATE (T5) |
| `roadmap-template.md` (new) | Roadmap — milestones, dependencies, iteration mapping (T6) |
| `metrics-baseline-template.md` (new) | Quantitative metrics baseline — current value, target, measurement method (T7) |
| `test-plan-template.md` (new) | Test plan — cases, expected/actual, pass/fail, AC coverage (T8) |

---

## Workstream×Phase Index

> Look up the right template by ALPEI workstream (row) and DSBV phase (column).
> "(new)" = added in A2 gap-fill. Use this table before reading the full Process Map.
> Full context: `_genesis/frameworks/alpei-dsbv-process-map.md`

| Workstream | Design (ltc-planner) | Sequence (ltc-planner) | Build (ltc-builder) | Validate (ltc-reviewer) |
|------|----------------------|------------------------|---------------------|-------------------------|
| **1-ALIGN** | charter-template.md (new)<br>force-analysis-template.md (new) | okr-template.md (new) | charter-template.md (new) | review-template.md |
| **2-LEARN** | _(see §P4 LEARN Pipeline)_ | _(see §P4 LEARN Pipeline)_ | `/learn pipeline` — entry: `/learn {slug}` → produces P0–P7 pages per topic | `/learn:review` — all P-pages reach `status: approved` |
| **3-PLAN** | force-analysis-template.md (new)<br>risk-entry-template.md | roadmap-template.md (new)<br>driver-entry-template.md (new) | architecture-template.md (new) | review-template.md |
| **4-EXECUTE** | design-template.md | dsbv-context-template.md | _(artifact-specific per SEQUENCE.md)_ | dsbv-eval-template.md |
| **5-IMPROVE** | metrics-baseline-template.md (new) | retro-template.md | test-plan-template.md (new)<br>feedback-template.md | review-package-template.md |

> Full LEARN pipeline: `_genesis/frameworks/alpei-dsbv-process-map.md` §P4 LEARN Pipeline

## Links

- [[adr-template]]
- [[alpei-dsbv-process-map]]
- [[architecture-template]]
- [[charter-template]]
- [[DESIGN]]
- [[design-template]]
- [[driver-entry-template]]
- [[dsbv-context-template]]
- [[dsbv-eval-template]]
- [[dsbv-process]]
- [[feedback-template]]
- [[force-analysis-template]]
- [[metrics-baseline-template]]
- [[okr-template]]
- [[research-methodology]]
- [[research-template]]
- [[retro-template]]
- [[review-package-template]]
- [[review-template]]
- [[risk-entry-template]]
- [[roadmap-template]]
- [[SEQUENCE]]
- [[sop-template]]
- [[spike-template]]
- [[standup-template]]
- [[test-plan-template]]
- [[VALIDATE]]
- [[vana-spec-template]]
- [[wiki-page-template]]
- [[dsbv]]
- [[iteration]]
- [[ltc-builder]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[methodology]]
- [[project]]
- [[standard]]
- [[workstream]]
