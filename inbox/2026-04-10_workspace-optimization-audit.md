---
version: "1.0"
status: draft
last_updated: 2026-04-10
work_stream: _genesis
tags: [audit, workspace, optimization, comprehensive]
---

# Workspace Optimization Audit — OPS_OE.6.4.LTC-PROJECT-TEMPLATE

**Date:** 2026-04-10
**Agents:** 2× ltc-explorer (haiku), 2× ltc-reviewer (opus), orchestrator (opus)
**Scope:** Full workspace — structure, processes, agents, IDEs, Obsidian, skills, rules, READMEs, _genesis

---

## Executive Summary

This template is **production-grade with one critical blocker**: the process map (`alpei-dsbv-process-map.md`) references ~50 deliverable paths that don't match the actual filesystem layout. Agents and PMs following the process map will create files in phantom directories. Everything else is strong — multi-agent support at 95/100, multi-IDE at 88/100, Obsidian at 89/100, ALPEI structure at 85/100 (if process map is fixed, this jumps to 95+).

```
┌──────────────────────────────────────────────────────────┐
│  WORKSPACE OPTIMIZATION SCORECARD                        │
│                                                          │
│  Multi-Agent Readiness:       95 / 100  ✓               │
│  Multi-IDE Readiness:         88 / 100  ✓               │
│  Obsidian Optimization:       89 / 100  ✓               │
│  ALPEI Process Completeness:  85 / 100  ⚠ (1 blocker)  │
│  Human-AI Collaboration:      93 / 100  ✓               │
│  Human-Human Collaboration:   90 / 100  ✓               │
│  Learning Pipeline:           92 / 100  ✓               │
│  Skills/Rules/Memory:         87 / 100  ⚠ (phantom refs) │
│                                                          │
│  CRITICAL BLOCKER: Process map path incoherence          │
│  (~50 phantom paths across 4 files)                      │
│                                                          │
│  DECISION NEEDED: Remove ~88 stub artifacts?             │
│  (templates exist to regenerate all of them)             │
└──────────────────────────────────────────────────────────┘
```

---

## BLOCKER: Process Map Path Incoherence

**Severity:** BLOCKER — affects every clone project that follows the process map.

The `alpei-dsbv-process-map.md` (and its part files p1, p3, p4) was written with a **"flat cross-cutting path"** mental model, but the actual filesystem uses a **"subsystem-first"** model:

| Process Map Says | Actual Filesystem |
|-----------------|-------------------|
| `1-ALIGN/charter/CHARTER.md` | `1-ALIGN/1-PD/pd-charter.md` (per subsystem) |
| `1-ALIGN/okrs/OKR_REGISTER.md` | `1-ALIGN/1-PD/pd-okr-register.md` |
| `3-PLAN/architecture/ARCHITECTURE.md` | `3-PLAN/1-PD/pd-architecture.md` |
| `3-PLAN/roadmap/ROADMAP.md` | `3-PLAN/1-PD/pd-roadmap.md` |
| `5-IMPROVE/metrics/METRICS_BASELINE.md` | `5-IMPROVE/_cross/cross-metrics-baseline.md` |
| `5-IMPROVE/metrics/FEEDBACK_REGISTER.md` | `5-IMPROVE/_cross/cross-feedback-register.md` |
| `5-IMPROVE/reviews/VERSION-REVIEW.md` | **Does not exist anywhere** |
| `5-IMPROVE/retrospectives/RETRO-PLAN.md` | `5-IMPROVE/1-PD/pd-retro-template.md` |

**Impact:** ~50 path references across `alpei-dsbv-process-map.md`, `alpei-dsbv-process-map-p1.md`, `alpei-dsbv-process-map-p3.md`, and `alpei-dsbv-process-map-p4.md`. Agents and PMs following the process map will `Write` to phantom directories. The `dsbv-skill-guard.sh` won't catch this because the files land in valid workstream directories — just the wrong subdirectory.

**Fix:** Update all process map deliverable paths to match the subsystem-first layout. This is a single coordinated edit across 4 files.

---

## Template vs Artifact Analysis — Safe Removals

### Summary

| Category | Count | Action |
|----------|-------|--------|
| Stub artifacts (safe to remove) | ~88 | Templates exist to regenerate all |
| Populated artifacts (KEEP) | ~20 | Changelogs, metrics, EPs, UBS analyses |
| Review needed | ~4 | UDS-analysis stubs (inconsistent state) |
| READMEs (KEEP always) | ~44 | Entry points for navigation |

