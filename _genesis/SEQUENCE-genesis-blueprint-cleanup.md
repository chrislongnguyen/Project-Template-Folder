---
version: "2.0"
status: draft
last_updated: 2026-04-03
owner: "Long Nguyen"
workstream: GOVERN
type: sequence
title: "_genesis/ Cleanup + Blueprint Restructure — Execution Sequence"
design_ref: "_genesis/DESIGN-genesis-blueprint-cleanup.md"
branch: "I2/chore/genesis-blueprint-cleanup"
---

# SEQUENCE: _genesis/ Cleanup + Blueprint Restructure

> Execution order for DESIGN v1.2. Each step is an atomic commit.
> Gate: Human approval required before Step 5 (content changes begin).

---

## Readiness Conditions

| # | Condition | Status |
|---|-----------|--------|
| C1 | DESIGN v1.2 validated (3 reviews passed) | ✓ DONE |
| C2 | BLUEPRINT.md source located at main repo (untracked) | ✓ DONE |
| C3 | Full reference inventory for all renames compiled (D7 table) | ✓ DONE |
| C4 | Existing rules read before enhancement (dsbv.md, chain-of-custody.md, versioning.md) | ○ Pre-build |
| C5 | Existing BLUEPRINT.md Parts 1-7 read before rewrite | ○ Pre-Step 6 |

---

## Step Sequence

```
STEP  AGENT     TYPE              COMMIT MESSAGE                        GATE
────  ─────     ────              ──────────────                        ────
 1    builder   chore(genesis)    "chore(genesis): move Blueprint to    None
                                   _genesis/ + redirect at old location"

 2    builder   cleanup(genesis)  "cleanup(genesis): archive 6 ALL_CAPS  After Step 1
                                   framework duplicates"

 3    builder   cleanup(genesis)  "cleanup(genesis): archive deprecated  After Step 2
                                   ALPEI_OPERATING_PROCEDURE.md"

 4    builder   refactor(genesis) "refactor(genesis): rename ALL_CAPS    After Step 3
                                   frameworks to kebab-case — content-   HUMAN GATE ✋
                                   free"

 5    builder   chore(rules)      "chore(rules): enhance dsbv.md,        After Step 4
                                   chain-of-custody.md, versioning.md    HUMAN GATE ✋
                                   — +11 lines, zero new files"

 6    builder   feat(genesis)     "feat(genesis): rewrite Blueprint —     After Step 5
                                   Part 3 Operating Model (new),          HUMAN GATE ✋
                                   Part 5 VANA+ACs, remove Part 7"

 7    builder   docs(genesis)     "docs(genesis): update README,          After Step 6
                                   VERSION_REGISTRY, MIGRATION_GUIDE,
                                   MEMORY.md"
```

---

## Step 1 — Move Blueprint to _genesis/

**Type:** chore(genesis) | **Risk:** LOW

**Actions:**
1. Read full content of `/Users/longnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/1-ALIGN/charter/BLUEPRINT.md` (source — untracked in main repo)
2. Write content to worktree `_genesis/BLUEPRINT.md` (version: "1.0", status: Draft, last_updated: 2026-04-03)
3. Write redirect stub to worktree `1-ALIGN/charter/BLUEPRINT.md`:
   ```markdown
   <!-- MOVED 2026-04-03 — Blueprint relocated to _genesis/BLUEPRINT.md (bedrock, not iteration-scoped). -->
   ```
4. Update references:
   - `CLAUDE.md` line with `1-ALIGN/charter/` Blueprint reference → `_genesis/BLUEPRINT.md`
   - `_genesis/DESIGN-genesis-blueprint-cleanup.md` Section D1 — no change needed (already documents the decision)
   - `.claude/rules/alpei-pre-flight.md` step 2 if it references `1-ALIGN/charter/BLUEPRINT`
5. `git add` both files, commit

**Verify:** `grep -r "1-ALIGN/charter/BLUEPRINT" . --include="*.md"` → only redirect stub matches

---

## Step 2 — Archive ALL_CAPS Framework Duplicates

**Type:** cleanup(genesis) | **Risk:** LOW

