---
name: organise
version: "2.3"
status: draft
last_updated: 2026-04-13
model: claude-sonnet-4-6
description: "Organise raw sources from captured/ into structured wiki pages in organised/. Use when PM drops files into PERSONAL-KNOWLEDGE-BASE/captured/ and says /organise, 'organise knowledge', or 'process captured'."
argument-hint: "[source-filename] [--depth L1|L2|L3|L4] [--dry-run]"
disable-model-invocation: true
allowed-tools: "Read Write Edit Grep Glob Bash Agent"
---
# /organise — Personal Knowledge Base Organise

> Reads raw sources from `PERSONAL-KNOWLEDGE-BASE/captured/`, organises them into structured wiki pages in `organised/`, updates the index and log. Based on Karpathy's LLM Wiki pattern + LTC Learning Hierarchy.

## Pre-Flight

```!
cd "$(git rev-parse --show-toplevel)" && ./scripts/pkb-lint.sh 2>&1 | head -20
```

## Argument Parsing

Parse `$ARGUMENTS` as space-separated tokens:

| Token | Meaning | Default |
|---|---|---|
| Bare word (no `--`) | Source filename in `captured/` | All uningested files |
| `--depth L1\|L2\|L3\|L4` | Override minimum depth target | L2 |
| `--dry-run` | Report what WOULD be created; no writes | Off (full writes) |

Examples:
- `/organise` — ingest all uningested files at L2
- `/organise claude-code-docs-full.md` — ingest one file at L2
- `/organise claude-code-docs-full.md --depth L3` — ingest one file at L3
- `/organise --dry-run` — preview all uningested files

## Decision Tree (Execute First)

```
Source Analysis
├─ Arg provided? → Ingest ONLY that file from captured/
├─ No arg? → Scan captured/ for ALL uningested files (not in _log.md)
│
Size Routing (per file)
├─ <100KB (≈3K lines) → STANDARD pipeline (Steps 1-5 below)
├─ 100KB-500KB → CHUNKED pipeline (split by headings, sequential)
└─ >500KB → PARALLEL pipeline (Agent dispatch, see §Large-Source Protocol)
│
Depth Override
├─ --depth L1|L2|L3|L4 → Override default L2 minimum
├─ --dry-run → Show what WOULD be created, no writes
└─ No flag → Default L2 minimum, full writes
```

## <HARD-GATE>

1. NEVER write a page without reading `_index.md` first — duplicate pages are the #1 quality failure
2. NEVER skip Steps 4-5 (_log.md + _index.md update) — invisible pages are worse than no pages
3. NEVER declare a level in frontmatter — level is DERIVED from `questions_answered` count
4. NEVER create a page below L2 minimum (6/12 questions) unless using the Escape Hatch
5. Every page MUST have `source:` frontmatter pointing to the captured/ file
6. After 2 validation failures on the same page, STOP and ask the user
7. NEVER modify files in `captured/` — they are immutable source material

</HARD-GATE>

## 5-Step Pipeline (Standard: <100KB)

```
Step 1 — Read source
  Read files in captured/ not yet in organised/_log.md.
  If arg provided, read ONLY that file.

Step 2 — Check _index.md (MANDATORY — prevents duplicates)
  Load _index.md → find existing related pages.
  Decide: create new page or update existing.
  If updating: read the existing page first, merge content.

Step 3 — Write/update organised/ pages
  a. Classify: entity page or synthesis page (→ ${CLAUDE_SKILL_DIR}/references/schema.md)
  b. Determine topic → write to organised/{topic}/{page-name}.md
  c. Answer L1-L4 questions per depth target (→ ${CLAUDE_SKILL_DIR}/references/schema.md)
  d. Add extended frontmatter (→ ${CLAUDE_SKILL_DIR}/references/schema.md §Frontmatter Spec)
  e. Add Obsidian [[links]] to related pages (check _index.md for candidates)
  f. If source yields ≥3 entity pages sharing a pattern → also create synthesis page

Step 4 — Append to _log.md (MANDATORY)
  Row: | date | source path | pages created | pages updated |

Step 5 — Update _index.md (MANDATORY)
  Add/update page entries and topic entries.
  Verify: every new page appears in _index.md.
```

## Chunked Pipeline (100KB-500KB)

For sources too large for single-pass but manageable sequentially:

```
1. Read source headings/structure (first 200 lines + grep for ## headers)
2. Identify natural sections (chapters, H2 blocks, logical units)
3. Process each section through Steps 2-3 sequentially
4. After ALL sections processed: run Steps 4-5 once (batch update)
5. Cross-link pages from different sections
```

