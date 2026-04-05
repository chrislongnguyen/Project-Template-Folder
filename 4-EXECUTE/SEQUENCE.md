---
version: "1.1"
status: validated
last_updated: 2026-04-03
type: ues-deliverable
sub_system: 1-PD
work_stream: 4-EXECUTE
stage: sequence
iteration: 2
---

# SEQUENCE.md — EXECUTE Workstream, I2: Obsidian Bases Integration

> DSBV Phase 2 artifact. Approved DESIGN.md (v1.2) is the input. This document orders the build.
> Branch: `I2/feat/obsidian-bases`

---

## Dependency Graph

```
T1: Schema + migration  ──┬──→ T3: 14 Bases
  (A1 — schema freeze)    ├──→ T4: Templater templates
                          └──→ T6: Validation test

T2: Vault scaffold       (no upstream dep — can follow T1 immediately)

T3 + T4 complete ────────────→ T5: Setup script
T3 + T4 + T5 complete ───────→ T7: Training slide deck
```

**Critical path:** T1 → T3 → T5 → T7 (longest chain, 4 tasks deep)

---

## Task Sequence

| # | Task | Artifact | Depends On | Size | ACs |
|---|------|----------|-----------|------|-----|
| T1 | Schema spec + migration script | A1 | None (first) | M (~45 min) | AC-1, AC-2, AC-3 |
| T2 | Vault folder scaffold | A2 | T1 | S (~20 min) | AC-4, AC-5, AC-6 |
| T3 | 14 Obsidian Bases (adopt + adapt) | A3 | T1 | L (~60 min) | AC-7 to AC-11 |
| T4 | 6 Templater templates | A4 | T1 | M (~45 min) | AC-12 to AC-14 |
| T5 | Setup script | A5 | T3, T4 | S (~20 min) | AC-15 to AC-17 |
| T6 | Frontmatter validation test | A6 | T1, T2 | S (~30 min) | AC-18 to AC-20 |
| T7 | Training slide deck | A7 | T3, T4, T5 | L (~2 hr) | AC-21 to AC-23 |

**Sizes:** S = <30 min | M = 30-60 min | L = >60 min (L tasks decomposed below)

---

## T1 Decomposition: Schema + Migration (A1)

| Step | Action | Output |
|------|--------|--------|
| T1a | Write `frontmatter-schema.md` — all 9 fields, S2 vocabulary, types, valid values, examples | `4-EXECUTE/docs/frontmatter-schema.md` |
| T1b | Write `migrate-status.sh` — sed replacements: `Draft→draft`, `Review→in-review`, `Approved→validated`. Dry-run mode by default. | `4-EXECUTE/scripts/migrate-status.sh` |
| T1c | Update `_genesis/BLUEPRINT.md` TABLE 2 status row to S2 vocabulary | `_genesis/BLUEPRINT.md` (edit in place) |

**Checkpoint commit after T1c.** T1 is the schema freeze — T3 and T4 cannot begin until this commit exists.

---

## T3 Decomposition: 14 Bases (A3)

Source: `remotes/origin/Vinh-ALPEI-AI-Operating-System-with-Obsidian` — git show to extract each file.

| Step | Bases | Change Required |
|------|-------|-----------------|
| T3a | B1 ALPEI Master Dashboard, B2 ALPEI Stage Board, B3 Approval Queue, B4 Blocker Dashboard, B5 Standup Preparation, B6 Version Progress, B7 Templates Library | Fix status filter values to S2 vocabulary. Fix B2: `audit` → `validate` in stage_order formula. No folder ref changes. |
| T3b | B8 Alignment Overview, B9 Learning Overview, B10 Planning Overview, B11 Execution Overview, B12 Improvement Overview | Fix folder refs: `1. ALIGN` → `1-ALIGN`, `2. LEARN` → `2-LEARN`, etc. Fix status values. |
| T3c | B13 Daily Notes Index, B14 Tasks Overview | Fix folder refs: `DAILY NOTES` → `DAILY-NOTES`, `MISC TASKS` → `MISC-TASKS`. Fix status values. |

All output to: `4-EXECUTE/src/obsidian/bases/`

**Checkpoint commit after T3c.**

---

## T7 Decomposition: Training Slide Deck (A7)

| Step | Action | Output |
|------|--------|--------|
| T7a | Load `rules/brand-identity.md`. Plan 7-scene storyboard (scene list below). | Storyboard in comments |
| T7b | Build HTML slide deck — React+Vite or single-file HTML, LTC brand. | `4-EXECUTE/docs/training/obsidian-workflow-deck/index.html` |

