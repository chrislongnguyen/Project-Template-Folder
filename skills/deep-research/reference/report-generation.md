# Report Generation Procedure (Phase 8)

This file contains the detailed procedure for generating, assembling, and delivering the final research report. Loaded on-demand during Phase 8 PACKAGE.

---

## File Organization

Create a dedicated folder for each research run:

```
~/Documents/[TopicName]_Research_[YYYYMMDD]/
├── research_report_[YYYYMMDD]_[topic_slug].md    ← Primary source
├── research_report_[YYYYMMDD]_[topic_slug].html   ← McKinsey-style
└── research_report_[YYYYMMDD]_[topic_slug].pdf    ← Professional print
```

Also save a copy to `~/.claude/research_output/` for internal tracking.

**Topic slug extraction:** Remove special characters, use underscores/CamelCase.
- "psilocybin research 2025" → `Psilocybin_Research_20260307`
- "compare React vs Vue" → `React_vs_Vue_Research_20260307`

---

## Length by Mode

| Mode | Target Words | Notes |
|---|---|---|
| Quick | 2,000-4,000 | Well under output limit |
| Standard | 4,000-8,000 | Comfortably under limit |
| Deep | 8,000-15,000 | Achievable with care |
| UltraDeep | 15,000-20,000 | At limit — use continuation if needed |

---

## Progressive Section Generation

Generate each section individually. Write to file immediately after each section. This allows unlimited report length while keeping each generation manageable.

**Pattern:** Generate section → Write/Edit to file → Track citations → Next section

Each Write/Edit call contains ONE section (keep under ~2,000 words per call).

### Section Order

1. **Executive Summary** (200-400 words) → Write to file (creates file)
2. **Introduction** (400-800 words) → Edit/append
3. **Finding 1** (300-2,000 words) → Edit/append
4. **Finding 2** → Edit/append
5. ... Continue for ALL findings (4-8 minimum, more if evidence warrants)
6. **Synthesis & Insights** → Edit/append
7. **Limitations & Caveats** → Edit/append
8. **Recommendations** → Edit/append
9. **Bibliography** (ALL citations) → Edit/append
10. **Methodology Appendix** → Edit/append

### Citation Tracking

Maintain a running list throughout: `citations_used = [1, 2, 3, ...]`

After each section: add new citations to the list.
In Bibliography: generate entry for EVERY citation in the final list.

**Bibliography rules:**
- NO ranges ([1-50])
- NO placeholders ("Additional citations...")
- NO truncation
- Write every single entry in full

### Anti-Fatigue Quality Check (per section)

Before moving to next section, verify:
- 3+ paragraphs for major sections (## headings)
- <20% bullet points (80%+ must be flowing prose)
- Zero placeholders ("Content continues", "Due to length")
- Specific data points and statistics (not vague statements)
- Major claims cited in same sentence

If ANY check fails: regenerate the section.

---

## Auto-Continuation (reports >18,000 words)

When output approaches 18,000 words in a single run, use the continuation protocol.

### Step 1: Save State

Create: `~/.claude/research_output/continuation_state_[report_id].json`

```json
{
  "report_id": "[unique_id]",
  "file_path": "[absolute_path_to_report.md]",
  "mode": "[research:lite|research:mid|research:deep|research:full]",
  "progress": {
    "sections_completed": [],
    "total_planned_sections": 0,
    "word_count_so_far": 0,
    "continuation_count": 1
  },
  "citations": {
    "used": [],
    "next_number": 1,
    "bibliography_entries": []
  },
  "research_context": {
    "research_question": "",
    "key_themes": [],
    "main_findings_summary": [],
    "narrative_arc": "beginning|middle|conclusion"
  },
  "quality_metrics": {
    "avg_words_per_finding": 0,
    "citation_density": 0,
    "prose_vs_bullets_ratio": "85%",
    "writing_style": "technical-precise-data-driven"
  },
  "next_sections": []
}
```

### Step 2: Spawn Continuation Agent

Use Task tool with general-purpose agent. The continuation agent:
1. Reads continuation state file
2. Reads existing report (last 3 sections for flow/style)
3. Continues citation numbering from state
4. Generates next batch of sections (stay under 18K words)
5. If more sections remain: updates state, spawns next agent
6. If final: generates bibliography, runs validation, deletes state file

### Step 3: Report Status

Tell user: which sections are complete, word count, what's continuing, estimated progress.

---

## HTML Generation (McKinsey Style)

1. Read McKinsey template from `./templates/mckinsey_report_template.html`
2. Extract 3-4 key quantitative metrics from findings for dashboard
3. Convert markdown to HTML:

```bash
cd ~/.claude/skills/deep-research
python scripts/md_to_html.py [markdown_report_path]
```

The script returns Part A (content HTML) and Part B (bibliography HTML).

4. Replace template placeholders:
   - `{{TITLE}}` — report title
   - `{{DATE}}` — YYYY-MM-DD
   - `{{SOURCE_COUNT}}` — unique sources
   - `{{METRICS_DASHBOARD}}` — metrics HTML
   - `{{CONTENT}}` — Part A
   - `{{BIBLIOGRAPHY}}` — Part B

5. No emojis in final HTML.
6. Save to folder.
7. Verify:

```bash
python scripts/verify_html.py --html [html_path] --md [md_path]
```

8. Open in browser: `open [html_path]`

---

## PDF Generation

1. Spawn sub-agent via Task tool
2. Agent invokes generating-pdf skill with markdown as input
3. Save to same folder as other formats
4. PDF auto-opens when complete

---

## Delivery

Present to user:
1. Executive summary (inline in chat)
2. Folder path with all three formats
3. Source quality summary (count, avg credibility)
4. Next steps if relevant
