---
name: learn-structure
description: >
  Structures deep-research output into 6 UEDS pages (P0-P5)
  per topic. One topic per invocation. Use after /learn:research completes.
argument-hint: <system-slug> <topic-number>
context: fork
model: opus
allowed-tools: Read, Glob, Write, Bash
---

# /learn:structure — UEDS Page Generator

You are generating 6 UEDS pages (P0-P5) for **one topic** of a learning book.
One topic per invocation. Do not process multiple topics.

## Arguments

Parse the user's invocation for two arguments:
- `{system-slug}` — e.g., `data-foundation` (kebab-case system name)
- `{topic-number}` — e.g., `0` for T0 Overview

If arguments are missing, check for a single `1-ALIGN/learning/input/learn-input-*.md` file. If exactly one exists, use it. Otherwise, list available learn-input files and ask.

---

## Injected Context

### Learn Input Metadata
!`cat 1-ALIGN/learning/input/learn-input-*.md 2>/dev/null | head -120`

### Constraints (CAG Rules)
!`cat 1-ALIGN/learning/config/constraints.yaml 2>/dev/null`

# Note: Phase C structuring rules are embedded in references/structuring-procedure.md

---

## Pre-Checks (before generating anything)

1. Verify `1-ALIGN/learning/input/learn-input-{system-slug}.md` exists. If not, error: "Run /learn:input first."
2. Verify `1-ALIGN/learning/research/{system-slug}/T{topic-number}-*.md` exists. If not, error: "Run /learn:research first."
3. Verify `1-ALIGN/learning/templates/page-0-overview-and-summary.md` exists (check one template as proxy for all 6).
4. Create `1-ALIGN/learning/output/{system-slug}/` directory if it doesn't exist.
5. Extract from learn-input file:
   - `system_name` (human-readable name)
   - `eo` (Effective Outcome)
   - `user_persona_r` (R actor description)
   - `user_persona_a` (A actor description)
   - `input_contract` and `output_contract` fields
   - `topic_depth` (T0 / T0-T2 / T0-T5)

---

## Generation Procedure (8 Steps)

Follow the detailed procedure in [structuring-procedure.md](./references/structuring-procedure.md).

**Summary of steps:**

### Step 1: Load Research
Read the research output:
```
1-ALIGN/learning/research/{system-slug}/T{topic-number}-*.md
```
Extract the research sections that map to P0-P5. Note the YAML frontmatter (EO, RACI, domains).

### Step 2: Generate P0 (Overview & Summary)
- Read template: `1-ALIGN/learning/templates/page-0-overview-and-summary.md`
- Extract `subject_abbreviation` from learn-input (e.g., `DF` for "Data Foundation")
- For T0: Generate 2 rows:
  - Row label: `**Effective {Full Subject Name}(R)**` (bold, full name in label column)
  - CAG prefix in cells: `Eff.{ABBREV}(R).` — e.g., `Eff.DF(R).REL:`, `Eff.DF(R).UD:`
  - Repeat for `(A)` row
- For T1+: COPY from parent topic's corresponding page (do not regenerate)
- Fill all 16 columns per row from research output
- Write to `1-ALIGN/learning/output/{system-slug}/T{n}.P0-overview-and-summary.md`
- Validate: 2 rows, 17 columns (row label + 16 content), all CAG tags present

### Step 3: Generate P1 (Ultimate Blockers)
- Read template: `1-ALIGN/learning/templates/page-1-ultimate-blockers.md`
- T0: 2 rows — `UBS(R)` seeded from P0 row R col 10, `UBS(A)` seeded from P0 row A col 10
- T1+: Up to 6 rows (3-row causal chain per role: `.UB`, `.UB.UB`, `.UB.UD`)
- **Direction rule:** On UBS rows, `.UD.EP` uses P_F notation (bad for role), `.UB.EP` uses P notation (good for role)
- Write and validate

### Step 4: Generate P2 (Ultimate Drivers)
- Read template: `1-ALIGN/learning/templates/page-2-ultimate-drivers.md`
- T0: 2 rows — `UDS(R)` seeded from P0 row R col 4, `UDS(A)` seeded from P0 row A col 4
- T1+: Up to 6 rows (3-row causal chain per role: `.UD`, `.UD.UB`, `.UD.UD`)
- **Direction rule:** On UDS rows, `.UD.EP` uses P notation (good for role), `.UB.EP` uses P_F notation (bad for role)
- Write and validate

### --- CHECKPOINT ---
**Re-read the P0, P1, P2 files you just wrote.** Extract:
- All principles from P0/P1/P2 column 6 (UD.EP) and column 12 (UB.EP)
- All tools from column 7 (UD.EOT) and column 13 (UB.EOT)
- All steps from column 3 (ACT) and column 9 (FAIL)
These become the seeds for P3, P4, P5.