**7-scene storyboard:**
1. Title: "The LTC PM Workspace" — Obsidian + Cursor split model
2. Vault structure tour — 5 ALPEI folders + 8 operational folders + inbox/
3. Daily workflow — open DAILY-NOTES, write standup, Bases auto-updates
4. Creating an artifact — Templater in action (UES Deliverable template, auto-fill demo)
5. Reading dashboards — ALPEI Master Dashboard → Blocker Dashboard → Approval Queue
6. Handing off to Cursor — what EXECUTE looks like, what the PM does NOT touch
7. Recap + quick reference card (plugin stack, status vocabulary, agent write rules)

**Checkpoint commit after T7b.**

---

## Section 1: Project Identity

**What:** Obsidian Bases integration for the LTC Project Template. Delivers the full PM workspace — vault folder structure, canonical frontmatter schema (S2), 14 live Bases dashboards (adopted from Vinh), 6 Templater templates, setup scripts, and a training deck.

**What NOT:** Cursor/Claude Code EXECUTE workflow, `/ues-next` skill, Obsidian Sync/Teams ($960/yr), dashboards beyond 14.

| Role | Person | RACI |
|------|--------|------|
| Director | Long Nguyen | **A** — approves G1/G2/G4 |
| Builder | ltc-builder (Sonnet) | **R** — produces all artifacts |
| CIO | Anh Vinh | **C** — Vinh's branch is the reference implementation |

**EO:** A new PM achieves full Obsidian workspace setup in <10 minutes, status visibility in <30 seconds, artifact creation in <1 minute — without terminal access or verbal coaching.

---

## Section 2: Key Decisions Already Made

| # | Decision | Rationale |
|---|----------|-----------|
| D1 | All 14 of Vinh's bases adopted (not 6) | Zero marginal build cost; Vinh's are validated and working |
| D2 | Status vocabulary = S2 (draft/in-progress/in-review/validated/archived) | Richer workflow state enables meaningful Kanban views; approved 2026-04-03 |
| D3 | All 8 operational folders adopted (DAILY-NOTES, MISC-TASKS, PEOPLE, PLACES, TEMP-IN, TEMP-OUT, THINGS, AI-AGENT-MEMORY) | PM full workspace, not just ALPEI mirror |
| D4 | Agent writes to `inbox/` only — never to canonical ALPEI folders | Safety: no silent file corruption during agent operations |
| D5 | Git-backed sync only — no Obsidian Sync | UBS-5: $960/yr unjustified; Git is more reliable for PM workflows |
| D6 | Single-agent sequential build | Structural artifacts (JSON configs, shell scripts) are deterministic — no diversity benefit |

---

## Section 3: What This Workstream Must Produce

| # | Artifact | File Path | Condition | Binary Test |
|---|----------|-----------|-----------|-------------|
| A1 | Schema spec + migration script | `4-EXECUTE/docs/frontmatter-schema.md` + `4-EXECUTE/scripts/migrate-status.sh` | AC-1: 9 fields with S2 values documented. AC-2: migrate-status.sh runs with no manual edits. AC-3: all existing `.md` pass after migration. | `./scripts/migrate-status.sh --dry-run` exits 0 with no errors |
| A2 | Vault scaffold | `4-EXECUTE/docs/vault-structure.md` + `4-EXECUTE/scripts/setup-vault.sh` | AC-4: all folders created on fresh checkout. AC-5: inbox/ + AI-AGENT-MEMORY/ have .gitkeep. AC-6: idempotent. | `./scripts/setup-vault.sh && ./scripts/setup-vault.sh` exits 0 both times |
| A3 | 14 Obsidian Bases | `4-EXECUTE/src/obsidian/bases/*.base` (14 files) | AC-7: all 14 load in Obsidian. AC-8: ALPEI Master Dashboard returns ≥1 result. AC-9: all filters use A1 fields only. AC-10: folder refs updated. AC-11: status values match S2. | `grep -r "1\. ALIGN\|2\. LEARN\|Draft\|Review\|Approved" 4-EXECUTE/src/obsidian/bases/` returns no matches |
| A4 | 6 Templater templates | `4-EXECUTE/src/obsidian/templates/*.md` (6 files) | AC-12: ues-deliverable.md has all 9 schema fields. AC-13: no required field blank. AC-14: ≤1 min to complete. | Each template file contains `tp.` calls for all 9 required fields |
| A5 | Setup script | `4-EXECUTE/scripts/setup-obsidian.sh` | AC-15: installs templates + bases on fresh clone. AC-16: idempotent. AC-17: exits 0/non-zero correctly. | `./scripts/setup-obsidian.sh && ./scripts/setup-obsidian.sh` exits 0 both times |
| A6 | Validation test | `4-EXECUTE/tests/obsidian/test-frontmatter-schema.sh` | AC-18: PASS for valid files. AC-19: FAIL with path+field for violations. AC-20: 67/67 I1 tests still pass. | `./4-EXECUTE/tests/obsidian/test-frontmatter-schema.sh` exits 0 on current main artifacts |
| A7 | Training slide deck | `4-EXECUTE/docs/training/obsidian-workflow-deck/index.html` | AC-21: 7 scenes covering full workflow. AC-22: standalone onboarding (no verbal coaching). AC-23: LTC brand compliant. | File exists, opens in browser, contains LTC brand colors and fonts |

