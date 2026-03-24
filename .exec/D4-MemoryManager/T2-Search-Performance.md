# D4-T2: Search Quality + Performance

## Identity

| Field | Value |
|---|---|
| Task ID | D4-T2 |
| Deliverable | D4: MemoryManager |
| Spec Version | v1 |
| Plan Section | plan.md L1451-L1522 |
| Agent Pattern | Single Agent |
| Agent Model | Sonnet |
| Status | blocked |
| Rework Count | 0 |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| V-2 | Vector search returns correct top-1 | Deterministic | 80% accuracy |
| V-3 | Lexical search returns correct top-1 | Deterministic | 80% accuracy |
| V-4 | Hybrid >= max(vector, lexical) | Deterministic | hybrid >= best single |
| A-E2 | Single write < 200ms | Deterministic | < 200ms |
| A-E3 | Single read (top-5) < 100ms | Deterministic | < 100ms |

## Acceptance Criteria

- [ ] AC-1: Vector search finds semantically related content ("machine learning" finds "Python AI")
- [ ] AC-2: Lexical search finds exact keyword matches ("JWT tokens" finds JWT entry)
- [ ] AC-3: Hybrid search finds correct result for "SQLite WAL concurrent"
- [ ] AC-4: Single knowledge write completes in < 200ms
- [ ] AC-5: Single read (top-5) completes in < 100ms with warm embedder
- [ ] AC-6: All 5 new tests pass (added to test_manager.py)

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] Code reviewed (self-review or peer)
- [ ] No regressions in dependent tasks
- [ ] status.json updated to "done"
- [ ] WMS synced

## References

| Reference | Location |
|---|---|
| Plan Section | plan.md L1451-L1522 |
| Spec ACs | vana-spec.md §2 (V-2, V-3, V-4), §3.2 (A-E2, A-E3) |
| Related Tasks | D4-T1 (blocked_by) |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| D4-T1 | plugins/memory-vault/engine/src/memory_engine/manager.py | MemoryManager with CRUD | Import succeeds |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| D6-T1 (Integration) | plugins/memory-vault/engine/tests/test_manager.py (appended) | 5 additional pytest tests | `python -m pytest tests/test_manager.py -v` |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocked_by | D4-T1 | CRUD methods must work |

## Environment

| Prerequisite | Verify Command |
|---|---|
| D4-T1 complete | `python -m pytest tests/test_manager.py -v` passes (9 original tests) |
| Embedding model cached | `python3 -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('all-MiniLM-L6-v2')"` |

## Increments

### INC-1: Add Search Quality Tests

**Input:** Plan section L1456-L1510
**Action:** Append 5 tests to tests/test_manager.py (vector, lexical, hybrid, write perf, read perf)
**Output:** Updated tests/test_manager.py
**Verify:** Tests are syntactically correct

### INC-2: Verify All Tests Pass

**Input:** INC-1 + D4-T1 implementation
**Action:** Run full test_manager.py suite
**Output:** 14/14 tests passing
**Verify:** `cd plugins/memory-vault/engine && python -m pytest tests/test_manager.py -v` exits 0

## Verify

```bash
cd plugins/memory-vault/engine && python -m pytest tests/test_manager.py -v -k "search or performance"
```

## Scope Exclusions

- Does NOT modify MemoryManager code (tests only — validates existing search implementation)
- Does NOT test hybrid > single mode numerically (tests that correct result is found)
- Does NOT benchmark at scale (20 entries, not 1000+)
