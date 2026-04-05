---
version: "1.2"
status: draft
last_updated: 2026-04-03
owner: "Long Nguyen"
workstream: GOVERN
type: design
title: "_genesis/ Cleanup + Blueprint Restructure"
branch: "I2/chore/genesis-blueprint-cleanup"
---

# DESIGN: _genesis/ Cleanup + Blueprint Restructure

> **EO:** Clean up _genesis/ to be MECE and functional across S × E × Sc, move the
> Blueprint to its correct home, enhance existing rules to close enforcement gaps
> (zero new rule files), and restructure the Blueprint for I1→I4 guidance.

---

## 1. PROBLEM STATEMENT

### 1.1 Current State

_genesis/ has 26 framework files with ~50% content overlap. Two generations of files
coexist: ALL_CAPS originals (created early I1) and `ltc-` prefixed Vinh canonical
sources (transcribed later). The duplicates create divergence risk, waste agent tokens,
and confuse file discovery.

The Blueprint lives in `1-ALIGN/charter/BLUEPRINT.md` — wrong location (bedrock
philosophy, not iteration-scoped alignment). Part 4 is over-detailed (~175 lines of
implementation spec that belongs in DESIGN.md). Part 7 (Decisions) is obsolete.

Enforcement gaps exist in VANA gate, sub-system inheritance, and version awareness —
but the existing rules already cover these topics partially. The gaps are 2-5 lines
each, not entire new files.

### 1.2 Root Cause

We never completed the Vinh decomposition for most frameworks. Vinh's pattern:

```
CANONICAL SOURCE (_genesis/frameworks/)     "What is this & how does it work"
     │
     ├── RULE (.claude/rules/)              "You must do this" (auto-loaded EP)
     ├── SKILL (.claude/skills/)            "Let me help you do this" (on-demand EOP)
     ├── HOOK (.claude/settings.json)       "Enforce this automatically" (EOE constraint)
     └── TRAINING (2-LEARN/)                "Learn this" (human-facing)
```

The ALL_CAPS files exist as a crutch — they serve the "quick reference" function that
existing rules should serve. The enforcement gaps are small — lines missing from
existing rules, not entire new rule files needed.

### 1.3 Why Now

I2 starts soon. At I2 scale (pilot PM, Obsidian Bases, 6 dashboards), a clean _genesis/
library is prerequisite for:
- Obsidian Bases frontmatter schema (needs clear canonical files to index)
- Pilot PM onboarding (needs Blueprint with Operating Model + actionable ACs)
- Template updates across projects (needs clean git history for merge)

---

## 2. DESIGN DECISIONS

### D1: Blueprint Location

**Decision:** Move `1-ALIGN/charter/BLUEPRINT.md` → `_genesis/BLUEPRINT.md`

**Why:** _genesis/ = bedrock (philosophy, frameworks, templates). 1-ALIGN/ = iteration-scoped
(I2 charter, I2 decisions, I2 OKRs). The Blueprint spans I0→I4 — it is not owned by
any single iteration.

**Action:** `git mv` + update all references (MEMORY.md, CLAUDE.md, pre-flight rule step 2).
Leave a redirect note at old location.

---

### D2: Duplicate Resolution — Archive, Don't Merge

**Decision:** Archive ALL_CAPS files to `_genesis/frameworks/archive/`. Do NOT merge
their content into canonical files.

**Why (from Review 1):**
- THREE_PILLARS.md has *application guidance* (code examples, process questions). This is
  operational checklist material, not philosophy. Merging into `ltc-10-ultimate-truths.md`
  would contaminate the canonical source with content of a different change velocity.
- SIX_WORKSTREAMS.md's "Why Concurrent" section contradicts BLUEPRINT Principle 1
  (sequential for building). Merging would create doctrinal conflict.
- Unique actionable content from THREE_PILLARS (S>E>Sc checklists) and SIX_WORKSTREAMS
  (folder mapping) is captured by enhancing existing rules (see D3), not by contaminating
  canonical sources.

**Resolution per file:**

