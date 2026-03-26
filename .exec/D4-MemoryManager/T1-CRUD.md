# D4-T1: MemoryManager CRUD

## Identity

| Field | Value |
|---|---|
| Task ID | D4-T1 |
| Deliverable | D4: MemoryManager |
| Spec Version | v1 |
| Plan Section | plan.md L1073-L1449 |
| Agent Pattern | Single Agent |
| Agent Model | Opus |
| Status | blocked |
| Rework Count | 0 |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| V-1 | Agent stores memory unit (7 types) | Deterministic | 7/7 round-trips |
| V-5 | Agent updates memory by ID | Deterministic | Content updated, ID unchanged |
| V-6 | Agent deletes memory by ID | Deterministic | Read returns empty |
| N-W1 | Single MemoryManager class with CRUD for all 7 types | Deterministic | 100% method coverage |
| Adj-W1 | Constructor takes only db_path and embedder | Deterministic | 2 required params |

## Acceptance Criteria

- [ ] AC-1: MemoryManager(db_path, embedder) constructor accepts exactly 2 required params
- [ ] AC-2: write_knowledge + read_knowledge round-trip returns MemoryUnit with type="knowledge"
- [ ] AC-3: write_workflow + read_workflow returns results
- [ ] AC-4: write_entity + read_entity returns results
- [ ] AC-5: write_conversation + read_conversation returns ConversationRow with correct role
- [ ] AC-6: update_knowledge changes content, preserves ID
- [ ] AC-7: delete_knowledge removes entry (read returns no match)
- [ ] AC-8: All 7 types writable without error (write_knowledge, write_workflow, write_entity, write_conversation, write_summary, write_toolbox, write_tool_log)
- [ ] AC-9: stats() returns counts per table and db_size_bytes
- [ ] AC-10: All 9 test_manager.py tests pass

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] Code reviewed (self-review or peer)
- [ ] No regressions in dependent tasks
- [ ] status.json updated to "done"
- [ ] WMS synced

## References

| Reference | Location |
|---|---|
| Plan Section | plan.md L1073-L1449 |
| Spec ACs | vana-spec.md §2 (V-1, V-5, V-6), §4.2 (N-W1), §5.1 (Adj-W1) |
| Related Tasks | D2-T2 (blocked_by), D3-T1 (blocked_by), D4-T2 (blocks), D4-T3 (blocks), D5-T1 (blocks) |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| D2-T2 | plugins/memory-vault/engine/src/memory_engine/storage.py | Storage class | `from memory_engine.storage import Storage` |
| D3-T1 | plugins/memory-vault/engine/src/memory_engine/embedder.py | LocalEmbedder class | `from memory_engine.embedder import LocalEmbedder` |
| D1-T1 | plugins/memory-vault/engine/src/memory_engine/models.py | MemoryUnit, ConversationRow | Import succeeds |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| D4-T2, D4-T3, D5-T1 | plugins/memory-vault/engine/src/memory_engine/manager.py | MemoryManager class | `from memory_engine.manager import MemoryManager` |
| D5-T1 | MemoryManager.write_*/read_*/update_*/delete_* methods | Typed method signatures | Unit tests pass |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocked_by | D2-T2 | Storage class must exist |
| blocked_by | D3-T1 | LocalEmbedder must exist |
| blocks | D4-T2 | Search tests need CRUD methods |
| blocks | D4-T3 | Validation needs write methods to hook into |
| blocks | D5-T1 | CLI wraps MemoryManager |

## Environment

| Prerequisite | Verify Command |
|---|---|
| Package installed with deps | `python3 -c "from memory_engine.storage import Storage; from memory_engine.embedder import LocalEmbedder"` |
| Embedding model cached | `python3 -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('all-MiniLM-L6-v2')"` |

## Increments

### INC-1: Write Failing Tests

**Input:** Plan section L1079-L1157
**Action:** Create tests/test_manager.py with 9 test functions + manager fixture
**Output:** `plugins/memory-vault/engine/tests/test_manager.py`
**Verify:** `python -m pytest tests/test_manager.py -v` exits FAIL

### INC-2: Implement MemoryManager

**Input:** Plan section L1164-L1437
**Action:** Create src/memory_engine/manager.py with MemoryManager class, all CRUD methods, _embed helper, _search helper, stats()
**Output:** `plugins/memory-vault/engine/src/memory_engine/manager.py`
**Verify:** `python -c "from memory_engine.manager import MemoryManager"`

### INC-3: Verify Tests Pass

**Input:** INC-1 + INC-2
**Action:** Run test suite
**Output:** 9/9 tests passing
**Verify:** `cd plugins/memory-vault/engine && python -m pytest tests/test_manager.py -v` exits 0

## Verify

```bash
cd plugins/memory-vault/engine && python -m pytest tests/test_manager.py -v
```

## Scope Exclusions

- Does NOT implement secret scanning or dedup (that's D4-T3)
- Does NOT implement build_context() (I2 scope)
- Does NOT implement enrichment (I2 scope)
- Does NOT implement summarize/expand (I2 scope)
