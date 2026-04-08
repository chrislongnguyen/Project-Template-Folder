---
date: "2026-04-08"
type: capture
source: conversation
tags: [memory-system, comparison, s-e-sc, vinh-design]
---

# Vinh's AI AGENT MEMORY vs Our Auto Memory — S x E x Sc Analysis

## Source

Vinh's branch: `Vinh-ALPEI-AI-Operating-System-with-Obsidian/AI AGENT MEMORY/`
Our system: `~/.claude/projects/{hash}/memory/` + vault + hooks + ETL + QMD

## Architecture Overview

| | Vinh's System | Our System |
|---|---|---|
| **Location** | `AI AGENT MEMORY/` inside Obsidian vault (in-repo) | `~/.claude/projects/{hash}/memory/` (machine-local) + vault (Google Drive) |
| **Agents served** | ALL agents: Claude, Gemini, Cursor, Windsurf, Copilot | Claude Code only |
| **Storage model** | Obsidian-native markdown with `[[wikilinks]]` | Plain markdown + QMD semantic index |
| **Index file** | `MEMORY.md` (200 line limit) | `MEMORY.md` (60 line limit, 3-section enforced) |
| **Topic types** | 4: user, feedback, project, reference | 4: user, feedback, project, reference (identical) |
| **Capture** | Manual — agent writes after learning something | Manual (`/compress`) + Automatic (6 hooks + ETL) |
| **Recall** | Agent reads `MEMORY.md` at session start | Hooks inject at SessionStart + QMD every prompt |
| **Governance** | `RULES.md` (single source of truth for all agents) | `.claude/rules/memory-format.md` + memory-guard hook |

## Architecture Diagram

```
VINH'S SYSTEM                              OUR SYSTEM
(Multi-agent, Obsidian-native)             (Claude-only, vault+QMD)

┌──────────────────────────┐               ┌──────────────────────────┐
│  ANY AI Agent            │               │  Claude Code             │
│  (Claude/Gemini/Cursor/  │               │  (only)                  │
│   Windsurf/Copilot)      │               │                          │
└──────────┬───────────────┘               └──────────┬───────────────┘
           │                                          │
           │ read at startup                          │ hooks auto-inject
           ▼                                          ▼
┌──────────────────────────┐               ┌──────────────────────────┐
│  AI AGENT MEMORY/        │               │  ~/.claude/.../memory/   │
│  MEMORY.md (index)       │               │  MEMORY.md (index)       │
│  user/ feedback/         │  ←identical→  │  topic files             │
│  project/ reference/     │    types       │  (flat, no subdirs)     │
└──────────┬───────────────┘               └──────────┬───────────────┘
           │ [[wikilinks]]                            │
           ▼                                          ▼
┌──────────────────────────┐               ┌──────────────────────────┐
│  Obsidian Vault          │               │  Memory Vault            │
│  (iCloud sync)           │               │  (Google Drive sync)     │
│  - Dataview queries      │               │  - Session ETL (auto)    │
│  - Bases dashboards      │               │  - QMD semantic search   │
│  - Graph view            │               │  - State snapshots       │
│  - Human-browsable       │               │  - Secret redaction      │
└──────────────────────────┘               └──────────────────────────┘
```

## S x E x Sc Evaluation

### SUSTAINABILITY (Correctness, Safety, Risk)

| Criterion | Vinh | Ours | Winner |
|-----------|------|------|--------|
| Multi-agent safety | All 6 agents read/write same memory | Claude-only | **Vinh** |
| Secret exposure risk | No redaction | 5-pattern redaction + fail-closed | **Ours** |
| Crash recovery | None without manual save | state-saver (30s), ETL (10min), session-summary (Stop) | **Ours** |
| Structure corruption | No enforcement — any agent can malform | memory-guard hook blocks malformed writes | **Ours** |
| Data loss on repo move | Memory travels with repo | Keyed to absolute path — move = lose | **Vinh** |
| Human auditability | `[[wikilinks]]` + Obsidian graph view | Machine-local, no UI | **Vinh** |
| Derivable info discipline | Not explicitly stated | Explicit rule: "NEVER save derivable info" | **Ours** |

**Sustainability: TIE** — different risk profiles. Vinh optimizes for human access; ours for machine safety.

### EFFICIENCY (Throughput, Cost, Time)

| Criterion | Vinh | Ours | Winner |
|-----------|------|------|--------|
| Capture effort | Agent writes opportunistically | Zero effort — auto hooks + ETL | **Ours** |
| Recall token cost | ~1K tokens (MEMORY.md read) | ~4K tokens (hooks + QMD + state) | **Vinh** |
| Recall precision | Read everything in index | QMD semantic — returns only relevant | **Ours** |
| Setup cost | Drop folder in vault — all agents work | setup-member.sh + QMD + vault config per project | **Vinh** |
| Token cost per session | ~1K | ~4K | **Vinh** |
| Information density | Human-curated → high signal | Auto-captured → needs filtering | **Vinh** |

**Efficiency: VINH WINS** — lower tokens, higher signal density, simpler setup.

### SCALABILITY (Automation, Growth, Prediction)

| Criterion | Vinh | Ours | Winner |
|-----------|------|------|--------|
| Agent count | 6+ agents (strategic advantage) | Claude-only (critical gap) | **Vinh** |
| Project count | One memory per vault — shared | Separate per project (encoded path) | **Ours** |
| Session volume | Manual caps at ~1-3 saves/day | 459 files, 380MB auto-processed | **Ours** |
| Historical search | Obsidian search (keyword-only) | QMD semantic (BM25 + vector, 1,848 docs) | **Ours** |
| Zero-action capture | Requires initiative | 4 capture layers fire automatically | **Ours** |
| New member onboard | Copy vault — instant | Run setup per project per machine | **Vinh** |
| Predictive recall | None | QMD auto-recall per prompt | **Ours** |

**Scalability: SPLIT** — Vinh wins multi-agent (strategic). Ours wins volume + semantic search.

## Scores

```
                    VINH                           OURS
SUSTAINABILITY      ████████░░  (8/10)             ████████░░  (8/10)
EFFICIENCY          █████████░  (9/10)             ██████░░░░  (6/10)
SCALABILITY         ████████░░  (8/10)             ███████░░░  (7/10)
```

## Key Insight

Vinh's design makes a strategically correct bet: memory should be agent-agnostic, human-auditable, and cheap. His `AI AGENT MEMORY/` folder is readable by ANY agent that can read markdown — no special tooling. The tradeoff (no auto-capture, no crash recovery, no semantic search) is a conscious efficiency choice.

Our system optimizes the opposite tradeoff: zero human effort, crash safety, semantic depth — but locks to Claude Code and costs 4x tokens per session.

## Recommended Synthesis

```
VINH'S FOUNDATION                    + OUR EXTENSIONS
─────────────────                      ────────────────
AI AGENT MEMORY/ in vault (all agents) + Secret redaction before write
MEMORY.md index (human-auditable)      + memory-guard hook (structure enforcement)
4 type folders (user/feedback/etc.)    + Session ETL auto-capture → same folder
[[wikilinks]] for Obsidian graph       + QMD indexing of the same files
~1K token recall at startup            + Semantic recall on demand (not every prompt)
```

Preserves Vinh's multi-agent portability (S), low token cost (E), easy onboarding (Sc) while adding crash recovery (S), secret safety (S), semantic search (Sc).

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[GEMINI]]
- [[architecture]]
- [[memory-format]]
- [[project]]
- [[session-summary]]
