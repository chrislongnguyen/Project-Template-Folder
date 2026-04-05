---
version: "2.0"
status: Approved
last_updated: 2026-04-05
owner: Long Nguyen
workstream: GOVERN
iteration: I2
type: ues-deliverable
work_stream: 0-govern
stage: sequence
---
# SEQUENCE.md — GOVERN: Personal Knowledge Base (PKB)

> DSBV Phase 2 artifact. Approved DESIGN.md (v2.0) is the input.

## Pre-Existing State

Premature build during brainstorming created partial artifacts on disk:
- `PERSONAL-KNOWLEDGE-BASE/{captured,distilled,expressed}/` — dirs exist (AC-05 satisfied)
- `.gitignore` — PKB entry exists (AC-08 satisfied)
- `PERSONAL-KNOWLEDGE-BASE/README.md` — draft exists but must be **rebuilt** from DESIGN spec (does not satisfy AC-01 through AC-04 yet)

These are noted in the sequence. Tasks verify or rebuild as needed.

## Dependency Graph

```
T1 (verify scaffold) ──→ T2 (_index.md) ──→ T4 (README.md)     ──→ T11 (verify all)
                     ──→ T3 (_log.md)   ──→ T5 (/ingest SKILL.md)
                                         ──→ T6 (hook script)
                                                 ──→ T7 (settings.json)
                                         ──→ T8 (dashboard)
                                         ──→ T9 (canvas)
                     T5 ──→ T10 (spaced rep frontmatter update)
```

```
T1 → {T2, T3} → {T4, T5, T6, T8, T9} → {T7, T10} → T11
      parallel     parallel                parallel    verify
```

T1 first: scaffold must exist.
T2 + T3 next (parallel): _index.md and _log.md establish patterns.
T4 + T5 + T6 + T8 + T9 parallel: all depend only on T1-T3.
T7 after T6 (wires script). T10 after T5 (adds review fields to /ingest frontmatter spec).
T11 last: verify all 23 ACs.

## Task Sequence

| # | Task | Artifact | Depends On | Size | ACs |
|---|------|----------|-----------|------|-----|
| T1 | Verify existing scaffold + gitignore | `PERSONAL-KNOWLEDGE-BASE/`, `.gitignore` | None | XS (~5 min) | AC-05, AC-08 |
| T2 | Write _index.md — LLM-maintained catalog stub | `PERSONAL-KNOWLEDGE-BASE/distilled/_index.md` | T1 | S (~10 min) | AC-06 |
| T3 | Write _log.md — append-only ingest history stub | `PERSONAL-KNOWLEDGE-BASE/distilled/_log.md` | T1 | S (~10 min) | AC-07 |
| T4 | Rebuild README.md from DESIGN spec (incl. plugin install checklist) | `PERSONAL-KNOWLEDGE-BASE/README.md` | T2, T3 | M (~30 min) | AC-01, AC-02, AC-03, AC-04, AC-23 |
| T5 | Write /ingest SKILL.md — schema + process + triggers | `.claude/skills/pkb/ingest/SKILL.md` | T2, T3 | M (~30 min) | AC-09, AC-10, AC-11, AC-12, AC-13, AC-14 |
| T6 | Write pkb-ingest-reminder.sh — staleness checker | `scripts/pkb-ingest-reminder.sh` | T2, T3 | S (~15 min) | AC-15, AC-16, AC-17 |
| T7 | Wire hook into settings.json | `.claude/settings.json` | T6 | XS (~5 min) | AC-18 |
| T8 | Write Dataview learning dashboard | `PERSONAL-KNOWLEDGE-BASE/dashboard.md` | T2, T3 | S (~20 min) | AC-19, AC-20 |
| T9 | Write starter Canvas knowledge map | `PERSONAL-KNOWLEDGE-BASE/knowledge-map.canvas` | T1 | S (~15 min) | AC-21 |
| T10 | Add spaced repetition fields to /ingest frontmatter spec | `.claude/skills/pkb/ingest/SKILL.md` (update) | T5 | XS (~5 min) | AC-22 |
| T11 | Verify all 23 ACs | — | All | XS (~10 min) | All |

