---
name: ltc-wms-adapters
description: Shared WMS adapter library — field maps, protocols, and templates for ClickUp and Notion integrations.
version: "1.0"
status: draft
last_updated: 2026-04-07
---

# ltc-wms-adapters

Shared library consumed by `/ltc-clickup-planner` and `/ltc-notion-planner`.
Do not invoke this skill directly — use the planner skills instead.

## Contents

```
clickup/
  adapter.md          — ClickUp REST API adapter (auth, base URLs, rate limits)
  field-map.md        — LTC field → ClickUp custom field ID mapping
  gotchas.md          — Known ClickUp API quirks and workarounds
  task-protocol.md    — Task creation / update protocol
  templates/          — ClickUp item templates (task, deliverable, increment, etc.)

notion/
  adapter.md          — Notion API adapter
  field-map.md        — LTC field → Notion property mapping
  task-protocol.md    — Task creation / update protocol
  templates/          — Notion item templates
```

## Links

- [[adapter]]
- [[deliverable]]
- [[field-map]]
- [[gotchas]]
- [[increment]]
- [[task]]
- [[task-protocol]]
