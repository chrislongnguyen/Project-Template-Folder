---
version: "1.0"
status: draft
last_updated: 2026-04-11
work_stream: _genesis
tags: [audit, release-readiness, template, multi-agent]
---

# Release-readiness audit — OPS_OE.6.4.LTC-PROJECT-TEMPLATE

**Date:** 2026-04-11  
**EO:** If we tag and ship this repo today, will a new LTC PM get a **complete, honest, day-1 usable template** with **no broken paths, no stale registries, no personal/WIP leakage**, and **no misleading docs**?  
**References reviewed:** `_genesis/alpei-blueprint.md`, `_genesis/frameworks/alpei-dsbv-process-map.md`, `_genesis/sops/archive/alpei-operating-procedure.md`  
**Prior audit templates:** `inbox/2026-04-10_pre-push-audit-v3.md`, `inbox/2026-04-10_workspace-optimization-audit.md`

---

## Executive summary

```
┌────────────────────────────────────────────────────────────────────┐
│  VERDICT:  NO-SHIP                                                 │
│                                                                    │
│  Blockers:   3  (see § Blockers)                                   │
│  Warnings:   6+ (registry drift, pre-flight semantics, map edge)   │
│                                                                    │
│  S × E × Sc summary (holistic):  S=48  E=62  Sc=55                 │
└────────────────────────────────────────────────────────────────────┘
```

| Verdict | Meaning |
|---------|---------|
| **NO-SHIP** | Canonical blueprint path broken; **zero** DSBV phase files (`DESIGN.md` / `SEQUENCE.md` / `VALIDATE.md`) **tracked** in git while process map and version registry describe a full grid; `template-check.sh` reports large `auto_add` / `merge` sets vs local tree — **consumer clone would not match documented ALPEI scaffold** without a follow-up sync or commit. |

**Suggested tag after blockers cleared:** `v2.x.x` (human decides); not recommended now.

### S × E × Sc summary table

| Pillar | Score (0–100) | Why |
|--------|----------------|-----|
| **S** Sustainability | 48 | Gates/hooks exist, but **missing blueprint path** and **missing workstream artifacts** undermine trust and onboarding. |
| **E** Efficiency | 62 | `./scripts/template-check.sh` **passes**; `./scripts/pre-flight.sh <ws>` **passes** with WARNs; README-driven flows not fully re-validated here. |
| **Sc** Scalability | 55 | Registries and process map **claim** a dense matrix; **git content** does not — drift is structural, not cosmetic. |

---

## Mandatory automated checks (evidence)

### `./scripts/template-check.sh` and `--quiet`

**Exit code:** `0` (both invocations).

**Summary (from JSON stats):** `total_template_files` 913; `auto_add` 171; `flagged_review_required` 185; `merge` 304; `unchanged` 253.

**Interpretation:** Local tree is **not** aligned with the configured upstream template snapshot — hundreds of paths are merge/review candidates. **Release readiness requires reconciling** what ships in **this** branch vs what `template-check` expects (commit, or document intentional minimal scope).

### `./scripts/pre-flight.sh`

**Usage:** `./scripts/pre-flight.sh <workstream>` (required argument).

**Runs (all EXIT 0):**

| Workstream | Result summary |
|------------|----------------|
| 1-ALIGN | 8 PASS, 0 FAIL, 2 WARN |
| 2-LEARN | 8 PASS, 0 FAIL, 2 WARN |
| 3-PLAN | 8 PASS, 0 FAIL, 2 WARN |
| 4-EXECUTE | 8 PASS, 0 FAIL, 2 WARN |
| 5-IMPROVE | 8 PASS, 0 FAIL, 2 WARN |

**Representative WARNs (1-ALIGN):**

```
C2a    WARN BLUEPRINT.md present — _genesis/BLUEPRINT.md not found
C8     WARN DESIGN.md exists for 1-ALIGN — No DESIGN.md — needed before Build stage
```

**Note (E + Sc):** C8 checks **`$WORKSTREAM/DESIGN.md`** (e.g. `1-ALIGN/DESIGN.md`). Subsystem-first routing (`1-ALIGN/1-PD/DESIGN.md`) means this check can **WARN even when** the correct per-subsystem files exist — **and** in this repo **no** `DESIGN.md` exists anywhere in git (see D2). Script semantics should be reconciled with `rules/filesystem-routing.md` / process map.

---

## D1 — Inventory

| Item | Evidence |
|------|----------|
| **Branch** | `main...origin/main` **ahead 87** (at audit time) |
| **Latest commit** | `a9e1071` — docs(genesis): DSBV subsystem scoping SEQUENCE + VALIDATE reports |
| **Large churn themes** | Prior audits (v3): security/CVE, DSBV enforcement, Obsidian, vocabulary, agent system — still relevant for narrative |

