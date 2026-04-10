---
version: "1.0"
status: draft
last_updated: 2026-04-09
work_stream: _governance
type: dsbv-sequence
---

# SEQUENCE — Status Lifecycle Automation

> Implements DESIGN: `inbox/2026-04-09_DESIGN-status-lifecycle-automation.md`
> 8 components + 6 unit test tasks = 14 tasks, 4 rounds.

## Dependency Graph

```
Round 1 (parallel):       C1                    C3
                           │                     │
Round 2 (partial):        C2 → C7              C4
                           │     │               │
Round 3 (parallel):        └─────┘              C5    C6
                                                 │     │
Round 4:                                        C8 ◄──┘
```

## Round Plan

| Round | Tasks | Parallel? |
|-------|-------|-----------|
| R1 | C1, C3 [independent] | Yes |
| R2 | C2 → C7 (sequential, same file), C4 [independent] | C4 parallel with C2→C7 |
| R3 | C5, C6 [independent] | Yes |
| R4 | C8 | No — depends on C5+C6 |

## Task Detail

### Round 1

**T-C1: inject-frontmatter.sh v2** [independent]
- Input: `.claude/hooks/inject-frontmatter.sh` (v1.0), DESIGN §4
- Output: `.claude/hooks/inject-frontmatter.sh` (v2.0)
- ACs:
  - AC-C1.1: Edit draft file → status becomes in-progress
  - AC-C1.2: Edit validated file → version bumps MINOR, status resets to draft
  - AC-C1.3: Edit .claude/rules/*.md → no status change
  - AC-C1.4: Edit in-progress file → stays in-progress
- Size: S (~40 lines changed)
- Depends: None

**T-C3: generate-registry.sh** [independent]
- Input: `_genesis/version-registry.md` (format), DESIGN §5
- Output: `scripts/generate-registry.sh`
- ACs:
  - AC-C3.1: Output table matches actual file frontmatter
  - AC-C3.2: Preserves registry file's own frontmatter
  - AC-C3.3: Idempotent — running twice produces identical output
- Size: M (~120 lines)
- Depends: None

### Round 2

**T-C2: DSBV skill gate writer** (before C7)
- Input: `.claude/skills/dsbv/SKILL.md`, DESIGN §3.4
- Output: `.claude/skills/dsbv/SKILL.md` (updated)
- ACs:
  - AC-C2.1: After approval, artifact has ## Approval Log with date/gate/verdict/signal/tier
  - AC-C2.2: Status set to validated via FORCE_APPROVE pathway
  - AC-C2.3: Next phase artifact created with status: draft
- Size: M (~100 lines)
- Depends: C1

**T-C7: Approval signal detection** (after C2, same file)
- Input: `.claude/skills/dsbv/SKILL.md` (post-C2), DESIGN §3.2
- Output: `.claude/skills/dsbv/SKILL.md` (updated)
- ACs:
  - AC-C7.1: Tier 1 "approved" triggers immediate advance
  - AC-C7.2: Tier 3 standalone "ok" triggers clarification question
  - AC-C7.3: Tier 4 "wait"/"revise" keeps status unchanged
- Size: M (~80 lines)
- Depends: C2

**T-C4: bulk-validate.sh** [independent]
- Input: DESIGN §7.1
- Output: `scripts/bulk-validate.sh`
- ACs:
  - AC-C4.1: Only in-review files touched
  - AC-C4.2: --dry-run lists files without modifying
  - AC-C4.3: Writes approval records to each file
- Size: S (~50 lines)
- Depends: C3

### Round 3

**T-C5: iteration-bump.sh** [independent]
- Input: DESIGN §6.3
- Output: `scripts/iteration-bump.sh`
- ACs:
  - AC-C5.1: Refuses if C1-C3 conditions unmet
  - AC-C5.2: All files bumped atomically
  - AC-C5.3: --from mismatch → refusal
  - AC-C5.4: Prompts for confirmation
- Size: M (~150 lines)
- Depends: C3, C4

**T-C6: readiness-report.sh** [independent]
- Input: DESIGN §6.1-6.2
- Output: `scripts/readiness-report.sh`
- ACs:
  - AC-C6.1: Shows ✓/✗ for C1, C2, C3 per subsystem
  - AC-C6.2: Shows READY only when all 3 met
  - AC-C6.3: Shows blocking reason when not ready
- Size: S (~50 lines)
- Depends: C3

### Round 4

**T-C8: Agent nudge logic**
- Input: `.claude/skills/dsbv/SKILL.md` (post-C7), DESIGN §6.2
- Output: `.claude/skills/dsbv/SKILL.md` (updated)
- ACs:
  - AC-C8.1: After IMPROVE validate, nudge with C1-C3 status
  - AC-C8.2: Nudge includes actionable prompt
  - AC-C8.3: No nudge if not ready
- Size: S (~40 lines)
- Depends: C5, C6

## Critical Path

C3 (M) → C4 (S) → C5 (M) → C8 (S) = longest path