---

## Section 4: Domain Context

### Reference Implementation
Vinh's branch: `remotes/origin/Vinh-ALPEI-AI-Operating-System-with-Obsidian`
- Extract base files via: `git show "remotes/origin/Vinh-ALPEI-AI-Operating-System-with-Obsidian:{path}"`
- All 14 base files listed in DESIGN.md § The 14 Bases table

### Schema Mapping (S2 migration)
| Old value (BLUEPRINT) | New value (S2) | Used in |
|-----------------------|---------------|---------|
| `Draft` | `draft` | All workstream artifacts |
| `Review` | `in-review` | Artifacts awaiting human approval |
| `Approved` | `validated` | Human-approved artifacts |
| _(new)_ | `in-progress` | Actively being built |
| _(new)_ | `archived` | Deprecated artifacts |

### Folder Name Mapping (Vinh → LTC Template)
| Vinh | LTC Template |
|------|-------------|
| `1. ALIGN` | `1-ALIGN` |
| `2. LEARN` | `2-LEARN` |
| `3. PLAN` | `3-PLAN` |
| `4. EXECUTE` | `4-EXECUTE` |
| `5. IMPROVE` | `5-IMPROVE` |
| `DAILY NOTES` | `DAILY-NOTES` |
| `MISC TASKS` | `MISC-TASKS` |

### LTC Brand (for T7 training deck)
Load `rules/brand-identity.md` before building A7.
Primary: Midnight Green #004851 | Gold #F2C75C | Dark Gunmetal #1D1F2A | White #FFFFFF
Typography: Inter (English), Work Sans (Vietnamese) via Google Fonts.

---

## Section 5: Agent System Constraints

| # | Truth | Impact on This Build |
|---|-------|---------------------|
| LT-1 | Hallucination is structural | Verify all 14 base file paths by git show before writing |
| LT-2 | Context compression is lossy | T3 and T4 dispatched as separate tasks — not combined |
| LT-3 | Reasoning degrades on complex tasks | Each task has ≤3 sub-steps; checkpoint commit enforces completion |
| LT-7 | Cost scales with tokens | Extract only relevant sections from Vinh's bases, not full files |

---

## Section 6: Agent Instructions

### Your Role
You are a single `ltc-builder` (Sonnet) agent. Produce 7 artifacts in the order T1 → T2 → T3 → T4 → T5 → T6 → T7. After each artifact, verify against its ACs, then commit. Do not proceed to the next task until the current one passes all ACs.

### Your Deliverables
1. **A1 frontmatter-schema.md + migrate-status.sh** — canonical schema with S2 vocabulary + bulk migration script
2. **A2 vault-structure.md + setup-vault.sh** — full vault folder layout + idempotent creation script
3. **A3 14 × .base files** — all of Vinh's bases, folder refs and status values corrected
4. **A4 6 × Templater templates** — auto-fill all 9 schema fields on artifact creation
5. **A5 setup-obsidian.sh** — one-command install of templates + bases into .obsidian/
6. **A6 test-frontmatter-schema.sh** — regression guard for schema compliance
7. **A7 index.html training deck** — 7-scene workflow demonstration with LTC brand

### What to Optimize For
- **Correctness first:** Base file filter expressions must exactly match A1 field names and S2 values — any mismatch silently breaks dashboard queries
- **Idempotency:** All scripts must be safe to run multiple times
- **Minimal delta from Vinh:** Adapt, do not rewrite — preserve Vinh's formulas and view structures; change only what the schema/folder mapping requires

### Constraints
- Extract Vinh's base files via `git show` — do NOT write from memory
- Load `rules/brand-identity.md` BEFORE building A7
- Agent writes go to the worktree path only (`4-EXECUTE/`, `_genesis/BLUEPRINT.md`)
- Do NOT modify anything in `.claude/rules/`, `.claude/skills/`, or `1-ALIGN/` through `3-PLAN/`
- Sustainability > Efficiency > Scalability in all prioritization

---

**Classification:** INTERNAL
