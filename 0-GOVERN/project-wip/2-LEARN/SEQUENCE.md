---
version: "1.1"
iteration: "I1: Concept"
status: Approved
last_updated: 2026-03-30
owner: Long Nguyen
---
# LEARN Zone — SEQUENCE

## Dependency Graph

```
T1 (create + migrate) → T2 (skill routing) ‖ T3 (cross-refs)
                                              → T4 (redirect stub)
```

T2 and T3 are independent after T1. T4 is trivial, bundled with T3.

## T1: Create 2-LEARN/ + Migrate Content

**Duration:** 15 min
**Depends on:** — (entry point)

**Work:**
1. Create `2-LEARN/` with subfolders: input/, research/, specs/, output/, templates/, references/, config/, scripts/, archive/
2. Move active files from `1-ALIGN/learning/` to `2-LEARN/` (see triage table in DESIGN session)
3. Move stale/completed files to `2-LEARN/archive/`
4. Write `2-LEARN/README.md` — explains LEARN = problem research workspace, not template docs
5. Preserve `input/raw/` subfolder structure

**Acceptance Criteria:**
- [ ] All 9 subfolders exist
- [ ] Active files present in correct subfolders
- [ ] Archive contains 11 stale files (DSBV artifacts, completed research, legacy SOP)
- [ ] README distinguishes LEARN from _genesis/training/

## T2: Update Skill Routing (14 files)

**Duration:** 10 min
**Depends on:** T1

**Work:**
1. In all 7 SKILL.md files under `.claude/skills/learning/`, replace `1-ALIGN/learning` → `2-LEARN`
2. In all 7 reference files under `.claude/skills/learning/`, replace `1-ALIGN/learning` → `2-LEARN`

**Acceptance Criteria:**
- [ ] `grep -r "1-ALIGN/learning" .claude/skills/` returns 0 matches
- [ ] All 7 skills still reference valid paths

## T3: Update Cross-References (22+ files)

**Duration:** 15 min
**Depends on:** T1

**Work:**
1. Update `CLAUDE.md` — structure section shows Zone 2 LEARN
2. Update `README.md` (root) — learning pipeline routing
3. Update `_genesis/reference/ltc-ai-agent-system-project-template-guide.md` — zone map, folder structure, skill routing
4. Update `_genesis/frameworks/LEARNING_HIERARCHY.md`, `SIX_WORKSTREAMS.md`
5. Update `_genesis/templates/RESEARCH_TEMPLATE.md`
6. Update `.claude/rules/alpei-pre-flight.md` — CHECK LEARNING step
7. Update `0-GOVERN/DESIGN.md`, `0-GOVERN/SEQUENCE.md`
8. Update `4-EXECUTE/DESIGN.md`
9. Update `5-IMPROVE/changelog/CHANGELOG.md`, `5-IMPROVE/metrics/multi-agent-eval/h-test-results.md`
10. Update `1-ALIGN/decisions/ADR-001-learn-zone-placement.md` — status: Decided → Executed
11. Update `1-ALIGN/decisions/ADR-004-subfolder-descriptions.md`
12. Update `1-ALIGN/DESIGN.md`, `1-ALIGN/SEQUENCE.md`
13. Leave redirect stub at `1-ALIGN/learning/README.md` pointing to `2-LEARN/`

**Acceptance Criteria:**
- [ ] `grep -r "1-ALIGN/learning" . --include="*.md"` returns 0 outside archive/
- [ ] ADR-001 status updated to Executed
- [ ] CLAUDE.md shows 2-LEARN in structure
- [ ] Root README updated

## Execution Summary

| Task | Depends On | Est. |
|------|-----------|------|
| T1   | —         | 15m  |
| T2   | T1        | 10m  |
| T3   | T1        | 15m  |

Total: ~25 min with T2‖T3 parallelism
