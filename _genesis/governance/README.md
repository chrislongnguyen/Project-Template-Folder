---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 0-GOVERN
type: template
iteration: 2
---

# governance

> "Who has authority to decide, and through what process?"

## Purpose

Organizational governance structures and decision-making authority.

Without a governance spec, authority is ambiguous — teams escalate incorrectly, decisions are reversed, and accountability gaps cause delivery failures. This directory holds org-level governance definitions (RACI, authority matrices, board-level mandates) that project teams inherit but do not override. This directory is an **Iteration 2 placeholder** — content will be populated in iteration 2.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| _(Iteration 2 placeholder)_ | No artifacts yet — to be populated in iteration 2 |

## How It Connects

```
_genesis/philosophy/ + _genesis/principles/
    │
    └──> _genesis/governance/ (who decides what, through what process)
              │
              ├──> 1-ALIGN/ — governance structures inform charter stakeholder section
              ├──> 3-PLAN/ — RACI applied to risk owners and decision gates
              └──> _genesis/compliance/ — governance and compliance interact on audit authority
```

## Pre-Flight Checklist

- [ ] Confirm governance artifacts have been ratified by the appropriate authority level before adding here
- [ ] Verify RACI entries cover all DSBV stage-gate decisions
- [ ] No orphaned or stale artifacts

## Naming Convention

Governance artifacts use descriptive kebab-case: `raci-matrix.md`, `decision-authority-matrix.md`.

## Links

- [[charter]]
- [[iteration]]
- [[project]]