### Step 5: Generate P3 (Principles)
- Read template: `1-ALIGN/learning/templates/page-3-principles.md`
- Harvest principles from P0+P1+P2 col 6 and col 12 (do NOT invent new principles)
- Each row: `P[n](pillar)(role)` for enabling principles, `P_F[n](pillar)(role)` for failure principles
- Pillar assignment: S=Sustainability (prevents failure), E=Efficiency (reduces waste), Sc=Scalability (enables growth)
- 4-8 rows typical
- Write and validate

### Step 6: Generate P4 (Components)
- Read template: `1-ALIGN/learning/templates/page-4-components.md`
- 3-layer structure: Foundational → Operational → Enabling
- Row codes: `INFRA.n(role)`, `WORKSPACE.n(role)`, `INTEL.n(role)`
- Derived from P3 principles (what tools/systems enable them)
- 4-8 rows typical
- Write and validate

### Step 7: Generate P5 (Steps to Apply)
- Read template: `1-ALIGN/learning/templates/page-5-steps-to-apply.md`
- Sequential operational steps: DERISK phase first, then OPTIMIZE phase
- Row codes: `STEP.n(role)` — sequential numbering
- References P1-P4 elements explicitly in each step
- 4-6 rows typical
- Write and validate

### Step 8: Validate All Pages
Run the validation script on each output page:
```bash
bash 1-ALIGN/learning/scripts/validate-learning-page.sh 1-ALIGN/learning/output/{system-slug}/T{n}.P{m}-{name}.md {page-type} {topic-depth}
```
Report results: pass/fail per page with specific errors.

---

## Output Naming Convention

```
1-ALIGN/learning/output/{system-slug}/T{n}.P0-overview-and-summary.md
1-ALIGN/learning/output/{system-slug}/T{n}.P1-ultimate-blockers.md
1-ALIGN/learning/output/{system-slug}/T{n}.P2-ultimate-drivers.md
1-ALIGN/learning/output/{system-slug}/T{n}.P3-principles.md
1-ALIGN/learning/output/{system-slug}/T{n}.P4-components.md
1-ALIGN/learning/output/{system-slug}/T{n}.P5-steps-to-apply.md
```

---

## Hard Rules

1. **One topic per invocation.** Do not process multiple topics.
2. **Every cell begins with its CAG tag.** Format: `{RowCode}{ColSuffix}: {content}`. Validate against the regex in 1-ALIGN/learning/config/constraints.yaml.
3. **Row counts within bounds.** See [page-dispatch-table.md](./references/page-dispatch-table.md).
4. **17 pipe-delimited columns per row** (row label column + 16 content columns).
5. **Content grounded in research.** Do not hallucinate facts. If research is thin for a cell, write what's available and flag as `[NEEDS REVIEW]`.
6. **Never ask the user.** Read learn-input for EO, RACI, contracts. You have everything you need.
7. **Direction inversion on UBS rows.** `.UD.EP` → P_F notation, `.UB.EP` → P notation. Opposite on UDS rows.
8. **Re-read P0-P2 before P3-P5.** The checkpoint is mandatory, not optional.
9. **Use UEDS terms only.** `.UD`, `.UB`, `.EP`, `.EOT`, `.EOE` — not generic synonyms.

---

## Completion Report

After all 6 pages are generated and validated, report:

```
/learn:structure complete.

System:     {system_name}
Topic:      T{n} — {topic_name}
Pages:      6/6 generated
Location:   1-ALIGN/learning/output/{system-slug}/

Validation:
  P0 Overview & Summary    — {PASS/FAIL} ({row_count} rows, {col_count} cols)
  P1 Ultimate Blockers     — {PASS/FAIL} ({row_count} rows, {col_count} cols)
  P2 Ultimate Drivers      — {PASS/FAIL} ({row_count} rows, {col_count} cols)
  P3 Principles            — {PASS/FAIL} ({row_count} rows, {col_count} cols)
  P4 Components            — {PASS/FAIL} ({row_count} rows, {col_count} cols)
  P5 Steps to Apply        — {PASS/FAIL} ({row_count} rows, {col_count} cols)

Next: /learn:review
```

---

## References

- [Structuring Procedure](./references/structuring-procedure.md) — detailed per-page generation instructions
- [Validation Rules](./references/validation-rules.md) — CAG regex, column/row count checks
- [Page Dispatch Table](./references/page-dispatch-table.md) — quick-reference for page → structure mapping
