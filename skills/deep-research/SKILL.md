---
name: deep-research
description: Multi-source research with citation tracking and verification. 4 modes — research:lite (5min), research:mid (15min), research:deep (30min), research:full (60min+). When auto-triggered, default to research:lite. Use this skill whenever the user asks to compare tools/products, analyze market trends, evaluate options for a decision, produce a cited report, or do any research requiring synthesis across 3+ sources. Even if you think you can answer with a quick WebSearch — if the user wants a structured, cited, multi-angle analysis, USE THIS SKILL. Do NOT use for fixing bugs, writing code, simple factual lookups, or questions with one clear answer.
---

# Deep Research

## Decision Tree (Execute First)

```
Request Analysis
├─ Simple lookup? → STOP: Use WebSearch, not this skill
├─ Debugging? → STOP: Use standard tools, not this skill
└─ Complex analysis needed? → CONTINUE

Mode Selection (auto-trigger always defaults to research:lite)
├─ Auto-triggered or "quick look"? → research:lite (3 phases, 2-5 min) [DEFAULT]
├─ User requests depth or /deep-research? → research:mid (6 phases, 5-10 min)
├─ User says "deep" or critical decision? → research:deep (8 phases, 10-20 min)
└─ User says "full" or "comprehensive"? → research:full (8+ phases, 20-45 min)
```

---

## Workflow

**AUTONOMY PRINCIPLE:** Proceed independently. Only stop for incomprehensible queries or contradictory requirements.

### 1. Clarify (rarely needed)

Default: proceed with research:lite. Derive assumptions from query context.

- Technical query → technical audience
- Comparison → balanced perspective
- Trend → recent 1-2 years

### 2. Plan

Announce: mode, estimated time, source target. Proceed without waiting for approval.

### 3. Act

Load phase instructions from [methodology](./reference/methodology.md) on demand per phase.

**All modes:** Scope → Retrieve → Package
**research:mid+:** + Plan → Triangulate → Outline Refinement → Synthesize
**research:deep+:** + Critique → Refine

Phase 3 RETRIEVE is parallel. Decompose into 5-10 search angles. Launch ALL searches + 3-5 sub-agents in a single message. Never sequential. Details: [methodology](./reference/methodology.md#phase-3-retrieve---parallel-information-gathering)

**Iterative Sub-agent Retrieval (D6):** After the initial parallel retrieval completes, evaluate coverage:
- If ≥3 independent sources per major claim → proceed to next phase
- If <3 sources on a key topic → launch a **targeted refinement round**: 1-2 focused sub-agents with narrower queries derived from gaps in round 1. Do NOT re-run the full retrieval.
- Maximum 2 refinement rounds. After round 2, proceed with available sources and note gaps in Limitations.
- Each refinement sub-agent should receive the specific gap it needs to fill (e.g., "Find primary sources for claim X — existing sources only cover Y angle").

### 4. Verify (always)

```bash
python scripts/verify_citations.py --report [path]
python scripts/validate_report.py --report [path]
```

If suspicious citations found: review, remove or replace, re-run until clean.
If validation fails: auto-fix attempt 1, manual fix attempt 2. After 2 failures → stop and ask user.

### 5. Report

Generate report following [report generation procedure](./reference/report-generation.md).

Output: Markdown + HTML (McKinsey) + PDF, saved to `~/Documents/[Topic]_Research_[YYYYMMDD]/`.

---

## Anti-Hallucination Protocol

- Every factual claim MUST cite a specific source [N] in the same sentence
- Distinguish FACTS (from sources) from SYNTHESIS (your analysis)
- Use "According to [1]..." or "[1] reports..." — not "Research suggests..."
- If unsure, say "No sources found for X" — never fabricate a citation
- Label inferences: "This suggests..." not "The mechanism is..."
- Mark all speculation explicitly as analysis, not fact

---

## Writing Standards

- **Narrative prose** — flowing paragraphs, not bullet-point-driven. Bullets only for distinct lists.
- **Precision** — "reduced mortality 23% (p<0.01)" not "significantly improved outcomes"
- **Economy** — no fluff, no unnecessary adjectives, every word carries intention
- **Clarity** — exact numbers embedded in sentences, precise technical terms
- **Citation density** — major claims cited in the same sentence, not end-of-paragraph
- **No placeholders** — zero TBD, TODO, "content continues", "due to length", or truncation

---

## Output Contract

Report must include all sections from [template](./templates/report_template.md):

| Section | Requirement |
|---|---|
| Executive Summary | 50-250 words, key findings + primary recommendation + confidence level |
| Introduction | Research question, scope, methodology, key assumptions |
| Main Analysis | 4-8 findings, each with evidence, citations, and implications |
| Synthesis | Patterns across findings, novel insights, second-order implications |
| Limitations | Counterevidence register, known gaps, areas of uncertainty |
| Recommendations | Immediate actions, next steps, further research needs |
| Bibliography | EVERY citation [N] with full metadata — no ranges, no placeholders, no truncation |
| Methodology | Process, source types, verification approach, claims-evidence table |

**Bibliography: ZERO TOLERANCE.** If report cites [1]-[30], bibliography must contain all 30 entries in full. Report is unusable without complete bibliography.

---

## Error Handling

- 2 validation failures on same error → stop, report to user, ask for direction
- <5 sources after exhaustive search → report limitation, request user direction
- 5-10 sources → note in limitations, proceed with extra verification
- User interrupts or changes scope → confirm new direction before continuing

---

## Quality Gates

- 10+ sources (document if fewer available)
- 3+ independent sources per major claim
- Executive summary <250 words
- Full citations with URLs
- Credibility assessment per source (0-100 via `scripts/source_evaluator.py`)
- No placeholders anywhere in the report
- Thoroughness over speed. Quality over volume.

---

## References (Load On-Demand)

- [Methodology](./reference/methodology.md) — 8-phase pipeline with parallel execution details
- [Report Generation](./reference/report-generation.md) — file organization, progressive assembly, continuation agents, HTML/PDF output
- [Report Template](./templates/report_template.md) — section structure and content guidance
- [McKinsey HTML Template](./templates/mckinsey_report_template.html) — HTML styling and layout

## Scripts

All Python stdlib only — no external dependencies.

- `scripts/validate_report.py` — 8-check quality validation
- `scripts/verify_citations.py` — DOI resolution, fabrication detection
- `scripts/source_evaluator.py` — source credibility scoring (0-100)
- `scripts/citation_manager.py` — citation tracking
- `scripts/md_to_html.py` — markdown to HTML conversion
- `scripts/verify_html.py` — HTML output validation