**Untracked / WIP (do not ship without review):** `.claude/logs/`, `.claude/state/*.json`, `OPS_OE.6.4.LTC-PROJECT-TEMPLATE.code-workspace`, `inbox/123.md`, `tools/` (see Appendix).

---

## D2 — ALPEI / DSBV completeness

### Canonical blueprint

| File | Role |
|------|------|
| `_genesis/alpei-blueprint.md` | **Present** — `aliases: [BLUEPRINT]`, full “LTC AI OPERATING SYSTEM — BLUEPRINT” (v2.4). **This is the substantive blueprint.** |
| `_genesis/BLUEPRINT.md` | **Absent** on disk |

**Downstream refs still use `_genesis/BLUEPRINT.md`:** e.g. `CLAUDE.md` §Subsystems, `AGENTS.md`, `CHANGELOG.md`, `_genesis/templates/memory-seeds/user_role.md`, `version-registry.md` summary row.

**Active SOP** (`_genesis/sops/alpei-standard-operating-procedure.md`) correctly points PMs at **`_genesis/alpei-blueprint.md`** for WHY vs HOW.

### DSBV file grid vs git

| Check | Result |
|-------|--------|
| **Tracked `DESIGN.md` anywhere** | **0** files (`git ls-files \| grep DESIGN.md` → 0) |
| **Tracked under `1-ALIGN/`** | **5** `.md` files — only `README.md` per subsystem + `_cross` + root (no charters, no DSBV trio) |
| **Version registry** (`_genesis/version-registry.md`) | Describes **48+** DSBV cells with DESIGN/SEQUENCE/VALIDATE rows — **not reflected** in committed tree |
| **2-LEARN** | No DSBV filenames under `2-LEARN/` (README text may mention DSBV — **not** violating “no DSBV files in LEARN” if files absent) |

**Stub vs populated policy:** Process map and registry **assume** scaffolded DSBV artifacts. **Current branch:** minimal README-only scaffold — **honesty gap** for “day-1 template” unless release notes state **bootstrap-only** and point to `template-check` / `template-sync` to hydrate.

### Process map internal consistency (HIGH)

`_genesis/frameworks/alpei-dsbv-process-map.md` uses **subsystem-first** paths for most cells, but **Validate** for **1-ALIGN** and **3-PLAN** lists **`1-ALIGN/VALIDATE.md`** and **`3-PLAN/VALIDATE.md`** (workstream root), not `{ws}/{N}-{SUB}/VALIDATE.md`. That may be **intentional** (one workstream-level validate) but must match `filesystem-routing.md` and `validate-blueprint.py` — **flag for alignment review** (see Cross-cutting).

| Dim | Score | Weight | S/E/Sc |
|-----|-------|--------|--------|
| D2 | **28** | 0.22 | **S**, **Sc** |

---

## D3 — Human–AI (RACI & gates)

| Mechanism | Evidence |
|-----------|----------|
| **G1–G4** | Documented in `_genesis/frameworks/alpei-dsbv-process-map.md` and `/dsbv` skill ecosystem |
| **status-guard / validated** | `./scripts/status-guard.sh` in pre-commit chain (`.claude/settings.json`) |
| **Archived SOP** | `_genesis/sops/archive/alpei-operating-procedure.md` — **deprecated**, points to `/dsbv` and frameworks — **OK** as historical; not day-1 primary |

| Dim | Score | Weight | S/E/Sc |
|-----|-------|--------|--------|
| D3 | **72** | 0.14 | **S** |

---

## D4 — Obsidian

| Check | Result |
|-------|--------|
| **Bases** | **18** `.base` files under `_genesis/obsidian/bases/` |
| **Prior audits** | v3: Bases PASS — assume stable unless regressions |

| Dim | Score | Weight | S/E/Sc |
|-----|-------|--------|--------|
| D4 | **85** | 0.09 | **E** |

---

## D5 — Learning pipeline

| Check | Result |
|-------|--------|
| **Learn skills** | **7** top-level learn skills (`learn`, `learn-input`, `learn-research`, `learn-structure`, `learn-review`, `learn-spec`, `learn-visualize`) under `.claude/skills/` |
| **Total skills** | **28** `SKILL.md` files |
| **DSBV in 2-LEARN** | No `DESIGN.md`/`SEQUENCE.md`/`VALIDATE.md` files present under `2-LEARN/` |

| Dim | Score | Weight | S/E/Sc |
|-----|-------|--------|--------|
| D5 | **88** | 0.09 | **S** |

---

## D6 — Agent system

### Agents

Four agents under `.claude/agents/` per `AGENTS.md` — not re-audited line-by-line; prior v3 **PASS**.

### Hooks vs disk

| Bucket | Count (audit) |
|--------|----------------|
| **Hook shell scripts** | **14** `*.sh` under `.claude/hooks/` |
| **Hook entries** | **7** event types, **29** hook command slots in `.claude/settings.json` (matches `CLAUDE.md`) |

