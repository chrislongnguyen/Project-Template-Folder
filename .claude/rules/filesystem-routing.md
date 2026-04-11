---
version: "1.3"
status: draft
last_updated: 2026-04-12
---

# Filesystem Routing — Always-On Rule

Full spec with routing table: `rules/filesystem-routing.md`
Terminology mapping: Mode A = L1+L2 DSBV workstreams | Mode B = L1+L2 LEARN | Mode C = vault dirs | Mode D = genesis

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

DSBV stage file placement (canonical rule):
- `DESIGN.md`, `SEQUENCE.md`, and `VALIDATE.md` all live at **subsystem level**: `{N}-{WS}/{N}-{SUB}/VALIDATE.md`
- One VALIDATE.md per subsystem per workstream — certifies that subsystem's full DSBV cycle is complete

All three DSBV control files are subsystem-scoped. The 5×4×4 matrix (workstream × subsystem × DSBV stage) places VALIDATE.md alongside DESIGN.md and SEQUENCE.md at subsystem level (e.g., `1-ALIGN/1-PD/VALIDATE.md`).

Artifacts require a DESIGN.md in the workstream before Build-stage writes (enforced by `scripts/dsbv-skill-guard.sh`).

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
