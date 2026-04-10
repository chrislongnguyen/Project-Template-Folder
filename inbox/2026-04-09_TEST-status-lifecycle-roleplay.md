---
version: "1.0"
status: draft
last_updated: 2026-04-09
work_stream: _governance
type: test-spec
tags: [status-lifecycle, integration-test, roleplay]
---

# TEST SPEC — Status Lifecycle Roleplay

> Integration test for the status lifecycle automation system.
> Runs in an isolated git worktree. Two agents roleplay PM and AI Responsible.
> 13 deterministic checkpoints with binary pass/fail assertions.

## Test Environment

- **Isolation:** Git worktree (no changes to main working tree)
- **Hooks:** inject-frontmatter.sh v2 must be active (PostToolUse:Write|Edit)
- **Scripts:** All 6 new scripts must exist and be executable
- **Artifacts:** Test creates files in 1-ALIGN/1-PD/ as the scenario workspace

## Scenario Script (13 Checkpoints)

### Phase A — Basic Status Transitions (T1, T2)

**CP-1: File Creation → draft**
- Action: Agent creates `1-ALIGN/1-PD/DESIGN.md` with frontmatter
- Assert: `status: draft`, `version: "1.0"`, `last_updated: today`

**CP-2: Agent Edit → in-progress (T1)**
- Action: Agent edits DESIGN.md (adds content)
- Assert: `status: in-progress` (hook auto-advanced from draft)
- Assert: `last_updated: today`

**CP-3: Gate Presentation → in-review (T2)**
- Action: Agent writes gate report (G1-Design) to DESIGN.md
- Assert: `status: in-review`

### Phase B — Approval Detection (Tier 1-4)

**CP-4: Tier 1 Explicit Approval → validated (T3)**
- PM says: "looks good"
- Action: Agent detects Tier 1, sets validated, writes approval record
- Assert: `status: validated`, `## Approval Log` section exists with gate=G1-Design

**CP-5: Tier 2 Implicit Approval — phase advance**
- PM says: "proceed to sequence"
- Action: Agent confirms ("Marking DESIGN.md as validated"), creates SEQUENCE.md
- Assert: DESIGN.md `status: validated`, SEQUENCE.md `status: draft`
- Note: For this test, reset DESIGN.md to in-review first to test Tier 2 separately

**CP-6: Tier 3 Ambiguous — agent asks**
- PM says: "ok" (standalone, no directive)
- Action: Agent asks "Are you validating this phase, or just acknowledging?"
- Assert: Status UNCHANGED (still in-review)

**CP-7: Tier 4 Rejection — stays in phase**
- PM says: "wait, revise section 3"
- Action: Agent stays in current phase, applies feedback
- Assert: Status reverts to `in-progress` (agent is re-editing)

### Phase C — Version Coupling (T4)

**CP-8: Re-edit Validated File → draft + version bump**
- Setup: DESIGN.md is `status: validated`, `version: "1.2"`
- Action: Agent edits DESIGN.md content
- Assert: `status: draft`, `version: "1.3"` (MINOR +1)

### Phase D — Bulk Operations

**CP-9: bulk-validate.sh**
- Setup: Create 5 files in 1-ALIGN/1-PD/ with `status: in-review`
- Action: Run `./scripts/bulk-validate.sh 1-ALIGN/1-PD/ --dry-run`
- Assert: Output shows 5 files would change. No actual changes (dry-run).
- Action: Run `./scripts/bulk-validate.sh 1-ALIGN/1-PD/`
- Assert: All 5 files now `status: validated` with approval records

**CP-10: generate-registry.sh accuracy**
- Setup: Files from CP-9 have known versions and statuses
- Action: Run `./scripts/generate-registry.sh`
- Assert: `_genesis/version-registry.md` table matches actual file frontmatter

### Phase E — Full ALPEI Cycle (abbreviated)

**CP-11: Complete DSBV for one subsystem**
- Action: Create DESIGN.md + SEQUENCE.md + build artifacts + VALIDATE.md for 1-ALIGN/1-PD/
- Advance all through draft → in-progress → in-review → validated
- Assert: All files validated, registry shows 1-ALIGN complete for PD

### Phase F — Iteration Advancement

**CP-12: Iteration Nudge**
- Setup: All 5 workstreams have validated artifacts for PD subsystem
- Action: Agent checks readiness
- Assert: Nudge message appears with C1-C3 readiness report

**CP-13: iteration-bump.sh**
- PM says: "advance PD to I2"
- Action: Run `./scripts/iteration-bump.sh --subsystem PD --from 1 --to 2`
- Assert: All PD files across all workstreams: `version: "2.0"`, `status: draft`, `iteration: 2`
- Assert: Single atomic operation (one commit or staged change set)

## Pass Criteria

- **PASS:** 13/13 checkpoints pass
- **PARTIAL:** 10-12 pass, remaining are non-blocking (cosmetic)
- **FAIL:** <10 pass, or any checkpoint in Phase A-C fails (core lifecycle broken)

## Execution Notes

- Checkpoints are sequential — each depends on prior state
- The "PM agent" is scripted (deterministic phrases), not free-form
- The "AI agent" uses real tools with real hooks firing
- All assertions read actual file frontmatter via grep/awk, not agent self-report
