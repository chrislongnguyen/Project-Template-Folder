---
type: reference
classification: INTERNAL
date: 2026-03-30
---

# UES VERSION-SPECIFIC BEHAVIORS

## PURPOSE

This document answers a single question: **"What does this work stream produce at this version level?"**

The ALPEI framework defines 5 version levels (Logic Scaffold, Concept, Prototype, MVE, Leadership) and 5 work streams (Align, Learn, Plan, Execute, Improve). Each combination produces deliverables of a specific depth, format, and rigor. This 25-cell matrix eliminates ambiguity about what "done" looks like at every intersection.

Use this document to:
- Scope deliverables correctly before starting work
- Avoid over-building (producing MVE-grade output during Logic Scaffold)
- Avoid under-delivering (skipping safety validation during Concept)
- Guide AI agents on appropriate output depth

---

## VERSION-BEHAVIOR MATRIX

### ALIGN WORK STREAM

| **VERSION** | **DEPTH** | **DELIVERABLES** | **KEY DIFFERENCE** |
|---|---|---|---|
| **Logic Scaffold** | Map scope and logic only | Project Charter (conceptual), VANA criteria (initial), Stakeholder map (draft) | No implementation details; purely structural understanding |
| **Concept** | Prove sustainability | Project Charter (validated), Master Plan (safety-focused), VANA criteria (sustainability-verified) | Must prove correctness and safety; all alignment claims validated |
| **Prototype** | Add efficiency | OKRs (efficiency metrics), Master Plan (efficiency-optimized), Resource allocation (benchmarked) | Must outperform alternatives; efficiency gains documented |
| **MVE** | Full efficiency | Full OKR set, Locked Master Plan, Stakeholder sign-off, Budget commitment | Production-ready alignment; all stakeholders formally committed |
| **Leadership** | Add scalability | Automated alignment checks, Predictive resource planning, Self-adjusting OKRs | Self-improving alignment; system detects and corrects misalignment automatically |

### LEARN WORK STREAM

| **VERSION** | **DEPTH** | **DELIVERABLES** | **KEY DIFFERENCE** |
|---|---|---|---|
| **Logic Scaffold** | Map what to learn | UBS inventory (draft), UDS inventory (draft), Research questions list | Identify blockers and drivers only; no analysis or validation |
| **Concept** | Validate principles | UBS analysis (validated), UDS analysis (validated), Effective Principles (derived and safety-checked) | Principles must be proven correct; simulated validation acceptable |
| **Prototype** | Test on real data | UBS/UDS tested against real data, Effective Principles (efficiency-proven), Research methodology (refined) | Principles tested on actual data; must demonstrate efficiency gains |
| **MVE** | Proven in production | UBS/UDS analysis (production-validated), Effective Principles (locked), Learning audit (complete) | Principles proven reliable in production; no open questions remain |
| **Leadership** | Automated learning | Automated UBS/UDS detection, Self-updating Effective Principles, Predictive blocker identification | System learns and updates principles without manual intervention |

### PLAN WORK STREAM

| **VERSION** | **DEPTH** | **DELIVERABLES** | **KEY DIFFERENCE** |
|---|---|---|---|
| **Logic Scaffold** | Rough scope only | Iteration Design (draft), Task list (conceptual), Dependency map (initial) | High-level structure; no time estimates, no resource assignments |
| **Concept** | Risk-aware planning | Iteration Design (risk-assessed), Task breakdown (safety-sequenced), UBS Risk Register (populated) | Plans must address sustainability risks first; risk mitigation explicit |
| **Prototype** | Optimized planning | Task breakdown (effort-estimated), UDS Driver Register (populated), Critical path (optimized) | Plans optimized for efficiency; effort estimates based on real data |
| **MVE** | Reliable execution plan | Locked Execution Plan, RACI assignments (final), Sprint schedule (committed), Risk/Driver entries (complete) | Plans are production-grade; all tasks assigned, estimated, and committed |
| **Leadership** | Adaptive planning | Auto-generated sprint plans, Predictive effort estimation, Dynamic re-planning on blocker detection | System generates and adjusts plans based on historical performance data |

### EXECUTE WORK STREAM