### What's Safe to Remove

All pre-generated DSBV phase files (DESIGN.md, SEQUENCE.md, VALIDATE.md) across all 16 subsystem cells are stubs. All per-subsystem deliverables in 1-ALIGN (charters, OKRs, ADRs), 3-PLAN (architecture, roadmap, risk/driver registers), and 5-IMPROVE (retro templates) are stubs with `<!-- TODO: Fill during DSBV Build -->` placeholders.

Corresponding templates exist in `_genesis/templates/` for every stub type:
- `charter-template.md` → `*-charter.md`
- `okr-template.md` → `*-okr.md`
- `architecture-template.md` → `*-architecture.md`
- `roadmap-template.md` → `*-roadmap.md`
- `design-template.md` → `DESIGN.md`
- `sequence-template.md` → `SEQUENCE.md`
- `dsbv-eval-template.md` → `VALIDATE.md`

### What MUST Be Kept

| Files | Why |
|-------|-----|
| `5-IMPROVE/*/pd-changelog.md` etc. (4) | Populated — semantic versioning records |
| `5-IMPROVE/*/pd-metrics.md` etc. (4) | Populated — S/E/Sc baseline with IDs |
| `2-LEARN/*/{sub}-effective-principles.md` (4) | Populated — evidence-backed EPs |
| `2-LEARN/*/{sub}-ubs-analysis.md` (4) | Populated — blocking force registers |
| `5-IMPROVE/_cross/cross-*.md` (3) | Cross-cutting governance records |
| `1-ALIGN/_cross/cross-*.md` (2) | Stakeholder map + RACI |
| All README.md files (44) | Navigation entry points |

### Recommendation on Stub Removal

**Do NOT bulk-remove stubs now.** The stubs serve as scaffolding — they show PMs "this is where your charter goes" in the file tree. Instead:

1. **Keep stubs for this push** — they're lightweight and provide structural visibility
2. **Fix the process map paths** — this is the actual blocker
3. **Document the template-first workflow** — when starting real work, regenerate from template rather than editing stubs
4. **Consider removal in Iteration 2** — once the template-first pattern is proven

---

## Multi-Agent Readiness (95/100)

| Agent | Entry Point | Score | Status |
|-------|-------------|-------|--------|
| Claude Code | `.claude/` + `CLAUDE.md` | 100/100 | Full DSBV, 28 skills, 29 hooks, 4 agents |
| Gemini CLI | `GEMINI.md` | 92/100 | Essentials in 80 lines |
| Codex (OpenAI) | `codex.md` | 90/100 | Clean, minimal, appropriate |
| Cursor | `.cursor/rules/` | 85/100 | 6 rules; missing DSBV, enforcement |
| Generic | `AGENTS.md` + `rules/` | 90/100 | Excellent agent-agnostic base |

**Gap:** Cursor has 6 rules vs Claude Code's 12. Missing: DSBV process, enforcement-layers, filesystem-routing. Cursor users must read `.claude/rules/` directly.

---

## Multi-IDE Readiness (88/100)

| IDE | Config | Score |
|-----|--------|-------|
| VS Code | `.vscode/` (folder colors, extensions) | 85/100 |
| Cursor | `.cursor/rules/` (6 files) | 82/100 |
| JetBrains | Not present | 0/100 |
| Cross-IDE | `rules/` markdown (8 specs) | 92/100 |

**Gaps:** No `.code-workspace` file for team settings sharing. JetBrains not supported (acceptable if not needed).

---

## Obsidian Optimization (89/100)

| Component | Score | Detail |
|-----------|-------|--------|
| Bases | 95/100 | 18 dashboards, correct Dataview syntax, complex formulas |
| Templates | 90/100 | 13 templates, missing build-output and retro-entry |
| PKB | 85/100 | Structure sound, auto-recall mechanism underdocumented |
| Vault structure | 90/100 | 17 folders, permissions defined, current |
| CSS themes | 95/100 | LTC palette applied (Midnight Green, Gold) |
| Wikilinks | 96/100 | 141/146 files have `## Links` sections |
| CLI integration | 75/100 | Skill documented, no `cli-blocked` defaults |

---

## ALPEI Process Completeness (85/100 → 95+ after process map fix)

### 5×4×4 Matrix Status

**58 PASS | 19 FAIL | 9 PARTIAL** across all checks.

Key findings beyond the process map blocker:

