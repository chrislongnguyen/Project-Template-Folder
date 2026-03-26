# D6-T1: Full Integration Test

## Identity

| Field | Value |
|---|---|
| Task ID | D6-T1 |
| Deliverable | D6: Final Integration + AC Verification |
| Spec Version | v1 |
| Plan Section | plan.md L2182-L2303 |
| Agent Pattern | Single Agent |
| Agent Model | Opus |
| Status | blocked |
| Rework Count | 0 |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| I1-VERIFY | Full test suite passes and all 30 I1 ACs verified against test coverage | Deterministic | All tests green + checklist complete |

> **Note:** D6-T1 is a verification task. It validates all 30 I1 ACs end-to-end but primary AC ownership is assigned to D1-D5 tasks.

## Acceptance Criteria

- [ ] AC-1: Full round-trip test passes (setup → write → read → update → read → delete → stats verify 0)
- [ ] AC-2: Full test suite passes: `python -m pytest tests/ -v` — all tests green
- [ ] AC-3: All 30 I1 ACs verified against test coverage (checklist in plan L2262-L2296)

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] Code reviewed (self-review or peer)
- [ ] No regressions
- [ ] status.json updated to "done"
- [ ] WMS synced

## References

| Reference | Location |
|---|---|
| Plan Section | plan.md L2182-L2303 |
| Spec ACs | vana-spec.md §2-§5 (all I1 ACs) |
| Related Tasks | D5-T2 (blocked_by) |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| All prior tasks | plugins/memory-vault/engine/ | Complete package | `pip install -e .` |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| Human Director | Updated tests/test_cli.py with integration test | Test passes | Exit 0 |
| Human Director | AC verification checklist (plan L2262-L2296) | All checked | Visual |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocked_by | D5-T2 | All CLI commands + setup must work |

## Environment

| Prerequisite | Verify Command |
|---|---|
| All D1-D5 complete | `cd plugins/memory-vault/engine && python -m pytest tests/ -v` all pass |
| Package installed | `memory --help` |

## Increments

### INC-1: Write Full Round-Trip Test

**Input:** Plan section L2187-L2244
**Action:** Append integration test to test_cli.py (setup → write → read → update → read → delete → stats)
**Output:** Updated tests/test_cli.py
**Verify:** Test syntactically correct

### INC-2: Run Full Test Suite

**Input:** All prior task outputs + INC-1
**Action:** `python -m pytest tests/ -v --tb=short`
**Output:** All tests green
**Verify:** Exit code 0

### INC-3: AC Verification Checklist

**Input:** Plan L2262-L2296
**Action:** Walk through each of 30 I1 ACs, map to test name, verify passing
**Output:** Completed checklist
**Verify:** All 30 ACs have a passing test or manual verification note

## Verify

```bash
cd plugins/memory-vault/engine && python -m pytest tests/ -v --tb=short
```

## Scope Exclusions

- Does NOT add I2-I4 features
- Does NOT deploy to production
- Does NOT integrate hooks (I3 scope)
- Does NOT run manual timing tests (V-10, A-E1 are Manual eval type — noted in checklist)