**Sizes:** XS = <10 min | S = <30 min | M = <60 min

---

## Task Detail

### T1 — Verify Existing Scaffold + Gitignore

**Input:** DESIGN §D1, existing disk state from premature build.

**What to verify:**
- `PERSONAL-KNOWLEDGE-BASE/captured/` exists
- `PERSONAL-KNOWLEDGE-BASE/distilled/` exists
- `PERSONAL-KNOWLEDGE-BASE/expressed/` exists
- `.gitignore` contains `PERSONAL-KNOWLEDGE-BASE/` line
- `git status` shows no PKB files tracked

**If any missing:** create/fix. If all present: mark AC-05 and AC-08 as PASS.

---

### T2 — Write _index.md

**Input:** DESIGN §D1 A3, §Artifact conventions (extended frontmatter spec).

**What to build:**

```markdown
---
version: "2.0"
status: Draft
last_updated: 2026-04-05
---
# Knowledge Index

> LLM-maintained catalog. Updated by /ingest after every ingest pass.
> Navigate this file before answering any PKB query.

## Pages

(empty — populated by /ingest)

## Topics

(empty — sub-dirs created by /ingest as domains emerge)
```

**AC:** AC-06 — file exists, YAML frontmatter valid, empty catalog section present.

---

### T3 — Write _log.md

**Input:** DESIGN §D1 A4.

**What to build:**

```markdown
---
version: "2.0"
status: Draft
last_updated: 2026-04-05
---
# Ingest Log

> Append-only. Each entry records one /ingest run. Never edit or delete entries.

## Format

| Date | Source | Pages Created | Pages Updated |
|------|--------|--------------|---------------|

## Log

(empty — populated by /ingest)
```

**AC:** AC-07 — file exists, YAML frontmatter valid, empty log with documented format.

---

### T4 — Rebuild README.md

**Input:** DESIGN §D1 A1, §Design Decisions (full content), `_genesis/frameworks/learning-hierarchy.md`.

**What to build:** Overwrite the premature draft with a version that satisfies all 4 ACs:
- AC-01: 7 sections (WHAT / WHAT NOT / Components / How it works / Setup / Why / Now what)
- AC-02: Explicit reference to learning-hierarchy.md with L1–L4 questions listed
- AC-03: Both ingest triggers documented (manual `/ingest` + post-session hook)
- AC-04: Obsidian plugin table with purpose per plugin (Canvas, Dataview, Learnie, PDF++, callouts)
- AC-23: §Setup includes step-by-step plugin install instructions + minimum config per plugin

**Note:** The premature README draft can be used as raw material but must be rebuilt to match DESIGN spec, including `questions_answered` frontmatter spec, level derivation rules, and plugin setup guide.

---

### T5 — Write /ingest SKILL.md

**Input:** DESIGN §D2 A6, §Artifact conventions (extended frontmatter + questions_answered), §Ingest depth table, `_genesis/frameworks/learning-hierarchy.md`.

**What to build:** Skill stub at `.claude/skills/pkb/ingest/SKILL.md`:
- AC-09: Trigger: `/ingest` or "ingest knowledge" or "process captured"
- AC-10: Schema section: entity-page vs synthesis-page decision criteria
- AC-11: 5-step pipeline: read source → check _index.md → write/update distilled/ pages → append _log.md → update _index.md
- AC-12: L1–L4 depth targets with all 12 questions from learning-hierarchy.md
- AC-13: Both triggers documented (manual + hook)
- AC-14: Extended frontmatter spec (version, status, last_updated, topic, source, questions_answered) + Obsidian `[[links]]` requirement

