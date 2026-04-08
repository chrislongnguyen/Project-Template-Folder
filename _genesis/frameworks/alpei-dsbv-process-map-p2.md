---
version: "1.0"
status: draft
last_updated: 2026-03-31
type: reference
source: "Derived from ues-version-behaviors.md — no invented behaviors"
---

# P2 — Version Progression: What Each Workstream Produces at Each Depth

## Introduction

The ALPEI framework defines 5 version levels. Each level sets a ceiling on what any workstream is allowed to produce — building deeper than your current version is waste; building shallower is a gap. This section maps those version levels to LTC iteration naming (I0–I4) and shows exactly what "done" looks like at every workstream-version intersection.

Source of truth for all 25 cells: `_genesis/frameworks/ues-version-behaviors.md`.

---

## Version Naming Map

| LTC Name | Original UES Name | Three Pillars Alignment | One-Line Summary |
|----------|-------------------|------------------------|-----------------|
| **I0** | Logic Scaffold | Pre-build (no pillar yet) | Map scope and logic only — no implementation |
| **I1** | Concept | Sustainability only | Prove correctness and safety — nothing breaks |
| **I2** | Prototype | Sustainability + Efficiency | Work on real data and outperform alternatives |
| **I3** | MVE (Minimum Viable Experience) | Sustainability + Efficiency (fully realized) | Production-grade — reliable at current scale |
| **I4** | Leadership | Sustainability + Efficiency + Scalability | Self-improving, self-executing, predictive |

> **Reading rule:** I0 is pre-build framing. I1 adds the first pillar (Safety/Sustainability). Each subsequent level adds capability, not replaces it — I4 assumes everything from I0–I3 is complete and stable.

---

## 25-Cell Version-Depth Matrix

> Rows = version level (I0–I4). Columns = ALPEI workstream. Each cell = what that workstream produces AT that version level.
> Source: `ues-version-behaviors.md` § per-work-stream tables.

| Version | 1-ALIGN | 2-LEARN | 3-PLAN | 4-EXECUTE | 5-IMPROVE |
|---------|---------|---------|--------|-----------|-----------|
| **I0** (Logic Scaffold) | Project Charter (conceptual), Stakeholder map (draft), VANA criteria (initial) | UBS inventory (draft), UDS inventory (draft), Research questions list | Iteration Scope (draft), Task list (conceptual), Dependency map (initial) | No artifacts — execution is out of scope at this level | Improvement areas list, Gap analysis (conceptual), Success criteria (initial) |
| **I1** (Concept) | Project Charter (validated), Master Plan (safety-focused), VANA criteria (sustainability-verified) | UBS analysis (validated), UDS analysis (validated), Effective Principles (derived, safety-checked) | Iteration Scope (risk-assessed), Task breakdown (safety-sequenced), UBS Risk Register (populated) | Simulated deliverables, Manual workflows, Safety-verified outputs | Feedback collection (structured), Retrospective notes (safety-focused), Validated improvement hypotheses |
| **I2** (Prototype) | OKRs (efficiency metrics), Master Plan (efficiency-optimized), Resource allocation (benchmarked) | UBS/UDS tested against real data, Effective Principles (efficiency-proven), Research methodology (refined) | Task breakdown (effort-estimated), UDS Driver Register (populated), Critical path (optimized) | Working deliverables (limited scope), Automated where efficient, Performance benchmarks | Feedback analysis (quantified), Sprint Review (efficiency-benchmarked), Prioritized improvement backlog |
| **I3** (MVE) | Full OKR set, Locked Master Plan, Stakeholder sign-off, Budget commitment | UBS/UDS analysis (production-validated), Effective Principles (locked), Learning audit (complete) | Locked Execution Plan, RACI assignments (final), Sprint schedule (committed), Risk/Driver entries (complete) | Production-grade deliverables, Reliable automated workflows, Cost-effective operations | Feedback Register (production-grade), Sprint Review (comprehensive), Implemented improvements (verified) |
| **I4** (Leadership) | Automated alignment checks, Predictive resource planning, Self-adjusting OKRs | Automated UBS/UDS detection, Self-updating Effective Principles, Predictive blocker identification | Auto-generated sprint plans, Predictive effort estimation, Dynamic re-planning on blocker detection | Self-executing workflows, Predictive issue prevention, Auto-scaling operations | Automated feedback detection, Predictive issue identification, Self-optimizing processes |

