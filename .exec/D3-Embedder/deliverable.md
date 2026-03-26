# D3: Embedder

## Identity

| Field | Value |
|---|---|
| Deliverable ID | D3 |
| Project | LTC Memory Engine v2.0 (I1) |
| Spec Version | v1 |
| Plan Section | plan.md L914-L1050 |
| Agent Architecture | Single Agent |
| Status | blocked |

## VANA Sentence

Every LTC-configured AI agent can embed text into 384-dimensional vectors using a locally-loaded sentence-transformers model, with lazy loading and graceful fallback to FTS5 when unavailable.

## Acceptance Criteria

| AC ID | Criteria | Eval Type | Covered By Tasks |
|---|---|---|---|
| N-I2 | all-MiniLM-L6-v2 model, embed("test") returns 384 floats | Deterministic | D3-T1 |
| Adj-I3 | Local embedder loads <3s cold, <200ms warm | Deterministic | D3-T1 |
| A-S4 | Embedding failure degrades to FTS5-only (never blocks reads/writes) | Deterministic | D3-T1 |

## Child Tasks

| Task ID | Name | Status | Dependencies |
|---|---|---|---|
| D3-T1 | Local Embedder | blocked | D1-T2 |

## Scope

- **In scope:** embedder.py (LocalEmbedder class, EmbedderUnavailable exception, lazy loading, embed/embed_batch/dimensions/model_name)
- **Out of scope:** API embedder (I2 scope — N-I4), enrichment (I2 scope — N-W6)