| Finding | Severity | Detail |
|---------|----------|--------|
| Process map phantom paths | BLOCKER | 8 paths × ~6 references each = ~50 phantom refs |
| `4-EXECUTE/_cross/` missing | Cosmetic | Only DSBV workstream without `_cross/` directory |
| `5-IMPROVE/reviews/VERSION-REVIEW.md` missing | Medium | Process map references it; no equivalent exists |
| `3-PLAN/architecture/` empty | Cosmetic | Contains .gitkeep subdirs only, no README |
| `1-ALIGN/charter/` effectively empty | Cosmetic | Only `drafts/` subdir, no README pointing to subsystem charters |
| Learning book P6 template missing | Cosmetic | P0-P5 + P7 exist, P6 gap (known open issue) |
| Cross-subsystem OKR register asymmetric | Cosmetic | Only PD has `pd-okr-register.md`; DP/DA/IDM lack registers |

### Human Gate Enablement: PASS

- G1-G4 gates documented in DSBV SKILL.md with clear PM guidance
- `status-guard.sh` enforces human-only `validated` at pre-commit
- 5 iteration versions documented with 25-cell behavior matrix
- `readiness-report.sh` available for C1-C3 checks

### Human-Human Collaboration: PASS

- ADR decision structure with 3-Pillar evaluation (S>E>Sc)
- Stakeholder map + RACI templates
- CHANGELOG + version-registry + `/dsbv status` for visibility
- 2 training decks (ALPEI slides + Obsidian Bases training)
- 8 SOPs in `_genesis/sops/`

### Human-AI Interaction: PASS

- `/dsbv` skill guides PM through full DSBV workflow with agent dispatch
- `/learn` skill guides PM through 6-stage learning pipeline
- Agent dispatch rules clear (4 MECE agents with scope boundaries)
- Pre-flight protocol with 9 checks
- Context packaging template available

---

## Learning Pipeline (92/100)

| Component | Status |
|-----------|--------|
| 7/7 learn skills | PASS |
| 6-state pipeline (S1-S5+Complete) | PASS |
| DSBV contamination = 0 | PASS |
| LEARN↔PKB boundary | PASS |
| P0-P5 page templates | PASS |
| P6 template | MISSING (known gap) |
| P7 template | PASS |
| _cross validation scripts | PASS |

---

## Consolidated Action Plan

### Tier 1: Blockers (fix before push)

| # | Item | Effort | Impact |
|---|------|--------|--------|
| **B1** | Fix ~50 phantom paths in `alpei-dsbv-process-map*.md` (4 files) — flat paths → subsystem-first | 2-3 hours | Every clone follows wrong paths without this |

### Tier 2: High Value (fix within 1 week)

| # | Item | Effort |
|---|------|--------|
| H1 | Create `4-EXECUTE/_cross/` with README | 5 min |
| H2 | Create `5-IMPROVE/_cross/cross-version-review.md` scaffold | 10 min |
| H3 | Add README to `3-PLAN/architecture/`, `1-ALIGN/charter/`, `scripts/` | 15 min |
| H4 | Add 3 missing rules to `.cursor/rules/` (dsbv, enforcement, routing) | 30 min |
| H5 | Document PKB auto-recall mechanism in PKB README | 15 min |
| H6 | Add frontmatter to 4 framework files (ltc-effective-learning, thinking, ubs-uds, version-behaviors) | 10 min |
| H7 | Fix 2 path errors in skills (learn-review/structure → `2-LEARN/_cross/scripts/`, brainstorming mece-validator) | 5 min |
| H8 | Fix 3 case violations (`status: Draft` → `status: draft`) in PKB README, dashboard, ingest gotchas | 5 min |

### Tier 3: Polish (within 1 month)

| # | Item | Effort |
|---|------|--------|
| P1 | Create `cli-blocked` defaults for sensitive vault folders | 1 hour |
| P2 | Add OKR registers to DP/DA/IDM (match PD symmetry) | 15 min |
| P3 | Create P6 learning book template | 30 min |
| P4 | Add Obsidian dark-mode CSS overrides | 1 hour |
| P5 | Add 2 missing Obsidian templates (build-output, retro-entry) | 30 min |
| P6 | Add gotchas.md to ltc-notion-planner and ltc-wms-adapters | 10 min |
| P7 | Clean up deep-research phantom script refs (document as aspirational or remove) | 30 min |
| P8 | Clarify `_genesis/` version exemption in version-registry.md | 5 min |
| P9 | Add READMEs to `.claude/`, `.claude/rules/`, `.claude/agents/`, `_genesis/guides/`, `_genesis/tools/` | 30 min |

