# Filesystem Routing — Always-On Rule

# version: 1.0 | status: draft | last_updated: 2026-04-06

4 routing modes govern where artifacts land. Every file write must match exactly one mode.

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

DSBV phase files (`DESIGN.md`, `SEQUENCE.md`, `VALIDATE.md`) live at workstream root or subsystem level.

Artifacts require a DESIGN.md in the workstream before Build-phase writes (enforced by `scripts/dsbv-skill-guard.sh`).

## Mode B — Learning Pipeline

**Applies to:** `2-LEARN/` only

Structure: pipeline dirs (`input/`, `research/`, `specs/`, `output/`, `archive/`) per subsystem.

**HARD CONSTRAINT:** DSBV files (`DESIGN.md`, `SEQUENCE.md`, `VALIDATE.md`) MUST NEVER exist in `2-LEARN/`. LEARN uses a 6-state pipeline (S1-S5 + Complete), not DSBV.

Skills `/ingest` and `/vault-capture` do NOT write to `2-LEARN/` — they write to Mode C dirs.

## Mode C — PKB / Vault

**Applies to:** `PERSONAL-KNOWLEDGE-BASE/`, `DAILY-NOTES/`, `inbox/`, `MISC-TASKS/`, `PEOPLE/`

These are Obsidian vault directories. `/ingest` and `/vault-capture` write here.

**HARD CONSTRAINT:** PKB content never goes to `2-LEARN/`. The learning pipeline and PKB are separate systems.

## Mode D — Genesis

**Applies to:** `_genesis/`

OE-builder artifacts: blueprints, frameworks, templates, brand, reference docs, SOPs.

**HARD CONSTRAINT:** `_genesis/` content never goes into ALPEI dirs (`1-5`). ALPEI dirs house user-produced project artifacts; `_genesis/` houses organizational knowledge that ships with every clone.

## Enforcement

| Layer | Mechanism | What it catches |
|-------|-----------|-----------------|
| EP (rule) | This file — agent reads at session load | Routing awareness |
| EOE (hook) | `scripts/dsbv-skill-guard.sh` PreToolUse | DSBV files in LEARN, writes without DESIGN.md |
| EOT (script) | `scripts/validate-blueprint.py` | Structural violations across all modes |
| EOP (skill) | `/dsbv` SKILL.md hard constraint | LEARN exclusion in DSBV flow |
| Agent | `ltc-planner.md`, `ltc-builder.md` | Routing boundaries in agent scope |

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[ltc-builder]]
- [[ltc-planner]]
- [[project]]
- [[workstream]]
