---
description: Filesystem routing — Mode A/B/C/D rules for where artifacts land
globs: "**"
---

# Filesystem Routing — 4 Modes

Full spec: `.claude/rules/filesystem-routing.md`

## Decision Tree

```
Is the target in 2-LEARN/?
  YES → Mode B (learning pipeline)
Is the target in 1-ALIGN/, 3-PLAN/, 4-EXECUTE/, 5-IMPROVE/?
  YES → Mode A (DSBV workstream)
Is the target in PERSONAL-KNOWLEDGE-BASE/, DAILY-NOTES/, inbox/, MISC-TASKS/, PEOPLE/?
  YES → Mode C (PKB / vault)
Is the target in _genesis/?
  YES → Mode D (genesis / OE-builder)
NONE → operational file (.claude/, scripts/, root) — no routing constraint
```

## Mode A — DSBV Workstreams

**Applies to:** `1-ALIGN/`, `3-PLAN/`, `4-EXECUTE/`, `5-IMPROVE/`

Structure: `{N}-{WORKSTREAM}/{subsystem}/` where subsystem = `1-PD`, `2-DP`, `3-DA`, `4-IDM`, `_cross`

Requires DESIGN.md in the workstream before any Build-phase writes.

## Mode B — Learning Pipeline

**Applies to:** `2-LEARN/` only

Structure: `input/`, `research/`, `specs/`, `output/`, `archive/` per subsystem.

HARD CONSTRAINT: `DESIGN.md`, `SEQUENCE.md`, `VALIDATE.md` MUST NEVER exist in `2-LEARN/`.

## Mode C — PKB / Vault

**Applies to:** `PERSONAL-KNOWLEDGE-BASE/`, `DAILY-NOTES/`, `inbox/`, `MISC-TASKS/`, `PEOPLE/`

PKB content NEVER goes to `2-LEARN/`. These are separate systems.

## Mode D — Genesis

**Applies to:** `_genesis/`

OE-builder artifacts only. NEVER write project artifacts to `_genesis/`.
`_genesis/` content NEVER goes into ALPEI dirs (`1-5`).

## Hard Constraints

- DSBV files in `2-LEARN/` → BLOCKED (Mode B exclusion)
- Build writes without DESIGN.md → BLOCKED (Mode A guard)
- PKB content in `2-LEARN/` → BLOCKED (Mode B/C separation)
- Project artifacts in `_genesis/` → BLOCKED (Mode D exclusion)

## Links

- [[filesystem-routing]]
- [[DESIGN]]
- [[project]]
- [[workstream]]
