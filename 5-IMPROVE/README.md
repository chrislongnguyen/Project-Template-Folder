---
version: "1.3"
status: draft
last_updated: 2026-04-12
work_stream: 5-IMPROVE
type: template
iteration: 1
---

# 5-IMPROVE — Learn, Reflect, Institutionalize

> "What worked? What didn't? How do we make it stick?"

## Purpose

Without a structured improvement workstream, teams repeat the same failures in the next iteration — EXECUTE builds something, it ships, and the lessons live only in people's heads. 5-IMPROVE closes the ALPEI loop by measuring actual system performance against the baselines from 3-PLAN, capturing what worked and what didn't in structured retrospectives, and synthesizing insights that feed 1-ALIGN's next iteration. Without IMPROVE, success is accidental and failure is unlearned.

## The 4 Stages

Every subsystem (PD, DP, DA, IDM) flows through these stages:

```
DESIGN  →  SEQUENCE  →  BUILD  →  VALIDATE
```

| Stage | Purpose | Key Output |
|-------|---------|-----------|
| **Design** | Define what to measure and how — metrics framework, feedback channels, retrospective scope | Metrics baseline design per subsystem; feedback collection plan; retrospective agenda template |
| **Sequence** | Order improvement activities by impact — what gets measured first, what gets reviewed | Measurement schedule; retrospective timeline; next-iteration re-alignment triggers |
| **Build** | Collect measurements, run retrospectives, document findings | `{ss}-metrics-baseline.md`; `{ss}-retro.md`; `{ss}-feedback.md`; `CHANGELOG.md`; `project-metrics-dashboard.md` |
| **Validate** | Verify improvement artifacts are complete and actionable — insights must be specific enough to inform 1-ALIGN | Improvement review report; next-iteration scope draft; validated improvement package → 1-ALIGN |

## Subsystem Flow

```
PD-IMPROVE  →  DP-IMPROVE  →  DA-IMPROVE  →  IDM-IMPROVE
```

| Subsystem | Focus | Key Inputs | Key Outputs |
|-----------|-------|-----------|------------|
| **PD** | Measure PD system performance — diagnosis accuracy, coverage, false-positive rate | **PD deployed artifacts from 4-EXECUTE**; baseline KPIs from `1-ALIGN/pd-okr.md` | `pd-retro.md`; `pd-metrics-baseline.md`; PD improvement insights → 1-ALIGN next iteration |
| **DP** | Measure pipeline performance — data quality, latency, uptime, error rates | **Principles from PD** + DP deployed pipeline; data quality SLAs from `3-PLAN/2-DP` | `dp-retro.md`; `dp-metrics-baseline.md`; pipeline improvement insights → 1-ALIGN |
| **DA** | Measure analysis quality — insight accuracy, method performance, bias metrics | **Principles from PD** + DA deployed analysis; insight quality SLAs from `3-PLAN/3-DA` | `da-retro.md`; `da-metrics-baseline.md`; analytical improvement insights → 1-ALIGN |
| **IDM** | Measure delivery effectiveness — usage rates, decision outcomes, adoption | **Principles from all upstream** + IDM deployed delivery layer; delivery SLAs from `3-PLAN/4-IDM`; stakeholder feedback | `idm-retro.md`; `satisfaction-metrics.md`; next-iteration delivery scope → 1-ALIGN (loop closes) |

> **Critical:** PD produces the effective principles that govern the entire UES — DP, DA, and IDM inherit and build on them.

## Structure

| Folder | Contents |
|--------|---------|
| `1-PD/` | PD retro, metrics baseline, feedback artifacts, DESIGN/SEQUENCE/VALIDATE |
| `2-DP/` | DP retro, pipeline performance metrics, feedback artifacts, DESIGN/SEQUENCE/VALIDATE |
| `3-DA/` | DA retro, analysis quality metrics, feedback artifacts, DESIGN/SEQUENCE/VALIDATE |
| `4-IDM/` | IDM retro, delivery effectiveness metrics, stakeholder satisfaction, DESIGN/SEQUENCE/VALIDATE |
| `_cross/` | CHANGELOG.md, project-wide metrics dashboard, team feedback aggregate, cross-cutting retrospective |

## Templates

| Stage | Template |
|-------|---------|
| Design | [`design-template.md`](../_genesis/templates/design-template.md) |
| Sequence | [`dsbv-process.md`](../_genesis/templates/dsbv-process.md) |
| Build (retro) | [`retro-template.md`](../_genesis/templates/retro-template.md) |
| Build (metrics) | [`metrics-baseline-template.md`](../_genesis/templates/metrics-baseline-template.md) |
| Build (feedback) | [`feedback-template.md`](../_genesis/templates/feedback-template.md) |
| Validate | [`review-template.md`](../_genesis/templates/review-template.md) |

## Pre-Flight Checklist

### Design Stage
- [ ] Metrics framework defined — what to measure, how, and at what frequency
- [ ] Baseline values captured from 3-PLAN KPIs and 4-EXECUTE test results
- [ ] Feedback collection channels identified (user surveys, logs, observability dashboards)
- [ ] Retrospective scope agreed — all 4 subsystems covered

### Sequence Stage
- [ ] Measurement period defined — how long before enough signal is available
- [ ] Retrospective scheduled with the right participants (not just the build team)
- [ ] Next-iteration re-alignment triggers defined (what metric threshold forces 1-ALIGN re-entry)

### Build Stage
- [ ] All `{ss}-metrics-baseline.md` files complete — actual vs. target comparison
- [ ] All `{ss}-retro.md` complete — what worked, what didn't, what changes for next iteration
- [ ] `CHANGELOG.md` updated with all iteration changes
- [ ] `project-metrics-dashboard.md` reflects current state

### Validate Stage
- [ ] All VANA acceptance criteria met
- [ ] Evidence basis verified
- [ ] Improvement insights are specific enough to inform 1-ALIGN scoping decisions
- [ ] No "we should do better next time" platitudes — every finding has a concrete next action
- [ ] Next-iteration scope documented and ready for 1-ALIGN
- [ ] Validated package ready for → 1-ALIGN (loop closes)

## How IMPROVE Connects

```
                    deployed + tested artifacts
4-EXECUTE  ───────────────────────────────────────>  5-IMPROVE
                                                          │
                                              iteration retrospective
                                              + metrics + next-version scope
                                                          │
                                                          ▼
                                               1-ALIGN  (loop closes)
```

- **4-EXECUTE → 5-IMPROVE:** Deployed artifacts, test results, user feedback signals
- **5-IMPROVE → 1-ALIGN:** Retrospective closes the iteration — next version begins with re-alignment
- **5-IMPROVE → any WS:** Systemic failure → re-enter the appropriate workstream

## DASHBOARDS

![[12-improvement-overview.base]]

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
- [[alpei-blueprint]]
- [[CHANGELOG]]