### Decision Needed: Stub Artifact Removal

**~88 stub files** can be safely removed since templates exist to regenerate them. Recommendation: **Keep for now** — they provide structural visibility for PMs browsing the file tree. Consider removal in Iteration 2 once template-first workflow is proven.

---

## Skills/Rules/README/_genesis Audit

### Skills (28/28 present — 12 broken script refs)

All 28 skills have valid SKILL.md with required frontmatter. 26/28 have gotchas.md (missing: `ltc-notion-planner`, `ltc-wms-adapters`).

**Critical finding:** 12 broken script references across 7 skills:

| Skill | Broken Refs | Nature |
|-------|------------|--------|
| `deep-research` | 6 Python scripts (`citation_manager.py`, `md_to_html.py`, `source_evaluator.py`, `validate_report.py`, `verify_citations.py`, `verify_html.py`) | **Aspirational** — skill has "If scripts not found, perform manual verification" fallback. Not a runtime crash, but misleading. |
| `ltc-brainstorming` | `scripts/mece-validator.sh` (wrong path — exists at `.claude/skills/ltc-brainstorming/scripts/mece-validator.sh`), `scripts/start-server.sh`, `scripts/stop-server.sh` | **Path error** (mece-validator) + **aspirational** (server scripts) |
| `dsbv` | `scripts/analysis.py`, `scripts/tool.sh` | Example/placeholder refs in live-test-patterns.md |
| `learn-review`, `learn-structure` | `scripts/validate-learning-page.sh` (wrong path — exists at `2-LEARN/_cross/scripts/validate-learning-page.sh`) | **Path error** |
| `template-check` | `.claude/rules/new-rule.md` | Example ref (not real file) |

**Assessment:** None of these cause runtime crashes — deep-research has explicit fallbacks, and the path errors are in documentation. But they mislead agents trying to locate scripts.

### Rules (12/12 present — counts now correct)

All 12 rules have valid frontmatter after the W3-W5 fixes. The CLAUDE.md now correctly says 49 scripts and 29 hooks.

**Remaining issue:** `script-registry.md` Automated section now lists `.claude/hooks/` scripts correctly after W9/W10 fixes, but the registry header says "49 scripts" while 49 tracked .sh/.py files exist. PASS.

### READMEs — Missing Locations

| Missing README | Severity |
|---------------|----------|
| `scripts/` | Medium — agents look here for script discovery |
| `_genesis/guides/` | Low |
| `_genesis/tools/` | Low |
| `.claude/` | Low |
| `.claude/rules/` | Low |
| `.claude/agents/` | Low |

### _genesis Wiki — Framework Frontmatter Gaps

4 framework files have YAML `---` delimiters but **lack version/status/last_updated** inside:

| File | Content |
|------|---------|
| `_genesis/frameworks/ltc-effective-learning.md` | Has `---` but no version fields |
| `_genesis/frameworks/ltc-effective-thinking.md` | Same |
| `_genesis/frameworks/ltc-ubs-uds-framework.md` | Same |
| `_genesis/frameworks/ltc-ues-version-behaviors.md` | Same |

These are Vinh's extracted framework files that were imported without template metadata.

### Version Anomaly: 2.x files in "Iteration 1" repo

~25 files across `_genesis/`, `2-LEARN/`, vault dirs use version "2.x" while `version-registry.md` says "Current iteration: Iteration 1 (all versions must be 1.x)". This is because `_genesis/` has its own lifecycle — it's organizational knowledge that evolves independently of project iteration. The rule should clarify that `_genesis/` files are exempt from the 1.x constraint. Not a bug, but a documentation gap.

### Frontmatter Case Violations

| File | Issue |
|------|-------|
| `PERSONAL-KNOWLEDGE-BASE/README.md` | `status: Draft` (uppercase D) |
| `PERSONAL-KNOWLEDGE-BASE/dashboard.md` | `status: Draft` (uppercase D) |
| `.claude/skills/ingest/gotchas.md` | Instructs `status: Draft` (uppercase) |

## Links

- [[BLUEPRINT]]
- [[CHANGELOG]]
- [[CLAUDE]]
- [[alpei-dsbv-process-map]]
- [[enforcement-layers]]
- [[filesystem-routing]]
- [[version-registry]]
