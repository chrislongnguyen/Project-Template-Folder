<%*
// LTC Templater — Risk Entry (3-PLAN/risks/)
// Complete time: <1 minute. Date auto-fills; all fields are static defaults.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: risk
work_stream: 3-PLAN
stage: design
sub_system: 1-PD
iteration: 2
---

# <% tp.file.title %>

> Risk entry. Folder: `<% tp.file.folder() %>`. Created <% tp.date.now("YYYY-MM-DD") %>.

## Risk ID

_e.g. UBS-001_

## Description

_What could go wrong?_

## Probability

_Low / Medium / High_

## Impact

_Low / Medium / High_

## Mitigation

_What action reduces or eliminates this risk?_

## Links

- [[DESIGN]]
- [[iteration]]
