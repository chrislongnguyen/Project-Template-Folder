---

## version: "1.0"
status: draft
last_updated: 2026-04-02
workstream: IMPROVE
iteration: "{{ITERATION}}"
owner: "{{OWNER}}"

> Source template: `_genesis/templates/review-package-template.md`

# Version Review: {{PROJECT_NAME}} — {{ITERATION}}


| Field          | Value                            |
| -------------- | -------------------------------- |
| Spec Version   | {spec_version}                   |
| Plan Version   | {plan_version}                   |
| Exec Version   | {exec_version}                   |
| Pipeline Stage | {pipeline_stage}                 |
| Total Tasks    | {total_tasks}                    |
| Completed      | {completed_tasks} ({pass_rate}%) |
| Rework Cycles  | {total_rework_count}             |
| Generated      | {timestamp}                      |


## AC Results


| AC ID | Task | Eval Type | Result | Evidence |
| ----- | ---- | --------- | ------ | -------- |
|       |      |           |        |          |


## Deliverable Status


| Deliverable | Name | Tasks | Done | Pass Rate | Status |
| ----------- | ---- | ----- | ---- | --------- | ------ |
|             |      |       |      |           |        |


## Rework History



*No rework cycles recorded.*

## Risk Flags



*No risk flags identified.*

---

## Three Pillars Score

> Rate each pillar 0-10 based on evidence from this iteration's deliverables.


| Pillar             | Score  | Evidence              | Target Next Iteration   |
| ------------------ | ------ | --------------------- | ----------------------- |
| Sustainability (S) | [0-10] | *[specific evidence]* | *[target]*              |
| Efficiency (E)     | [0-10] | *[specific evidence]* | *[target]*              |
| Scalability (Sc)   | [0-10] | *[specific evidence]* | *[target]*              |
| **Overall**        | [0-10] | *[summary]*           | *[next iteration goal]* |


## GO/NO-GO Decision


| Criterion                                | Status      | Notes      |
| ---------------------------------------- | ----------- | ---------- |
| All iteration ACs pass                   | PASS / FAIL | *[detail]* |
| Three Pillars overall ≥ 7/10             | PASS / FAIL | *[detail]* |
| Retrospective complete with action items | PASS / FAIL | *[detail]* |
| Metrics baseline captured                | PASS / FAIL | *[detail]* |
| Changelog updated                        | PASS / FAIL | *[detail]* |
| VERSION_REGISTRY rows current            | PASS / FAIL | *[detail]* |


**Human Director Decision:**

- Approved — trigger completion cascade
- Code changes needed — specify tasks to rework
- Plan is wrong — re-enter Stage 3
- Spec is wrong — re-enter Stage 1