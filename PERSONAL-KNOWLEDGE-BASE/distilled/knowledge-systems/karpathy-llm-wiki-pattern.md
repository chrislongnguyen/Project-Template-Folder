---
version: "2.1"
status: Draft
last_updated: 2026-04-05
topic: knowledge-systems
source: captured/llm-wiki.md
review: true
review_interval: 14
questions_answered:
  # L1 Knowledge
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  # L2 Understanding
  - why_does_it_work
  - why_not
  # L3 Wisdom
  - so_what_benefit
  - now_what_next
  # L4 Expertise
  - what_is_it_not
  - how_does_it_not_work
  - what_if
  - now_what_better
---
# Karpathy LLM Wiki Pattern

> A design pattern for personal knowledge management where LLMs incrementally compile raw sources into a persistent, interlinked wiki — not RAG. The wiki is the artifact. The LLM is the maintainer. Obsidian is the IDE.

## L1 — Knowledge

### So What? (Relevance)

This pattern shifts LLM usage from code manipulation to **knowledge manipulation**. Instead of treating LLMs as coding assistants, they become knowledge librarians — ingesting, organising, distilling, and querying accumulated wisdom. This is the foundation of the LTC PKB system.

The key insight from the gist: "Humans abandon wikis because the maintenance burden grows faster than the value. LLMs don't get bored, don't forget to update a cross-reference, and can touch 15 files in one pass."

Related in spirit to Vannevar Bush's Memex (1945) — a personal, curated knowledge store with associative trails between documents. Bush's vision was private, actively curated, with connections as valuable as documents themselves. The missing piece was who does the maintenance. The LLM handles that.

### What Is It?

A three-layer architecture:

```
Layer 1 — Raw sources (immutable)
  Articles, papers, images, data files.
  LLM reads from these but NEVER modifies them.
  This is the source of truth.

Layer 2 — The wiki (LLM-owned)
  Directory of LLM-generated .md files.
  Summaries, entity pages, concept pages, comparisons, synthesis.
  LLM creates, updates, cross-references, maintains consistency.
  You read it; the LLM writes it.

Layer 3 — The schema (co-evolved)
  CLAUDE.md / AGENTS.md — tells the LLM how the wiki is structured,
  conventions, workflows for ingest/query/lint.
  You and the LLM co-evolve this as you learn what works.
```

Three core operations:
- **Ingest:** Drop source into raw → LLM reads, discusses, writes summary, updates index, updates entity/concept pages across the wiki, appends to log. A single source can touch 10-15 pages.
- **Query:** Ask questions → LLM searches wiki, synthesises answer with citations → good answers get filed back into wiki (compounding flywheel).
- **Lint:** Periodic health checks → find contradictions, stale claims, orphans, missing pages, gaps fillable by web search.

Two special files:
- **index.md** — content-oriented catalog (pages, summaries, metadata). LLM reads this first for any query. Works to ~100 sources without needing RAG.
- **log.md** — chronological, append-only. Parseable with unix tools (`grep "^## \[" log.md | tail -5`).

### What Else?

Related approaches:
- **RAG (NotebookLM, ChatGPT uploads):** Re-derives knowledge from scratch every query. No accumulation. No synthesis artifact.
- **Zettelkasten:** Human-maintained atomic notes. Similar structure but manual — LLM wiki automates the maintenance burden.
- **Traditional wikis:** Human-written and maintained. Abandoned when maintenance cost exceeds perceived value.
- **qmd:** Local search engine with hybrid BM25/vector + LLM re-ranking. CLI + MCP server. Supplements index.md at scale.

Applicable domains: personal (goals, health, self-improvement), research (papers over months), reading a book (character/theme wiki), business (Slack/meetings/docs), competitive analysis, due diligence, trip planning, course notes, hobby deep-dives.

### How Does It Work?

```
raw/ (immutable sources — Web Clipper, manual drops)
  ↓ /ingest
wiki/ (LLM-owned .md files)
  ├── index.md          ← catalog, read-first for queries
  ├── log.md            ← append-only timeline
  ├── entity pages      ← one concept per page
  ├── concept pages     ← cross-topic synthesis
  └── output pages      ← filed query results (compounding)
  ↓ Obsidian renders
Human browses: markdown, graph view, Marp slides, Dataview tables
  ↓ query → answer filed back
Wiki grows smarter with every interaction
```

Scale: ~100 articles / ~400K words navigable via index.md alone. Beyond that, qmd adds proper search (BM25 + vector, on-device).

## L2 — Understanding

### Why Does It Work?

1. **Compile-once compounds.** Knowledge accumulates rather than being recomputed per query. Cross-references already exist. Contradictions already flagged. Synthesis already reflects everything read.
2. **LLM-owned maintenance eliminates human abandonment.** The tedious part — updating cross-references, keeping summaries current, noting contradictions — costs the LLM near-zero. Humans quit wikis because maintenance grows faster than value.
3. **Index-first retrieval without RAG infrastructure.** index.md + LLM navigation works surprisingly well at moderate scale. No embeddings, no vector DB, no chunking strategy.
4. **Query flywheel.** Answers filed back as new pages mean explorations compound. The wiki gets smarter with use.
5. **Obsidian as IDE gives transparency.** The human sees exactly what the LLM wrote. Graph view shows connections. Not a black box.
6. **Schema co-evolution.** CLAUDE.md/AGENTS.md governs LLM behaviour. As you learn what works, you update the schema. The system adapts to your domain.