**Actions:**
1. Create `_genesis/frameworks/archive/` directory
2. Write archive header to each file being archived (prepend):
   ```
   <!-- ARCHIVED 2026-04-03 — Superseded by {canonical}. Do not load. -->
   ```
3. `git mv` each file to archive/:
   - `THREE_PILLARS.md` → `archive/THREE_PILLARS.md`
   - `SIX_WORKSTREAMS.md` → `archive/SIX_WORKSTREAMS.md`
   - `EFFECTIVE_SYSTEM.md` → `archive/EFFECTIVE_SYSTEM.md`
   - `COGNITIVE_BIASES.md` → `archive/COGNITIVE_BIASES.md`
   - `CRITICAL_THINKING.md` → `archive/CRITICAL_THINKING.md`
   - `UBS_UDS_GUIDE.md` → `archive/UBS_UDS_GUIDE.md`
4. **Delete** `ues-version-behaviors.md` (exact duplicate — `git rm`)
5. Commit

**Verify:** `ls _genesis/frameworks/` shows no ALL_CAPS files except the 9 to-be-renamed in Step 4

---

## Step 3 — Archive Deprecated SOP

**Type:** cleanup(genesis) | **Risk:** LOW

**Actions:**
1. Create `_genesis/sops/archive/` directory
2. `git mv _genesis/sops/ALPEI_OPERATING_PROCEDURE.md _genesis/sops/archive/ALPEI_OPERATING_PROCEDURE.md`
3. Commit

**Keep:** `_genesis/security/NAMING_CONVENTION.md` — NOT archived (human-readable prose, different audience)

---

## Step 4 — Kebab-Case Rename (Content-Free)

**Type:** refactor(genesis) | **Risk:** MED | **Gate: HUMAN APPROVAL REQUIRED**

**Actions (git mv only — ZERO content edits in this commit):**

| `git mv` FROM | `git mv` TO |
|---------------|-------------|
| `AGENT_SYSTEM.md` | `agent-system.md` |
| `AGENT_DIAGNOSTIC.md` | `agent-diagnostic.md` |
| `LEARNING_HIERARCHY.md` | `learning-hierarchy.md` |
| `HISTORY_VERSION_CONTROL.md` | `history-version-control.md` |
| `ALPEI_DSBV_PROCESS_MAP.md` | `alpei-dsbv-process-map.md` |
| `ALPEI_DSBV_PROCESS_MAP_P1.md` | `alpei-dsbv-process-map-p1.md` |
| `ALPEI_DSBV_PROCESS_MAP_P2.md` | `alpei-dsbv-process-map-p2.md` |
| `ALPEI_DSBV_PROCESS_MAP_P3.md` | `alpei-dsbv-process-map-p3.md` |
| `ALPEI_DSBV_PROCESS_MAP_P4.md` | `alpei-dsbv-process-map-p4.md` |

**Reference updates (SEPARATE content commit after rename commit):**

Update ALL occurrences of old names in:
- `.claude/rules/alpei-chain-of-custody.md` (lines 16, 29)
- `.claude/rules/alpei-pre-flight.md` (line 22)
- `.claude/rules/versioning.md` (line 8 — `HISTORY_VERSION_CONTROL.md`)
- `.claude/rules/agent-system.md` (line 5 — `AGENT_SYSTEM.md` ref)
- `.claude/rules/agent-diagnostic.md` (line 1 — `AGENT_DIAGNOSTIC.md` ref)
- `CLAUDE.md` (line referencing `HISTORY_VERSION_CONTROL.md`)
- `.claude/skills/dsbv/SKILL.md` (lines 91, 132, 180)
- `.claude/skills/dsbv/references/context-packaging.md` (line 48)
- `3-PLAN/architecture/ARCHITECTURE.md` (lines 12, 57)
- `_genesis/version-registry.md` (line 51)
- `_genesis/tools/alpei-navigator.html` (lines 276, 385, 392-396)
- `_genesis/templates/README.md` (lines 53, 63)
- `_genesis/templates/architecture-template.md` (line 44)
- `_genesis/templates/research-template.md` (line 8)
- `_genesis/principles/README.md` (line 22)
- `_genesis/frameworks/README.md` (multiple)
- `_genesis/sops/archive/ALPEI_OPERATING_PROCEDURE.md` (line 22 — update even in archive)

