<%*
// LTC Templater — OKR Register (1-ALIGN/okrs/)
// Complete time: <1 minute. Only sub_system and iteration require input.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: ues-deliverable
work_stream: 1-ALIGN
stage: sequence
sub_system: <% tp.system.suggester(["1-PD (Problem Diagnosis)", "2-DP (Data Pipeline)", "3-DA (Data Analysis)", "4-IDM (Insights & Decisions)"], ["1-PD", "2-DP", "3-DA", "4-IDM"]) %>
iteration: <% tp.system.prompt("Iteration number (e.g. 2 for Iteration 2)") %>
---

# <% tp.file.title %>

> OKR Register. Created <% tp.date.now("YYYY-MM-DD") %> in `<% tp.file.folder() %>`.

## OKR Register Identity

| Field | Value |
|-------|-------|
| Sub-system | _[name]_ |
| Iteration | _[Iteration 1 / Iteration 2 / Iteration 3 / Iteration 4]_ |
| Review cadence | _[weekly / sprint / monthly]_ |
| Owner | _[name]_ |

## Objectives

### Objective 1 — [Title]

_[Objective statement — qualitative, ambitious but achievable within the iteration.]_

| Key Result | Baseline | Target | Formula / Measurement | Status |
|------------|----------|--------|-----------------------|--------|
| KR 1.1 | _[current value]_ | _[target value]_ | _[how measured]_ | Draft |
| KR 1.2 | _[current value]_ | _[target value]_ | _[how measured]_ | Draft |
| KR 1.3 | _[current value]_ | _[target value]_ | _[how measured]_ | Draft |

## Scoring Guide

| Score | Meaning |
|-------|---------|
| 0.0–0.3 | Failed — rethink approach |
| 0.4–0.6 | Partial — acceptable if stretch target |
| 0.7–1.0 | Achieved — meeting bar or exceeded |

## Links

- [[SEQUENCE]]
- [[iteration]]
- [[ues-deliverable]]
