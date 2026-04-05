---
date: 2026-04-04
tags: [obsidian, knowledge-management, llm, research, inspiration]
source: X/@karpathy, X/@omarsar0
status: unprocessed
---

# Karpathy LLM Knowledge Bases + omarsar0 ObsidianOS

## Context

Two prominent AI practitioners sharing their Obsidian-based knowledge management systems (April 3, 2026). Both got massive engagement — Karpathy's post hit 5.5M views, 28K likes.

---

## Andrej Karpathy — LLM Knowledge Bases

**Core idea:** Use LLMs to build personal knowledge bases. Raw data → LLM-compiled wiki → queryable via agents. Zero vector DB, zero RAG infrastructure.

### Architecture (3-column)

```
INGEST                  KNOWLEDGE BASE              READ / QUERY
──────                  ──────────────              ────────────
Web Clipper ──→         Index & Summaries    ──→    Obsidian IDE
Papers/Repos ──→        Concept Articles (~100)     Q&A Agent
raw/ directory ──→      Derived Outputs (Marp)      Search Engine
LLM Compiler ──→        Backlinks & Cross-links     Linting
```

### 4-Phase Pipeline (cyclical)

1. **Ingest** — raw data from articles, papers, repos, datasets
2. **Compile** — LLM turns raw/ into structured wiki (.md directory)
3. **Query & enhance** — Q&A agent answers questions; outputs filed back into wiki
4. **Lint & maintain** — LLM health checks: inconsistencies, missing data, new connections

### Key Details

- **Scale:** ~100 articles, ~400K words, backlinked
- **Web Clipper:** Obsidian extension → .md + local images
- **IDE:** Obsidian as frontend — view raw data, compiled wiki, visualizations
- **Output formats:** Markdown files, Marp slides, matplotlib charts — all viewable in Obsidian
- **Feedback loop:** Query outputs filed BACK into wiki → "explorations always add up"
- **Linting:** LLM finds inconsistent data, imputes missing info (via web search), suggests new article candidates
- **Future:** Synthetic data generation → fine-tuning (LLM "knows" data in weights, not just context)

### Notable Quote

> "raw data from a given number of sources is collected, then compiled by an LLM into a .md wiki, then operated on by various CLIs by the LLM to do Q&A and to incrementally enhance the wiki, and all of it viewable in Obsidian. You rarely ever write or edit the wiki manually, it's the domain of the LLM."

---

## Elvis Saravia (@omarsar0) — ObsidianOS

**Core idea:** Obsidian vault as an AI-powered work OS. "Agentic operating system for thinkers."

### Key Details

- **GitHub:** `benoror/obsidianos_work` (151 stars, MIT, JS/Python/Shell)
- **Stack:** Obsidian + Claude Code plugin + Google Calendar/Gmail integration
- **Paradigm:** "Chief of Staff" — AI orchestrates inbox, calendar, tasks
- **Workflows:** Meeting prep, email triage, task automation, time analysis
- **Plugins:** Omnisearch, vault-agent-terminal, Claude-Code native embedding
- **Philosophy:** Personalized agentic workflows > generic tools

### Elvis's Background

- Founder/CEO DAIR.AI (6M+ learners)
- Prev: Meta AI (Galactica LLM), Elastic, PhD
- Creator: Prompting Guide (~6M users)
- Also exploring MemOS (persistent agent memory)

---

## Comparison with LTC Setup

### They Have, We Don't

| Pattern | Who | Our Gap |
|---|---|---|
| LLM-compiled wiki (raw → auto-generated articles + backlinks) | Karpathy | We ingest manually via templates |
| Always-maintained Index & Summaries file | Karpathy | MEMORY.md briefing card is close but per-workstream indexes missing |
| Feedback loop (query outputs auto-filed back into KB) | Karpathy | /learn outputs stay in 2-LEARN/output/, don't enrich graph |
| LLM linting (health checks, impute missing, find connections) | Karpathy | No equivalent skill |
| Chief-of-staff automation (calendar/email/inbox triage) | omarsar0 | No automated inbox integration |
| Web Clipper → raw/ pipeline | Karpathy | No standardized web capture |

### We Have, They Don't

| Pattern | LTC Advantage |
|---|---|
| Chain-of-custody (ALIGN→LEARN→PLAN→EXECUTE→IMPROVE with gates) | Neither has dependency enforcement |
| Version lifecycle (MAJOR=iteration, status gates, human-only approval) | Neither has formal versioning |
| 7-page learning model (P0→P7) mapped to decision criticality | Neither has depth-calibrated research |
| UBS/UDS → Effective Principles pipeline | Neither formalizes risk→principle extraction |
| 14 Bases dashboards (live queryable tables) | Karpathy uses flat search |
| 4 MECE agents with model routing | omarsar0 uses Claude Code without specialization |
| 3-tier search with mandatory .claude/ sweep | Neither has cross-layer enforcement |

### Recommended Actions

| Pri | Action | Effort |
|---|---|---|
| P1 | `/learn-compile` skill: raw sources → auto-generated summaries + backlinks | Medium |
| P2 | Feedback loop: query outputs auto-enrich knowledge graph | Medium |
| P3 | `/vault-lint` skill: orphans + broken links + missing frontmatter + stale dates | Small |
| P4 | Web Clipper standardization: Obsidian Clipper → `2-LEARN/input/raw/` | Small |
| P5 | Chief-of-staff: daily standup auto-prep from git + blockers + approval queue | Large |

---

## Raw Sources

- Karpathy X post: April 3, 2026, 5.5M views, 28K likes, 3.9K RTs
- omarsar0 diagram post: April 3, 2026 (diagram of LLM KB architecture)
- GitHub: `benoror/obsidianos_work`
- Related: DeepWiki, CocoIndex, llm-council, obsidian-claude-code plugin
