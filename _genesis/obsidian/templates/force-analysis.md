<%*
// LTC Templater — Force Analysis (1-ALIGN/design/ or 3-PLAN/design/)
// Complete time: <1 minute. work_stream, sub_system, and iteration require input.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: ues-deliverable
work_stream: <% tp.system.suggester(["1-ALIGN", "3-PLAN"], ["1-ALIGN", "3-PLAN"]) %>
stage: design
sub_system: <% tp.system.suggester(["1-PD (Problem Diagnosis)", "2-DP (Data Pipeline)", "3-DA (Data Analysis)", "4-IDM (Insights & Decisions)"], ["1-PD", "2-DP", "3-DA", "4-IDM"]) %>
iteration: <% tp.system.prompt("Iteration number (e.g. 2 for I2)") %>
---

# <% tp.file.title %>

> Force Analysis. Created <% tp.date.now("YYYY-MM-DD") %> in `<% tp.file.folder() %>`.

## Session Identity

| Field | Value |
|-------|-------|
| Sub-system | _[name]_ |
| Scope question | _[What change are we analyzing forces for?]_ |
| Facilitator | _[name]_ |
| Date | <% tp.date.now("YYYY-MM-DD") %> |

## Driving Forces (UDS — What Helps)

| # | Force | Strength (1–5) | Root Enabler | Leverage Action |
|---|-------|---------------|-------------|----------------|
| D1 | _[force]_ | _[1–5]_ | _[why it exists]_ | _[how to amplify]_ |
| D2 | _[force]_ | _[1–5]_ | _[why it exists]_ | _[how to amplify]_ |
| D3 | _[force]_ | _[1–5]_ | _[why it exists]_ | _[how to amplify]_ |

## Restraining Forces (UBS — What Blocks)

| # | Force | Strength (1–5) | Root Cause | Mitigation Action |
|---|-------|---------------|-----------|-----------------|
| R1 | _[force]_ | _[1–5]_ | _[why it exists]_ | _[how to reduce]_ |
| R2 | _[force]_ | _[1–5]_ | _[why it exists]_ | _[how to reduce]_ |
| R3 | _[force]_ | _[1–5]_ | _[why it exists]_ | _[how to reduce]_ |

## Net Direction Assessment

| Dimension | Score | Notes |
|-----------|-------|-------|
| Total driving force strength | _[sum]_ | _[comment]_ |
| Total restraining force strength | _[sum]_ | _[comment]_ |
| Net force direction | _[toward / against / balanced]_ | _[recommendation]_ |
