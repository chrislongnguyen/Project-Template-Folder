<%*
// LTC Templater — Charter (1-ALIGN/charter/)
// Complete time: <1 minute. Only sub_system and iteration require input.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: ues-deliverable
work_stream: 1-align
stage: design
sub_system: <% tp.system.suggester(["1-PD (Problem Diagnosis)", "2-DP (Data Pipeline)", "3-DA (Data Analysis)", "4-IDM (Insights & Decisions)"], ["1-PD", "2-DP", "3-DA", "4-IDM"]) %>
iteration: <% tp.system.prompt("Iteration number (e.g. 2 for I2)") %>
owner: <% tp.system.prompt("Owner name") %>
---

# <% tp.file.title %>

> Charter artifact. Created <% tp.date.now("YYYY-MM-DD") %> in `<% tp.file.folder() %>`.

## Project Identity

| Field | Value |
|-------|-------|
| Project name | _[name]_ |
| Scope code (UNG) | _[SCOPE_FA.ID.NAME]_ |
| Owner | _[name]_ |
| Iteration | _[I1 / I2 / I3 / I4]_ |
| Last reviewed | <% tp.date.now("YYYY-MM-DD") %> |

## Expected Outcome (EO)

_[Describe the expected outcome — specific enough that a new team member could verify it.]_

## Stakeholders

| Role | Name | Involvement |
|------|------|-------------|
| Sponsor | _[name]_ | _[decision authority / funding]_ |
| PM | _[name]_ | _[day-to-day ownership]_ |
| Consumer | _[name or group]_ | _[who uses the output]_ |

## Scope

### In Scope

- _[item 1]_
- _[item 2]_

### Out of Scope

- _[item 1]_
- _[item 2]_

## VANA Criteria

| Criterion | Statement |
|-----------|-----------|
| **V** (Value) | _[What value does this deliver and to whom?]_ |
| **A** (Acceptance) | _[Binary test: how do we know it is done?]_ |
| **N** (Needs) | _[What resources / dependencies are required?]_ |
| **A** (Assumptions) | _[What must be true for this charter to hold?]_ |

## Design Principles

- _[Principle 1 — cite LEARN finding]_
- _[Principle 2 — cite LEARN finding]_
