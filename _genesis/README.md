---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 0-GOVERN
type: template
iteration: 2
---

# _genesis

> "What foundational knowledge does every LTC project inherit?"

## Purpose

Organizational knowledge base — philosophy, principles, frameworks, and derived artifacts that ship with every project clone.

It exists as a separate directory to enforce the boundary between org-level knowledge (read-only for project teams, owned by LTC COE OPS) and project-specific work (owned by the project team). Nothing in `_genesis/` is modified by project teams — changes flow through the template repo and propagate on clone or update.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| `philosophy/` | Core beliefs — the WHY behind LTC's approach |
| `principles/` | Non-negotiable standards derived from philosophy |
| `frameworks/` | System models and analytical tools (ALPEI, UBS/UDS, 8-component, UES versioning) |
| `reference/` | Authoritative guides, company handbook, EOP governance spec, ALPEI PDFs |
| `templates/` | DSBV stage templates, ADR, VANA-SPEC, research, review, and 15+ artifact starters |
| `brand/` | Visual identity — colors, typography, logo usage |
| `security/` | Data classification, naming convention, security hierarchy |
| `sops/` | Standard operating procedures for repeatable activities |
| `governance/` | Organizational governance structures (Iteration 2 placeholder) |
| `compliance/` | Regulatory and policy obligations (Iteration 2 placeholder) |
| `culture/` | Team norms and working agreements (Iteration 2 placeholder) |
| `obsidian/` | Vault structure scaffold for Obsidian-based knowledge management |

## How It Connects

```
_genesis (org-level, read-only)
    │
    ├──> CLAUDE.md + .claude/rules/ — EP loaded each session
    ├──> .claude/agents/ — agent definitions reference frameworks
    ├──> 1-ALIGN/ through 5-IMPROVE/ — every workstream pulls templates,
    │    frameworks, and brand rules from here
    └──> scripts/ — template-check.sh validates structure against _genesis
```

## Pre-Flight Checklist

- [ ] Confirm `_genesis/` is not modified directly inside a project repo — changes belong in the template repo
- [ ] Verify `_genesis/frameworks/` contains the current versions of all 9 Vinh frameworks
- [ ] No orphaned or stale artifacts

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[adr]]
- [[iteration]]
- [[project]]
- [[security]]
- [[standard]]
- [[versioning]]
- [[workstream]]
