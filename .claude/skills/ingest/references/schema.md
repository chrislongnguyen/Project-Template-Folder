# Ingest Schema Reference

## Entity Page vs Synthesis Page

| Type | Content | When to create | Example |
|---|---|---|---|
| **Entity page** | "What is X?" — factual, topic-specific, one concept per page | Every source produces ≥1 entity page | `skills/anthropic-skill-patterns.md` |
| **Synthesis page** | "What have I learned?" — cross-topic wisdom, patterns, principles | When ≥3 entity pages in a topic share a common pattern | `skills/ltc-skill-design-principles.md` |

**Decision criteria:**
- If the source introduces a new concept, tool, or technique → entity page
- If the source reinforces or connects existing concepts → update entity pages + consider synthesis
- If ≥3 entity pages in a topic share a pattern → create or update a synthesis page
- A single ingest can produce both types

## Depth Targets (Learning Hierarchy)

Reference: `_genesis/frameworks/learning-hierarchy.md`

### L1 Knowledge (required for ALL pages)

| Key | Question | Purpose |
|---|---|---|
| `so_what_relevance` | So What? | Why is this important? (Relevance) |
| `what_is_it` | What is it? | Definition and scope |
| `what_else` | What else? | Related concepts, alternatives |
| `how_does_it_work` | How does it work? | Mechanisms, processes |

### L2 Understanding (MINIMUM for all pages)

| Key | Question | Purpose |
|---|---|---|
| `why_does_it_work` | Why does it work? | Underlying principles |
| `why_not` | Why not? | When and why does it fail? |

### L3 Wisdom (required for core skill/framework pages)

| Key | Question | Purpose |
|---|---|---|
| `so_what_benefit` | So What? | How can we benefit from this? |
| `now_what_next` | Now What? | What should we do next? |

### L4 Expertise (required for architecture decision pages)

| Key | Question | Purpose |
|---|---|---|
| `what_is_it_not` | What is it NOT? | Common misconceptions |
| `how_does_it_not_work` | How does it NOT work? | Anti-patterns to avoid |
| `what_if` | What If? | Alternatives if this fails |
| `now_what_better` | Now What? | How can we do better than others? |

**Level derivation:**
- L1 complete = all 4 L1 questions answered
- L2 complete = L1 complete + both L2 questions (6/12)
- L3 complete = L2 complete + both L3 questions (8/12)
- L4 complete = L3 complete + all 4 L4 questions (12/12)

## Extended Frontmatter Spec

Every wiki page in `distilled/` MUST have this frontmatter:

```yaml
---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: skills
source: captured/anthropic-skill-docs.md
review: true
review_interval: 7
questions_answered:
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
---
```

**Rules:**
- `version`, `status`, `last_updated` — per `rules/versioning.md`
- `questions_answered` — only list questions actually answered in the page content
- Level is **derived** from coverage, never declared
- `review: true` — default for all pages (Learnie spaced repetition)
- `review_interval: 7` — default 7 days; adjust per topic maturity
- Obsidian `[[links]]` required for cross-referencing

## Size Routing Thresholds

| Size | Lines (approx) | Pipeline | Rationale |
|---|---|---|---|
| <100KB | <3,000 | Standard (Steps 1-5) | Fits in single context window with room for reasoning |
| 100KB-500KB | 3,000-15,000 | Chunked (sequential sections) | Too large for single pass; sequential preserves coherence |
| >500KB | >15,000 | Parallel (Agent dispatch) | Requires decomposition per EP-09; orchestrator synthesis per EP-13 |

**How to measure:** `wc -c captured/filename.md` for bytes, `wc -l` for lines.

## Multi-Page Ingest Rules

When a single source produces multiple pages:

1. **Entity pages first** — create all entity pages before considering synthesis
2. **Cross-link pass** — after all entity pages exist, add `[[links]]` between related pages
3. **Synthesis trigger** — if ≥3 entity pages in same topic share a pattern, create synthesis page
4. **Batch index update** — update `_index.md` and `_log.md` once after all pages, not per-page

## Page Structure Template

```markdown
---
(frontmatter as above)
---
# {Page Title}

> One-line summary.

## L1 — Knowledge
### So What? (Relevance)
### What Is It?
### What Else?
### How Does It Work?

## L2 — Understanding
### Why Does It Work?
### Why Not?

## L3 — Wisdom
<!-- Add when depth warrants -->

## L4 — Expertise
<!-- Add when depth warrants -->

## Sources
- [[source-link]]

## Links
- [[related-page]]
```
