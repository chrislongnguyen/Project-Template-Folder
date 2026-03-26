# D1: Package Scaffolding + Data Models

## Identity

| Field | Value |
|---|---|
| Deliverable ID | D1 |
| Project | LTC Memory Engine v2.0 (I1) |
| Spec Version | v1 |
| Plan Section | plan.md L40-L268 |
| Agent Architecture | Single Agent |
| Status | ready |

## VANA Sentence

Every LTC-configured AI agent can `pip install -e .` the memory-engine package and import all data models (MemoryUnit, TokenUsage, ConversationRow) — with a minimal 2-parameter constructor interface.

## Acceptance Criteria

| AC ID | Criteria | Eval Type | Covered By Tasks |
|---|---|---|---|
| Adj-W1 | MemoryManager constructor takes only `db_path` and `embedder` — no hidden configuration | Deterministic | D1-T1 |
| V-10 | Human installs the engine (`pip install -e .` + `memory setup`) in under 5 minutes | Manual | D1-T2 |

## Child Tasks

| Task ID | Name | Status | Dependencies |
|---|---|---|---|
| D1-T1 | Data Models | ready | — |
| D1-T2 | Package Scaffolding | ready | D1-T1 |

## Scope

- **In scope:** pyproject.toml, src/memory_engine/__init__.py, models.py (MemoryUnit, TokenUsage, ConversationRow), conftest.py with shared fixtures
- **Out of scope:** storage, embedder, CLI, config — those are D2-D5
