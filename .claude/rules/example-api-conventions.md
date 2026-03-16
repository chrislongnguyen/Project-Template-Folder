---
paths:
  - src/api/**
  - src/routes/**
---

# API Conventions (Example — path-scoped rule)

> This rule only loads when editing files matching the paths above.
> Zero token cost when working on other files.
> Delete this file and create your own rules. See: https://docs.anthropic.com/en/docs/claude-code/memory#rules

- All endpoints return `{ data, error, meta }` envelope
- Use input validation on all request bodies
- Return appropriate HTTP status codes