**This is a STUB.** It defines the schema and process. Full ingest implementation (actual LLM reading + writing logic) is scoped to I3.

---

### T6 — Write pkb-ingest-reminder.sh

**Input:** DESIGN §D3 A7, T3 output (_log.md format).

**What to build:**

```bash
#!/usr/bin/env bash
# pkb-ingest-reminder.sh — check for uningested files in captured/
# version: 2.0 | status: Draft | last_updated: 2026-04-05

# Find PKB captured/ dir (relative to repo root)
CAPTURED="PERSONAL-KNOWLEDGE-BASE/captured"
LOG="PERSONAL-KNOWLEDGE-BASE/distilled/_log.md"

# Compare files in captured/ against entries in _log.md
# Print reminder if uningested files found
# Always exit 0 (reminder, not blocker)
```

- AC-15: Compares captured/ files against _log.md entries
- AC-16: Prints reminder only when uningested files exist
- AC-17: Exits 0 always

---

### T7 — Wire Hook into settings.json

**Input:** DESIGN §D3 A8, T6 output (script path confirmed).

**What to do:** Add `scripts/pkb-ingest-reminder.sh` to the appropriate hook event in `.claude/settings.json`.

- AC-18: Hook event wired to run pkb-ingest-reminder.sh

---

### T8 — Write Dataview Learning Dashboard

**Input:** DESIGN §D4 A9, T2 output (_index.md format), T3 output (_log.md format), §Artifact conventions (questions_answered frontmatter).

**What to build:** Markdown file at `PERSONAL-KNOWLEDGE-BASE/dashboard.md` with Dataview query blocks:

1. **Level distribution** — count pages by derived learning level (L1/L2/L3/L4) based on `questions_answered` list length
2. **Uningested files** — list files in `captured/` not found in `_log.md` (staleness monitor from UBS-2)
3. **Recent ingests** — last 10 entries from `_log.md` sorted by date
4. **Topic counts** — pages grouped by `topic` frontmatter field

- AC-19: ≥4 Dataview query blocks present
- AC-20: Queries reference `questions_answered` frontmatter and _log.md format

---

### T9 — Write Starter Canvas Knowledge Map

**Input:** DESIGN §D4 A10.

**What to build:** Valid Obsidian `.canvas` JSON file at `PERSONAL-KNOWLEDGE-BASE/knowledge-map.canvas`:
- 3 nodes representing captured/ → distilled/ → expressed/ flow
- Empty group nodes for future topic clusters
- Edges showing pipeline direction

- AC-21: Valid .canvas JSON, placeholder nodes, pipeline flow edges

---

### T10 — Add Spaced Repetition Fields to /ingest Frontmatter Spec

**Input:** DESIGN §D4 A11, T5 output (SKILL.md).

**What to update:** In `.claude/skills/pkb/ingest/SKILL.md`, add to the extended frontmatter template:

```yaml
review: true          # Learnie picks up pages with review: true
review_interval: 7    # days between review surfacing
```

- AC-22: Both fields present in frontmatter spec, documented as Learnie-compatible

---

### T11 — Verify All 23 ACs

**Input:** All artifacts from T1–T10.

**What to do:** Run through AC-01 to AC-23, verify each is PASS. Report any failures.

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | Single-agent sequential with parallel batches: T1 → {T2,T3} → {T4,T5,T6,T8,T9} → {T7,T10} → T11 |
| Agent config | Main context — small artifacts, DESIGN is the spec |
| Git strategy | 1 commit: `feat(govern): PERSONAL-KNOWLEDGE-BASE scaffold + /ingest skill + Obsidian UX + hook` |
| Human gates | G2=this SEQUENCE. G3=review before commit. G4=validate 23 ACs. |
| Cost estimate | ~30K tokens total |

---

[[SEQUENCE]]
[[DESIGN]]
[[pkb]]
[[ingest]]
[[govern]]
[[obsidian]]
[[dataview]]
[[canvas]]
