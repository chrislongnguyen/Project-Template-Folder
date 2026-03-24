# D5-T1: Core CLI Commands

## Identity

| Field | Value |
|---|---|
| Task ID | D5-T1 |
| Deliverable | D5: Click CLI |
| Spec Version | v1 |
| Plan Section | plan.md L1636-L1871 |
| Agent Pattern | Single Agent |
| Agent Model | Opus |
| Status | blocked |
| Rework Count | 0 |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| N-W2 | CLI with all required commands and flags | Deterministic | All commands present |
| Adj-W2 | --help with usage examples | Deterministic | All commands have examples |
| Adj-W3 | Exit 1 + fix suggestion on error | Deterministic | Present |

## Acceptance Criteria

- [ ] AC-1: `memory write knowledge "content" --tag x` writes and returns ID
- [ ] AC-2: `memory read knowledge "query" -k 1 --json` returns JSON array
- [ ] AC-3: `memory stats --json` returns JSON with counts and total
- [ ] AC-4: `memory stats` output ≤ 30 lines
- [ ] AC-5: `memory write --help`, `memory read --help`, `memory stats --help` contain "example" or "Example"
- [ ] AC-6: Writing content < 10 chars exits 1 with "at least" or "10 char" in output
- [ ] AC-7: `memory delete knowledge <id>` removes the entry
- [ ] AC-8: `memory update knowledge <id> "new"` updates the entry
- [ ] AC-9: All 7 test_cli.py tests pass

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] Code reviewed (self-review or peer)
- [ ] No regressions in dependent tasks
- [ ] status.json updated to "done"
- [ ] WMS synced

## References

| Reference | Location |
|---|---|
| Plan Section | plan.md L1636-L1871 |
| Spec ACs | vana-spec.md §4.2 (N-W2), §5.1 (Adj-W2, Adj-W3) |
| Related Tasks | D2-T1 (blocked_by), D4-T1 (blocked_by), D4-T3 (blocked_by), D5-T2 (blocks) |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| D2-T1 | src/memory_engine/config.py | Config + load_config | Import succeeds |
| D4-T1 | src/memory_engine/manager.py | MemoryManager | Import succeeds |
| D4-T3 | manager.py with validation | ValueError on secrets/dupes | Validation tests pass |
| User | CLI args | Click argument grammar | Click validates |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| D5-T2, D6-T1 | src/memory_engine/cli.py | Click group with main() entry | `python -c "from memory_engine.cli import main"` |
| User | stdout | Human text or JSON (--json) | Valid JSON when --json |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocked_by | D2-T1 | Config module for default db_path |
| blocked_by | D4-T1 | MemoryManager for all operations |
| blocked_by | D4-T3 | Validation for error messages |
| blocks | D5-T2 | Setup command needs CLI framework |

## Environment

| Prerequisite | Verify Command |
|---|---|
| All D1-D4 tasks complete | `python -m pytest tests/ -v` passes all |
| click installed | `python3 -c "import click"` |

## Increments

### INC-1: Write Failing Tests

**Input:** Plan section L1642-L1729
**Action:** Create tests/test_cli.py with 7 test functions
**Output:** `plugins/memory-vault/engine/tests/test_cli.py`
**Verify:** `python -m pytest tests/test_cli.py -v` exits FAIL

### INC-2: Implement CLI

**Input:** Plan section L1736-L2103
**Action:** Create src/memory_engine/cli.py with Click group (main, write, read, update, delete, stats, audit, config, setup)
**Output:** `plugins/memory-vault/engine/src/memory_engine/cli.py`
**Verify:** `python -c "from memory_engine.cli import main"`

### INC-3: Verify Tests Pass

**Input:** INC-1 + INC-2
**Action:** Run CLI test suite
**Output:** 7/7 tests passing
**Verify:** `cd plugins/memory-vault/engine && python -m pytest tests/test_cli.py -v` exits 0

## Verify

```bash
cd plugins/memory-vault/engine && python -m pytest tests/test_cli.py -v
```

## Scope Exclusions

- Does NOT implement `memory import` (I3 scope)
- Does NOT implement `memory teardown` (I4 scope)
- Does NOT register hooks or cron (I3 scope)
- Does NOT implement `--quiet` mode (deferred to when needed)
