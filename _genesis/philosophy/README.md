---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 0-GOVERN
type: template
iteration: 2
---

# philosophy

> "Why do we do things this way?"

## Purpose

Core beliefs and first principles — the WHY behind everything LTC does.

If philosophy is absent, teams make decisions from convenience or habit rather than conviction — producing frameworks and principles that contradict each other over time. This directory is the root of the `_genesis/` cascade: `philosophy → principles → frameworks → derived artifacts`. Nothing downstream may contradict a statement made here.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| _(files currently empty — philosophy is captured inline across Vinh frameworks)_ | Philosophical foundations live in `_genesis/frameworks/ltc-10-ultimate-truths.md` and `ltc-effective-thinking.md` pending extraction into dedicated philosophy files |

## How It Connects

```
_genesis/philosophy/ (root — WHY)
    │
    ├──> _genesis/principles/ (WHAT we commit to)
    ├──> _genesis/frameworks/ (HOW we think)
    ├──> _genesis/culture/ (HOW we behave)
    └──> _genesis/brand/ (HOW we present)
```

## Pre-Flight Checklist

- [ ] Verify no principle in `_genesis/principles/` contradicts a statement in `_genesis/philosophy/`
- [ ] Confirm philosophy files reflect current org beliefs, not aspirational ideals
- [ ] No orphaned or stale artifacts

## Naming Convention

Philosophy files use descriptive kebab-case: `why-ltc-exists.md`, `learning-as-first-principle.md`.

## Links

- [[iteration]]
- [[ltc-10-ultimate-truths]]
- [[ltc-effective-thinking]]
