<%*
// LTC Templater — Driver Entry (3-PLAN/drivers/)
// Complete time: <1 minute. Date auto-fills; all fields are static defaults.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: driver
work_stream: 3-PLAN
stage: design
sub_system: 1-PD
iteration: 2
---

# <% tp.file.title %>

> Driver entry. Folder: `<% tp.file.folder() %>`. Created <% tp.date.now("YYYY-MM-DD") %>.

## Driver ID

_e.g. UDS-001_

## Description

_What external or internal force is shaping this project?_

## Source

_Who or what is driving this? (stakeholder, market, regulation, technology)_

## Impact

_How does this driver affect scope, timeline, or decisions?_

## Links

- [[DESIGN]]
- [[iteration]]
- [[project]]
