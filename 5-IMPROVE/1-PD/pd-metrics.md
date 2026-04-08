---
version: "1.0"
status: draft
last_updated: 2026-04-05
work_stream: 5-IMPROVE
stage: build
type: metrics
sub_system: 1-PD
iteration: 1
---

# PD Subsystem Metrics

## Purpose

Baseline and current measurements for Problem Diagnosis subsystem health. Metrics are organized by the 3-pillar lens: Sustainability (S), Efficiency (E), Scalability (Sc). Targets are set in `3-PLAN/` and referenced here — do not redefine targets in this file.

## Metrics Table

| ID    | Metric                          | Pillar | Target  | Current | Method                                      |
|-------|---------------------------------|--------|---------|---------|---------------------------------------------|
| PD-M1 | Diagnostic accuracy rate        | S      | TBD     | —       | Post-decision review: PD conclusion vs outcome |
| PD-M2 | PD cycle time (problem to brief)| E      | TBD     | —       | Timestamp: problem intake → PD brief signed off |
| PD-M3 | Rework rate (PD revisions)      | E      | TBD     | —       | Count of PD briefs requiring major revision  |
| PD-M4 | Framework coverage              | Sc     | TBD     | —       | % of problem types handled by documented PD frameworks |
| PD-M5 | Downstream rejection rate       | S      | TBD     | —       | % of PD outputs rejected by DP/DA for insufficient framing |

## Collection Schedule

| Frequency  | Metrics        | Owner  | Method            |
|------------|----------------|--------|-------------------|
| Per cycle  | PD-M2, PD-M3   | PD lead| Manual log at cycle close |
| Quarterly  | PD-M1, PD-M5   | PD lead| Post-decision review aggregation |
| Semi-annual| PD-M4          | PD lead| Framework inventory audit |

## Notes

- Targets marked TBD are populated during PLAN workstream. Do not estimate targets here.
- PD-M5 (downstream rejection rate) is collected via `dp-feedback-{YYYY-MM}.md` and `da-feedback-{YYYY-MM}.md` — coordinate with DP and DA leads for data.
- Current column is updated at each collection cycle, not in real time.

## Links

- [[iteration]]
- [[workstream]]