---

## Practical Calibration Guide

Use this to sanity-check deliverables before starting or reviewing work.

### I0 — Logic Scaffold (Pre-build)

**DO produce:**
- Scope definitions, structural maps, dependency diagrams
- VANA criteria (initial), stakeholder lists (draft)
- UBS/UDS inventories (identified, not yet analyzed)
- Conceptual task lists and improvement area maps

**DO NOT produce:**
- Working code, automated pipelines, performance benchmarks
- Validated principles, signed-off plans, locked registers
- Any executed output — execution is explicitly out of scope at I0

---

### I1 — Concept (Sustainability)

**DO produce:**
- Validated charters and safety-checked designs
- Simulated or manual-but-correct workflows
- Risk Registers with populated entries
- Structured feedback collection (no disruption to operations)

**DO NOT produce:**
- Efficiency benchmarks or optimized systems
- Production-grade automation or real-data testing
- Locked or committed plans — I1 proves correctness, not finality

---

### I2 — Prototype (Sustainability + Efficiency)

**DO produce:**
- Working tools using real data (limited scope)
- Efficiency comparisons — must outperform I1 manual approach
- Benchmarked performance and effort estimates
- Populated Driver Registers and optimized critical paths

**DO NOT produce:**
- Fully scaled systems or production-grade reliability
- Self-healing automation or predictive capabilities
- Comprehensive audit trails (those belong to I3)

---

### I3 — MVE (Full S+E)

**DO produce:**
- Production-grade deliverables — reliable at current scale
- Locked plans, final RACI, committed sprint schedules
- Stakeholder sign-off, budget commitment, closed-loop improvement tracking
- Comprehensive retrospectives and verified improvement outcomes

**DO NOT produce:**
- Self-optimizing systems or predictive analytics
- Auto-scaling infrastructure or automated decision-making
- Anything that adjusts itself without human trigger

---

### I4 — Leadership (S+E+Scalability)

**DO produce:**
- Self-executing workflows, auto-scaling operations
- Predictive models (issues, blockers, resource needs)
- Self-adjusting OKRs, automated alignment checks
- Systems that learn and update Effective Principles without manual intervention

**DO NOT produce:**
- New foundational work — I4 presumes I0–I3 are complete and stable
- Manual workarounds — if a manual step exists at I4, it is a gap, not a feature

---

## Sub-System Inheritance Note

When a project has multiple sub-systems (e.g., PD → DP → DA → IDM), the **Problem Diagnosis (PD) version sets the ceiling** for all downstream sub-systems.

| PD Version | DP ceiling | DA ceiling | IDM ceiling |
|------------|-----------|-----------|------------|
| I0 | Pipeline design is conceptual only | Analysis methodology is mapped only | Decision framework is theoretical only |
| I1 | Pipeline must handle data safely and correctly | Analysis must produce validated results | Decisions must be provably safe |
| I2 | Pipeline must be more efficient than alternatives | Analysis must outperform prior methods | Decisions must demonstrate better outcomes |
| I3 | Pipeline must be production-reliable | Analysis must be production-reliable | Decisions must be reliably actionable |
| I4 | Pipeline self-optimizes and scales | Analysis auto-detects patterns | Decisions are predictive and prescriptive |

**Rule:** If a downstream sub-system's design conflicts with PD's Effective Principles, PD wins. Downstream sub-systems cannot exceed their upstream dependency's version level.

---

*Source: `_genesis/frameworks/ues-version-behaviors.md` — all 25 cells and sub-system inheritance table trace directly to that document. No behaviors invented.*

## Links

- [[DESIGN]]
- [[blocker]]
- [[charter]]
- [[iteration]]
- [[methodology]]
- [[okr]]
- [[project]]
- [[task]]
- [[workstream]]
