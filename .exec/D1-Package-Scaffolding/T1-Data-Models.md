# D1-T1: Data Models

## Identity

| Field | Value |
|---|---|
| Task ID | D1-T1 |
| Deliverable | D1: Package Scaffolding + Data Models |
| Spec Version | v1 |
| Plan Section | plan.md L58-L183 |
| Agent Pattern | Single Agent |
| Agent Model | Opus |
| Status | ready |
| Rework Count | 0 |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| N-W1-pre | Data model classes (MemoryUnit, TokenUsage, ConversationRow) importable — prerequisite for N-W1 | Deterministic | 3 classes importable |

## Acceptance Criteria

- [ ] AC-1: MemoryUnit, TokenUsage, ConversationRow dataclasses are importable from `memory_engine.models`
- [ ] AC-2: MemoryUnit.to_dict() returns a JSON-serializable dict
- [ ] AC-3: TokenUsage.status accepts "green", "yellow", "red"
- [ ] AC-4: ConversationRow.summary_id is Optional[str] defaulting to None
- [ ] AC-5: All 4 test_models.py tests pass

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] Code reviewed (self-review or peer)
- [ ] No regressions in dependent tasks
- [ ] status.json updated to "done"
- [ ] WMS synced

## References

| Reference | Location |
|---|---|
| Plan Section | plan.md L58-L183 |
| Spec ACs | vana-spec.md §5.1 (Adj-W1) |
| Related Tasks | D1-T2 (depends on this) |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| Plan specification | docs/superpowers/plans/2026-03-22-ltc-memory-engine-v2-i1.md L58-L183 | Markdown with code blocks | Plan must be frozen |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| D1-T2 (Package Scaffolding) | plugins/memory-vault/engine/src/memory_engine/__init__.py | Python module with __version__ and exports | `python -c "from memory_engine import MemoryUnit"` |
| D1-T2, D2-T2, D4-T1 | plugins/memory-vault/engine/src/memory_engine/models.py | 3 dataclasses: MemoryUnit, TokenUsage, ConversationRow | `python -m pytest tests/test_models.py -v` |
| D1-T2 | plugins/memory-vault/engine/tests/test_models.py | 4 pytest tests | Exit code 0 |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocks | D1-T2 | models.py must exist for package to be importable |

## Environment

| Prerequisite | Verify Command |
|---|---|
| Python >= 3.10 | `python3 --version` |
| pytest installed | `python3 -m pytest --version` |

## Increments

### INC-1: Write Failing Tests

**Input:** Plan section L58-L110 (test code blocks)
**Action:** Create `tests/test_models.py` with 4 test functions
**Output:** `plugins/memory-vault/engine/tests/test_models.py`
**Verify:** `python -m pytest tests/test_models.py -v` exits with FAIL (ImportError)

### INC-2: Implement Models

**Input:** Plan section L117-L160 (models.py code)
**Action:** Create `src/memory_engine/models.py` with MemoryUnit, TokenUsage, ConversationRow dataclasses
**Output:** `plugins/memory-vault/engine/src/memory_engine/models.py`
**Verify:** `python -c "from memory_engine.models import MemoryUnit"` succeeds

### INC-3: Create __init__.py

**Input:** Plan section L162-L170
**Action:** Create `src/memory_engine/__init__.py` with version and exports
**Output:** `plugins/memory-vault/engine/src/memory_engine/__init__.py`
**Verify:** `python -c "from memory_engine import MemoryUnit; print('OK')"` prints OK

### INC-4: Verify Tests Pass

**Input:** INC-1 tests + INC-2/3 implementation
**Action:** Run test suite
**Output:** 4/4 tests passing
**Verify:** `cd plugins/memory-vault/engine && python -m pytest tests/test_models.py -v` exits 0

## Verify

```bash
cd plugins/memory-vault/engine && python -m pytest tests/test_models.py -v && python -c "from memory_engine import MemoryUnit, TokenUsage, ConversationRow; print('All models importable')"
```

## Scope Exclusions

- Does NOT create pyproject.toml (that's T1.2)
- Does NOT create conftest.py (that's T1.2)
- Does NOT implement storage, config, or CLI logic