**Representative hook targets:** `resume-check.sh`, `session-reconstruct.sh`, `pkb-lint.sh`, `verify-deliverables.sh`, `builder-audit.sh`, `save-context-state.sh`, `session-summary.sh`, `pkb-ingest-reminder.sh`, `naming-lint.sh`, `dsbv-provenance-guard.sh`, `verify-agent-dispatch.sh`, `nesting-depth-guard.sh`, `inject-frontmatter.sh`, `state-saver.sh`, `strategic-compact.sh`, `auto-recall-filter.sh` — **all present** under `.claude/hooks/` where referenced.

**Dead hook:** v3 cited `validate-frontmatter.sh` — **not present** in current `.claude/hooks/` (either removed or never added) — **no drift** if nothing references it.

| Dim | Score | Weight | S/E/Sc |
|-----|-------|--------|--------|
| D6 | **84** | 0.14 | **Sc** |

---

## D7 — Ship segregation

| Check | Result |
|-------|--------|
| **Secrets scan** | Not exhaustive; rely on `.gitignore` + prior audits |
| **`owner: Long` in frontmatter** | Example in `_genesis/frameworks/history-version-control.md` (illustrative) — acceptable if labeled |
| **Personal / session** | Untracked `.claude/logs/`, `inbox/123.md` — **do not add** without scrubbing |

| Dim | Score | Weight | S/E/Sc |
|-----|-------|--------|--------|
| D7 | **70** | 0.10 | **S** |

---

## D8 — Clone-ready

| Check | Result |
|-------|--------|
| **README → CLAUDE → blueprint** | Broken link to **`_genesis/BLUEPRINT.md`** until symlink or doc fix |
| **Training / navigator** | Paths referenced in `README.md` — spot-check before release |
| **Windows** | Prior audits addressed `template-check` Windows behavior — not re-run here |

| Dim | Score | Weight | S/E/Sc |
|-----|-------|--------|--------|
| D8 | **35** | 0.12 | **E**, **S** |

---

## Cross-cutting — Process map vs filesystem

| ID | Severity | Finding | S/E/Sc |
|----|----------|---------|--------|
| **PM-1** | **BLOCKER** | Committed tree lacks DSBV trio and per-subsystem deliverables described in process map + version registry | **S**, **Sc** |
| **PM-2** | **HIGH** | `1-ALIGN/VALIDATE.md` vs `1-ALIGN/1-PD/VALIDATE.md` — mixed pattern; must be **one** canonical rule | **Sc** |
| **PM-3** | **MED** | `pre-flight.sh` C8 uses workstream-root `DESIGN.md` — misaligned with subsystem-first for PMs who fix only PD | **E** |

---

## Cross-cutting — Multi-IDE

| IDE | Config | Notes |
|-----|--------|------|
| **Claude Code** | `.claude/` | Full rules, skills, hooks |
| **Cursor** | `.cursor/rules/` | **9** `.md` files (includes `dsbv-process.md`, `enforcement-layers.md`, `filesystem-routing.md`) — **improved** vs older “6 rules” audit |
| **AGENTS.md** | Cross-IDE | Still lists `_genesis/BLUEPRINT.md` — **broken path** |

| Dim | Score | Weight | S/E/Sc |
|-----|-------|--------|--------|
| D10 | **78** | 0.06 | **Sc** |

---

## Cross-cutting — Skills & rules

| Check | Result |
|-------|--------|
| **Ghost `.claude/rules/dsbv.md`** | **No** matches in tracked `.md`/`.sh` **outside** `inbox/` — prior issue **cleared** or confined to audits |
| **`/resume` collision** | Skill still named `resume` — known low risk (v3 W7) |
| **Rules count** | `CLAUDE.md` line 19: **12** rules; line 78: **“11 files”** — **internal inconsistency** (COSMETIC/LOW) |

---

## D9 — Registry fidelity

| Claim | Source | Actual (audit) |
|-------|--------|----------------|
| Scripts in `scripts/` | `script-registry.md` header | **49** claimed vs **52** `scripts/*.{sh,py}` |
| Hooks in `.claude/hooks/` | `script-registry.md` | **15** claimed vs **14** `*.sh` (definition of “hook” may include `hooks.json` / `lib/`) |
| Skills | `CLAUDE.md` | **28** `SKILL.md` ✓ |
| Rules | `CLAUDE.md` | **12** `.md` in `.claude/rules/` ✓ |

| Dim | Score | Weight | S/E/Sc |
|-----|-------|--------|--------|
| D9 | **58** | 0.10 | **Sc** |

---

## D14 — GitHub / CI

| Workflow | Purpose |
|----------|---------|
| `.github/workflows/issue-triage.yml` | Issue triage / template enforcement — **not** PR lint or test |

