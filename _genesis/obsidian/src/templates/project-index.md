<%*
// LTC Templater — Project Index (project root or vault root)
// Complete time: <1 minute. Only work_stream, iteration, and ues_version require input.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: project-index
work_stream: <% tp.system.prompt("Primary work stream (e.g. 4-EXECUTE)") %>
stage: build
sub_system: PD
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
