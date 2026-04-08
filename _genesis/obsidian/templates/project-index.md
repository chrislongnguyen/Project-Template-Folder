<%*
// LTC Templater — Project Index (project root or vault root)
// Complete time: <1 minute. Only work_stream, iteration, and ues_version require input.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: project-index
work_stream: <% tp.system.suggester(["1-ALIGN","2-LEARN","3-PLAN","4-EXECUTE","5-IMPROVE"], ["1-ALIGN","2-LEARN","3-PLAN","4-EXECUTE","5-IMPROVE"]) %>
stage: build
sub_system: <% tp.system.suggester(["1-PD (Problem Diagnosis)", "2-DP (Data Pipeline)", "3-DA (Data Analysis)", "4-IDM (Insights & Decisions)"], ["1-PD", "2-DP", "3-DA", "4-IDM"]) %>
iteration: <% tp.system.prompt("Iteration number (e.g. 2 for I2)") %>
---

# <% tp.file.title %> — Project Index

> Project-level index. Obsidian Bases pull metadata from this file.
> Created <% tp.date.now("YYYY-MM-DD") %> in `<% tp.file.folder() %>`.

## Overview

_One paragraph: what this project is, what problem it solves, who it serves._

## Key Artifacts

| Workstream | Artifact | Path | Status |
|------------|----------|------|--------|
| Align | Charter | `1-ALIGN/charter/` | draft |
| Plan | Risk Register | `3-PLAN/risks/` | draft |
| Execute | Source | `4-EXECUTE/src/` | draft |

## Links

- [[charter]]
- [[iteration]]
- [[project]]
- [[workstream]]
