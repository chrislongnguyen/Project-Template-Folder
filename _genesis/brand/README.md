---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 0-GOVERN
type: template
iteration: 2
---

# brand

> "Would a stakeholder recognize this as an LTC deliverable?"

## Purpose

Visual identity — colors, typography, logo usage, and brand guide.

Without this directory, teams produce deliverables with inconsistent or incorrect colors and fonts, breaking the LTC brand on every visual output. It exists separately from `principles/` because brand is a derived specification, not an abstract principle — it translates philosophy into concrete, machine-readable design tokens.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| `brand-guide.md` | Full brand spec: color palette, typography scale, logo usage rules, do/don't examples |
| `colors.json` | Machine-readable color tokens — Midnight Green, Gold, Dark Gunmetal, accent palette |
| `assets/` | Logo files and approved visual assets |

## How It Connects

```
_genesis/philosophy/ + _genesis/principles/
    │
    └──> _genesis/brand/ (translates values into visual spec)
              │
              ├──> All HTML, CSS, SVG, chart, slide, and email artifacts
              ├──> CLAUDE.md § Brand Identity (quick-ref for agents)
              └──> .claude/rules/ brand-identity.md (always-on enforcement)
```

## Pre-Flight Checklist

- [ ] Verify `colors.json` tokens match the hex values in `brand-guide.md`
- [ ] Confirm `assets/` contains at least one approved logo variant (dark bg + light bg)
- [ ] No orphaned or stale artifacts

## Naming Convention

Assets use descriptive kebab-case: `ltc-logo-dark.svg`, `ltc-logo-light.png`. Color token keys use kebab-case matching CSS custom property convention: `midnight-green`, `gold`.

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[brand-guide]]
- [[brand-identity]]
- [[deliverable]]
- [[iteration]]
