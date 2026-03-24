# D4: MemoryManager

## Identity

| Field | Value |
|---|---|
| Deliverable ID | D4 |
| Project | LTC Memory Engine v2.0 (I1) |
| Spec Version | v1 |
| Plan Section | plan.md L1054-L1614 |
| Agent Architecture | Single Agent |
| Status | blocked |

## VANA Sentence

Every LTC-configured AI agent can write, read, update, and delete memories across all 7 types through a single MemoryManager class, with hybrid search (vector + FTS5), secret scanning, and duplicate detection.

## Acceptance Criteria

| AC ID | Criteria | Eval Type | Covered By Tasks |
|---|---|---|---|
| V-1 | Agent stores a memory unit (any of 7 types) | Deterministic | D4-T1 |
| V-5 | Agent updates an existing memory unit by ID | Deterministic | D4-T1 |
| V-6 | Agent deletes a memory unit by ID | Deterministic | D4-T1 |
| N-W1 | Single MemoryManager class with CRUD for all 7 types | Deterministic | D4-T1 |
| Adj-W1 | Constructor takes only db_path and embedder | Deterministic | D4-T1 |
| V-2 | Vector search returns correct top-1 (80%) | Deterministic | D4-T2 |
| V-3 | Lexical search returns correct top-1 (80%) | Deterministic | D4-T2 |
| V-4 | Hybrid >= max(vector, lexical) | Deterministic | D4-T2 |
| A-E2 | Single write < 200ms | Deterministic | D4-T2 |
| A-E3 | Single read (top-5) < 100ms | Deterministic | D4-T2 |
| A-S2 | Secret patterns rejected at write time | Deterministic | D4-T3 |
| A-S3 | Duplicate detection rejects >0.95 cosine similarity | Deterministic | D4-T3 |

## Child Tasks

| Task ID | Name | Status | Dependencies |
|---|---|---|---|
| D4-T1 | MemoryManager CRUD | blocked | D2-T2, D3-T1 |
| D4-T2 | Search Quality + Performance | blocked | D4-T1 |
| D4-T3 | Secret Scanning + Dedup Detection | blocked | D4-T1 |

## Scope

- **In scope:** manager.py (MemoryManager class, CRUD for 7 types, hybrid search, secret scanning, dedup detection, stats)
- **Out of scope:** build_context() (I2 — V-7, N-W5), enrichment (I2 — N-W6), summarize/expand (I2 — V-8, V-9)
