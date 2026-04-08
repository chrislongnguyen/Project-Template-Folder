---
version: "1.0"
status: draft
last_updated: 2026-04-08
owner: Long Nguyen
work_stream: 0-GOVERN
stage: design
type: dsbv-design
iteration: 2
---
# DESIGN — Obsidian Bases Filter + Deterministic Frontmatter Injection

> DSBV Phase 1 artifact. Resolves GitHub Issue #17.
> This document is the contract. If it is not here, it is not in scope.

---

## Scope Check

| Question | Answer |
|----------|--------|
| Q1: Upstream outputs sufficient? | YES — 3 ltc-explorer reports + 1 ltc-reviewer verdict (APPROVE WITH CONDITIONS) |
| Q2: In scope? | (1) Replace C1-C7 filter from `type` to `work_stream`. (2) Build PostToolUse hook for deterministic frontmatter injection. (3) Fix frontmatter-schema.md casing contradiction. |
| Q2b: Out of scope? | C6 version_order formula bug (separate issue). LEARN pipeline_state field (future iteration). Chain-of-custody dashboard formulas (separate enhancement). |
| Q3: Go/No-Go | **GO** |

---

## Problem Statement

All 7 C-bases (C1-C7) filter on `type == "ues-deliverable"`. Agent-generated artifacts use semantic types (`dsbv-design`, `charter`, `okr`, etc.) and are invisible to every dashboard. The frontmatter schema defines 8 required fields, but the agent path has zero auto-injection — agents manually fill placeholders, subject to LT-3 (reasoning degradation on 8+ fields) and LT-8 (alignment drift under pressure).

Result: dashboards show only Obsidian Templater-created files. All agent work is invisible. This is a silent failure — no error, no warning.

---

## Force Analysis — 7-CS × S × E × Sc

### EA → EO

**EA:** Fix C1-C7 Bases filters + auto-inject frontmatter on every file write.
**EO:** Every PM-trackable artifact is visible in correct dashboards, always. Zero human or agent frontmatter errors.

### UBS (Blocking Forces)

| # | Force | Category | Mechanism | Severity | Mitigation in Design |
|---|-------|----------|-----------|----------|---------------------|
| UBS-1 | Agent forgets frontmatter fields | Technical (LT-3) | 8 fields × 0.9 per-field = 43% all correct | HIGH | Part 2: PostToolUse hook auto-injects from filepath |
| UBS-2 | Agent drifts on field values | Technical (LT-8) | Uses wrong type, wrong casing, wrong stage | HIGH | Part 2: hook derives values deterministically |
| UBS-3 | Casing mismatch (SCREAMING vs lowercase) | Technical | Bases filters are case-sensitive; mismatch = zero matches | CRITICAL | Part 1: all C-bases use SCREAMING to match actual frontmatter |
| UBS-4 | LEARN S1-S2 files lack work_stream | Technical | Minimal frontmatter on early pipeline files | MEDIUM | Part 2: hook injects work_stream from parent dir for all [1-5]-* files |
| UBS-5 | New artifact types invisible | Temporal (Sc) | Every new type needs manual filter update | HIGH | Part 1: filter on work_stream (closed set), not type (open set) |
| UBS-6 | Human forgets frontmatter in Obsidian | Human | Templater handles it, but what if user skips template? | LOW | Part 2: pre-commit hook catches missing fields (already exists) |
| UBS-7 | Hook latency on every Write/Edit | Economic (E) | Shell script fires on every file write | LOW | Path guard: hook is no-op for files outside [1-5]-*/ |

### UDS (Driving Forces)

| # | Force | Category | Mechanism |
|---|-------|----------|-----------|
| UDS-1 | File path is fully deterministic | Technical | work_stream, sub_system, stage, type all derivable from path |
| UDS-2 | work_stream is a closed set | Technical | 5 ALPEI values, definitional, never changes |
| UDS-3 | Obsidian Templater already complete | Economic | Human path needs zero changes |
| UDS-4 | Pre-commit validation exists | Technical | Safety net already in place (validate-frontmatter.sh) |
| UDS-5 | W1-W5 folder-based filters work | Technical | Workstream dashboards are never broken — C-bases are the only gap |

### S × E × Sc Matrix