| File | Finding | Resolution |
|------|---------|------------|
| THREE_PILLARS.md | HAS UNIQUE (practical checklists) | Checklist value → enhance existing rules. Archive. |
| SIX_WORKSTREAMS.md | HAS UNIQUE (folder mapping) | Folder mapping → already in CLAUDE.md Structure. Archive. |
| EFFECTIVE_SYSTEM.md | TRUE SUBSET | Archive. Canonical: ltc-effective-system-design-blueprint.md |
| COGNITIVE_BIASES.md | SUBSET | Already covered by rules/agent-system.md §4 (6 biases). Archive. |
| CRITICAL_THINKING.md | 100% SUBSET | Archive. Canonical: ltc-effective-thinking.md |
| UBS_UDS_GUIDE.md | SUBSET | Archive. Canonical: ltc-ubs-uds-framework.md |
| ues-version-behaviors.md | EXACT DUPLICATE | Delete (no unique value to preserve). |

Archive header format:
```markdown
<!-- ARCHIVED 2026-04-03 — Superseded by {canonical file}. Do not load. -->
```

---

### D3: Enhance Existing Rules — Zero New Files

**Decision:** Close enforcement gaps by adding 2-5 lines to 3 existing rules.
Do NOT create new auto-loaded rule files.

**Why zero new files (from GAN analysis — Review 2):**

Current session start: 8 auto-loaded rules + CLAUDE.md (project + global) + rules/
(referenced from CLAUDE.md) = ~30-40K tokens. Already 15-20% of a 200K context window
burned before work begins. Adding new files compounds LT-2 (context compression) and
LT-7 (token cost) with diminishing enforcement returns.

```
Enforcement value
     │
     │    ╭──── diminishing returns
     │   ╱
     │  ╱
     │ ╱
     │╱
     └──────────────────── # of always-on rules
     0    5    8    13
          ↑         ↑
        current   rejected
```

The 5 proposed new rules (R1-R5 from Review 1) ALL address gaps already partially
covered by existing rules. The gaps are 2-5 lines each — small enough to fold in.

**Enhancements to existing rules:**

| Existing Rule | Enhancement | Lines Added | Gap Closed |
|---|---|---|---|
| `dsbv.md` | + VANA gate: "At Validate phase, verify deliverable against VANA criteria table for current UES version. No VANA criteria met = not done. Reference: `_genesis/frameworks/ltc-ues-versioning.md`" | +3 | R1 (VANA gate) |
| `alpei-chain-of-custody.md` | + Sub-system section: "Sub-System Sequence: PD→DP→DA→IDM. Downstream sub-system cannot exceed upstream version. PD Effective Principles govern all downstream sub-systems. Violation = same STOP protocol as workstream violations." | +5 | R2 (sub-system inheritance) |
| `versioning.md` | + Version awareness: "Before producing any deliverable, verify current iteration. I1 = Concept (correct + safe only). I2 = Prototype (+ efficient). Do not produce artifacts beyond current iteration scope. Reference: `_genesis/frameworks/ltc-ues-version-behaviors.md` 25-cell matrix." | +3 | R5 (version awareness) |

**What we are NOT enhancing (already covered):**
- S > E > Sc ordering (R3) — already stated in CLAUDE.md and referenced in pre-flight step 3.
  Adding it again would be duplication, not enforcement.
- File routing (R4) — already in CLAUDE.md Structure section. The one recurring mistake
  (research → wrong dir) is a `/deep-research` skill bug, not a rule gap.
- Cognitive bias check — already in `rules/agent-system.md` §4. Create `/bias-check` skill
  (on-demand EOP) if explicit bias audits are needed.

**Net token impact:** ~11 lines / ~150 tokens added. Zero new files. Session start
cost unchanged.

---

### D4: Blueprint Restructure

**Decision:** Rewrite Blueprint with this structure:

