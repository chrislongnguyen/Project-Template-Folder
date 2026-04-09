<%*
// LTC Templater — Roadmap (3-PLAN/roadmap/)
// Complete time: <1 minute. Only sub_system and iteration require input.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: ues-deliverable
work_stream: 3-PLAN
stage: sequence
sub_system: <% tp.system.suggester(["1-PD (Problem Diagnosis)", "2-DP (Data Pipeline)", "3-DA (Data Analysis)", "4-IDM (Insights & Decisions)"], ["1-PD", "2-DP", "3-DA", "4-IDM"]) %>
iteration: <% tp.system.prompt("Iteration number (e.g. 2 for Iteration 2)") %>
---

# <% tp.file.title %>

> Roadmap artifact. Created <% tp.date.now("YYYY-MM-DD") %> in `<% tp.file.folder() %>`.

## Roadmap Identity

| Field | Value |
|-------|-------|
| Sub-system | _[name]_ |
| Iteration scope | _[Iteration 1 / Iteration 2 / Iteration 3 / Iteration 4]_ |
| Owner | _[name]_ |
| Research scope inherited from | `2-LEARN/research/[SUBSYSTEM]-RESEARCH-SCOPE.md` |

## Iteration Map

| Iteration | Focus | Key Milestone | Done When |
|-----------|-------|--------------|-----------|
| Iteration 1 | _[theme]_ | _[milestone name]_ | _[binary test]_ |
| Iteration 2 | _[theme]_ | _[milestone name]_ | _[binary test]_ |
| Iteration 3 | _[theme]_ | _[milestone name]_ | _[binary test]_ |
| Iteration 4 | _[theme]_ | _[milestone name]_ | _[binary test]_ |

## Milestones

| # | Milestone | Owner | Target date | Depends on | Done when |
|---|-----------|-------|-------------|------------|-----------|
| M1 | _[name]_ | _[role]_ | _[YYYY-MM-DD]_ | none | _[binary test]_ |
| M2 | _[name]_ | _[role]_ | _[YYYY-MM-DD]_ | M1 | _[binary test]_ |
| M3 | _[name]_ | _[role]_ | _[YYYY-MM-DD]_ | M2 | _[binary test]_ |

## Dependencies

| Milestone | Upstream dependency | Risk if delayed |
|-----------|-------------------|----------------|
| M1 | _[what must exist before M1 can start]_ | _[impact]_ |
| M2 | M1 complete | _[impact]_ |

## Critical Path

```
M1 ──► M2 ──► M3 ──► Release
```

## Links

- [[SEQUENCE]]
- [[iteration]]
- [[ues-deliverable]]
