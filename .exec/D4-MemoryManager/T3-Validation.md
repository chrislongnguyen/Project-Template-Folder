# D4-T3: Secret Scanning + Dedup Detection

## Identity

| Field | Value |
|---|---|
| Task ID | D4-T3 |
| Deliverable | D4: MemoryManager |
| Spec Version | v1 |
| Plan Section | plan.md L1524-L1614 |
| Agent Pattern | Single Agent |
| Agent Model | Sonnet |
| Status | blocked |
| Rework Count | 0 |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| A-S2 | Secret patterns rejected at write time | Deterministic | All patterns caught |
| A-S3 | Duplicate detection rejects >0.95 cosine similarity | Deterministic | Duplicate blocked |

## Acceptance Criteria

- [ ] AC-1: write_knowledge with "sk-proj-abc123def456" raises ValueError matching "secret"
- [ ] AC-2: write_knowledge with "AKIAIOSFODNN7EXAMPLE" raises ValueError matching "secret"
- [ ] AC-3: write_knowledge with "ghp_abc123def456ghi789" raises ValueError matching "secret"
- [ ] AC-4: Writing identical content twice raises ValueError matching "duplicate"
- [ ] AC-5: _SECRET_PATTERNS list covers OpenAI/Anthropic, AWS, GitHub PAT, GitHub OAuth, GitLab, Slack, private keys
- [ ] AC-6: All 2 new validation tests pass (added to test_manager.py)

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] Code reviewed (self-review or peer)
- [ ] No regressions in dependent tasks (existing tests still pass)
- [ ] status.json updated to "done"
- [ ] WMS synced

## References

| Reference | Location |
|---|---|
| Plan Section | plan.md L1524-L1614 |
| Spec ACs | vana-spec.md §3.1 (A-S2, A-S3) |
| Related Tasks | D4-T1 (blocked_by), D5-T1 (blocks — CLI surfaces validation errors) |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| D4-T1 | plugins/memory-vault/engine/src/memory_engine/manager.py | MemoryManager with write_* methods | Import succeeds |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| D5-T1 (CLI) | Modified manager.py with _check_secrets, _check_duplicate methods | ValueError raised with descriptive message | Tests pass |
| D6-T1 | Updated tests/test_manager.py with 2 validation tests | `python -m pytest tests/test_manager.py -v` |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocked_by | D4-T1 | Write methods must exist to add validation hooks |
| blocks | D5-T1 | CLI needs to surface validation errors |

## Environment

| Prerequisite | Verify Command |
|---|---|
| D4-T1 complete | `python -m pytest tests/test_manager.py -v` passes |

## Increments

### INC-1: Add Validation Tests

**Input:** Plan section L1530-L1549
**Action:** Append 2 tests to tests/test_manager.py (secret detection, dedup detection)
**Output:** Updated tests/test_manager.py
**Verify:** Tests fail (validation not yet implemented)

### INC-2: Implement Validation Methods

**Input:** Plan section L1556-L1601
**Action:** Add _SECRET_PATTERNS, _check_secrets(), _check_duplicate() to manager.py; hook into write_* methods
**Output:** Modified manager.py
**Verify:** `python -c "from memory_engine.manager import MemoryManager"`

### INC-3: Verify All Tests Pass

**Input:** INC-1 + INC-2
**Action:** Run full test_manager.py suite
**Output:** 16/16 tests passing (9 original + 5 search/perf + 2 validation)
**Verify:** `cd plugins/memory-vault/engine && python -m pytest tests/test_manager.py -v` exits 0

## Verify

```bash
cd plugins/memory-vault/engine && python -m pytest tests/test_manager.py -v -k "secret or duplicate"
```

## Scope Exclusions

- Does NOT implement enrichment validation (I2 — A-S6)
- Does NOT implement configurable dedup threshold (hardcoded 0.95 for I1)
- Does NOT add --force flag to bypass dedup (CLI will add this later if needed)
