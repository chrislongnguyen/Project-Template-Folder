<%*
// LTC Templater — Metrics Baseline (5-IMPROVE/metrics/)
// Complete time: <1 minute. Only sub_system and iteration require input.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: ues-deliverable
work_stream: 5-IMPROVE
stage: design
sub_system: <% tp.system.suggester(["1-PD (Problem Diagnosis)", "2-DP (Data Pipeline)", "3-DA (Data Analysis)", "4-IDM (Insights & Decisions)"], ["1-PD", "2-DP", "3-DA", "4-IDM"]) %>
iteration: <% tp.system.prompt("Iteration number (e.g. 2 for I2)") %>
---

# <% tp.file.title %>

> Metrics Baseline. Created <% tp.date.now("YYYY-MM-DD") %> in `<% tp.file.folder() %>`.

## Metrics Baseline Identity

| Field | Value |
|-------|-------|
| Sub-system | _[name]_ |
| Iteration | _[I1 / I2 / I3 / I4]_ |
| Baseline date | <% tp.date.now("YYYY-MM-DD") %> |
| Owner | _[name]_ |

## Pillar Metrics

> Three Pillars: Sustainability (S) → Efficiency (E) → Scalability (Sc).
> Only measure pillars active at your current iteration (I1=S, I2=S+E, I3=S+E, I4=S+E+Sc).

### Sustainability Metrics

| Metric | Current Value | Target | Formula | Cadence |
|--------|--------------|--------|---------|---------|
| _[name]_ | _[value + unit]_ | _[value + unit]_ | _[how calculated]_ | _[weekly / sprint]_ |
| _[name]_ | _[value + unit]_ | _[value + unit]_ | _[how calculated]_ | _[weekly / sprint]_ |

### Efficiency Metrics (I2+)

| Metric | Current Value | Target | Formula | Cadence |
|--------|--------------|--------|---------|---------|
| _[name]_ | _[value + unit]_ | _[value + unit]_ | _[how calculated]_ | _[weekly / sprint]_ |

### Scalability Metrics (I4+)

| Metric | Current Value | Target | Formula | Cadence |
|--------|--------------|--------|---------|---------|
| _[name]_ | _[value + unit]_ | _[value + unit]_ | _[how calculated]_ | _[weekly / sprint]_ |

## Links

- [[DESIGN]]
- [[iteration]]
- [[ues-deliverable]]
