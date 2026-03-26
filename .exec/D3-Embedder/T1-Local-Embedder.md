# D3-T1: Local Embedder

## Identity

| Field | Value |
|---|---|
| Task ID | D3-T1 |
| Deliverable | D3: Embedder |
| Spec Version | v1 |
| Plan Section | plan.md L931-L1050 |
| Agent Pattern | Single Agent |
| Agent Model | Sonnet |
| Status | blocked |
| Rework Count | 0 |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| N-I2 | Local embedder returns 384 floats | Deterministic | 384 dims |
| Adj-I3 | Local embedder <3s cold, <200ms warm | Deterministic | <3s / <200ms |
| A-S4 | Embedding failure degrades to FTS5 | Deterministic | FTS5 results returned |

## Acceptance Criteria

- [ ] AC-1: embed("test") returns a list of 384 floats
- [ ] AC-2: embed_batch(["a", "b"]) returns 2 vectors of 384 floats each
- [ ] AC-3: dimensions() returns 384
- [ ] AC-4: model_name() contains "MiniLM"
- [ ] AC-5: Warm embed completes in <200ms
- [ ] AC-6: Nonexistent model raises EmbedderUnavailable
- [ ] AC-7: All 6 test_embedder.py tests pass

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] Code reviewed (self-review or peer)
- [ ] No regressions in dependent tasks
- [ ] status.json updated to "done"
- [ ] WMS synced

## References

| Reference | Location |
|---|---|
| Plan Section | plan.md L931-L1050 |
| Spec ACs | vana-spec.md §4.1 (N-I2), §5.2 (Adj-I3), §3.1 (A-S4) |
| Related Tasks | D1-T2 (blocked_by), D4-T1 (blocks — manager needs embedder) |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| D1-T2 | plugins/memory-vault/engine/pyproject.toml | Package with sentence-transformers dep | `pip install -e .` |
| Caller | text: str | Arbitrary text | Non-empty string |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| D4-T1 (MemoryManager) | plugins/memory-vault/engine/src/memory_engine/embedder.py | LocalEmbedder class + EmbedderUnavailable | `python -c "from memory_engine.embedder import LocalEmbedder"` |
| D4-T1 | embed(text) -> list[float] | 384-element list of floats | `len(vec) == 384` |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocked_by | D1-T2 | Package must be installable (sentence-transformers available) |
| blocks | D4-T1 | MemoryManager depends on embedder |

## Environment

| Prerequisite | Verify Command |
|---|---|
| Package installed | `python3 -c "import memory_engine"` |
| sentence-transformers available | `python3 -c "import sentence_transformers"` |
| ~400MB disk for model cache | `df -h ~/.cache/` |

## Increments

### INC-1: Write Failing Tests

**Input:** Plan section L937-L980
**Action:** Create tests/test_embedder.py with 6 tests
**Output:** `plugins/memory-vault/engine/tests/test_embedder.py`
**Verify:** `python -m pytest tests/test_embedder.py -v` exits FAIL

### INC-2: Implement LocalEmbedder

**Input:** Plan section L987-L1038
**Action:** Create src/memory_engine/embedder.py with LocalEmbedder class and EmbedderUnavailable exception
**Output:** `plugins/memory-vault/engine/src/memory_engine/embedder.py`
**Verify:** `python -c "from memory_engine.embedder import LocalEmbedder"`

### INC-3: Verify Tests Pass

**Input:** INC-1 + INC-2
**Action:** Run test suite (first run downloads ~80MB model)
**Output:** 6/6 tests passing
**Verify:** `cd plugins/memory-vault/engine && python -m pytest tests/test_embedder.py -v` exits 0

## Verify

```bash
cd plugins/memory-vault/engine && python -m pytest tests/test_embedder.py -v
```

## Scope Exclusions

- Does NOT implement API embedder (that's I2 — N-I4)
- Does NOT implement auto-fallback from API to local (that's I2 — Adj-I5)
- Does NOT embed at write time (MemoryManager D4-T1 handles that)