### Why Not? (When and Why It Fails)

1. **High-velocity sources outpace maintenance.** No auto-trigger in the original pattern. If raw/ grows faster than the LLM compiles, the wiki goes stale.
2. **Schema is invisible debt.** As domain evolves, schema must co-evolve or distillation degrades silently. No one notices until quality drops.
3. **Single-user bias.** Multi-user/team use requires human review of LLM edits. Not solved by the pattern.
4. **Image handling is clunky.** LLMs can't natively read markdown with inline images in one pass. Workaround: read text first, view images separately. Works but breaks flow.
5. **~100-source sweet spot.** Index navigation degrades past hundreds of pages. qmd solves this but adds infrastructure.
6. **Pull-only retrieval.** No proactive surfacing. The wiki doesn't push "your notes on X are contradicted by this new source."
7. **Intentionally abstract.** The gist describes the pattern, not an implementation. Directory structure, schema conventions, page formats are left to the user + LLM to figure out.

## L3 — Wisdom

### So What? (How Can We Benefit?)

The LTC PKB is a direct implementation with four extensions beyond the original:

| Gap in original | LTC extension |
|---|---|
| No auto-trigger | Post-session hook (`pkb-ingest-reminder.sh`) |
| Index degrades at scale | QMD as first-class citizen from day one |
| No depth enforcement | Learning Hierarchy (L1–L4, 12 questions) |
| No human UX layer | Obsidian plugins (Dataview dashboard, Learnie, Canvas) |

The pattern validates: Obsidian + LLM + markdown is sufficient infrastructure. No vector databases, cloud APIs, or proprietary tools required.

### Now What? (What Should We Do Next?)

1. **Use the PKB.** Drop sources into `captured/`, run `/ingest`.
2. **Monitor the flywheel.** After 10+ ingests, check if synthesis pages emerge. If not, tune the schema.
3. **Watch for scale limits.** When distilled/ passes ~100 pages, verify QMD retrieval quality.
4. **Consider linting (I3).** Periodic health checks — contradictions, orphans, gaps, stale claims.
5. **Consider filing query answers back.** When an agent produces a good answer from PKB knowledge, file it to `expressed/` or back into `distilled/` as a new page.

## L4 — Expertise

### What Is It NOT?

- **NOT RAG.** RAG re-derives knowledge per query from raw chunks. This compiles knowledge once into persistent pages. The wiki IS the artifact, not a retrieval cache.
- **NOT NotebookLM.** NotebookLM is project-scoped, flat, API-dependent. This is local, interlinked, LLM-owned.
- **NOT a chatbot with memory.** Session memory is ephemeral. The wiki is persistent, versioned, browsable, and grows with every interaction.
- **NOT a manual note-taking system.** You rarely write the wiki. The LLM writes and maintains it. Your job is sourcing, questioning, and thinking.

### How Does It NOT Work? (Anti-Patterns)

1. **Dumping raw sources without ingest.** Filling raw/ but never running ingest = a folder of files, not a knowledge base. The wiki only grows through the ingest operation.
2. **Over-supervising the LLM.** Editing wiki pages manually defeats the purpose. Let the LLM own the wiki. Correct via schema updates, not direct edits.
3. **Ignoring the schema.** Without a well-crafted schema (CLAUDE.md), the LLM produces inconsistent, shallow pages. Schema quality = wiki quality.
4. **Batch-ingesting without involvement.** Karpathy prefers one-at-a-time ingest with discussion. Batch ingest loses the serendipitous connections that come from human attention.
5. **Never linting.** Without periodic health checks, contradictions and orphans accumulate silently. Lint is the maintenance that keeps the wiki trustworthy.

### What If? (Alternatives If This Fails)

- **If wiki grows too large for index.md:** Add qmd/search engine (already in LTC as QMD MCP).
- **If schema becomes unmanageable:** Split into domain-specific schema files, load on demand.
- **If LLM quality degrades on complex synthesis:** Use multi-agent pattern — one agent ingests, another reviews.
- **If the human stops engaging:** The post-session hook reminder is the safety net. If that fails, the dashboard staleness monitor surfaces neglected captured/ files.

### Now What? (How Can We Do Better?)

The LTC PKB already extends the original in 4 ways. Next frontiers:
1. **Auto-ingest from session context.** When an agent reads external docs during work, auto-capture to captured/ without manual drop. (I3 scope.)
2. **Cross-project synthesis.** QMD indexes multiple vaults. A synthesis agent could find patterns across projects.
3. **Linting skill.** Periodic `/lint-pkb` — find contradictions, orphans, shallow pages, suggest new questions.
4. **Spaced repetition integration.** Learnie surfaces pages for review. Track which pages the PM actually reads. Use read/skip data to tune review_interval.

## Sources

- [[llm-wiki]] — `captured/llm-wiki.md` (primary — the full gist)
- [[Thread by @karpathy]] — `captured/Thread by @karpathy.md` (Twitter summary)

## Links

- [[_index]]
- [[_log]]