```
PART 1: PHILOSOPHY — WHY WE EXIST                    (keep + enhance)
  - Existing content (UT#5, UT#6, UT#7, Success Formula, S>E>Sc)
  - ADD: LTC 5 Principles + 2 Philosophies (summary, not duplication)
  - REFERENCE: _genesis/reference/ltc-company-handbook.md
  - REFERENCE: _genesis/frameworks/ltc-10-ultimate-truths.md

PART 2: PRINCIPLES — HOW WE WORK                     (keep + add EP reference)
  - 8 working principles (P1-P8) — already good
  - ADD: reference to EP-01 through EP-13 registry
  - REFERENCE: _genesis/reference/ltc-effective-agent-principles-registry.md

PART 3: OPERATING MODEL — WHO DOES WHAT               (NEW)
  - PM's 4 responsibilities: LEARN > INPUT > REVIEW > APPROVE
  - RACI: Agent = Responsible, PM = Accountable
  - LEARN as bridge between human collaboration and AI execution
  - Tool split: Obsidian (ALIGN/LEARN/PLAN) + Cursor (EXECUTE)
  - SOURCE: Vinh's ltc-operating-model rule pattern

PART 4: FRAMEWORK OVERVIEW — ALPEI + DSBV + 8-COMPONENT  (keep, already lean)

PART 5: ROADMAP — VANA + ACCEPTANCE CRITERIA           (REWRITE)
  - Iteration-to-version mapping table (keep — compact)
  - Per iteration: VANA statement + 5-8 user-centric Acceptance Criteria
  - I0/I1: retrospective (brief — what was done, what "done" looked like)
  - I2: next (the main focus, detailed user-centric ACs)
  - I3/I4: directional (not prescriptive — avoid specifying components)
  - Target: ~70 lines (down from ~175)
  - Acceptance Criteria, not Acceptance Conditions (Blueprint level, not DESIGN level)

PART 6: UBS/UDS REGISTER — THIS PROJECT               (keep + reference)
  - Project-specific entries
  - REFERENCE: _genesis/frameworks/ltc-ubs-uds-framework.md

PART 7: REFERENCE TABLES FOR AI AGENTS                 (keep, deduplicate)

(OLD PART 7 DECISIONS: REMOVED — all decided, no longer contested)
```

---

### D5: PDF Files — Keep as Provenance

**Decision:** Keep all 5 PDFs in `_genesis/reference/`. No action needed.

**Why:** These are Vinh's ORIGINAL source documents. The `.md` framework files are
transcriptions derived FROM these PDFs, not the other way around.

| File | Size | Purpose |
|------|------|---------|
| ltc-alpei-framework-overview.pdf | 121KB | Source for ltc-alpei-framework-overview.md |
| ltc-alpei-framework-by-workstreams.pdf | 196KB | Source for ltc-alpei-framework-by-subsystems.md |
| ltc-alpei-framework-by-subsystem.pdf | 175KB | Source for same |
| ltc-alpei-process-requirements.pdf | 30KB | Source for ALPEI_DSBV_PROCESS_MAP parts |
| ltc-ues-versioning.pdf | 59KB | Source for ltc-ues-versioning.md |

S × E × Sc:
- **S:** Provenance — if .md transcription has errors, PDF is how we verify. Removing
  loses the verification path.
