# D1-T2: Package Scaffolding

## Identity

| Field | Value |
|---|---|
| Task ID | D1-T2 |
| Deliverable | D1: Package Scaffolding + Data Models |
| Spec Version | v1 |
| Plan Section | plan.md L184-L268 |
| Agent Pattern | Single Agent |
| Agent Model | Opus |
| Status | blocked |
| Rework Count | 0 |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| V-10-pre | pip install -e . succeeds — prerequisite for V-10 (full install owned by D5-T2) | Deterministic | Exit 0 |

## Acceptance Criteria

- [ ] AC-1: `pip install -e ".[dev]"` succeeds without error
- [ ] AC-2: `python -c "from memory_engine import MemoryUnit; print('OK')"` prints OK
- [ ] AC-3: pyproject.toml declares all required dependencies (sqlite-vec, sentence-transformers, click, tiktoken, tomli, tomli_w)
- [ ] AC-4: conftest.py provides tmp_db_path and tmp_config_dir fixtures
- [ ] AC-5: `memory` entry point is registered via pyproject.toml [project.scripts]

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] Code reviewed (self-review or peer)
- [ ] No regressions in dependent tasks
- [ ] status.json updated to "done"
- [ ] WMS synced

## References

| Reference | Location |
|---|---|
| Plan Section | plan.md L184-L268 |
| Spec ACs | vana-spec.md §2 (V-10) |
| Related Tasks | D1-T1 (blocked_by), D2-T1, D2-T2, D3-T1 (blocks) |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| D1-T1 | plugins/memory-vault/engine/src/memory_engine/__init__.py | Python module | Import succeeds |
| D1-T1 | plugins/memory-vault/engine/src/memory_engine/models.py | 3 dataclasses | Import succeeds |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| D2-T1, D2-T2, D3-T1, D4-T1, D5-T1 | plugins/memory-vault/engine/pyproject.toml | TOML with [project] and [project.scripts] | `pip install -e .` succeeds |
| All test tasks | plugins/memory-vault/engine/tests/conftest.py | pytest fixtures | `python -m pytest --co tests/conftest.py` |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocked_by | D1-T1 | models.py and __init__.py must exist |
| blocks | D2-T1 | Package must be installable |
| blocks | D2-T2 | Package must be installable |
| blocks | D3-T1 | Package must be installable |

## Environment

| Prerequisite | Verify Command |
|---|---|
| Python >= 3.10 | `python3 --version` |
| pip available | `python3 -m pip --version` |

## Increments

### INC-1: Create pyproject.toml

**Input:** Plan section L190-L219
**Action:** Create pyproject.toml with all dependencies and entry points
**Output:** `plugins/memory-vault/engine/pyproject.toml`
**Verify:** File is valid TOML

### INC-2: Create conftest.py

**Input:** Plan section L221-L251
**Action:** Create shared pytest fixtures (tmp_db_path, tmp_config_dir)
**Output:** `plugins/memory-vault/engine/tests/conftest.py`
**Verify:** `python -m pytest --co tests/conftest.py`

### INC-3: Install and Verify

**Input:** INC-1 pyproject.toml + D1-T1 outputs
**Action:** Run pip install -e ".[dev]" and verify imports
**Output:** Installed package
**Verify:** `pip install -e ".[dev]" && python -c "from memory_engine import MemoryUnit; print('OK')"`

## Verify

```bash
cd plugins/memory-vault/engine && pip install -e ".[dev]" && python -c "from memory_engine import MemoryUnit, TokenUsage, ConversationRow; print('Package OK')" && python -m pytest tests/test_models.py -v
```

## Scope Exclusions

- Does NOT implement any business logic (storage, embedder, manager, CLI)
- Does NOT install or verify sentence-transformers model download (that's D3)
- Does NOT create config.toml (that's D2-T1)
