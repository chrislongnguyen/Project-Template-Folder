---
version: "1.3"
status: draft
last_updated: 2026-04-12
work_stream: 4-EXECUTE
type: template
iteration: 1
---

# 4-EXECUTE — Deliver with Effective Process

> "Build it right, with the right tools, in the right environment."

## Purpose

Without rigorous execution discipline, even the best plan produces untested artifacts that fail in production — PLAN rigor is wasted if EXECUTE skips tests, ignores the architecture, or bypasses validation gates. 4-EXECUTE translates the approved architecture and roadmap from 3-PLAN into built, tested, and documented system artifacts — one subsystem at a time, in risk order. Its output — validated, deployed artifacts per subsystem — is what 5-IMPROVE measures and what stakeholders receive.

## The 4 Stages

Every subsystem (PD, DP, DA, IDM) flows through these stages:

```
DESIGN  →  SEQUENCE  →  BUILD  →  VALIDATE
```

| Stage | Purpose | Key Output |
|-------|---------|-----------|
| **Design** | Translate the architecture spec into an execution plan — what to build in what order, with what acceptance criteria | DSBV DESIGN.md per subsystem; agent dispatch plan; acceptance criteria (ACs) mapped to VANA outcomes |
| **Sequence** | Order build tasks by risk and dependency — parallelizable vs. sequential work identified | DSBV SEQUENCE.md per subsystem; task dependency map; sprint or iteration assignments |
| **Build** | Produce the artifacts — code, configs, tests, documentation — following DESIGN.md ACs | Source code (src/); test suite (tests/); configuration files (config/); documentation (docs/) |
| **Validate** | Verify artifacts against DESIGN.md acceptance criteria — human gate required for `status: validated` | VALIDATE.md review; test results; coverage report; defect log; validated artifact set → 5-IMPROVE |

## Subsystem Flow

```
PD-EXECUTE  →  DP-EXECUTE  →  DA-EXECUTE  →  IDM-EXECUTE
```

| Subsystem | Focus | Key Inputs | Key Outputs |
|-----------|-------|-----------|------------|
| **PD** | Build the problem-diagnosis system — implement the PD architecture from 3-PLAN | **pd-architecture.md from 3-PLAN**; PD Effective Principles as build constraints | PD src/ + tests/ + docs/ → validated PD system; inputs to DP build |
| **DP** | Build the data pipeline — ingest, transform, validate, store per dp-architecture.md | **DP architecture + PD constraints**; data quality SLAs from 3-PLAN | DP pipeline code + tests + pipeline-test-plan.md → validated pipeline feeding DA |
| **DA** | Build the analysis layer — implement analytical methods per da-architecture.md | **DA architecture + DP pipeline outputs** (test data); analytical constraints | DA analysis code + tests + da-test-plan.md → validated analysis feeding IDM |
| **IDM** | Build the delivery layer — dashboards, reports, APIs per idm-architecture.md | **IDM architecture + DA outputs**; delivery format spec; access requirements | Delivery artifacts + acceptance tests → validated delivery system → 5-IMPROVE |

> **Critical:** PD produces the effective principles that govern the entire UES — DP, DA, and IDM inherit and build on them.

## Structure

| Folder | Contents |
|--------|---------|
| `1-PD/` | PD source code, test suite, documentation, DESIGN/SEQUENCE/VALIDATE |
| `2-DP/` | Pipeline code, data quality tests, ingestion configs, DESIGN/SEQUENCE/VALIDATE |
| `3-DA/` | Analysis code, statistical tests, analytical documentation, DESIGN/SEQUENCE/VALIDATE |
| `4-IDM/` | Dashboard/API/report artifacts, acceptance tests, delivery docs, DESIGN/SEQUENCE/VALIDATE |
| `_cross/` | Shared configuration, environment setup, CI/CD config, cross-cutting documentation |

## Templates

| Stage | Template |
|-------|---------|
| Design | [`design-template.md`](../_genesis/templates/design-template.md) |
| Sequence | [`dsbv-process.md`](../_genesis/templates/dsbv-process.md) |
| Build (test plan) | [`test-plan-template.md`](../_genesis/templates/test-plan-template.md) |
| Build (SOP) | [`sop-template.md`](../_genesis/templates/sop-template.md) |
| Validate | [`review-template.md`](../_genesis/templates/review-template.md) |

## Pre-Flight Checklist

### Design Stage
- [ ] 3-PLAN architecture received and understood — DESIGN.md maps each AC to a VANA outcome
- [ ] Agent dispatch plan written — which agents build which artifacts
- [ ] Acceptance criteria are testable and measurable (not vague)
- [ ] Environment ready — tools, permissions, infrastructure confirmed

### Sequence Stage
- [ ] Build tasks ordered by risk (most dangerous unknowns built first)
- [ ] Dependencies between subsystems explicit — DP needs PD done before integration tests
- [ ] Parallelizable work identified

### Build Stage
- [ ] Source code reviewed and passes all tests
- [ ] Test coverage meets agreed threshold
- [ ] Documentation written for every public interface
- [ ] Configuration externalized — no hardcoded secrets or paths

### Validate Stage
- [ ] All DESIGN.md ACs passed — results documented in VALIDATE.md
- [ ] Human reviewer set `status: validated` (agents cannot self-validate)
- [ ] Defect log reviewed — critical issues resolved or deferred with rationale
- [ ] Validated artifacts ready → 5-IMPROVE

## How EXECUTE Connects

```
                    approved architecture + roadmap
3-PLAN  ─────────────────────────────────────────────>  4-EXECUTE
                                                              │
                                                  deployed + tested artifacts
                                                  + build postmortem
                                                              │
                                                              ▼
                                                         5-IMPROVE
```

- **3-PLAN → 4-EXECUTE:** Architecture, risk register, sequenced roadmap — the build contract
- **4-EXECUTE → 5-IMPROVE:** Deployed artifacts, test results, build postmortem
- **4-EXECUTE → 3-PLAN:** Design flaw discovered mid-build → back to planning (expensive — minimize via 3-PLAN rigor)

## DASHBOARDS

![[11-execution-overview.base]]

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
- [[alpei-blueprint]]
- [[dsbv-process]]
