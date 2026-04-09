---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: 5-IMPROVE
stage: build
type: changelog
sub_system: _cross
iteration: 1
---

# Project Changelog

> Template — populate during DSBV Build phase.

## Unreleased

### 2026-04-06 — Learn Skill Routing + QMD Integration (SKILLS)

**fix(skills): learn skill routing — Option X cross-first pipeline + templates** (`50f43e4`, `0e64225`)

- Root cause: filesystem migration deleted `2-LEARN/templates/` and broke 93 path refs in 7 skills
- Option X: pipeline stages in `_cross/` (exploratory), converge to subsystem dirs via `/learn:spec`
- 7 LBE page templates → `_genesis/templates/learning-book/`
- Created `validate-learning-page.sh`, `constraints.yaml`, `learn-path-lint.sh`
- 93 path rewrites across 14 skill files: `2-LEARN/{flat}/` → `2-LEARN/_cross/{dir}/`
- DSBV terminology fixed in learn-spec (handoff TO downstream, not LEARN using DSBV)
- QMD `learn` + `learn_specs` collections added — P-pages auto-indexed on SessionStop

### 2026-04-06 — Filesystem Routing Harness (GOVERN)

**fix(govern): 4-mode filesystem routing harness — LEARN pipeline exclusion** (`e17cbf9`)

- **P1:** Created `.claude/rules/filesystem-routing.md` — 4-mode routing rule (A=DSBV, B=Learn pipeline, C=PKB, D=Genesis)
- **P2:** Updated `CLAUDE.md` — routing section + DSBV "not LEARN" exclusion
- **P3:** Fixed `scripts/dsbv-skill-guard.sh` — LEARN DSBV block (exit 2), pipeline allow (exit 0)
- **P4:** Fixed `scripts/populate-blueprint.py` — skip LEARN in DSBV phase file creation
- **P5:** Fixed `scripts/generate-readmes.py` — LEARN-specific pipeline README template
- **P6:** Fixed `.claude/skills/dsbv/SKILL.md` — HARD-CONSTRAINT LEARN exclusion + status table
- **P7:** Updated `.claude/agents/ltc-planner.md` + `ltc-builder.md` — Routing Boundaries section
- **P8:** Updated `scripts/validate-blueprint.py` — Mode B/D routing checks + pre-commit hook

**Root cause:** `populate-blueprint.py` applied DSBV uniformly to all workstreams; `dsbv-skill-guard.sh` silently passed LEARN. No routing rule existed.

### 2026-04-06 — README Population + Filesystem Fixes (PLAN)

- 48 READMEs populated via blueprint template + parallel agents (`d042c36`)
- 14 DSBV files deleted from 2-LEARN (LEARN uses pipeline, not DSBV)
- filesystem-blueprint.md + cross-dependency-map.md moved to _genesis/
- 4 VALIDATE.md created for 4-EXECUTE subsystems (`8dd4c28`)

## Iteration 1: Concept

<!-- Entries before 2026-04-06 not yet backfilled -->

## Links

- [[AGENTS]]
- [[BLUEPRINT]]
- [[CHANGELOG]]
- [[CLAUDE]]
- [[README]]
- [[SKILL]]
- [[VALIDATE]]
- [[cross-dependency-map]]
- [[filesystem-blueprint]]
- [[filesystem-routing]]
- [[iteration]]
- [[ltc-builder]]
- [[ltc-planner]]
- [[project]]