**Gap (Sc, E):** No workflow validating `template-check`, `skill-validator`, or link checks on PRs.

---

## Scoring rubric (D1–D8 + D9 + D10)

| Code | Dimension | Score | Weight | Primary pillar |
|------|-----------|-------|--------|----------------|
| D1 | Inventory | 75 | 0.08 | Sc |
| D2 | ALPEI / DSBV | 28 | 0.22 | S, Sc |
| D3 | RACI / gates | 72 | 0.14 | S |
| D4 | Obsidian | 85 | 0.09 | E |
| D5 | Learning | 88 | 0.09 | S |
| D6 | Agent system | 84 | 0.14 | Sc |
| D7 | Ship segregation | 70 | 0.10 | S |
| D8 | Clone-ready | 35 | 0.12 | E, S |
| D9 | Registry fidelity | 58 | 0.10 | Sc |
| D10 | Multi-IDE | 78 | 0.06 | Sc |

---

## Blockers

### B1 — Missing `_genesis/BLUEPRINT.md` (path broken)

| Field | Content |
|-------|---------|
| **Repro** | `test ! -f _genesis/BLUEPRINT.md`; `pre-flight.sh` C2a WARN |
| **Blast radius** | Every link from `CLAUDE.md`, `AGENTS.md`, CHANGELOG, memory seeds |
| **Minimal fix** | Add `_genesis/BLUEPRINT.md` as **symlink or thin re-export** to `alpei-blueprint.md`, **or** bulk-update refs to `_genesis/alpei-blueprint.md` |
| **Owner** | Human approves naming; agent can execute mechanical rename |

### B2 — DSBV scaffold not in git

| Field | Content |
|-------|---------|
| **Repro** | `git ls-files \| grep -E 'DESIGN.md$'` → **0**; `1-ALIGN` only README stubs |
| **Blast radius** | PMs following process map cannot find files; version registry misleading |
| **Minimal fix** | Run **`./scripts/template-check.sh` → resolve `merge`/`auto_add`**, or **`template-sync`** per project skill; **commit** scaffold; or **narrow** registry + README to “minimal bootstrap” explicitly |
| **Owner** | Human + builder agent |

### B3 — `template-check` vs branch content

| Field | Content |
|-------|---------|
| **Repro** | JSON: `merge` 304, `auto_add` 171 vs sparse local tree |
| **Blast radius** | Tagging **this** branch ships a repo **out of sync** with template expectations |
| **Minimal fix** | Complete merge from template **or** branch intentionally documents “slim fork” |
| **Owner** | Human |

---

## Tiered action plan

| Tier | ID | Item |
|------|-----|------|
| **T1** | B1–B3 | Resolve blueprint path + scaffold + template alignment |
| **T2** | H1 | Reconcile `script-registry.md` (49 vs 52 scripts; 15 vs 14 hooks) |
| **T2** | H2 | Fix `CLAUDE.md` “11 vs 12” rules line |
| **T2** | H3 | Align `pre-flight.sh` C8 with subsystem-first `DESIGN.md` paths |
| **T3** | P1 | Add CI job: `template-check --quiet`, link check, or `skill-validator` on PR |
| **T3** | P2 | Resolve `1-ALIGN/VALIDATE.md` vs per-subsystem VALIDATE in process map + validators |

---

## Binary success criteria

| Criterion | Status |
|-----------|--------|
| Every hook in `settings.json` has a verdict | **PASS** (targets exist on disk) |
| Process map vs subsystem-first | **PARTIAL** — **HIGH** issues remain (workstream `VALIDATE.md` + **B2**) |
| Ghost refs above cosmetic | **PASS** for `.claude/rules/dsbv.md` in non-inbox sources |
| `template-check` / `pre-flight` | **template-check** EXIT **0**; **pre-flight** EXIT **0** with WARNs |
| **SHIP** / **NO-SHIP** | **NO-SHIP** — ordered blockers **B1–B3** |

---

## Appendix — Must not ship (without review)

| Path / pattern | Action |
|----------------|--------|
| `.claude/logs/` | Gitignore / do not commit |
| `.claude/state/*.json` | Local session — do not commit |
| `inbox/*` session captures | Exclude or sanitize |
| `tools/` experimental | Confirm generic value before track |
| `*.code-workspace` | Usually personal — optional team file |

---

## Appendix — Optional dev-only

- `scripts/dsbv-benchmark*.sh` / benchmark harnesses — dev-only unless documented in release notes

---

## Links

- [[BLUEPRINT]] — *resolve path to `alpei-blueprint.md` or restore `BLUEPRINT.md`*
- [[CLAUDE]]
- [[AGENTS]]
- [[alpei-dsbv-process-map]]
- [[enforcement-layers]]
- [[version-registry]]
