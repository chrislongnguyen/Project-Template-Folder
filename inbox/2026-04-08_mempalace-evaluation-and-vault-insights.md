---
date: "2026-04-08"
type: capture
source: conversation
tags: []
---

# MemPalace Evaluation and Vault Insights

## What is MemPalace
- GitHub: https://github.com/milla-jovovich/mempalace
- Local-only AI memory system: ChromaDB (vectors) + SQLite (knowledge graph)
- Palace metaphor: Wings → Rooms → Halls → Drawers
- 98.4% Recall@5 on LongMemEval benchmark (vs Mem0: 30-45%)
- Zero API cost (~$10/year local compute)
- MCP server with 19 tools, works with Claude Code, Cursor, ChatGPT, local models

## Key Architecture Difference vs LTC Vault
- MemPalace: owns the storage layer (ChromaDB binary). Better retrieval, not human-readable.
- LTC Vault: delegates storage to markdown files + QMD. Human-readable, deeper Claude Code integration.
- MemPalace wins: retrieval quality (benchmarked), auto-capture (every 15 exchanges), entity detection, multi-IDE
- LTC Vault wins: cross-project awareness, hook enforcement (12 hooks × 6 events), lossless compression, workflow integration

## Highest-Value Insights to Steal

### P1: Hybrid keyword re-ranking for QMD
QMD already supports lex+vec. Adding fusion scoring (`fused_score = semantic_score × (1 + 0.30 × keyword_overlap)`) would reduce our 60-70% ignored-recall rate to ~30%. Low effort.

### P1: Auto-save every N exchanges
Replace manual /compress with a counter hook that fires /compress-lite automatically. Removes the "user forgot to compress" failure mode. Medium effort.

### P2: LongMemEval benchmark for QMD
Measure actual recall quality instead of proxy metric (% injected context used). Low effort.

### P2: Historical conversation ingestion
MemPalace's convo_miner supports 6 formats (Claude, ChatGPT, Codex, Slack, plain text). Use as a one-time import tool for historical context. Low effort.

## Semantic Search vs Semantic Reasoning

Key insight from evaluation: **the bottleneck is retrieval, not reasoning.**

- Semantic search = "find things related to X" → needed 30-80% of sessions
- Semantic reasoning = "infer causal chains across documents" → needed ~5-10% of sessions
- When reasoning IS needed, the LLM does it if search surfaces the right 3-5 documents
- Knowledge graph (MemPalace's SQLite, or Obsidian graph) is P4 I3+ — solves <10% of sessions

MemPalace's own benchmark proves this: LoCoMo multi-hop reasoning is 88.9% with raw search, 100% only with Sonnet reranking. The graph helps search find pieces; Sonnet chains them.

## Obsidian as Knowledge Graph

Obsidian graph + Local REST API can serve as lightweight knowledge graph:
- Nodes = notes, Edges = [[backlinks]], Temporal queries via Dataview
- Already integrated via /obsidian skill
- Can't do: vector similarity, confidence scoring, semantic multi-hop
- Those need QMD (which we already have)
- Together: Obsidian graph + QMD ≈ 80% of MemPalace's SQLite + ChromaDB, all human-readable

## Decision
Adopt MemPalace's retrieval patterns (hybrid re-ranking, auto-save), not its storage layer. The two systems are complementary — possible hybrid deployment as secondary MCP backend for historical conversation import.

## Links

- [[CLAUDE]]
- [[SKILL]]
- [[architecture]]
- [[codex]]
- [[mempalace]]
