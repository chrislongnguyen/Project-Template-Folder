---
version: "1.0"
status: Draft
last_updated: 2026-04-02
type: govern
work_stream: GOVERN
stage: validate
sub_system: human-adoption
---

# VALIDATE — N8 Human Adoption Training Package (Cycle 2)

## Test Runner Results

TOTAL: 20  PASS: 20  FAIL: 0  SKIP: 0

## Per-Artifact Validation

| Artifact | ACs | Completeness | Quality | Coherence | Downstream Ready | Issues |
|----------|-----|-------------|---------|-----------|-----------------|--------|
| A1 cmux-quickstart.md | AC-01..05 | PASS | PASS | PASS | PASS | None |
| A2 session-lifecycle-cheatsheet.md | AC-06..10 | PASS | PASS | PASS | PASS | None |
| A3 tool-routing-cheatsheet.md | AC-11..15 | PASS | PASS | PASS | PASS | None |
| A4 alpei-navigator.html | AC-16..20 | PASS | PASS | PASS | PASS | None |

## AC Detail Table

| AC | Criterion | Test Run | Result | Evidence |
|----|-----------|----------|--------|----------|
| AC-01 | File exists with 4-field Vinh frontmatter: type, work_stream, stage, sub_system | `grep -c` = 4 | PASS | `_genesis/sops/cmux-quickstart.md` lines 1-9 |
| AC-02 | Install command present (brew or equivalent for macOS) | `grep -i "brew\|install"` exits 0 | PASS | Line 20: `brew install tmux` |
| AC-03 | 3 core commands documented: create/new workspace, switch, list | `grep -c` = 4 (>=3) | PASS | Lines 27-30: new, ls, attach |
| AC-04 | Orchestrator pattern documented: read-screen + send-keys/send commands | `grep -i "read.screen\|send"` exits 0 | PASS | Lines 39-46: capture-pane + send-keys |
| AC-05 | LTC workspace naming convention table present (workspace name -> agent type) | `grep -i` line count = 18 (>=3) | PASS | Lines 50-55: 4-row table |
| AC-06 | File exists with frontmatter (version, status, last_updated) | `grep "version:"` exits 0 | PASS | `_genesis/sops/session-lifecycle-cheatsheet.md` line 2 |
| AC-07 | Canonical workflow documented as ordered steps: /compress -> /clear -> /resume | `grep -i` line count = 10 (>=3) | PASS | Lines 14-17: numbered 1-2-3 |
| AC-08 | Each command has: what it does + when to call it | `grep -c "##\|###"` = 5 (>=3) | PASS | Sections: Command Reference, Deprecated, Token Savings |
| AC-09 | Deprecated commands listed with replacement pointer | `grep -i "deprecated\|session-start\|session-end"` exits 0 | PASS | Lines 30-34: table with "Use instead" column |
| AC-10 | Token cost quantified: old cost vs new cost | `grep -i "token\|35K\|5K\|30K"` exits 0 | PASS | Lines 38-42: 35K -> 3-5K, ~30K savings |
| AC-11 | File exists with frontmatter | `grep "version:"` exits 0 | PASS | `_genesis/sops/tool-routing-cheatsheet.md` line 2 |
| AC-12 | 3-tool hierarchy table: QMD -> Obsidian CLI -> Grep/.claude | `grep -i` line count = 18 (>=3) | PASS | Lines 17-21: Priority 1/2/3 table |
| AC-13 | Decision criteria present: when to use each tool (>=3 scenario rows) | `grep -c "\|"` = 15 (>=5) | PASS | Lines 27-35: 8 scenario rows |
| AC-14 | Mandatory .claude/ grep sweep called out explicitly | `grep -i` exits 0 | PASS | Lines 38-49: "MANDATORY" header + code block |
| AC-15 | Obsidian fallback (not running -> use Grep) documented | `grep -i` exits 0 | PASS | Lines 51-54: "Fallback Rule" section |
| AC-16 | session-start desc or name contains "[DEPRECATED]" | `grep` pipeline exits 0 | PASS | Navigator HTML: session-start node marked DEPRECATED |
| AC-17 | session-end desc or name contains "[DEPRECATED]" | `grep` pipeline exits 0 | PASS | Navigator HTML: session-end node marked DEPRECATED |
| AC-18 | compress desc mentions rich frontmatter or Briefing Card | `grep` pipeline exits 0 | PASS | Navigator HTML: compress node desc includes frontmatter/briefing |
| AC-19 | resume desc mentions 2-pass or token cap | `grep` pipeline exits 0 | PASS | Navigator HTML: resume node desc includes 2-pass/token ref |
| AC-20 | obsidian skill node added or existing entry updated | `grep -i "obsidian"` exits 0 | PASS | Navigator HTML contains obsidian reference |

## Cross-Artifact Coherence

| Check | Verdict | Evidence |
|-------|---------|----------|
| A2 deprecated commands match A4 deprecated status (session-start, session-end) | PASS | A2 lines 30-34 list both as DEPRECATED; A4 grep confirms both nodes marked DEPRECATED |
| A3 hierarchy (QMD -> Obsidian -> Grep) matches tool-routing.md v1.3 | PASS | A3 lines 17-21 match `rules/tool-routing.md` lines 60-66 exactly |
| A1 workspace names consistent with multi-agent patterns | PASS | A1 lines 50-55: orchestrator/builder/reviewer/explorer match agent roster in tool-routing.md lines 48-53 |

## Quality Floor

| Check | Verdict | Evidence |
|-------|---------|----------|
| A1 has LTC versioning fields (version, status, last_updated) | PASS | Lines 2-4: version "1.0", status Draft, last_updated 2026-04-02 |
| A2 has LTC versioning fields | PASS | Lines 2-4: version "1.0", status Draft, last_updated 2026-04-02 |
| A3 has LTC versioning fields | PASS | Lines 2-4: version "1.0", status Draft, last_updated 2026-04-02 |
| A1 has Vinh 4-field schema (type, work_stream, stage, sub_system) | PASS | Lines 5-8: type sop, work_stream govern, stage build, sub_system human-adoption |
| No file uses 0.x versioning | PASS | All files use version "1.0" |
| No file self-sets status: Approved | PASS | All files use status: Draft |

## Issues Found

None.

## Gate G4 Recommendation

**PASS** — All 20 acceptance criteria pass their binary tests. Cross-artifact coherence confirmed on 3 checks. Quality floor met on all 6 checks. Downstream readiness verified: A1 includes install command and commented examples, A2 has unambiguous ordered workflow, A3 has 8 scenario rows with mandatory sweep prominent, A4 marks deprecated skills clearly. Recommend human review at G4 gate.