- **E:** Dead weight for agent workflows (grep/QMD can't index PDFs). But negligible
  storage cost (~580KB total). Claude Code CAN read PDFs when needed.
- **Sc:** New PMs at I3 may want Vinh's polished originals for first exposure. More
  readable than .md for onboarding context.

---

### D6: Other _genesis/ Cleanup

| Action | File | Reason |
|--------|------|--------|
| Archive | `sops/ALPEI_OPERATING_PROCEDURE.md` | Self-marked DEPRECATED. Move to `sops/archive/`. |
| Keep | `security/NAMING_CONVENTION.md` | Human-readable prose version of `rules/naming-rules.md`. Referenced by `rules/naming-rules.md` (line 1) and `.claude/skills/ltc-naming-rules/SKILL.md` (line 26). NOT a duplicate — different audience (human vs agent). |
| Keep | `reference/ltc-system-wiki-template.md` | May be useful for I2 wiki pages. Reassess at I2 close. |
| Keep | All placeholder dirs (governance/, compliance/, culture/, philosophy/, principles/) | Structural markers for future content. Low cost to keep. |
| Keep | LEARNING_HIERARCHY.md | Unique content (4-level K→U→W→E) not covered by ltc-effective-learning.md. |

---

### D7: Kebab-Case Rename (Separate Commit — Merge-Friendly)

Per Naming Convention GAN Synthesis (P3: kebab-case universal), rename surviving
ALL_CAPS framework files. This is a **content-free rename** — separate commit from
content changes to preserve git rename tracking for downstream project merges.

| Current | Renamed |
|---------|---------|
| AGENT_SYSTEM.md | agent-system.md |
| AGENT_DIAGNOSTIC.md | agent-diagnostic.md |
| LEARNING_HIERARCHY.md | learning-hierarchy.md |
| HISTORY_VERSION_CONTROL.md | history-version-control.md |
| ALPEI_DSBV_PROCESS_MAP.md | alpei-dsbv-process-map.md |
| ALPEI_DSBV_PROCESS_MAP_P1.md | alpei-dsbv-process-map-p1.md |
| ALPEI_DSBV_PROCESS_MAP_P2.md | alpei-dsbv-process-map-p2.md |
| ALPEI_DSBV_PROCESS_MAP_P3.md | alpei-dsbv-process-map-p3.md |
| ALPEI_DSBV_PROCESS_MAP_P4.md | alpei-dsbv-process-map-p4.md |

**Requires:** Grep entire repo for each old name and update ALL hits. Known locations:

| Old Name | Referenced In |
|----------|--------------|
| `ALPEI_DSBV_PROCESS_MAP.md` | `.claude/rules/alpei-chain-of-custody.md` (lines 16, 29) |
| | `.claude/rules/alpei-pre-flight.md` (line 22) |
| | `.claude/skills/dsbv/SKILL.md` (lines 91, 132, 180) |
| | `.claude/skills/dsbv/references/context-packaging.md` (line 48) |
| | `3-PLAN/architecture/ARCHITECTURE.md` (lines 12, 57) |
| | `_genesis/version-registry.md` (line 51) |
| | `_genesis/tools/alpei-navigator.html` (lines 392-396) |
| | `_genesis/templates/README.md` (lines 53, 63) |
| | `_genesis/templates/architecture-template.md` (line 44) |
| | `_genesis/frameworks/README.md` (multiple lines) |
| | `_genesis/sops/ALPEI_OPERATING_PROCEDURE.md` (line 22) — being archived, update anyway |
| `HISTORY_VERSION_CONTROL.md` | `CLAUDE.md` (line 107) |
| | `.claude/rules/versioning.md` (line 8) |
| | `_genesis/frameworks/README.md` |
| `AGENT_SYSTEM.md` | `rules/agent-system.md` (line 5) |
| | `_genesis/frameworks/README.md` |
| `AGENT_DIAGNOSTIC.md` | `rules/agent-diagnostic.md` (line 1) |
| | `_genesis/principles/README.md` (line 22) |
| | `_genesis/frameworks/README.md` |
| `LEARNING_HIERARCHY.md` | `_genesis/tools/alpei-navigator.html` (lines 276, 385) |
| | `_genesis/templates/research-template.md` (line 8 — uses stale `_shared/` path) |
| | `_genesis/frameworks/README.md` |

**Verification:** After rename commit, `grep -r "ALPEI_DSBV_PROCESS_MAP\|AGENT_SYSTEM\|AGENT_DIAGNOSTIC\|LEARNING_HIERARCHY\|HISTORY_VERSION_CONTROL" . --include='*.md' --include='*.html' --include='*.tsx'` must return zero hits outside `archive/`.

---

### D8: Git Merge Strategy for Downstream Projects

**Context:** LTC projects clone this template and get `_genesis/` as shared
infrastructure. They don't continuously pull — they clone once, then get updates via
periodic manual upgrades (`_genesis/guides/MIGRATION_GUIDE.md`).

**Design for merge-friendliness:**

```
CHANGE TYPE               MERGE DIFFICULTY    OUR APPROACH
──────────                ────────────────    ────────────
Content edit in place     Auto-merge          ✓ Rule enhancements (D3)
File rename (git mv)      Auto-tracks         ✓ Kebab rename (D7) — content-free
File move to archive/     Conflict if local   ✓ Archive moves (D2) — rarely customized
                          modified
Delete file               Conflict if local   ✓ Only 2 deletes (exact dup + security dup)
                          modified
Rename + content change   Lost rename track   ✗ NEVER in same commit
  in same commit
```

**Commit discipline for merge safety:**

1. **Renames are content-free commits.** `git mv` only, zero edits to file content.
   Git tracks renames when similarity > 50%. Content edits in the same commit break
   rename detection, causing downstream merges to see "delete + create" instead of
   "rename" — painful conflicts.

2. **Content changes are rename-free commits.** Blueprint rewrite, rule enhancements,
   README updates — all in separate commits from any file moves.

3. **Migration guide updated.** `_genesis/guides/MIGRATION_GUIDE.md` will include a
   rename table so project owners know what moved. Projects that haven't customized
   `_genesis/` files (most won't — it's shared bedrock) will get clean auto-merges.

---

## 3. ACCEPTANCE CRITERIA

| # | Criterion | How to Verify |
|---|-----------|---------------|
| AC-1 | Zero duplicate framework files in `_genesis/frameworks/` (no ALL_CAPS + ltc- pairs) | `ls _genesis/frameworks/` shows only canonical files + archive/ |
| AC-2 | VANA gate, sub-system inheritance, and version awareness enforced via existing rules (zero new rule files) | `diff` of dsbv.md, alpei-chain-of-custody.md, versioning.md shows +11 lines total |
| AC-3 | Blueprint lives at `_genesis/BLUEPRINT.md` with no broken references | `grep -r "1-ALIGN/charter/BLUEPRINT" .` returns zero matches |
| AC-4 | Blueprint Part 5 (Roadmap) uses VANA + user-centric ACs, not 8-component tables | Part 5 is ≤80 lines. Each iteration has VANA statement + ≤8 ACs. |
| AC-5 | Blueprint Part 3 (Operating Model) defines PM role, RACI, tool split | Part 3 includes LEARN > INPUT > REVIEW > APPROVE + Obsidian/Cursor split |
| AC-6 | All framework files in `_genesis/frameworks/` are kebab-case | No SCREAMING_SNAKE filenames outside archive/ |
| AC-7 | Auto-loaded rule token budget unchanged (zero new rule files) | `ls .claude/rules/` shows same 9 files. No additions. |
| AC-8 | Every surviving `_genesis/frameworks/` file has S × E × Sc justification | Section 5 table — each file traceable to risk (S), function (E), scale (Sc) |
| AC-9 | `sops/ALPEI_OPERATING_PROCEDURE.md` archived; `security/NAMING_CONVENTION.md` kept | `ls sops/archive/` confirms; `ls security/` confirms NAMING_CONVENTION.md present |
| AC-10 | All renames are content-free commits; all content changes are rename-free commits | `git log --diff-filter=R` shows renames only; content commits show no renames |
| AC-11 | Migration guide updated with rename table | `_genesis/guides/MIGRATION_GUIDE.md` has a "v1.1 Changes" section |
| AC-12 | 5 PDFs in `_genesis/reference/` untouched | `ls _genesis/reference/*.pdf` shows all 5 |
| AC-13 | Placeholder dirs (governance/, compliance/, culture/, philosophy/, principles/) untouched | All 5 dirs present with their README.md files |
| AC-14 | Zero old SCREAMING_SNAKE references outside `archive/` after rename | Grep verification command in D7 returns zero matches |
| AC-15 | `_genesis/frameworks/README.md` updated to reflect new file inventory | README lists 18 canonical files with correct kebab-case names |
| AC-16 | APEI→ALPEI typo fixed in touched files (`dsbv.md`, `CLAUDE.md`) | `grep -r "APEI" .claude/rules/ CLAUDE.md` returns zero false hits |

---

## 4. EXECUTION SEQUENCE

```
STEP  ACTION                                    COMMIT TYPE        RISK
────  ──────                                    ───────────        ────
 1    Move BLUEPRINT.md to _genesis/            chore(genesis)     LOW — git mv
      + leave redirect at old location
      + update references in CLAUDE.md,
        MEMORY.md, pre-flight rule

 2    Archive 6 ALL_CAPS frameworks to          cleanup(genesis)   LOW — git mv to
      _genesis/frameworks/archive/                                 archive/ (no content
      + delete 1 exact dup (UES_VERSION_                           changes)
        BEHAVIORS.md)

 3    Archive sops/ALPEI_OPERATING_PROCEDURE.md  cleanup(genesis)   LOW — git mv
      (security/NAMING_CONVENTION.md KEPT —
       it is the human-readable prose version
       of rules/naming-rules.md, not a dup)

 4    Rename ALL_CAPS → kebab-case              refactor(genesis)  MED — many refs
      (CONTENT-FREE commit — git mv only)
      + grep entire repo for each old name
        and update ALL hits (see D7 table
        for complete reference inventory)
      + verify: zero old-name refs outside
        archive/ after commit

 5    Enhance 3 existing rules                  chore(rules)       LOW — +11 lines
      (+3 lines dsbv.md, +5 lines chain-of-                       total across 3 files
       custody.md, +3 lines versioning.md)
      + fix APEI→ALPEI typo in dsbv.md (line 9)

 6    Rewrite Blueprint                         feat(genesis)      MED — content change
      - Part 3 (Operating Model): NEW
      - Part 4 (Framework): keep (renumbered)
      - Part 5 (Roadmap): REWRITE as VANA+ACs
      - Part 7 (Decisions): REMOVE
      - Part 1, 2: enhance with references
      + fix APEI→ALPEI in CLAUDE.md (line 17)

 7    Update bookkeeping                        docs(genesis)      LOW — index refresh
      - _genesis/README.md (file index)
      - _genesis/frameworks/README.md (file
        inventory — currently stale)
      - _genesis/guides/MIGRATION_GUIDE.md
        (rename table for downstream projects)
      - VERSION_REGISTRY.md
      - MEMORY.md briefing card
```

Steps 1-4 are mechanical (moves, renames). Step 5 is minimal rule enhancement.
Step 6 is the creative work. Step 7 is bookkeeping.

---

## 5. S × E × Sc JUSTIFICATION FOR SURVIVING frameworks/ FILES

| File | S (risk managed?) | E (functional value?) | Sc (scales to I3?) |
|------|---|---|---|
| ltc-10-ultimate-truths.md | Foundation — wrong UTs = everything wrong | Agent/human first-principle alignment | Shared across all 6 projects |
| ltc-effective-system-design-blueprint.md | 8-component model prevents missing components | System design validation reference | Universal model, project-agnostic |
| ltc-alpei-framework-overview.md | Prevents workstream/stage confusion | Agent/PM quick ALPEI lookup | Unchanged across iterations |
| ltc-alpei-framework-by-subsystems.md | Prevents subsystem scope bleed | 80-cell subsystem × workstream reference | Grows with subsystem count |
| alpei-dsbv-process-map.md | Authoritative process — prevents ad-hoc DSBV | Agent dispatches from this map | Updated per iteration, not per project |
| alpei-dsbv-process-map-p1 to p4.md | Each part = 1 focused concern | Targeted lookup without loading full map | Independent parts, extensible |
| ltc-effective-thinking.md | Reasoning quality = output quality | Loaded during LEARN/analysis phases | Universal thinking framework |
| ltc-effective-learning.md | LEARN workstream = bottleneck (Principle 2) | Defines LEARN outputs (UBS/UDS/EP) | Unchanged across projects |
| learning-hierarchy.md | Wrong learning level = wrong output | K→U→W→E + minimum Level 2 constraint | Applied per topic, not per project |
| ltc-ubs-uds-framework.md | Risk analysis quality = system quality | Full recursive UBS/UDS trace method | Applied to every subsystem |
| ltc-ues-version-behaviors.md | Wrong version scope = over/under-build | 25-cell "what does done look like" matrix | Referenced at every DSBV Design |
| ltc-ues-versioning.md | VANA criteria prevent premature advancement | Version × pillar × component mapping | Stable across iterations |
| history-version-control.md | Git strategy prevents merge conflicts | Day-to-day workflow + branch model | Scales with team size |
| agent-system.md | Agent misconfiguration = silent failures | 7-CS model + LLM Truths + component cards | Updated as model capabilities change |
| agent-diagnostic.md | Blame-the-model fallacy wastes time | 6-component trace before escalating | Applied per agent failure |

---

## 6. RESULTING _genesis/ STRUCTURE

```
_genesis/
├── README.md                              ← Updated index
├── VERSION_REGISTRY.md                    ← Keep
├── BLUEPRINT.md                           ← MOVED from 1-ALIGN/charter/ + restructured
├── DESIGN-genesis-blueprint-cleanup.md    ← This document (remove after merge)
│
├── frameworks/                            (26 → 19 files: 18 canonical + README + archive/)
│   ├── README.md                          ← Updated
│   ├── ltc-10-ultimate-truths.md
│   ├── ltc-effective-system-design-blueprint.md
│   ├── ltc-alpei-framework-overview.md
│   ├── ltc-alpei-framework-by-subsystems.md
│   ├── alpei-dsbv-process-map.md          ← Renamed from ALPEI_DSBV_PROCESS_MAP.md
│   ├── alpei-dsbv-process-map-p1.md       ← Renamed
│   ├── alpei-dsbv-process-map-p2.md       ← Renamed
│   ├── alpei-dsbv-process-map-p3.md       ← Renamed
│   ├── alpei-dsbv-process-map-p4.md       ← Renamed
│   ├── ltc-effective-thinking.md
│   ├── ltc-effective-learning.md
│   ├── learning-hierarchy.md              ← Renamed from LEARNING_HIERARCHY.md
│   ├── ltc-ubs-uds-framework.md
│   ├── ltc-ues-version-behaviors.md
│   ├── ltc-ues-versioning.md
│   ├── history-version-control.md         ← Renamed from HISTORY_VERSION_CONTROL.md
│   ├── agent-system.md                    ← Renamed from AGENT_SYSTEM.md
│   ├── agent-diagnostic.md                ← Renamed from AGENT_DIAGNOSTIC.md
│   └── archive/                           ← Absorbed duplicates (git-recoverable)
│       ├── THREE_PILLARS.md
│       ├── SIX_WORKSTREAMS.md
│       ├── EFFECTIVE_SYSTEM.md
│       ├── COGNITIVE_BIASES.md
│       ├── CRITICAL_THINKING.md
│       └── UBS_UDS_GUIDE.md
│
├── templates/                             (27 files — untouched)
├── reference/                             (untouched — 5 PDFs + .md sources preserved)
├── brand/                                 (untouched)
├── security/                              (untouched — NAMING_CONVENTION.md kept)
├── sops/                                  (-1 deprecated → archive/)
│   └── archive/
│       └── ALPEI_OPERATING_PROCEDURE.md
├── guides/                                (MIGRATION_GUIDE.md updated with rename table)
├── tools/                                 (untouched)
├── training/                              (untouched)
├── skills/                                (untouched)
├── scripts/                               (untouched)
├── governance/                            (placeholder — keep)
├── compliance/                            (placeholder — keep)
├── culture/                               (placeholder — keep)
├── philosophy/                            (placeholder — keep)
└── principles/                            (placeholder — keep)
```

`.claude/rules/` after cleanup (SAME 8 files, 3 enhanced):
```
.claude/rules/
├── agent-dispatch.md                      (unchanged)
├── alpei-chain-of-custody.md              (ENHANCED: +5 lines sub-system ordering)
├── alpei-pre-flight.md                    (UPDATED: Blueprint path reference)
├── alpei-template-usage.md                (unchanged)
├── dsbv.md                                (ENHANCED: +3 lines VANA gate)
├── example-api-conventions.md             (unchanged)
├── git-conventions.md                     (unchanged)
├── memory-format.md                       (unchanged)
└── versioning.md                          (ENHANCED: +3 lines version awareness)
```

---

## 7. EXPECTED OUTCOMES

### 7.1 Immediate (This Branch)

| What Changes | What It Enables |
|---|---|
| 16 MECE framework files (was 26) | Agent loads the RIGHT file first time. No "which version of THREE_PILLARS do I read?" ambiguity. |
| Blueprint at `_genesis/BLUEPRINT.md` | Clear separation: bedrock vs iteration. `1-ALIGN/` is freed for I2 charter work. |
| 3 existing rules enhanced (+11 lines) | VANA gate, sub-system ordering, version awareness enforced WITHOUT new files or token cost. |
| Part 5 rewritten (VANA + ACs) | Blueprint is actionable, not encyclopedic. PM reads ACs and knows what "done" looks like. |
| Part 3 added (Operating Model) | PM knows their role: LEARN > INPUT > REVIEW > APPROVE. Obsidian for thinking, Cursor for building. |
| Content-free rename commits | Downstream projects get clean auto-merges when pulling template updates. |
| Migration guide updated | Project owners have a rename table — no guesswork during template upgrades. |

### 7.2 I2 (Prototype)

- Clean `_genesis/` is prerequisite for Obsidian Bases frontmatter schema design.
  Bases queries reference framework files — MECE files = precise queries.
- Blueprint Part 5 ACs guide what I2 must deliver. Pilot PM reads ACs, not a
  175-line implementation spec.
- Blueprint Part 3 (Operating Model) tells the pilot PM their job on day one:
  LEARN > INPUT > REVIEW > APPROVE. Obsidian for thinking, Cursor for building.
- File routing is clear in CLAUDE.md — ALIGN/LEARN/PLAN artifacts in Obsidian,
  EXECUTE artifacts in Cursor.

### 7.3 I3 (MVE — 6 Projects)

- 6 projects clone template. `_genesis/` is the shared library.
- MECE frameworks = no confusion about which file is canonical.
- Migration guide tells each project exactly what renamed/moved.
- Sub-system inheritance (now in chain-of-custody) prevents projects from
  building DA artifacts before PD is validated.
- Kebab-case naming = consistent across all 6 projects (no SCREAMING_SNAKE
  vs kebab-case confusion).
- PDFs preserve Vinh's provenance for any framework disputes.

### 7.4 I4 (Leadership) and Beyond

- `_genesis/` pattern is established for future growth:
  - New framework = `ltc-` prefixed, kebab-case, one topic per file
  - Enforcement = enhance existing rules (2-5 lines), not new rule files
  - Quick reference = on-demand skill, not always-on rule
  - Provenance = keep source PDFs in `reference/`
- Archive/ preserves history for governance audits without cluttering active dir.
- Placeholder dirs (governance/, compliance/, etc.) ready for population when
  the org formalizes those concerns.

---

## 8. REVIEW HISTORY

### Review 1 (2026-04-03): Objective S × E × Sc Review

Key findings incorporated:
1. Do NOT merge content into canonical files (contamination risk)
2. Do NOT create cognitive-bias-check.md (already in agent-system.md §4)
3. SIX_WORKSTREAMS "Why Concurrent" contradicts BLUEPRINT P1 — don't merge
4. All enforcement rules must be in `.claude/rules/` (auto-loaded), not `rules/`
5. LEARNING_HIERARCHY.md must stay (unique K→U→W→E content)

### Review 2 (2026-04-03): GAN Analysis — New Rules vs Enhance Existing

Key finding: The 5 proposed new auto-loaded rule files would add ~1.5K tokens to
an already 30-40K session start. All 5 gaps are partially covered by existing rules
and can be closed with 2-5 lines each. Zero new files needed.

Decision changed: D3 went from "5 new rule files" to "enhance 3 existing rules
(+11 lines total)."

### Review 3 (2026-04-03): Independent validation of v1.1

Rating: PASS WITH CONDITIONS. 1 blocker + 3 important + 4 minor found. All resolved in v1.2:

1. **BLOCKER FIXED:** `security/NAMING_CONVENTION.md` is NOT a duplicate — it's the
   human-readable prose version of `rules/naming-rules.md`. Reclassified from "delete" to
   "keep" in D6. `brand/NAMING_CONVENTION.md` does not exist on disk.
2. **FIXED:** File count arithmetic corrected: 26 → 19 (18 canonical + README), not 16.
   Delta is -7 active (-27%), not -10 (-38%).
3. **FIXED:** Expanded D7 reference table to include ALL locations referencing old names:
   `3-PLAN/architecture/`, `_genesis/version-registry.md`, `_genesis/tools/alpei-navigator.html`,
   `_genesis/templates/`, `_genesis/principles/`, `rules/agent-system.md`, `rules/agent-diagnostic.md`.
   Added verification grep command.
4. **FIXED:** CLAUDE.md line 17 "APEI" → "ALPEI" typo noted for correction in Step 6.
5. **VERIFIED:** No external references to Blueprint Part numbers exist — renumbering is safe.
6. **FIXED:** `dsbv.md` "APEI" → "ALPEI" typo noted for correction in Step 5.
7. **FIXED:** `_genesis/frameworks/README.md` added to Step 7 bookkeeping.
8. **FIXED:** AC-7 corrected to "9 files" (not "8 + 1 = 9"). AC-14/15/16 added for
   reference verification, frameworks README, and APEI→ALPEI fix.

---

## 9. NET IMPACT

```
                        BEFORE          AFTER           DELTA
                        ──────          ─────           ─────
frameworks/ files       26              19 (18+README)   -7 active (-27%) + archive/
                                        + archive/
Auto-loaded rules       9 files         9 files         0 new files (+11 lines)
Blueprint location      1-ALIGN/        _genesis/       Correct home
Blueprint Part 5        ~175 lines      ~70 lines       -60% (VANA+AC)
Duplicate content       ~50% overlap    0% overlap      MECE achieved
Enforcement gaps        3 identified    0               Closed via +11 lines in existing rules
Token budget (rules)    ~30-40K         ~30-40K         Unchanged (zero new files)
PDF provenance          5 files         5 files         Preserved
Naming convention       security/       security/       Kept (human-readable prose version)
Placeholder dirs        5 dirs          5 dirs          Preserved
Downstream merge cost   N/A             LOW             Content-free rename commits
APEI→ALPEI typos        2 found         0               Fixed in dsbv.md + CLAUDE.md
```
