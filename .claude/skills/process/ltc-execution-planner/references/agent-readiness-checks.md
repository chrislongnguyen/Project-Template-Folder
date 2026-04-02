---
version: "1.0"
last_updated: 2026-03-30
---
# Agent Readiness Checks

> Run these checks AFTER generating .exec/ files, BEFORE execution begins.
> All checks must pass. Failure -> fix and retry (max 3), then escalate.
> Source: LTC Execution Pipeline Design Spec §4.4.

## 10-Point Checklist

| # | Check | Type | Criteria | Fix Action |
|---|---|---|---|---|
| 1 | Task file completeness | Deterministic | Every section in template is populated (no empty placeholders `{...}`) | Fill missing sections from plan |
| 2 | Dependency graph acyclicity | Deterministic | No circular dependencies in blocked_by/blocks | Remove cycle, escalate if ambiguous |
| 3 | AC coverage MECE | Deterministic | Every spec AC appears in exactly one task; every task AC appears in the spec | Add missing mappings or remove orphans |
| 4 | I/O contract consistency | Deterministic | Every task output path matches the expected input path of its dependent | Fix paths to align |
| 5 | Environment prereqs verifiable | Deterministic | Every verify command in Environment section is syntactically valid | Fix command syntax |
| 6 | status.json <-> task files consistency | Deterministic | Every task in status.json has a .md file and vice versa | Sync status.json with task files |
| 7 | WMS sync successful | Deterministic | All tasks created in WMS with correct status mapping | Retry sync, check API credentials |
| 8 | Agent pattern matches decision tree | Deterministic | Agent pattern in task file matches spec §6.1 2D matrix for task count x complexity | Correct pattern assignment |
| 9 | Model assignment matches decision tree | Deterministic | Agent model in task file matches spec §6.2 for task type | Correct model assignment |
| 10 | Traceability chain complete | Deterministic | Every task traces: Task -> Plan section -> Spec AC -> EO | Fill missing trace links |

## Check Details

### Check 1: Task File Completeness

**What:** Scan every `.md` task file in `.exec/` for unfilled template placeholders.

**How:** Regex scan for `{...}` patterns that indicate unfilled template fields.
Exceptions: code blocks (fenced with triple backticks) are excluded from this check.

**Pass criteria:** Zero unfilled placeholders outside code blocks.

### Check 2: Dependency Graph Acyclicity

**What:** Build a directed graph from all `blocked_by` and `blocks` fields across task files.

**How:** DFS-based cycle detection. Each task ID is a node; `blocked_by` creates an edge from the dependency to the dependent.

**Pass criteria:** No cycles detected. Every task is reachable from at least one task with no `blocked_by` entries (a root task).

### Check 3: AC Coverage MECE

**What:** Verify bidirectional mapping between spec ACs and task ACs.

**How:**
- Parse all AC IDs from spec VANA Traceability sections
- Parse all AC IDs from task VANA Traceability sections
- Verify: every spec AC appears in exactly one task
- Verify: every task AC appears in the spec

**Pass criteria:** Bijective mapping — no orphan ACs, no duplicate coverage.

### Check 4: I/O Contract Consistency

**What:** Verify that output paths match downstream input paths.

**How:** For each task's Outputs table, find the consumer task and verify it lists the same path in its Inputs table.

**Pass criteria:** Every output-input pair matches on path.

### Check 5: Environment Prerequisites Verifiable

**What:** Verify that Environment section verify commands are syntactically valid.

**How:** Check each verify command is non-empty and does not contain obvious errors (e.g., unmatched quotes, empty command). Does NOT execute the commands.

**Pass criteria:** All verify commands pass syntax check.

### Check 6: status.json <-> Task Files Consistency

**What:** Every task ID in status.json has a corresponding `.md` file, and vice versa.

**How:** List all task .md files in `.exec/`, extract task IDs from filenames. Compare against task IDs in status.json.

**Pass criteria:** Sets are identical.

### Check 7: WMS Sync Successful

**What:** Verify `.wms-sync.json` exists and contains entries for all tasks.

**How:** Check file exists, parse JSON, verify all task IDs have `wms_id` entries.

**Note:** This check is SKIPPED if WMS sync has not been configured (no `.wms-sync.json` file). A warning is emitted instead.

**Pass criteria:** All tasks have WMS IDs, or WMS sync not yet configured (warning).

### Check 8: Agent Pattern Matches Decision Tree

**What:** Verify agent pattern assignment follows the spec §6.1 2D matrix.

**How:** For each task, check that `Agent Pattern` is a valid value (`Single Agent`, `Sub-Agents`, `Agent Team`).

**Pass criteria:** All agent patterns are valid enum values.

### Check 9: Model Assignment Matches Decision Tree

**What:** Verify agent model assignment follows the spec §6.2 mapping.

**How:** For each task, check that `Agent Model` is a valid value (`Opus`, `Sonnet`, `Haiku`).

**Pass criteria:** All agent models are valid enum values.

### Check 10: Traceability Chain Complete

**What:** Every task must trace back to the spec through References section.

**How:** Check that each task file has non-placeholder values in:
- References > Plan Section
- References > Spec ACs
- VANA Traceability table has at least one row with a real AC ID

**Pass criteria:** All tasks have complete trace links.

## Execution

### CLI Usage

```bash
python3 3-PLAN/skills/ltc-execution-planner/scripts/readiness-check.py /path/to/.exec/
```

### Exit Codes

| Code | Meaning |
|---|---|
| 0 | All checks pass |
| 1 | One or more checks failed |

### Output Format

```
[PASS] Check 1: Task file completeness
[PASS] Check 2: Dependency graph acyclicity
[FAIL] Check 3: AC coverage MECE — Spec AC 'Noun-AC3' not covered by any task
[PASS] Check 4: I/O contract consistency
...

RESULT: 9/10 checks passed, 1 failed
```

## Retry Protocol

1. If any check fails, examine the failure message
2. Fix the specific .exec/ file(s) identified in the failure
3. Re-run the full 10-point check
4. Maximum 3 retry attempts
5. After 3 failures: present .exec/ directory with readiness report to Human Director

## Links

- [[DESIGN]]
- [[task]]
