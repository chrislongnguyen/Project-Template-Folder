<%*
// LTC Templater — Architecture Decision Record (1-ALIGN/decisions/)
// Complete time: <1 minute. Only sub_system, iteration, and ues_version require input.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: decision
work_stream: 1-align
stage: design
sub_system: <% tp.system.suggester(["1-PD (Problem Diagnosis)", "2-DP (Data Pipeline)", "3-DA (Data Analysis)", "4-IDM (Insights & Decisions)"], ["1-PD", "2-DP", "3-DA", "4-IDM"]) %>
iteration: <% tp.system.prompt("Iteration number (e.g. 2 for I2)") %>
ues_version: <% tp.system.suggester(["logic-scaffold","concept","prototype","mve","leadership"], ["logic-scaffold","concept","prototype","mve","leadership"]) %>
---

# <% tp.file.title %>

> Architecture Decision Record. Created <% tp.date.now("YYYY-MM-DD") %>.

## Context

_What situation or constraint prompted this decision?_

## Decision

_What was decided?_

## Rationale

_Why this option over alternatives?_

## Consequences

_What changes, risks, or follow-on work does this decision create?_
