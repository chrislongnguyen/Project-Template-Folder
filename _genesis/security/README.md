---
version: "2.0"
status: draft
last_updated: 2026-04-06
type: template
iteration: 2
---

# security

> "Is this data classified correctly and handled according to policy?"

## Purpose

Data classification, naming convention, security hierarchy, and access control.

Without a security layer, teams misclassify data, use inconsistent naming, and create access gaps that are difficult to audit. This directory exists separately from `principles/` because security is both a principle and an operational spec — the specs here translate the principle into concrete rules that agents and humans enforce on every artifact.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| `naming-convention.md` | LTC Universal Naming Grammar (UNG) — full spec with all scope codes, separator rules, and lookup tables |
| `data-classification.md` | Data classification tiers and handling rules for each tier |
| `security-hierarchy.md` | Security authority hierarchy — who can override what level of security control |

## How It Connects

```
_genesis/principles/ (security as a non-negotiable commitment)
    │
    └──> _genesis/security/ (security translated into operational rules)
              │
              ├──> CLAUDE.md § Naming — quick-ref for agents (SCOPE codes)
              ├──> .claude/rules/naming-rules.md — always-on naming enforcement
              ├──> .claude/rules/obsidian-security.md — vault-specific security rules
              ├──> All artifact creation — naming-convention.md governs every file/folder name
              └──> All data handling — data-classification.md governs storage and sharing
```

## Pre-Flight Checklist

- [ ] Confirm `naming-convention.md` Table 3a is current before creating any new named artifact
- [ ] Verify `data-classification.md` tiers are consistent with `security-hierarchy.md` authority levels
- [ ] No orphaned or stale artifacts

## Naming Convention

Security spec files use descriptive kebab-case: `naming-convention.md`, `data-classification.md`. Never abbreviate — these docs are loaded by agents and must be unambiguous.

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[data-classification]]
- [[iteration]]
- [[naming-convention]]
- [[naming-rules]]
- [[obsidian-security]]
- [[security]]
- [[security-hierarchy]]
