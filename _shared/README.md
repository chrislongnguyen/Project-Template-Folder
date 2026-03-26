# _shared/ — LTC Organizational Knowledge

This directory contains LTC organizational knowledge that applies across ALL zones in every project using this template. These rules are maintained centrally and inherited by every APEI project instance.

---

## Core Equation

```
Success = Efficient & Scalable Management of Failure Risks
```

## Three Pillars (Priority Order)

1. **Sustainability** — Correct, safe, risk-managed operation. Always first.
2. **Efficiency** — Fast, lean, frugal operation. Only after Sustainability is confirmed.
3. **Scalability** — Repeatable, comparable, growth-capable operation. Only after Efficiency is confirmed.

When pillars conflict: **Sustainability > Efficiency > Scalability**.

---

## Directory Structure

```
_shared/
├── README.md                          ← This file
├── brand/
│   ├── BRAND_GUIDE.md                 ← Full LTC brand identity specification
│   └── colors.json                    ← Machine-readable color + typography tokens
├── reference/                         ← Canonical SSOT documents (org-wide)
│   ├── EFFECTIVENESS-GUIDE.md         ← 10 Ultimate Truths + 8-component ESD template
│   ├── effective-system-design.md     ← 3-phase ESD methodology
│   ├── system-wiki-template.md        ← Documentation template for systems
│   ├── effective-agent-principles-registry.md ← 10 Effective Principles (EP-01–EP-10)
│   ├── ltc-company-handbook.md        ← LTC organizational handbook
│   └── archive/                       ← Retired documents + absorbed-into mapping
├── security/
│   ├── SECURITY_HIERARCHY.md          ← 3-layer defense model + 6 security rules
│   ├── NAMING_CONVENTION.md           ← Universal Naming Grammar (UNG) for all platforms
│   └── DATA_CLASSIFICATION.md         ← 5-level data classification scheme
└── frameworks/
    ├── EFFECTIVE_SYSTEM.md            ← POINTER → rules/general-system.md + _shared/reference/
    ├── AGENT_SYSTEM.md                ← POINTER → rules/agent-system.md + _shared/reference/
    ├── AGENT_DIAGNOSTIC.md            ← POINTER → rules/agent-diagnostic.md
    ├── HISTORY_VERSION_CONTROL.md     ← Git strategy, commits, PRs, tags, ADRs (unique content)
    ├── THREE_PILLARS.md               ← 3 Pillars of Effectiveness (unique content)
    ├── SIX_WORKSTREAMS.md             ← 6-workstream model (unique content)
    ├── UBS_UDS_GUIDE.md               ← Force analysis guide (unique content)
    ├── LEARNING_HIERARCHY.md          ← ELF learning hierarchy (unique content)
    ├── CRITICAL_THINKING.md           ← Critical thinking framework (unique content)
    └── COGNITIVE_BIASES.md            ← Cognitive bias catalog (unique content)
```

## Subfolders

| Folder | Purpose |
|---|---|
| **brand/** | Visual identity — colors, typography, logo usage, function color assignments. Mandatory for all visual output. |
| **reference/** | Canonical SSOT documents — organization-wide source-of-truth. Loaded on demand during LEARN and PLAN phases. |
| **security/** | Security rules, naming governance, and data classification. Defines the blast-radius model, risk tiers, and the Universal Naming Grammar. |
| **frameworks/** | System design methodology, agent configuration, diagnostics, and version control conventions. The intellectual foundation for how LTC builds and operates systems. |

## SSOT Principle — Frameworks as Thin Pointers

Three framework files (`EFFECTIVE_SYSTEM.md`, `AGENT_SYSTEM.md`, `AGENT_DIAGNOSTIC.md`) are **thin pointer files** (~15-20 lines each), NOT full copies. They provide:
- A one-paragraph summary of what the framework is
- When to use it
- A table of canonical sources with paths and load-timing guidance
- Key concepts as a summary checklist (not full spec)

The content flow follows Single Source of Truth (SSOT):

```
Canonical source (_shared/reference/)  ← Research-grade, full spec
  → Agent-distilled rules (rules/)     ← Always-loaded via CLAUDE.md, concise
    → Thin pointers (_shared/frameworks/)  ← Quick reference, zero duplication
```

This eliminates ~800 lines of duplicated content that would drift from the canonical sources. When a framework changes, update the canonical source and the rules/ distillation — the pointer files need no change.

## How These Rules Work

- **Centrally maintained:** Canonical sources live in `_shared/reference/` and `rules/` in the template repo. The `_shared/frameworks/` pointer files reference them without duplicating content.
- **Inherited by every project:** When a new project is created from this template, `_shared/` comes with it.
- **Zone-agnostic:** These rules apply across all four APEI zones (ALIGN, PLAN, EXECUTE, IMPROVE) — they are not scoped to any single zone.
- **Override hierarchy:** Project-specific rules in zone directories override `_shared/` rules where they conflict. Flag contradictions to the Human Director if intent is ambiguous.

## Institutionalization Flow

```
  4-IMPROVE/retrospectives/  →  Identify improvement
  4-IMPROVE/changelog/       →  Record what changed and why
  _shared/                   →  Update relevant rule, framework, or standard
```

---

**Classification:** INTERNAL
