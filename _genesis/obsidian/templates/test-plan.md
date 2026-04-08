<%*
// LTC Templater — Test Plan (4-EXECUTE/tests/)
// Complete time: <1 minute. Only sub_system and iteration require input.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: ues-deliverable
work_stream: 4-EXECUTE
stage: validate
sub_system: <% tp.system.suggester(["1-PD (Problem Diagnosis)", "2-DP (Data Pipeline)", "3-DA (Data Analysis)", "4-IDM (Insights & Decisions)"], ["1-PD", "2-DP", "3-DA", "4-IDM"]) %>
iteration: <% tp.system.prompt("Iteration number (e.g. 2 for I2)") %>
---

# <% tp.file.title %>

> Test Plan. Created <% tp.date.now("YYYY-MM-DD") %> in `<% tp.file.folder() %>`.

## Test Plan Identity

| Field | Value |
|-------|-------|
| Sub-system | _[name]_ |
| Artifact(s) under test | _[list of deliverable paths]_ |
| Iteration | _[I1 / I2 / I3 / I4]_ |
| Test owner | _[name]_ |
| Date | <% tp.date.now("YYYY-MM-DD") %> |

## Test Cases

| # | Case | Input / Setup | Expected Output | Actual Output | Pass / Fail | Notes |
|---|------|--------------|----------------|---------------|-------------|-------|
| TC-01 | _[description]_ | _[input or precondition]_ | _[expected]_ | _[fill during execution]_ | _[P / F]_ | _[notes]_ |
| TC-02 | _[description]_ | _[input or precondition]_ | _[expected]_ | _[actual]_ | _[P / F]_ | _[notes]_ |
| TC-03 | _[description]_ | _[input or precondition]_ | _[expected]_ | _[actual]_ | _[P / F]_ | _[notes]_ |

## AC Coverage Mapping

| SEQUENCE.md AC | Test Case(s) | Covered? |
|----------------|-------------|---------|
| _[AC text]_ | TC-01, TC-02 | Yes / No |
| _[AC text]_ | TC-03 | Yes / No |

## Sign-Off

| Role | Name | Decision | Date |
|------|------|---------|------|
| Test owner | _[name]_ | _[GO / NO-GO]_ | _[YYYY-MM-DD]_ |
| Human gate (G4) | _[name]_ | _[APPROVE / REJECT]_ | _[YYYY-MM-DD]_ |

## Links

- [[SEQUENCE]]
- [[VALIDATE]]
- [[deliverable]]
- [[iteration]]
- [[ues-deliverable]]
