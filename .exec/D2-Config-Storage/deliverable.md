# D2: Config + Storage Layer

## Identity

| Field | Value |
|---|---|
| Deliverable ID | D2 |
| Project | LTC Memory Engine v2.0 (I1) |
| Spec Version | v1 |
| Plan Section | plan.md L272-L911 |
| Agent Architecture | Single Agent |
| Status | blocked |

## VANA Sentence

Every LTC-configured AI agent can load TOML configuration and store/retrieve memory units in a SQLite database with WAL mode, FTS5 full-text search, and atomic transaction guarantees.

## Acceptance Criteria

| AC ID | Criteria | Eval Type | Covered By Tasks |
|---|---|---|---|
| N-I3 | TOML config at ~/.config/memory-engine/config.toml with all required keys | Deterministic | D2-T1 |
| Adj-I4 | Config is human-readable TOML; every field has a comment | Deterministic | D2-T1 |
| N-I1 | SQLite DB with WAL, FTS5, sqlite-vec, 7+ tables | Deterministic | D2-T2 |
| Adj-I1 | Database is single-file, zero-server, portable | Deterministic | D2-T2 |
| Adj-I2 | Database enables WAL mode at creation automatically | Deterministic | D2-T2 |
| A-S1 | Memory writes are atomic — partial writes never persist | Deterministic | D2-T2 |

## Child Tasks

| Task ID | Name | Status | Dependencies |
|---|---|---|---|
| D2-T1 | Config Module | blocked | D1-T2 |
| D2-T2 | Storage Layer | blocked | D1-T2 |

## Scope

- **In scope:** config.py (TOML load/save/defaults), storage.py (SQLite + WAL + FTS5 + CRUD + vector_search), 7 memory tables + 3 FTS virtual tables + triggers
- **Out of scope:** embedder integration (D3), MemoryManager business logic (D4), CLI (D5)
