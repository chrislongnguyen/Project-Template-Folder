# D2-T2: Storage Layer

## Identity

| Field | Value |
|---|---|
| Task ID | D2-T2 |
| Deliverable | D2: Config + Storage Layer |
| Spec Version | v1 |
| Plan Section | plan.md L488-L911 |
| Agent Pattern | Single Agent |
| Agent Model | Opus |
| Status | blocked |
| Rework Count | 0 |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| N-I1 | SQLite DB with WAL, FTS5, sqlite-vec, 7+ tables | Deterministic | 7+ tables, WAL enabled |
| Adj-I1 | Database is single-file, zero-server, portable | Deterministic | Single file, no server |
| Adj-I2 | Database enables WAL mode at creation automatically | Deterministic | PRAGMA journal_mode returns "wal" |
| A-S1 | Memory writes are atomic — partial writes never persist | Deterministic | 0 partial rows after simulated crash |

## Acceptance Criteria

- [ ] AC-1: init_db() creates 7 base tables (conversations, knowledge, workflows, entities, summaries, toolbox, tool_logs)
- [ ] AC-2: PRAGMA journal_mode returns "wal" after init
- [ ] AC-3: FTS5 virtual tables created (knowledge_fts, workflows_fts, entities_fts) with triggers
- [ ] AC-4: write() + read() round-trip preserves content
- [ ] AC-5: Simulated error during write leaves 0 partial rows (atomic)
- [ ] AC-6: update() modifies content by ID
- [ ] AC-7: delete() removes row by ID
- [ ] AC-8: fts_search() returns matching rows by keyword
- [ ] AC-9: All 8 test_storage.py tests pass

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] Code reviewed (self-review or peer)
- [ ] No regressions in dependent tasks
- [ ] status.json updated to "done"
- [ ] WMS synced

## References

| Reference | Location |
|---|---|
| Plan Section | plan.md L488-L911 |
| Spec ACs | vana-spec.md §4.1 (N-I1), §5.1 (Adj-I1, Adj-I2), §3.1 (A-S1) |
| Related Tasks | D1-T2 (blocked_by), D4-T1 (blocks — manager needs storage) |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| D1-T2 | plugins/memory-vault/engine/pyproject.toml | Package with sqlite-vec dep | `pip install -e .` |
| Caller | db_path: str | File path | Path.parent exists |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| D4-T1 (MemoryManager) | plugins/memory-vault/engine/src/memory_engine/storage.py | Storage class with init_db, write, read, update, delete, fts_search, vector_search, count, close | `python -c "from memory_engine.storage import Storage"` |
| Runtime | SQLite database file | 7 tables + 3 FTS + WAL | `PRAGMA journal_mode` returns "wal" |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocked_by | D1-T2 | Package must be installable |
| blocks | D4-T1 | MemoryManager depends on Storage class |

## Environment

| Prerequisite | Verify Command |
|---|---|
| Package installed | `python3 -c "import memory_engine"` |
| sqlite3 available | `python3 -c "import sqlite3; print(sqlite3.sqlite_version)"` |

## Increments

### INC-1: Write Failing Tests

**Input:** Plan section L494-L598
**Action:** Create tests/test_storage.py with 8 tests
**Output:** `plugins/memory-vault/engine/tests/test_storage.py`
**Verify:** `python -m pytest tests/test_storage.py -v` exits FAIL

### INC-2: Implement Storage Class

**Input:** Plan section L605-L898
**Action:** Create src/memory_engine/storage.py with Storage class, table schemas, FTS schemas, FTS triggers
**Output:** `plugins/memory-vault/engine/src/memory_engine/storage.py`
**Verify:** `python -c "from memory_engine.storage import Storage"`

### INC-3: Verify Tests Pass

**Input:** INC-1 + INC-2
**Action:** Run test suite
**Output:** 8/8 tests passing
**Verify:** `cd plugins/memory-vault/engine && python -m pytest tests/test_storage.py -v` exits 0

## Verify

```bash
cd plugins/memory-vault/engine && python -m pytest tests/test_storage.py -v
```

## Scope Exclusions

- Does NOT implement vector_search end-to-end (sqlite-vec virtual table creation is deferred to when sqlite-vec is confirmed available)
- Does NOT implement MemoryManager business logic (that's D4)
- Does NOT handle config loading (Storage takes raw db_path, not Config object)
