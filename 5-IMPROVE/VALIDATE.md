---
version: "1.0"
status: draft
last_updated: 2026-04-02
workstream: IMPROVE
iteration: "{{ITERATION}}"
owner: "{{OWNER}}"
---

> Source template: `_genesis/templates/REVIEW_PACKAGE_TEMPLATE.md`

# Review Package: {{PROJECT_NAME}} — IMPROVE Workstream

| Field | Value |
|---|---|
| Spec Version | {spec_version} |
| Plan Version | {plan_version} |
| Exec Version | {exec_version} |
| Pipeline Stage | {pipeline_stage} |
| Total Tasks | {total_tasks} |
| Completed | {completed_tasks} ({pass_rate}%) |
| Rework Cycles | {total_rework_count} |
| Generated | {timestamp} |

## AC Results

| AC ID | Task | Eval Type | Result | Evidence |
|---|---|---|---|---|
| <!-- Fill in AC results for IMPROVE workstream artifacts --> | | | | |

## Deliverable Status

| Deliverable | Name | Tasks | Done | Pass Rate | Status |
|---|---|---|---|---|---|
| <!-- Fill in IMPROVE deliverables: changelog, retro, metrics, reviews --> | | | | | |

## Rework History

<!-- Fill in rework log entries if any rework cycles occurred -->
_No rework cycles recorded._

## Risk Flags

<!-- Fill in any risk flags identified during IMPROVE validation -->
_No risk flags identified._

---

## Three Pillars Score

| Pillar | Score | Notes |
|--------|-------|-------|
| Sustainability (S) | [0-10] | _[evidence]_ |
| Efficiency (E) | [0-10] | _[evidence]_ |
| Scalability (Sc) | [0-10] | _[evidence]_ |
| **Overall** | [0-10] | _[summary]_ |

## GO/NO-GO Decision

| Criterion | Status | Notes |
|-----------|--------|-------|
| All IMPROVE ACs pass | PASS / FAIL | _[detail]_ |
| Metrics baseline captured | PASS / FAIL | _[detail]_ |
| Retrospective complete with action items | PASS / FAIL | _[detail]_ |
| Changelog updated | PASS / FAIL | _[detail]_ |
| Three Pillars score ≥ 7/10 | PASS / FAIL | _[detail]_ |

**Human Director Decision:**
- [ ] Approved — trigger completion cascade
- [ ] Code changes needed — specify tasks to rework
- [ ] Plan is wrong — re-enter Stage 3
- [ ] Spec is wrong — re-enter Stage 1