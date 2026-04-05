---
status: unprocessed
tags: [obsidian, karpathy, llm-knowledge-base, architecture, inspiration]
source: Karpathy X post diagram (detailed version)
related: "[[2026-04-04-karpathy-omarsar0-obsidian-kb]]"
---

# Karpathy LLM Knowledge Base — Detailed Architecture Diagram

Screenshot captured 2026-04-04. This is the expanded diagram from Karpathy's April 3 post.

## 3-Column Architecture

### DATA INGEST
- Sources: Articles, Papers, Repos, Datasets, Images
- Web Clipper (Obsidian ext.) → `raw/` (source docs)

### LLM ENGINE (4 functions)
1. **Compile** — raw → wiki (structured .md articles)
2. **Q&A** — Research answers from wiki context
3. **Linting** — Health checks (find inconsistencies, impute missing data, suggest new articles, find connections)
4. **Indexing** — Summaries + links (auto-maintained)

### KNOWLEDGE STORE
- Wiki (.md) — ~100 articles, ~400K words, backlinks, concepts, categories
- Outputs filed BACK into wiki ("explorations add up")

### EXTRA TOOLS
- Search (Web UI + CLI) — custom-built search engine over wiki
- CLI tools — various processing scripts

### OUTPUTS
- Markdown (.md articles)
- Slides (Marp format)
- Charts (Matplotlib)
- All viewable in Obsidian IDE frontend

### FUTURE EXPLORATIONS
- Synthetic data gen + finetuning on wiki
- Product vision ("beyond hacky scripts")

## Key Difference from Omar's ObsidianOS

| | Karpathy | Omar |
|---|---|---|
| Model | COMPILER (raw → LLM → wiki) | ORCHESTRATOR (vault = source of truth) |
| Human role | Never touches wiki | Co-edits with agent |
| Focus | Knowledge accumulation | Daily work productivity |
| Feedback | Outputs filed back to wiki | Workflow automation |
