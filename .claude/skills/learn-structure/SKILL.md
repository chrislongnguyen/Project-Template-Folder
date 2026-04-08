---
version: "1.2"
status: draft
last_updated: 2026-04-07
name: learn-structure
description: >
  Use when /learn:research is complete for a topic and you need to generate
  structured Effective Learning pages (P0-P5) with 17-column CAG-prefixed tables
  and mermaid relationship diagrams. One topic per invocation.
argument-hint: <system-slug> <topic-number>
context: fork
model: opus
allowed-tools: Read, Glob, Write, Bash
---
# /learn:structure — Effective Learning Page Generator

> **HARD-GATE:** This skill requires the highest-capability model for 17-column table generation with CAG prefixes. If model selection is available, fork to Opus.

> **GATE — Single Topic Scope:** This skill processes ONE topic per invocation. Load ONLY that topic's research file. Do NOT load research for other topics. The orchestrator (/learn) calls this skill in a loop, once per topic.

> Load [references/structure-rules.md](references/structure-rules.md) for column definitions, CAG rules, and validation criteria.

## Arguments

Parse the user's invocation for two arguments:
- `{system-slug}` — e.g., `data-foundation` (kebab-case system name)
- `{topic-number}` — e.g., `0` for T0 Overview

If arguments are missing, check for a single `2-LEARN/_cross/input/learn-input-*.md` file. If exactly one exists, use it. Otherwise, list available learn-input files and ask.

---

## Injected Context

### Learn Input Metadata
!`cat 2-LEARN/_cross/input/learn-input-*.md 2>/dev/null | head -120`

### Constraints (CAG Rules)
!`cat 2-LEARN/_cross/config/constraints.yaml 2>/dev/null`

---

## Pre-Checks

1. Verify `2-LEARN/_cross/input/learn-input-{system-slug}.md` exists. If not, error: "Run /learn:input first."
2. Verify `2-LEARN/_cross/research/{system-slug}/T{topic-number}-*.md` exists. If not, error: "Run /learn:research first."
3. Verify `_genesis/templates/learning-book/page-0-overview-and-summary.md` exists.
4. Create `2-LEARN/_cross/output/{system-slug}/` directory if it doesn't exist.
5. Extract from learn-input: `system_name`, `eo`, `user_persona_r`, `user_persona_a`, `subject_abbreviation`, `input_contract`, `output_contract`, `topic_depth`.

---

## Generation Procedure

Follow [structuring-procedure.md](./references/structuring-procedure.md) for detailed per-page instructions.

| Step | Page | Key Action | Mermaid |
|------|------|-----------|---------|
| 1 | — | Load research for T{topic-number} ONLY | — |
| 2 | P0 | Overview: 2 rows (R + A), 17 cols, CAG-prefixed | Relationship map |
| 3 | P1 | Blockers: UBS rows with direction inversion | Causal chain |
| 4 | P2 | Drivers: UDS rows with direction inversion | Causal chain |
| **GATE** | — | **Re-read P0-P2 from disk. Extract seeds for P3-P5.** | — |
| 5 | P3 | Principles: harvested from P0-P2 cols 6,12 | Pillar map |
| 6 | P4 | Components: 3-layer (Foundational/Operational/Enabling) | Layer diagram |
| 7 | P5 | Steps: DERISK then OPTIMIZE sequence | Flow diagram |
| 8 | — | Validate all pages via validation script | — |

### Mermaid Companion Blocks

Each P-page output file MUST include a lightweight mermaid diagram block after the table, visualizing key relationships in that page:
- **P0:** Entity relationship map (R/A actors, EO, subject)
- **P1:** UBS causal chain (surface → driver → deeper driver)
- **P2:** UDS causal chain (surface → driver → deeper driver)
- **P3:** Principle pillar map (S/E/Sc grouping with P and P_F)
- **P4:** Component layer diagram (Foundational → Operational → Enabling)
- **P5:** Sequential flow (DERISK steps → OPTIMIZE steps)

Keep mermaid blocks under 15 nodes. These are companions to the table, not replacements.

### Checkpoint (between P2 and P3)

**HARD-GATE:** After writing P2, re-read P0, P1, P2 files from disk. Extract:
- Principles from cols 6 (UD.EP) and 12 (UB.EP)
- Tools from cols 7 (UD.EOT) and 13 (UB.EOT)
- Steps from cols 3 (ACT) and 9 (FAIL)

These become seeds for P3-P5. Do NOT skip this step.

---

## Output Path

```
2-LEARN/_cross/output/{system-slug}/T{n}.P0-overview-and-summary.md
2-LEARN/_cross/output/{system-slug}/T{n}.P1-ultimate-blockers.md
2-LEARN/_cross/output/{system-slug}/T{n}.P2-ultimate-drivers.md
2-LEARN/_cross/output/{system-slug}/T{n}.P3-principles.md
2-LEARN/_cross/output/{system-slug}/T{n}.P4-components.md
2-LEARN/_cross/output/{system-slug}/T{n}.P5-steps-to-apply.md
```

---

## Hard Rules

1. **One topic per invocation.** Do not process multiple topics.
2. **Every cell begins with its CAG tag.** See [structure-rules.md](./references/structure-rules.md).
3. **Row counts within bounds.** See [page-dispatch-table.md](./references/page-dispatch-table.md).
4. **17 pipe-delimited columns** (row label + 16 content columns).
5. **Content grounded in research.** Flag gaps as `[NEEDS REVIEW]`.
6. **Never ask the user.** All inputs come from learn-input file.
7. **Direction inversion on UBS rows.** `.UD.EP` = P_F, `.UB.EP` = P. Opposite on UDS rows.
8. **Re-read P0-P2 before P3-P5.** Checkpoint is mandatory.
9. **EL terms only.** `.UD`, `.UB`, `.EP`, `.EOT`, `.EOE` — not generic synonyms.
10. **Mermaid companion on every page.** Under 15 nodes each.

---

## Escape Hatches

- **Validation fails 2x:** Present partial output + report specific gaps to user. Do not loop indefinitely.
- **Context budget exceeded:** Reduce mermaid blocks first (remove or simplify to under 8 nodes). If still over, reduce example rows to minimum bounds per page type.

---

## Validation

Run on each output page:
```bash
bash 2-LEARN/_cross/scripts/validate-learning-page.sh \
  2-LEARN/_cross/output/{system-slug}/T{n}.P{m}-{name}.md {page-type} {topic-depth}
```

---

## Completion Report

```
/learn:structure complete.

System:     {system_name}
Topic:      T{n} — {topic_name}
Pages:      6/6 generated
Location:   2-LEARN/_cross/output/{system-slug}/

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

- [Structure Rules](./references/structure-rules.md) — column definitions, CAG prefix rules, row count bounds
- [Structuring Procedure](./references/structuring-procedure.md) — detailed per-page generation instructions
- [Validation Rules](./references/validation-rules.md) — CAG regex, column/row count checks
- [Page Dispatch Table](./references/page-dispatch-table.md) — page → structure mapping

## Links

- [[SEQUENCE]]
- [[VALIDATE]]
- [[page-0-overview-and-summary]]
- [[page-dispatch-table]]
- [[structure-rules]]
- [[structuring-procedure]]
- [[validation-rules]]
