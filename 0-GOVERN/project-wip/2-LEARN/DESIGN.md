---
version: "1.0"
iteration: "I1: Concept"
status: Approved
last_updated: 2026-03-30
owner: Long Nguyen
---
# LEARN Zone — DESIGN Specification

## Intent

Extract `1-ALIGN/learning/` into standalone `2-LEARN/` zone per ADR-001 (LEARN zone placement — DECIDED). LEARN is the centerpiece of ALPEI: a structured workspace where the Human Director + Agent research, synthesize, and understand the problem domain before planning.

LEARN ≠ template training. Training materials about how to use the template live in `_genesis/training/`. LEARN is where project-specific problem research happens.

## Required Artifacts (3)

| # | Artifact | Path | Purpose | Success Criteria |
|---|---|---|---|---|
| A1 | LEARN zone structure | `2-LEARN/` | Workflow workspace with correct subfolders, migrated content, archived stale files | All active files migrated. Stale files archived. Subfolders: input/, research/, specs/, output/, templates/, references/, config/, scripts/, archive/ |
| A2 | Skill routing update | `.claude/skills/learning/` (14 files) | All `/learn-*` skills target `2-LEARN/` | `grep -r "1-ALIGN/learning" .claude/skills/` returns 0 matches |
| A3 | Cross-reference update | CLAUDE.md, README.md, _genesis refs, ADRs, GOVERN refs, EXECUTE refs, IMPROVE refs, rules | All references updated to `2-LEARN/` | `grep -r "1-ALIGN/learning" . --include="*.md"` returns 0 in active files (archive exempted) |

## 5 Conditions for Completion

| # | Condition | Binary Test |
|---|---|---|
| C1 | `2-LEARN/` exists with correct subfolders | input/, research/, specs/, output/, templates/, references/, config/, scripts/, archive/ all present |
| C2 | All active content migrated, stale content archived | `1-ALIGN/learning/` contains only redirect README |
| C3 | Zero active files reference old path | `grep -r "1-ALIGN/learning" . --include="*.md"` returns 0 outside archive/ |
| C4 | README distinguishes LEARN workspace from _genesis training | README.md exists with clear framing |
| C5 | CLAUDE.md structure section shows LEARN zone | Zone 2 LEARN in 5-zone matrix |
