---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 5-IMPROVE
stage: build
type: readme
sub_system: 3-DA
iteration: 2
---

# 5-IMPROVE / 3-DA — Data Analysis Improvement

## Purpose

Captures improvement artifacts for the Data Analysis subsystem: model accuracy metrics, methodology retrospectives, visualization feedback, and changelogs for analytical framework changes.

DA sits between DP (upstream pipeline) and IDM (downstream decision-making). Improvement findings here address analytical quality, methodology drift, and communication of insights. When DP pipeline changes alter the data shape, DA must evaluate whether existing models and visualizations remain valid.

## Cascade Position

```
5-IMPROVE/2-DP  ──►  5-IMPROVE/3-DA  ──►  5-IMPROVE/4-IDM
```

DA improvement artifacts are inputs to IDM retros when analytical changes affect the quality or framing of decision inputs.

## Contents

| Artifact Type     | Naming Pattern              | Description                                              |
|-------------------|-----------------------------|----------------------------------------------------------|
| Changelog         | `da-changelog.md`           | Versioned record of model, methodology, and viz changes  |
| Metrics           | `da-metrics.md`             | Accuracy, coverage, and insight-to-decision conversion   |
| Retrospective     | `da-retro-{YYYY-QN}.md`     | Quarterly retro for analytical quality and methodology   |
| Feedback          | `da-feedback-{YYYY-MM}.md`  | Feedback from IDM on decision-readiness of outputs       |

## Notes

- Methodology changes (new frameworks, dropped models) must be logged in `da-changelog.md` with rationale before rollout.
- Visualization feedback from stakeholders routes through IDM feedback first — only DA-specific viz issues land here.
- Accuracy metrics must reference the target baseline set in `3-PLAN/` — do not set new targets here without PLAN workstream update.
