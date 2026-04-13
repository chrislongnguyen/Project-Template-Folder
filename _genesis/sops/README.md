---
version: "2.0"
status: draft
last_updated: 2026-04-06
type: template
iteration: 2
---

# sops

> "What is the approved process for this activity?"

## Purpose

Standard operating procedures — repeatable processes for code review, deployment, discussions, and more.

Without SOPs, teams improvise repeatable activities differently each time — accumulating inconsistency that compounds into quality failures and onboarding debt. This directory holds org-level SOPs that apply across all projects. Project-specific procedures belong in `4-EXECUTE/docs/`, not here.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| `git-workflow.md` | Branch strategy, commit conventions, PR process — Iteration 0 through Iteration 4 |
| `code-review-sop.md` | Code review checklist and required approvals |
| `deployment-sop.md` | Deployment steps, environment gates, and rollback procedure |
| `discussion-sop.md` | How to run a structured decision discussion (async + sync) |
| `multi-agent-setup-guide.md` | How to configure and test the 4-agent system in a new project |
| `session-lifecycle-cheatsheet.md` | Claude Code session start, mid-session, and close-out checklist |
| `tool-routing-cheatsheet.md` | Quick reference for choosing the right tool per task type |
| `cmux-quickstart.md` | Claude multiplexer (cmux) setup and usage guide |
| `archive/` | Superseded SOPs preserved for historical context |

## How It Connects

```
_genesis/frameworks/ + _genesis/principles/
    │
    └──> _genesis/sops/ (frameworks translated into step-by-step procedures)
              │
              ├──> .claude/agents/ — multi-agent-setup-guide.md governs agent config
              ├──> .claude/skills/ — session-lifecycle + tool-routing inform skill design
              ├──> 4-EXECUTE/ — deployment-sop.md and code-review-sop.md apply during Build stage
              └──> All workstreams — git-workflow.md governs every commit and PR
```

## Pre-Flight Checklist

- [ ] Verify `git-workflow.md` branch strategy is consistent with the current iteration (Iteration 0–Iteration 4)
- [ ] Confirm each SOP has been tested against the actual toolchain before declaring it active
- [ ] No orphaned or stale artifacts

## Naming Convention

SOP files use descriptive kebab-case ending in `-sop.md` or `-guide.md` or `-cheatsheet.md`. Match the pattern of existing files.

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[SKILL]]
- [[cmux-quickstart]]
- [[code-review-sop]]
- [[deployment-sop]]
- [[discussion-sop]]
- [[git-workflow]]
- [[iteration]]
- [[multi-agent-setup-guide]]
- [[project]]
- [[session-lifecycle-cheatsheet]]
- [[standard]]
- [[task]]
- [[tool-routing]]
- [[tool-routing-cheatsheet]]
