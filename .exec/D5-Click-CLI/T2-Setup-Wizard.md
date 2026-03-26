# D5-T2: Setup Wizard + Integration Test

## Identity

| Field | Value |
|---|---|
| Task ID | D5-T2 |
| Deliverable | D5: Click CLI |
| Spec Version | v1 |
| Plan Section | plan.md L2117-L2162 |
| Agent Pattern | Single Agent |
| Agent Model | Sonnet |
| Status | blocked |
| Rework Count | 0 |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| V-10 | Install < 5 min | Manual | < 5 min |
| V-11 | Stats + audit show health | Deterministic | Counts > 0, healthy |
| N-W3 | Idempotent setup wizard | Deterministic | All steps pass |
| N-W4 | Stats + audit JSON | Deterministic | Valid JSON |
| A-E1 | Setup < 5 min, zero config | Manual | < 5 min |
| A-E4 | Setup idempotent | Deterministic | Identical state |
| Adj-W4 | No partial state on failure | Deterministic | Clean |
| Adj-W5 | Stats ≤ 30 lines | Deterministic | ≤ 30 |

## Acceptance Criteria

- [ ] AC-1: `memory setup` completes with "Ready" in output
- [ ] AC-2: Running setup twice produces exit code 0 both times (idempotent)
- [ ] AC-3: `memory audit --json` returns status=healthy after setup
- [ ] AC-4: All 3 new tests pass

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] Code reviewed (self-review or peer)
- [ ] No regressions in dependent tasks
- [ ] status.json updated to "done"
- [ ] WMS synced

## References

| Reference | Location |
|---|---|
| Plan Section | plan.md L2117-L2162 |
| Spec ACs | vana-spec.md §2 (V-10, V-11), §4.2 (N-W3, N-W4), §3.2 (A-E1, A-E4), §5.1 (Adj-W4, Adj-W5) |
| Related Tasks | D5-T1 (blocked_by), D6-T1 (blocks) |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| D5-T1 | src/memory_engine/cli.py | CLI with setup command | `memory setup --help` |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| D6-T1 | Updated tests/test_cli.py with 3 new tests | pytest | `python -m pytest tests/test_cli.py -v` |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocked_by | D5-T1 | CLI framework with setup command must exist |
| blocks | D6-T1 | Integration test needs all CLI commands working |

## Environment

| Prerequisite | Verify Command |
|---|---|
| D5-T1 complete | `python -m pytest tests/test_cli.py -v` passes (7 tests) |

## Increments

### INC-1: Add Setup + Audit Tests

**Input:** Plan section L2122-L2150
**Action:** Append 3 tests to test_cli.py (setup_completes, setup_is_idempotent, audit_healthy)
**Output:** Updated tests/test_cli.py
**Verify:** Tests syntactically correct

### INC-2: Verify All CLI Tests Pass

**Input:** INC-1 + D5-T1 implementation
**Action:** Run full CLI test suite
**Output:** 10/10 tests passing (7 original + 3 new)
**Verify:** `cd plugins/memory-vault/engine && python -m pytest tests/test_cli.py -v` exits 0

## Verify

```bash
cd plugins/memory-vault/engine && python -m pytest tests/test_cli.py -v -k "setup or audit"
```

## Scope Exclusions

- Does NOT test the full 11-step setup (hook/cron steps are I3)
- Does NOT test setup failure recovery (Adj-W4 is verified by idempotency)
- Does NOT test manual timing (V-10, A-E1 are Manual eval type)