**Verify:** `grep -r "ALPEI_DSBV_PROCESS_MAP\|AGENT_SYSTEM\|AGENT_DIAGNOSTIC\|LEARNING_HIERARCHY\|HISTORY_VERSION_CONTROL" . --include='*.md' --include='*.html' | grep -v "archive/"` → ZERO hits

---

## Step 5 — Enhance 3 Existing Rules (+11 Lines)

**Type:** chore(rules) | **Risk:** LOW | **Gate: HUMAN APPROVAL REQUIRED**

**Actions:**

**dsbv.md** — append VANA gate section (after existing content):
```markdown
## VANA Gate (Validate Phase)

At Validate phase, verify deliverable against VANA criteria table for current UES version.
No VANA criteria met = not done. Reference: `_genesis/frameworks/ltc-ues-versioning.md`
Fix APEI→ALPEI typo on line 9.
```

**alpei-chain-of-custody.md** — add sub-system sequence section:
```markdown
## Sub-System Sequence

PD → DP → DA → IDM. Downstream sub-system cannot exceed upstream version.
PD Effective Principles govern all downstream sub-systems.
Violation: same STOP protocol as workstream violations — state the violation,
name the missing upstream artifact, wait for human override.
```

**versioning.md** — add version awareness section:
```markdown
## Version Awareness

Before producing any deliverable, verify current iteration. I1 = Concept (correct + safe only).
I2 = Prototype (+ efficient). Do not produce artifacts beyond current iteration scope.
Reference: `_genesis/frameworks/ltc-ues-version-behaviors.md` 25-cell matrix.
```

**Version bumps:** Each rule file's `version` and `last_updated` bump per versioning.md convention.

---

## Step 6 — Rewrite Blueprint

**Type:** feat(genesis) | **Risk:** MED | **Gate: HUMAN APPROVAL REQUIRED**

**Source:** Existing `_genesis/BLUEPRINT.md` (placed in Step 1)

**Actions (see DESIGN D4 for full spec):**
- **PART 1** (Philosophy): Keep + ADD reference to `ltc-company-handbook.md` + `ltc-10-ultimate-truths.md`
- **PART 2** (Principles): Keep P1-P8 + ADD EP registry reference
- **PART 3** (Operating Model): **NEW** — PM role (LEARN > INPUT > REVIEW > APPROVE), RACI, tool split (Obsidian/Cursor)
- **PART 4** (Framework Overview): Keep, renumber from old Part 4
- **PART 5** (Roadmap): **REWRITE** — VANA statement + ≤8 user-centric ACs per iteration (target ≤80 lines)
- **PART 6** (UBS/UDS): Keep + add reference to `ltc-ubs-uds-framework.md`
- **PART 7** (Decisions): **REMOVE** (all decided, no longer contested)
- Fix `APEI` → `ALPEI` in CLAUDE.md (line 17) in same commit
- Bump version to "2.0" (this is I2 iteration work, complete rewrite)

---

## Step 7 — Bookkeeping

**Type:** docs(genesis) | **Risk:** LOW

**Actions:**
1. `_genesis/README.md` — update file index (Blueprint now in root, frameworks count = 18)
2. `_genesis/frameworks/README.md` — update inventory to reflect 18 canonical kebab-case files + archive/
3. `_genesis/guides/MIGRATION_GUIDE.md` — add "v2.0 Changes" section with rename table (all 9 renames)
4. `_genesis/version-registry.md` — update rows for all modified files
5. Memory Vault `MEMORY.md` Briefing Card — update Current state date to 2026-04-03, state = "Build complete"

---

## Dependency Graph

```
Step 1 ──→ Step 2 ──→ Step 3 ──→ Step 4 ──→ Step 5 ──→ Step 6 ──→ Step 7
  │                                   ✋              ✋              ✋
  └── Must complete before             Human gates at Steps 4, 5, 6
      any content changes
```

---

## Validation Handoff

After Step 7, dispatch `ltc-reviewer` with:
- DESIGN: `_genesis/DESIGN-genesis-blueprint-cleanup.md`
- ACs: AC-1 through AC-16
- Output: `_genesis/VALIDATE-genesis-blueprint-cleanup.md`
