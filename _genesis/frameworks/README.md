---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 0-GOVERN
type: template
iteration: 2
---

# frameworks

> "Which thinking model applies to this problem?"

## Purpose

System models and analytical frameworks — UBS/UDS, ALPEI, 8-component model, UES versioning, and more.

This directory exists separately from `principles/` because frameworks are operational tools (how to think through a problem), while principles are commitments (what we will not compromise). Frameworks translate abstract principles into structured methods that agents and humans apply to real work. These are the 9 Vinh frameworks — read-only for project teams.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| `alpei-dsbv-process-map.md` + `p1–p4` | Full ALPEI×DSBV process map across all workstreams (5 files) |
| `ltc-alpei-framework-overview.md` | ALPEI framework overview — 5-workstream model |
| `ltc-alpei-framework-by-subsystems.md` | ALPEI breakdown by PD/DP/DA/IDM subsystems |
| `ltc-effective-system-design-blueprint.md` | 8-component UES model (EI→EU→EA→EO + EP→EOE→EOT→EOP) |
| `ltc-ubs-uds-framework.md` | UBS (blocking forces) + UDS (driving forces) analysis method |
| `ltc-ues-versioning.md` | UES version lifecycle — I0 through I4 |
| `ltc-ues-version-behaviors.md` | 25-cell matrix: iteration × behavior per sub-system |
| `ltc-effective-learning.md` | Learning framework — how LTC captures and applies knowledge |
| `ltc-effective-thinking.md` | Thinking framework — structured reasoning for decisions |
| `ltc-10-ultimate-truths.md` | 8 LLM Truths + 2 meta-truths governing agent design |
| `agent-diagnostic.md` | 6-component agent diagnostic — trace failures before blaming the model |
| `agent-system.md` | 7-CS agent system model |
| `history-version-control.md` | Version control and iteration history spec |
| `learning-hierarchy.md` | Hierarchy of learning artifact types |
| `archive/` | Superseded framework versions |

## How It Connects

```
_genesis/philosophy/ + _genesis/principles/
    │
    └──> _genesis/frameworks/ (operational thinking tools)
              │
              ├──> CLAUDE.md — agents load frameworks as EP
              ├──> 3-PLAN/ — UBS/UDS applied to risk and driver registers
              ├──> 1-ALIGN/ — ALPEI process map drives workstream sequencing
              ├──> _genesis/templates/ — templates are framework-derived artifacts
              └──> All 5 workstreams — agents reference frameworks in every DSBV phase
```

## Pre-Flight Checklist

- [ ] Verify all 9 Vinh framework files are present and not modified inside the project repo
- [ ] Confirm `alpei-dsbv-process-map.md` and its p1–p4 parts are consistent with each other
- [ ] No orphaned or stale artifacts

## Naming Convention

Framework files use `ltc-{topic}.md` for Vinh-authored frameworks. Process maps use `alpei-dsbv-process-map{-pN}.md`. Use `[[wikilinks]]` to connect framework references across workstream artifacts.

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[agent-diagnostic]]
- [[agent-system]]
- [[alpei-dsbv-process-map]]
- [[history-version-control]]
- [[iteration]]
- [[learning-hierarchy]]
- [[ltc-10-ultimate-truths]]
- [[ltc-alpei-framework-by-subsystems]]
- [[ltc-alpei-framework-overview]]
- [[ltc-effective-learning]]
- [[ltc-effective-system-design-blueprint]]
- [[ltc-effective-thinking]]
- [[ltc-ubs-uds-framework]]
- [[ltc-ues-version-behaviors]]
- [[ltc-ues-versioning]]
- [[project]]
- [[versioning]]
- [[workstream]]
