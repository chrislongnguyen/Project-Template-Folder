---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 5-IMPROVE
type: template
iteration: 1
---

# 5-IMPROVE — Learn, Reflect, Institutionalize

> "What worked? What didn't? How do we make it stick?"

## Purpose

Nothing shipped is automatically useful. Without IMPROVE, validated deliverables exit EXECUTE without any mechanism to capture what failed, institutionalize what worked, or route corrections to the right subsystem. Teams repeat the same mistakes across iterations because failures are observed but never formalized. This workstream closes the ALPEI loop by collecting, prioritizing, and routing validated improvements back to the correct subsystem's ALIGN — ensuring every future iteration starts with evidence, not assumption.

## The 4 Stages

Every subsystem (PD, DP, DA, IDM) flows through these stages:

```
DESIGN  →  SEQUENCE  →  BUILD  →  VALIDATE
```

| Stage | Purpose | Key Output |
|-------|---------|-----------|
| **Design** | Define what feedback to collect — focus areas, collection channels, stakeholder voices, and what noise to filter out | Feedback collection plan; channels activated; improvement scope boundaries; prior backlog reviewed |
| **Sequence** | Design feedback analysis methodology; establish signal-vs-noise criteria; prioritize improvements using Sustainability > Efficiency > Scalability | Feedback analysis methodology; validation criteria; prioritization framework; routing rules per issue type |
| **Build** | Process and categorize all feedback; validate each improvement request against evidence; route to the correct subsystem | Categorized feedback register; validated improvement requests (prioritized); rejected log with rationale; recommendations → 1-ALIGN |
| **Validate** | Verify the improvement process was rigorous and fair — no cherry-picking; priorities serve end-user needs and the Three Pillars | Improvement review report; corrective actions; validated package → 1-ALIGN (loop closes) |

## Subsystem Flow

```
PD-IMPROVE  →  DP-IMPROVE  →  DA-IMPROVE  →  IDM-IMPROVE
```

| Subsystem | Focus | Key Inputs | Key Outputs |
|-----------|-------|-----------|------------|
| **PD** | Assess diagnosis accuracy, EP applicability, and quality of design guidelines passed to downstream subsystems | Validated PD deliverables from PD-EXECUTE; consumer feedback from DP, DA, IDM teams | PD improvement requests → PD-ALIGN; updated UBS/UDS/EP if diagnosis gaps found |
| **DP** | Assess transformation quality, source reliability, and pipeline robustness — safety issues before efficiency improvements | **Principles from PD** + validated DP deliverables; data quality metrics; downstream consumer feedback | DP improvement requests → DP-ALIGN; updated pipeline architecture if structural issues found |
| **DA** | Assess analytical accuracy, conclusion reliability, and methodological gaps — accuracy issues before scalability improvements | **Principles from PD** + validated DA deliverables; accuracy metrics; stakeholder feedback on insight quality | DA improvement requests → DA-ALIGN; updated analytical methodology if accuracy gaps found |
| **IDM** | Assess delivery usability, decision quality, and full-UES effectiveness — routes improvements to **all subsystems**, not just IDM | **Principles from all upstream** + validated IDM deliverables; end-user feedback; adoption and decision outcome data | IDM improvement requests → IDM-ALIGN; **cross-subsystem improvements → each subsystem's ALIGN** (closes full ALPEI loop) |

> **Critical:** PD produces the effective principles that govern the entire UES — DP, DA, and IDM inherit and build on them.

## Structure

| Folder | Contents |
|--------|---------|
| `1-PD/` | IMPROVE artifacts for problem diagnosis — reviews, retrospectives, improvement requests, updated risk log |
| `2-DP/` | IMPROVE artifacts for transformation — data quality feedback, pipeline reliability reviews, improvement requests |
| `3-DA/` | IMPROVE artifacts for analysis and logic — accuracy assessments, analytical gap reports, improvement requests |
| `4-IDM/` | IMPROVE artifacts for insight delivery — usability reviews, decision outcome feedback, full-UES improvement register |
| `_cross/` | Cross-cutting improvement artifacts — project-level retrospectives, shared improvement register, institutionalized templates and SOPs |

## Templates

| Stage | Template |
|-------|---------|
| Design | [`design-template.md`](_genesis/templates/design-template.md) |
| Sequence | [`dsbv-process.md`](_genesis/templates/dsbv-process.md) |
| Build | [`retro-template.md`](_genesis/templates/retro-template.md) — retrospective and feedback register |
| Validate | [`review-template.md`](_genesis/templates/review-template.md) |

## Pre-Flight Checklist

### Design Stage
- [ ] Define feedback collection plan — what to measure, who to ask, and what channels to activate
- [ ] Set improvement scope boundaries — what is in scope for this iteration's review
- [ ] Review prior improvement backlog — are any outstanding items resolved or superseded

### Sequence Stage
- [ ] Establish signal-vs-noise criteria — what threshold makes a piece of feedback actionable
- [ ] Apply prioritization framework: sustainability blockers first, then efficiency, then scalability
- [ ] Define routing rules — which issue type routes to which subsystem's ALIGN

### Build Stage
- [ ] Process all feedback and categorize by subsystem and issue type
- [ ] Validate each improvement request against evidence (not just subjective opinion)
- [ ] Prioritize the validated register and route each item to the correct subsystem
- [ ] Log rejected feedback with explicit rationale

### Validate Stage
- [ ] All VANA acceptance criteria met
- [ ] Evidence basis verified
- [ ] Process was consistent — no cherry-picking, priorities serve users and Three Pillars
- [ ] Validated package ready for → 1-ALIGN (loop closes)

## How IMPROVE Connects

```
                   validated deliverables
4-EXECUTE  ─────────────────────────────>  5-IMPROVE
                                               │
                                  validated improvement requests
                                  (routed per subsystem)
                                               │
                                               ▼
                                  1-ALIGN (PD / DP / DA / IDM)
                                  (loop closes — next iteration starts here)

5-IMPROVE ──"new unknown surfaces"──> 2-LEARN  (deepen analysis)
5-IMPROVE ──"scope must change"─────> 1-ALIGN  (re-align before next iteration)
```

## DASHBOARDS

![[12-improvement-overview.base]]

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[architecture]]
- [[design-template]]
- [[dsbv-process]]
- [[iteration]]
- [[methodology]]
- [[retro-template]]
- [[review-template]]
- [[workstream]]