| **VERSION** | **DEPTH** | **DELIVERABLES** | **KEY DIFFERENCE** |
|---|---|---|---|
| **Logic Scaffold** | No execution | No artifacts produced; execution is out of scope | This version produces understanding, not implementation |
| **Concept** | Manual or simulated execution | Simulated deliverables, Manual workflows, Safety-verified outputs | Execution proves correctness; manual processes acceptable; must not break anything |
| **Prototype** | Real but limited execution | Working deliverables (limited scope), Automated where efficient, Performance benchmarks | Real tools and real outputs; must demonstrate clear efficiency over manual approach |
| **MVE** | Full production execution | Production-grade deliverables, Reliable automated workflows, Cost-effective operations | Everything works reliably at current scale; proven cost-effectiveness |
| **Leadership** | Automated execution | Self-executing workflows, Predictive issue prevention, Auto-scaling operations | System executes, monitors, and self-corrects without human intervention |

### IMPROVE WORK STREAM

| **VERSION** | **DEPTH** | **DELIVERABLES** | **KEY DIFFERENCE** |
|---|---|---|---|
| **Logic Scaffold** | Identify improvement areas | Improvement areas list, Gap analysis (conceptual), Success criteria (initial) | Map where improvement is needed; no feedback collection or analysis yet |
| **Concept** | Collect feedback safely | Feedback collection (structured), Retrospective notes (safety-focused), Validated improvement hypotheses | Feedback must be collected without disrupting operations; safety-first |
| **Prototype** | Analyze efficiently | Feedback analysis (quantified), Sprint Review (efficiency-benchmarked), Prioritized improvement backlog | Analysis must be efficient; improvements ranked by effort-to-impact ratio |
| **MVE** | Reliable feedback loops | Feedback Register (production-grade), Sprint Review (comprehensive), Implemented improvements (verified) | Closed-loop improvement; every improvement tracked from hypothesis to verified outcome |
| **Leadership** | Predictive improvement | Automated feedback detection, Predictive issue identification, Self-optimizing processes | System predicts problems before they surface and applies improvements proactively |

---

## SUB-SYSTEM INHERITANCE AT EACH VERSION

The version level of Problem Diagnosis (PD) governs all downstream sub-systems. When PD is at a given version, downstream sub-systems (DP, DA, IDM) cannot exceed that version's behavioral expectations.

| **PD VERSION** | **DP INHERITS** | **DA INHERITS** | **IDM INHERITS** |
|---|---|---|---|
| **Logic Scaffold** | Pipeline design is conceptual only | Analysis methodology is mapped only | Decision framework is theoretical only |
| **Concept** | Pipeline must handle data safely and correctly | Analysis must produce validated results | Decisions must be provably safe |
| **Prototype** | Pipeline must be more efficient than alternatives | Analysis must outperform prior methods | Decisions must demonstrate better outcomes |
| **MVE** | Pipeline must be production-reliable | Analysis must be production-reliable | Decisions must be reliably actionable |
| **Leadership** | Pipeline self-optimizes and scales | Analysis auto-detects patterns | Decisions are predictive and prescriptive |

PD's Effective Principles always take precedence. If a downstream sub-system's design conflicts with PD's EP, PD wins.

---

## PRACTICAL GUIDE

Use this quick reference to calibrate your deliverables:

**If you are at Logic Scaffold:**
- Your deliverables should look like: maps, inventories, structural diagrams, scope definitions, VANA criteria
- Do NOT produce: working code, automated pipelines, production configurations, performance benchmarks

**If you are at Concept:**
- Your deliverables should look like: validated principles, safety-checked designs, simulated environments, manual-but-correct workflows
- Do NOT produce: optimized systems, efficiency benchmarks, production-grade automation

**If you are at Prototype:**
- Your deliverables should look like: working tools with real data, efficiency comparisons, benchmarked performance, limited-scope implementations
- Do NOT produce: fully scaled systems, self-healing automation, predictive capabilities

**If you are at MVE:**
- Your deliverables should look like: production-grade systems, reliable automated workflows, cost-effective operations, comprehensive audit trails
- Do NOT produce: self-optimizing systems, predictive analytics, auto-scaling infrastructure

**If you are at Leadership:**
- Your deliverables should look like: self-improving systems, predictive models, automated decision-making, auto-scaling operations
- Everything from prior versions is assumed complete and stable

---

## RELATED REFERENCES

- [[COE EFF_EFFECTIVE PLANNING - User Enablement System (UES) Versioning]] -- Version progression and VANA criteria
- [[ALPEI Framework Overview & Principles]] -- Full framework reference
- [[COE EFF_EFFECTIVENESS - AREA TRAINING MATERIALS - 1. Truths We Need to Master to Succeed]] -- 10 Ultimate Truths
- [[COE EFF_EFFECTIVENESS - AREA TRAINING MATERIALS - 2. Effective System Design]] -- 8-Component System Design Model
