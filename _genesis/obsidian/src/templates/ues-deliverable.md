<%*
// LTC Templater — UES Deliverable
// Complete time: <1 minute. Only prompted fields require input; all others are auto-filled.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: ues-deliverable
work_stream: <% tp.system.suggester(["1-ALIGN","2-LEARN","3-PLAN","4-EXECUTE","5-IMPROVE"], ["1-ALIGN","2-LEARN","3-PLAN","4-EXECUTE","5-IMPROVE"]) %>
stage: <% tp.system.suggester(["design","sequence","build","validate"], ["design","sequence","build","validate"]) %>
sub_system: <% tp.system.suggester(["problem-diagnosis","data-pipeline","data-analysis","insights-decision-making"], ["problem-diagnosis","data-pipeline","data-analysis","insights-decision-making"]) %>
iteration: <% tp.system.prompt("Iteration number (e.g. 2 for I2)") %>
---

# <% tp.file.title %>

> DSBV artifact. Created <% tp.date.now("YYYY-MM-DD") %> in folder: `<% tp.file.folder() %>`.

## Purpose

_Describe what this artifact establishes — scope, decisions, or deliverables._

## Content

_Main body here._

## Acceptance Criteria

- [ ] AC-1:
- [ ] AC-2:
- [ ] AC-3:

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[deliverable]]
- [[iteration]]
