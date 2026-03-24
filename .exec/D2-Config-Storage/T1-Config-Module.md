# D2-T1: Config Module

## Identity

| Field | Value |
|---|---|
| Task ID | D2-T1 |
| Deliverable | D2: Config + Storage Layer |
| Spec Version | v1 |
| Plan Section | plan.md L290-L486 |
| Agent Pattern | Single Agent |
| Agent Model | Sonnet |
| Status | blocked |
| Rework Count | 0 |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| N-I3 | TOML config at ~/.config/memory-engine/config.toml with all required keys | Deterministic | File exists, parseable, keys present |
| Adj-I4 | Config is human-readable TOML; every field has a comment | Deterministic | All keys have comments |

## Acceptance Criteria

- [ ] AC-1: DEFAULT_CONFIG dict contains all required keys (database.path, embedder.backend, embedder.local_model, context.*, mirror.*, dedup.threshold)
- [ ] AC-2: save_config() + load_config() round-trips produce identical Config
- [ ] AC-3: load_config() returns None for missing files (not an exception)
- [ ] AC-4: Saved config file contains comment lines (# prefix)
- [ ] AC-5: All 4 test_config.py tests pass

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] Code reviewed (self-review or peer)
- [ ] No regressions in dependent tasks
- [ ] status.json updated to "done"
- [ ] WMS synced

## References

| Reference | Location |
|---|---|
| Plan Section | plan.md L290-L486 |
| Spec ACs | vana-spec.md §4.1 (N-I3), §5.1 (Adj-I4) |
| Related Tasks | D1-T2 (blocked_by), D5-T1 (blocks — CLI needs config) |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| D1-T2 | plugins/memory-vault/engine/pyproject.toml | Package with tomli/tomli_w deps | `pip install -e .` |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| D5-T1 (CLI) | plugins/memory-vault/engine/src/memory_engine/config.py | Config dataclass + load/save functions | `python -c "from memory_engine.config import Config"` |
| D5-T2 (Setup) | ~/.config/memory-engine/config.toml | TOML with comments | File parseable by tomllib |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocked_by | D1-T2 | Package must be installable (tomli/tomli_w available) |
| blocks | D5-T1 | CLI reads config for default db_path |

## Environment

| Prerequisite | Verify Command |
|---|---|
| Package installed | `python3 -c "import memory_engine"` |
| tomli_w available | `python3 -c "import tomli_w"` |

## Increments

### INC-1: Write Failing Tests

**Input:** Plan section L296-L337
**Action:** Create tests/test_config.py with 4 tests
**Output:** `plugins/memory-vault/engine/tests/test_config.py`
**Verify:** `python -m pytest tests/test_config.py -v` exits FAIL

### INC-2: Implement Config Module

**Input:** Plan section L344-L474
**Action:** Create src/memory_engine/config.py with Config dataclass, DEFAULT_CONFIG, load_config, save_config, _CONFIG_HEADER
**Output:** `plugins/memory-vault/engine/src/memory_engine/config.py`
**Verify:** `python -c "from memory_engine.config import Config, load_config, save_config"`

### INC-3: Verify Tests Pass

**Input:** INC-1 + INC-2
**Action:** Run test suite
**Output:** 4/4 tests passing
**Verify:** `cd plugins/memory-vault/engine && python -m pytest tests/test_config.py -v` exits 0

## Verify

```bash
cd plugins/memory-vault/engine && python -m pytest tests/test_config.py -v
```

## Scope Exclusions

- Does NOT create the config file on disk at install time (setup command does that, D5-T2)
- Does NOT validate config values beyond type (no range checking)
- Does NOT implement config CLI subcommand (that's D5-T1)
