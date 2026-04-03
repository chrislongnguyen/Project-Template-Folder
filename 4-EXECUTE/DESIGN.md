---
version: "1.2"
status: draft
last_updated: 2026-04-03
type: ues-deliverable
sub_system: problem-diagnosis
work_stream: execute
stage: design
iteration: 2
ues_version: prototype
---

# DESIGN.md — EXECUTE Workstream, I2: Obsidian Bases Integration

> Branch: `I2/feat/obsidian-bases`
> DSBV Phase 1 artifact. This document is the contract. If it is not here, it is not in scope.

---

## Scope Check

| Question | Answer |
|----------|--------|
| Q1: Are upstream workstream outputs sufficient? | YES — BLUEPRINT.md I2 has 8 binary ACs; frontmatter schema draft in TABLE 2; UBS/UDS registered; external research (24 sources) validates pattern |
| Q2: What is in scope? | Vault folder scaffold (all operational folders), canonical frontmatter schema, 14 Obsidian Bases (adopt all of Vinh's with folder name fixes), 6 Templater templates, plugin stack setup script, inbox/ staging folder, frontmatter validation test, training slide deck |
| Q2b: What is explicitly OUT of scope? | `/ues-next` skill (separate branch); Obsidian Sync / Teams ($960/yr — Git only); dashboards beyond Vinh's 14; Cursor-side EXECUTE workflow (separate branch) |
| Q3: Go/No-Go | GO |

---

## Workflow Model

```
PM DAILY WORKFLOW
─────────────────────────────────────────────────────────────────
OBSIDIAN (PM cockpit)              CURSOR / CLAUDE CODE (build)
  ALIGN   → charter, decisions       EXECUTE → src, tests, config
  LEARN   → research, specs          (PM hands off task here)
  PLAN    → risks, drivers, roadmap
  IMPROVE → retros, metrics
  ─────────────────────────────────
  DAILY-NOTES → standup prep
  MISC-TASKS  → ad-hoc work
  PEOPLE      → stakeholder notes
  inbox/      → agent staging area
─────────────────────────────────────────────────────────────────
Sync: Git-backed vault (not Obsidian Sync). Agent writes to inbox/ only.
```

---

## Design Decisions

**Intent:** Deliver the full Obsidian PM workspace — vault folder structure, canonical frontmatter schema, 14 live Bases dashboards, Templater auto-fill, and a training slide deck — so a PM can check status in <30 seconds, create a correctly-frontmatted artifact in <1 minute, and onboard without verbal instruction.

**Key constraints:**
- Adopt all 14 of Vinh's bases (adjust folder refs from `1. ALIGN` → `1-ALIGN` etc.)
- Vault folder structure = ALPEI workstream folders + all 8 operational folders + inbox/ staging
- Git-backed sync only (no Obsidian Sync/$960 license) per UBS-5
- Agent writes staged to `inbox/` — never directly to canonical ALPEI folders
- Plugin stack: Bases + Templater + Daily Notes + Dataview + Kanban (5 core plugins)
- Schema decision (open — resolve in A1): Vinh uses `draft|in-review|in-progress|validated|archived`; BLUEPRINT TABLE 2 uses `Draft|Review|Approved`. Must pick one before A3 build begins.

---

## Artifact Inventory

| # | Artifact | Path | Purpose (WHY) | Acceptance Conditions |
|---|----------|------|---------------|-----------------------|
| A1 | Frontmatter schema spec + migration script | `4-EXECUTE/docs/frontmatter-schema.md` + `4-EXECUTE/scripts/migrate-status.sh` | Canonical YAML field definitions (S2 vocabulary). Migration script bulk-updates existing I1 artifacts from `Draft→draft`, `Review→in-review`, `Approved→validated`. | AC-1: All 9 BLUEPRINT TABLE 2 fields documented with S2 status values, types, valid values, examples. AC-2: `migrate-status.sh` runs on main branch artifacts with zero manual edits required. AC-3: After migration, all workstream `.md` artifacts pass schema validation with S2 vocabulary. |
| A2 | Vault folder scaffold | `4-EXECUTE/docs/vault-structure.md` + `4-EXECUTE/scripts/setup-vault.sh` | Documents and creates the full vault folder layout — ALPEI workstreams + 8 operational folders + inbox/ + 0-REUSABLE-RESOURCES/. This is what PMs clone/setup on day 1. | AC-4: `setup-vault.sh` creates all folders on a fresh checkout. AC-5: `inbox/` and `AI-AGENT-MEMORY/` exist with correct `.gitkeep` files. AC-6: Script is idempotent (runs twice with no errors). |
| A3 | Obsidian Bases dashboards | `4-EXECUTE/src/obsidian/bases/` (14 `.base` files) | All 14 of Vinh's bases adopted, folder references adjusted to LTC template naming convention. Live views covering daily PM workflow needs. | AC-7: All 14 `.base` files load in Obsidian without error after `setup-obsidian.sh` runs. AC-8: ALPEI Master Dashboard returns results for ≥1 artifact within 5 seconds. AC-9: All filter expressions use only fields defined in A1 — no ad-hoc field references. AC-10: Folder references updated (`1. ALIGN` → `1-ALIGN` etc.). AC-11: Status filter values match the A1-resolved vocabulary. |
| A4 | Templater templates | `4-EXECUTE/src/obsidian/templates/` (6 `.md` files) | Auto-fill frontmatter on artifact creation — PM never hand-crafts YAML. Covers the 6 most-created artifact types. | AC-12: `ues-deliverable.md` auto-populates all required schema fields using `tp.*` functions. AC-13: No required field left blank — all have a static default or `tp.system.prompt` fallback. AC-14: Creating an artifact from template to correct frontmatter takes ≤1 minute. |
| A5 | Setup script | `4-EXECUTE/scripts/setup-obsidian.sh` | One-command install: copies templates + bases + plugin config into `.obsidian/`. Eliminates manual drag-and-drop onboarding. | AC-15: Running `./setup-obsidian.sh` on a fresh clone produces working `.obsidian/` with all templates + bases installed. AC-16: Script is idempotent. AC-17: Exits 0 on success, non-zero with actionable message on failure. |
| A6 | Frontmatter validation test | `4-EXECUTE/tests/obsidian/test-frontmatter-schema.sh` | Regression guard — verifies all committed `.md` artifacts have valid frontmatter matching A1 schema. | AC-18: Reports PASS for all workstream `.md` files with frontmatter. AC-19: Reports FAIL with file path + missing field for any violation. AC-20: All 67 I1 test scripts still pass (no regression). |
| A7 | Training slide deck | `4-EXECUTE/docs/training/obsidian-workflow-deck/` | Demonstrates the full PM workflow — how to use Bases dashboards, create artifacts with Templater, run daily standup via Daily Notes, hand off to Cursor for EXECUTE. Self-service onboarding. | AC-21: Deck covers: vault setup → daily standup → artifact creation → status check via Bases → Cursor handoff. AC-22: A new PM can complete onboarding using the deck alone (no verbal coaching). AC-23: Deck follows LTC brand identity (brand-identity.md). |

**Alignment check:**

| I2 BLUEPRINT AC | Covered by |
|-----------------|-----------|
| AC1: Status check in <30 sec | A3 (ALPEI Master Dashboard) |
| AC2: `/ues-next` identifies next task | OUT OF SCOPE — separate branch |
| AC3: Self-service onboarding | A5 + A4 + A7 (setup + templates + training deck) |
| AC4: Correctly-frontmatted artifact in <1 min | A4 (Templater) |
| AC5: No hand-crafting YAML | A4 (Templater auto-fill) |
| AC6: I1 ACs still pass | A6 (regression tests) |
| AC7: Context switch <2 min via `/resume` | OUT OF SCOPE — shipped I1 |
| AC8: 6 Bases dashboards accurate live views | A3 (all 14 bases, 8 of which are new vs I1) |

- [x] Orphan conditions = 0
- [x] Orphan artifacts = 0 (A1 referenced by A3, A4, A6; A2 referenced by A5)
- [ ] Artifact count here = deliverable count in SEQUENCE.md — verify at G2

---

## The 14 Bases (Vinh → LTC Template)

| # | Name | Source File | Folder Ref Change | Notes |
|---|------|------------|------------------|-------|
| B1 | ALPEI Master Dashboard | `ALPEI Master Dashboard.base` | None (cross-vault) | Adopt as-is; fix status values |
| B2 | ALPEI Stage Board | `ALPEI Stage Board.base` | None (cross-vault) | Fix `audit` → `validate` in stage_order formula |
| B3 | Approval Queue | `Approval Queue.base` | None (cross-vault) | Fix status vocabulary per A1 |
| B4 | Blocker Dashboard | `Blocker Dashboard.base` | None (cross-vault) | Adopt as-is (time-based staleness, Option A) |
| B5 | Standup Preparation | `Standup Preparation.base` | None (cross-vault) | Adopt as-is |
| B6 | Version Progress | `Version Progress.base` | None (cross-vault) | Adopt as-is |
| B7 | Templates Library | `Templates Library.base` | None | Adopt as-is |
| B8 | Alignment Overview | `Alignment Overview.base` | `1. ALIGN` → `1-ALIGN` | Folder ref fix |
| B9 | Learning Overview | `Learning Overview.base` | `2. LEARN` → `2-LEARN` | Folder ref fix |
| B10 | Planning Overview | `Planning Overview.base` | `3. PLAN` → `3-PLAN` | Folder ref fix |
| B11 | Execution Overview | `Execution Overview.base` | `4. EXECUTE` → `4-EXECUTE` | Folder ref fix |
| B12 | Improvement Overview | `Improvement Overview.base` | `5. IMPROVE` → `5-IMPROVE` | Folder ref fix |
| B13 | Daily Notes Index | `Daily Notes Index.base` | `DAILY NOTES` → `DAILY-NOTES` | Folder ref fix |
| B14 | Tasks Overview | `Tasks Overview.base` | `MISC TASKS` → `MISC-TASKS` | Folder ref fix |

---

## The 6 Templater Templates

| # | Template | File | Covers |
|---|----------|------|--------|
| T1 | UES Deliverable | `ues-deliverable.md` | Any DSBV phase artifact (DESIGN, SEQUENCE, VALIDATE, etc.) |
| T2 | Daily Note | `daily-note.md` | DAILY-NOTES/ standup prep (yesterday / today / blockers) |
| T3 | Decision Record | `adr.md` | `1-ALIGN/decisions/ADR-xxx.md` |
| T4 | Risk Entry | `risk-entry.md` | `3-PLAN/risks/` entries |
| T5 | Driver Entry | `driver-entry.md` | `3-PLAN/drivers/` entries |
| T6 | Project Index | `project-index.md` | Project-level `index.md` (Bases pulls metadata from here) |

---

## Vault Folder Structure

```
vault/
  ├── 1-ALIGN/           ALPEI workstreams (PM writes here daily)
  ├── 2-LEARN/
  ├── 3-PLAN/
  ├── 4-EXECUTE/         Minimal — PM hands off to Cursor here
  ├── 5-IMPROVE/
  ├── DAILY-NOTES/       Daily standup notes (1 file per day per PM)
  ├── MISC-TASKS/        Ad-hoc tasks
  ├── PEOPLE/            Stakeholder + contact notes
  ├── PLACES/            Location + meeting context notes
  ├── TEMP-IN/           Inbox for incoming materials
  ├── TEMP-OUT/          Outbox for outgoing materials
  ├── THINGS/            Reference items
  ├── AI-AGENT-MEMORY/   Agent session logs (append-only)
  ├── inbox/             Agent staging area — writes here, PM reviews
  └── 0-REUSABLE-RESOURCES/
        ├── templates/   Templater templates (T1-T6)
        └── bases/       All 14 .base files
```

**Agent write rule:** Claude Code / ltc-builder agents write ONLY to `inbox/` and `AI-AGENT-MEMORY/`. All other folders are PM-write-only. Human reviews inbox/ before moving artifacts to canonical locations.

---

## Schema Decision (must resolve in A1 before A3 build)

| Field | BLUEPRINT TABLE 2 | Vinh's Bases | Decision Required |
|-------|------------------|-------------|------------------|
| `status` | `Draft\|Review\|Approved` | `draft\|in-review\|in-progress\|validated\|archived` | Expand or align? |
| `stage` | `design\|sequence\|build\|validate` | `design\|sequence\|build\|audit` | Fix: `audit` → `validate` in B2 |

**Decision: S2 — adopt Vinh's vocabulary (approved 2026-04-03)**
`draft | in-progress | in-review | validated | archived`

Rationale: Richer workflow state enables meaningful Kanban views (D3/D4/D5). BLUEPRINT TABLE 2 must be updated as part of A1 build. Existing I1 artifacts using `Draft|Review|Approved` require a one-pass migration (A1 scope includes migration script).

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | Single-agent sequential (deterministic structural artifacts) |
| Why this pattern | .base config files and Templater templates have no ambiguity — diversity adds cost not quality |
| Agent config | 1× `ltc-builder` (Sonnet), tasks dispatched sequentially per SEQUENCE.md |
| Git strategy | All work on `I2/feat/obsidian-bases` worktree. Checkpoint commit after each artifact. Merge to main after G4. |
| Human gates | G1 (this DESIGN.md), Schema freeze (status vocabulary), G2 (SEQUENCE.md), G4 (validation) |
| EP validation | EP-01: no secrets in scripts. EP-03: setup scripts idempotent. EP-04: all artifacts version-controlled. EP-09: 3-level folder depth preserved. |
| Cost estimate | ~5-6 builder dispatches × ~8K tokens each ≈ 40-50K tokens total |
| Plugin stack | Bases (core) + Templater + Daily Notes (core) + Dataview + Kanban — all free, no Obsidian Sync |

---

## Dependencies

| Dependency | From | Status |
|------------|------|--------|
| BLUEPRINT.md I2 ACs (8 criteria) | `_genesis/BLUEPRINT.md` § I2 | Ready |
| Frontmatter schema draft | `_genesis/BLUEPRINT.md` § TABLE 2 | Ready — schema conflict to resolve |
| Vinh's 14 bases (format reference) | `remotes/origin/Vinh-ALPEI-AI-Operating-System-with-Obsidian` | Ready |
| I1 test scripts (67 ACs baseline) | `4-EXECUTE/tests/obsidian/` | Ready |
| Obsidian security rules | `.claude/rules/obsidian-security.md` | Ready |
| LTC brand identity | `rules/brand-identity.md` | Ready (A7 training deck requires) |
| External validation | `2-LEARN/output/ALPEI_AI_OS_for_PM_Research.md` (24 sources) | Ready |

---

## Human Gates

| Gate | Trigger | Decision Required |
|------|---------|-------------------|
| G1 | This DESIGN.md | Approve scope, artifacts, and folder structure to proceed to SEQUENCE |
| Schema freeze | Before A3/A4 build | Approve status vocabulary (S1 / S2 / S3) |
| G2 | SEQUENCE.md complete | Approve task ordering and sizing |
| G3 | Build complete | Builder reports all ACs pass — review artifact list |
| G4 | Validate complete | Approve workstream output; branch ready to merge |

---

## Readiness Conditions (C1-C6)

| ID | Condition | Status |
|----|-----------|--------|
| C1 | Clear scope — in/out written down | GREEN |
| C2 | Input materials curated — BLUEPRINT I2 ACs, Vinh's 14 bases, 24-source research, brand rules | GREEN |
| C3 | Success rubric defined — 23 binary ACs across 7 artifacts | GREEN |
| C4 | Process definition loaded — DSBV_PROCESS.md + routing table | GREEN |
| C5 | Context scoped to obsidian-bases feature | GREEN |
| C6 | Single-agent sequential; ltc-reviewer for VALIDATE | GREEN |

**All conditions GREEN. Ready for G1.**