```
              SUSTAINABILITY              EFFICIENCY                SCALABILITY
              (reliable, never fails)     (fast, low friction)      (1000+ files, I0-I4)
─────────     ────────────────────────    ──────────────────────    ──────────────────────
HUMAN PM      Filter uses closed set      Zero new fields           No per-type maintenance
              (5 values, never changes)   Zero new workflow         Add files, not filter rules
              Hook catches agent errors   Obsidian path unchanged   Works identically at I4
              Pre-commit is safety net

AI AGENT      Hook auto-injects 8 fields  ~40 tokens saved/file     Hook is O(1) per file
              Agent CANNOT create          Agent focuses on content  Same logic at 10 or 10K files
              invisible artifact           not metadata
              LT-3/LT-8 compensated
              by EOE, not by Agent
```

### 7-CS Component Mapping

```
EP    versioning.md + frontmatter-schema.md define the 8 fields (RULES)
      → FIX NEEDED: schema.md casing contradiction (GAP-3)

EOP   /dsbv skill routes to correct template (PROCEDURES)
      → NO CHANGE: skill works as-is, hook handles frontmatter

EOE   PostToolUse hook auto-injects frontmatter (ENVIRONMENT)
      → THIS IS THE PRIMARY FIX: moves responsibility from Agent to Environment

EOT   validate-frontmatter.sh catches remaining gaps (TOOLS)
      → NO CHANGE: safety net already exists

Agent FREED from frontmatter responsibility (MODEL)
      → Agent produces content; environment produces metadata

EA    Every file has correct frontmatter, always (OBSERVABLE)
      → Dashboards are complete and accurate

EO    PM can track all work via Obsidian Bases (OUTCOME)
```

---

## Design Decisions

**Intent:** Make Obsidian Bases C1-C7 dashboards reliably show every PM-trackable artifact, regardless of whether it was created by human (Templater) or agent (/dsbv). Eliminate frontmatter as a source of dashboard failure.

**Key constraints:**
- Zero changes to human Obsidian workflow (Templater templates stay as-is)
- Zero new frontmatter fields (no `trackable: true`, no `artifact_kind`)
- Deterministic — hook logic has zero conditional branches that require agent judgment
- LEARN pipeline artifacts included without pretending LEARN uses DSBV

---

## Artifact Inventory

| # | Artifact | Path | Purpose (WHY) | Acceptance Conditions |
|---|----------|------|---------------|-----------------------|
| A1 | C1-C7 base files (7 files) | `_genesis/obsidian/bases/C*.base` | Fix filter + casing | AC-01: filter uses `work_stream` OR-clause with SCREAMING values |
| | | | | AC-02: option blocks use SCREAMING values (`1-ALIGN` not `1-align`) |
| | | | | AC-03: `type == "ues-deliverable"` removed from all 7 files |
| A2 | PostToolUse hook script | `.claude/hooks/inject-frontmatter.sh` | Auto-inject frontmatter from filepath | AC-04: fires on Write/Edit for `[1-5]-*/**/*.md` only |
| | | | | AC-05: derives work_stream from parent workstream dir |
| | | | | AC-06: derives sub_system from subsystem dir (1-PD, 2-DP, etc.) |
| | | | | AC-07: derives stage from filename (DESIGN→design, SEQUENCE→sequence, VALIDATE→validate) |
| | | | | AC-08: derives stage: build for non-phase files in workstream dirs |
| | | | | AC-09: derives type from filename for phase files (DESIGN.md→dsbv-design) |
| | | | | AC-10: sets last_updated to today on every edit |
| | | | | AC-11: sets version to "1.0" and status to "draft" ONLY on new files (no frontmatter block) |
| | | | | AC-12: NEVER overwrites existing frontmatter values |
| | | | | AC-13: is a complete no-op for files outside `[1-5]-*/` |
| A3 | Hook registration | `.claude/settings.json` | Wire hook into PostToolUse | AC-14: PostToolUse entry for Write and Edit tools |
| A4 | frontmatter-schema.md fix | `_genesis/reference/frontmatter-schema.md` | Fix casing contradiction | AC-15: work_stream valid values show `1-ALIGN \| 2-LEARN \| 3-PLAN \| 4-EXECUTE \| 5-IMPROVE` |
| A5 | GitHub Issue #17 comment | github.com | Document decision + rationale | AC-16: comment posted with design summary and link to this DESIGN.md |