## Large-Source Protocol (>500KB)

Sources exceeding 500KB require parallel agent dispatch per EP-09 (Decompose Before You Delegate) + EP-13 (Orchestrator Authority).

**Model routing per phase:**

| Phase | Agent | Model | Why |
|---|---|---|---|
| Phase 1 — Survey | ltc-explorer | Haiku | Read-only TOC scan, no writing — fast + cheap |
| Phase 2 — Section Build | ltc-builder (×N parallel) | Sonnet | L2+ depth requires Sonnet reasoning; Haiku risks G1 (shallow) |
| Phase 3 — Synthesis | Orchestrator (this session) | Sonnet | Cross-linking + dedup + synthesis pages |

```
Phase 1 — Survey (ltc-explorer, Haiku)
  Dispatch a single ltc-explorer agent to:
    EO: "Produce a section manifest for parallel ingest"
    INPUT: Source file path + first 500 lines + grep for H1/H2 headers
    EP: "Read-only. Do not write any files. Return structured manifest only."
    OUTPUT: "JSON array: [{name, start_line, end_line, estimated_topics}]"
    VERIFY: "Sections cover 100% of source lines with no gaps or overlaps"

Phase 2 — Section Build (N × ltc-builder, Sonnet, parallel)
  Dispatch N ltc-builder agents in parallel. Each receives:
    EO: "Distil section N into wiki pages following schema"
    INPUT: Section text (by line range) + _index.md + schema.md
    EP: "L2 minimum, entity/synthesis classification, [[links]] required"
    OUTPUT: "1+ wiki pages as markdown with full frontmatter, written to organised/{topic}/"
    VERIFY: "questions_answered ≥ 6, source attribution present, no duplicate titles vs _index.md"

Phase 3 — Synthesis (orchestrator, this session, Sonnet)
  a. Collect all agent outputs
  b. Deduplicate: merge pages covering same concept
  c. Cross-link: add [[links]] between pages from different sections
  d. Create synthesis pages where ≥3 entity pages share a pattern
  e. Run Steps 4-5 (batch _log.md + _index.md update)
  f. Run pkb-lint.sh to verify integrity
```

## Depth Minimum

Every organised/ page must reach **L2 (Understanding)** — 6/12 questions answered.
Core skill/framework pages: L3. Architecture decisions: L4.
Full question list and frontmatter spec: [references/schema.md](references/schema.md)

## Escape Hatch

If a source is too shallow for L2 depth:
1. Create the page at L1 with whatever questions can be answered
2. Add `<!-- SHALLOW: L2 questions unanswered — needs deeper source -->` at top
3. Log it normally — the dashboard staleness monitor will surface it for follow-up
4. Set `review_interval: 3` (shorter cycle to prompt follow-up)

## Validation Gate

After completing all steps, verify before finishing:
- [ ] Every new page has `questions_answered` with ≥6 entries (L2 minimum)
- [ ] `_log.md` has a new row for this ingest run
- [ ] `_index.md` lists every new/updated page
- [ ] All new pages have `[[links]]` to ≥1 related page
- [ ] No duplicate page titles in `_index.md`
- [ ] `source:` frontmatter points to correct captured/ file
- [ ] If updating existing page: version bumped, last_updated set

Post-validation:
```bash
cd "$(git rev-parse --show-toplevel)" && ./scripts/pkb-lint.sh
```

If lint fails, fix issues before reporting done.

## Gotchas

See [references/gotchas.md](references/gotchas.md) for documented failure patterns. Top 3:
1. **Surface-level summaries** — page only reaches L1, missing L2 "why" questions. Fix: L2 is mandatory.
2. **Forgetting _index.md + _log.md** — page exists but invisible to dashboard/auto-recall. Fix: Steps 4-5 are mandatory.
3. **Duplicate pages** — same concept under different names. Fix: ALWAYS read _index.md in Step 2.

## References

- [Schema + frontmatter + page template](references/schema.md) — load before writing any page
- [Gotchas](references/gotchas.md) — failure patterns to avoid
- [Learning Hierarchy](/_genesis/frameworks/learning-hierarchy.md) — the 12 questions

## Links

- [[AGENTS]]
- [[EP-09]]
- [[EP-13]]
- [[_index]]
- [[_log]]
- [[architecture]]
- [[dashboard]]
- [[gotchas]]
- [[learning-hierarchy]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[schema]]
- [[standard]]
