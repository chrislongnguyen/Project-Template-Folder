<%*
// LTC Templater — Daily Note (DAILY-NOTES/)
// Complete time: <1 minute. Date auto-fills; all other fields are static defaults.
-%>
---
version: "1.0"
status: draft
last_updated: <% tp.date.now("YYYY-MM-DD") %>
type: daily-note
---

# <% tp.date.now("YYYY-MM-DD") %> — Daily Standup

## Yesterday

- 

## Today

- 

## Blockers

- 

---

_Note created at `<% tp.file.folder() %>/<% tp.file.title %>`_