**Alignment check:**
- [x] Orphan conditions = 0 (every AC maps to an artifact)
- [x] Orphan artifacts = 0 (every artifact has at least one AC)
- [x] Artifact count = 5

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | Pattern 1: Single Agent Sequential |
| Why this pattern | 5 artifacts, all small edits, sequential dependencies (hook must exist before testing) |
| Why NOT simpler | Cannot be simpler — this IS the simplest pattern |
| Agent config | 1 agent (orchestrator), Opus, direct execution |
| Git strategy | Single branch, atomic commit per artifact group |
| Human gates | G1 only (approve this DESIGN.md) — Build is mechanical |
| Cost estimate | ~20K tokens build + ~5K tokens validate |

---

## Dependencies

| Dependency | From | Status |
|------------|------|--------|
| Explorer reports (3) | ltc-explorer agents | Ready (completed) |
| Reviewer verdict | ltc-reviewer agent | Ready (APPROVE WITH CONDITIONS) |
| GAP-1 resolution | This design | Resolved: SCREAMING casing confirmed |
| Bases case-sensitivity | Obsidian Bases behavior | Assumed case-sensitive per schema doc; design uses exact match |

---

## Human Gates

| Gate | Trigger | Decision Required |
|------|---------|-------------------|
| G1 | This DESIGN.md complete | Approve scope, ACs, and approach |
| G2 | Build complete | Verify C-bases show agent artifacts; verify hook injects correctly |

---

## Readiness Conditions

| ID | Condition | Status |
|----|-----------|--------|
| C1 | Clear scope — in/out written down | GREEN |
| C2 | Input materials curated — 3 explorer reports + reviewer verdict | GREEN |
| C3 | Success rubric defined — 16 ACs above | GREEN |
| C4 | Process definition loaded — DSBV template used | GREEN |
| C5 | Prompt engineered — context fits effective window | GREEN |
| C6 | Evaluation protocol — verify dashboards show agent artifacts | GREEN |

**All conditions GREEN. Ready for G1.**

---

## PostToolUse Hook — Derivation Logic

```
INPUT:  file path (e.g., 3-PLAN/2-DP/dp-architecture.md)
OUTPUT: frontmatter fields injected/merged

STEP 1: Path guard
  path NOT match [1-5]-*/**/*.md → EXIT (no-op)

STEP 2: Parse path components
  workstream_dir = first path segment    → "3-PLAN"
  subsystem_dir  = second path segment   → "2-DP" (or empty if root)
  filename       = basename              → "dp-architecture.md"

STEP 3: Derive fields
  work_stream  = workstream_dir          → "3-PLAN"
  sub_system   = subsystem_dir           → "2-DP" (skip if _cross or empty)
  iteration    = read from ./VERSION     → 2

  IF filename == "DESIGN.md":
    stage = "design",  type = "dsbv-design"
  ELIF filename == "SEQUENCE.md":
    stage = "sequence", type = "dsbv-sequence"
  ELIF filename == "VALIDATE.md":
    stage = "validate", type = "dsbv-validate"
  ELSE:
    stage = "build"    (all non-phase deliverables are Build outputs)
    type  = (do NOT inject — preserve agent's semantic type)

  last_updated = today (ALWAYS set)
  version      = "1.0" (ONLY if file has no frontmatter block)
  status       = "draft" (ONLY if file has no frontmatter block)

STEP 4: Merge
  For each field:
    IF field exists in frontmatter AND has a value → KEEP existing
    IF field missing or empty → INJECT derived value
```

**Key design choice (AC-08):** The hook injects `stage: build` for all non-phase files in workstream dirs. Build deliverables (charter, okr, architecture, etc.) are outputs of the Build phase — `stage: build` is correct and enables C2 (stage-board) grouping. Only DESIGN.md/SEQUENCE.md/VALIDATE.md get their specific stage values; everything else defaults to `build`.

---

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[UBS-1]]
- [[UBS-2]]
- [[UBS-3]]
- [[UBS-4]]
- [[UBS-5]]
- [[UBS-6]]
- [[UBS-7]]
- [[UDS-1]]
- [[UDS-2]]
- [[UDS-3]]
- [[UDS-4]]
- [[UDS-5]]
- [[VALIDATE]]
- [[architecture]]
- [[charter]]
- [[dashboard]]
- [[dp-architecture]]
- [[friction]]
- [[frontmatter-schema]]
- [[iteration]]
- [[ltc-explorer]]
- [[ltc-reviewer]]
- [[okr]]
- [[schema]]
- [[ues-deliverable]]
- [[versioning]]
- [[workstream]]
