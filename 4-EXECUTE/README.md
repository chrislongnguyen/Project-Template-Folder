---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 4-EXECUTE
type: template
iteration: 1
---

# 4-EXECUTE — Deliver with Effective Process

> "Build it right, with the right tools, in the right environment."

## Purpose

Without EXECUTE, planning artifacts accumulate but nothing ships. The risk here is not inaction — it is uncontrolled action: building without confirming prerequisites, skipping correctness checks in favor of throughput, and delivering artifacts that cannot be verified against VANA criteria. This workstream enforces a derisk-first discipline — validate the environment and block all identified risks before producing output, then confirm each deliverable against its acceptance criteria before handing off to 5-IMPROVE.

## The 4 Stages

Every subsystem (PD, DP, DA, IDM) flows through these stages:

```
DESIGN  →  SEQUENCE  →  BUILD  →  VALIDATE
```

| Stage | Purpose | Key Output |
|-------|---------|-----------|
| **Design** | Confirm sprint scope; verify all prerequisites (inputs, tools, environment); log and mitigate blockers before work begins | Confirmed sprint scope; blocker log with mitigations; environment readiness checklist; team kick-off brief |
| **Sequence** | Design technical implementation for each deliverable; produce test plans and acceptance cases before writing any artifact | Technical design per deliverable; design review sign-off; test plan with acceptance criteria; integration specs |
| **Build** | Build and deliver artifacts — derisk-first: correctness before throughput; validate each component before integrating | Delivered artifacts; test results (all passing); delivery confirmation; inline documentation |
| **Validate** | Verify each deliverable meets VANA acceptance criteria; confirm evidence basis; reject any artifact that cannot be verified | Execution review report; defect log with severity; corrective actions; validated deliverables → 5-IMPROVE |

## Subsystem Flow

```
PD-EXECUTE  →  DP-EXECUTE  →  DA-EXECUTE  →  IDM-EXECUTE
```

| Subsystem | Focus | Key Inputs | Key Outputs |
|-----------|-------|-----------|------------|
| **PD** | Build problem-diagnosis artifacts — define what the problem is and establish effective principles that govern downstream work | PD execution plan + EP from PD-LEARN; PD acceptance criteria from PD-PLAN | UBS/UDS analysis documents; finalized effective principles; design guidelines for DP, DA, IDM |
| **DP** | Build and validate the transformation system — inputs are correctly processed before passing to analysis | **Principles from PD** + DP execution plan; PD design guidelines; source inputs | Transformation artifacts (source connectors, cleaning rules, processing logic); validated analysis-ready output |
| **DA** | Execute analytical logic; validate conclusions against evidence before producing insights | **Principles from PD** + DA execution plan; analysis-ready output from DP; DA acceptance criteria | Analyzed outputs (patterns, conclusions, anomalies); validated findings with confidence basis; methodology documentation |
| **IDM** | Build and deploy user-facing outputs — manual review before automation; usability validated before rollout | **Principles from all upstream** + IDM execution plan; analyzed outputs from DA; consumer decision context | Insight delivery artifacts (dashboards, reports, alerts, decision tools); user SOPs; delivery confirmation |

> **Critical:** PD produces the effective principles that govern the entire UES — DP, DA, and IDM inherit and build on them.

## Structure

| Folder | Contents |
|--------|---------|
| `1-PD/` | EXECUTE artifacts for problem diagnosis — analysis documents, effective principles, design guidelines; organized by DSBV stage |
| `2-DP/` | EXECUTE artifacts for transformation — source connectors, cleaning rules, processing logic, validation gates; organized by DSBV stage |
| `3-DA/` | EXECUTE artifacts for analysis and logic — analytical outputs, models, validated conclusions, methodology docs; organized by DSBV stage |
| `4-IDM/` | EXECUTE artifacts for insight delivery — dashboards, decision tools, alerts, SOPs, training materials; organized by DSBV stage |

## Templates

| Stage | Template |
|-------|---------|
| Design | [`design-template.md`](_genesis/templates/design-template.md) |
| Sequence | [`dsbv-process.md`](_genesis/templates/dsbv-process.md) |
| Build | Artifact-specific templates in [`_genesis/templates/`](_genesis/templates/) — match to subsystem deliverable type |
| Validate | [`review-template.md`](_genesis/templates/review-template.md) |

## Pre-Flight Checklist

### Design Stage
- [ ] Confirm sprint scope maps directly to a deliverable in the 3-PLAN execution plan
- [ ] Verify prerequisites — inputs available, tools accessible, environment configured
- [ ] Log all blockers with assigned mitigations before starting
- [ ] Distribute team kick-off brief with sprint scope and acceptance criteria

### Sequence Stage
- [ ] Complete technical design for each deliverable before any build work begins
- [ ] Obtain design review sign-off from a second reviewer
- [ ] Write test plan covering all VANA acceptance criteria
- [ ] Document integration specs for anything passed to a downstream subsystem

### Build Stage
- [ ] Follow derisk-first order — validate correctness at each step before proceeding
- [ ] All tests passing before marking any deliverable complete
- [ ] Documentation updated to match implementation
- [ ] Delivery confirmation obtained from the responsible owner

### Validate Stage
- [ ] All VANA acceptance criteria met
- [ ] Evidence basis verified
- [ ] Defect log complete with severity ratings
- [ ] Validated package ready for → 5-IMPROVE

## How EXECUTE Connects

```
                   locked execution plan
3-PLAN  ─────────────────────────────>  4-EXECUTE
                                            │
                                   validated deliverables
                                            │
                                            ▼
                                        5-IMPROVE

4-EXECUTE ──"unresolved unknown"──> 2-LEARN  (close gap before continuing)
4-EXECUTE ──"scope change"────────> 1-ALIGN  (re-align before proceeding)
```

## DASHBOARDS

![[EXECUTE Overview.base]]
