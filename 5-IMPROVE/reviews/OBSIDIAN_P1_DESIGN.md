---
version: "1.0"
status: draft
last_updated: 2026-04-01
type: improve
work_stream: IMPROVE
stage: Design
sub_system: obsidian-cli
---

# DESIGN — Obsidian CLI P1/P2 Prescriptive Fixes

## Source

4-EXECUTE/tests/obsidian/AB_RETEST_RESULTS.md §4 Prescriptive

## Problem Statement

A/B re-test revealed 2 systematic gaps in the hybrid obsidian-cli integration:

1. **S4 gap (P1):** Hybrid sweep in SKILL.md only greps `.claude/**/*.md` — misses `.sh`, `.py`, `.html` files that contain agent-relevant references. Grep found 8 more files than obsidian in S4.
2. **S1 non-md awareness (P1):** No guidance tells agents WHEN to skip obsidian and use grep directly. Obsidian indexes `.md` only — queries targeting scripts/configs should go straight to grep.
3. **S1 context gap (P2):** `search:context` command exists in SKILL.md but wasn't used in S1 methodology. Adding it may close the 79→86 file gap.

## Artifacts to Modify

| # | Artifact | Fix | ACs |
|---|----------|-----|-----|
| F1 | `.claude/skills/obsidian/SKILL.md` | Extend L9 hybrid sweep glob to `*.md,*.sh,*.py,*.html` | AC-F1: grep command in SKILL.md includes non-md extensions |
| F2 | `.claude/skills/obsidian/SKILL.md` | Add "When NOT to Use Obsidian" section | AC-F2: section exists with ≥3 explicit scenarios |
| F3 | `.claude/skills/obsidian/SKILL.md` | Promote `search:context` as primary search command | AC-F3: `search:context` listed first in command table |
| F4 | `rules/tool-routing.md` | Extend `.claude/` sweep instruction to include non-md | AC-F4: grep command in tool-routing includes non-md extensions |
| F5 | `.claude/rules/obsidian-security.md` | Extend L9 sweep to non-md | AC-F5: L9 rule grep command includes non-md extensions |

## Acceptance Criteria

- AC-F1: SKILL.md hybrid sweep grep includes `--include='*.sh' --include='*.py' --include='*.html'`
- AC-F2: SKILL.md has "When NOT to Use Obsidian" section with ≥3 scenarios (non-md files, known paths, exact-match)
- AC-F3: `search:context` is the first entry in the Safe Command Allowlist table
- AC-F4: tool-routing.md sweep command includes non-md extensions
- AC-F5: obsidian-security.md L9 sweep command includes non-md extensions
- AC-F6: All 9 existing test scripts still pass (`run-all.sh`)
- AC-F7: Version bumped on all modified files

## Out of Scope

- S2 re-test at 500+ files (I2)
- V4 Bases, V8 matrix view (I2)
- New test scripts for these fixes (existing AC-37 covers sweep presence)