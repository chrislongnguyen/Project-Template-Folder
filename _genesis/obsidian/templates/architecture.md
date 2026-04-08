<%*
// LTC Templater — Architecture (3-PLAN/architecture/)
// Complete time: <1 minute. Only sub_system and iteration require input.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: ues-deliverable
work_stream: 3-PLAN
stage: build
sub_system: <% tp.system.suggester(["1-PD (Problem Diagnosis)", "2-DP (Data Pipeline)", "3-DA (Data Analysis)", "4-IDM (Insights & Decisions)"], ["1-PD", "2-DP", "3-DA", "4-IDM"]) %>
iteration: <% tp.system.prompt("Iteration number (e.g. 2 for I2)") %>
---

# <% tp.file.title %>

> Architecture artifact. Created <% tp.date.now("YYYY-MM-DD") %> in `<% tp.file.folder() %>`.

## Architecture Identity

| Field | Value |
|-------|-------|
| Sub-system | _[name]_ |
| Version | _[I1 / I2 / I3 / I4]_ |
| Owner | _[name]_ |
| Last reviewed | <% tp.date.now("YYYY-MM-DD") %> |

## Architecture Summary

_[Describe the overall structure and governing design principle.]_

## Components

| Component | Responsibility | Owner |
|-----------|---------------|-------|
| _[name]_ | _[what it does]_ | _[role]_ |
| _[name]_ | _[what it does]_ | _[role]_ |

## Interfaces

| From | To | Data / Signal | Protocol |
|------|----|---------------|----------|
| _[component]_ | _[component]_ | _[what crosses]_ | _[how]_ |

## Data Flows

```
[Component A] ──► [Component B] ──► [Component C]
```

## Open Questions

- _[question 1]_
- _[question 2]_

## Links

- [[DESIGN]]
- [[iteration]]
- [[ues-deliverable]]
