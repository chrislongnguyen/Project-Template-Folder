# /deep-research — Gotchas

Known failure patterns from observed executions. Update this file when new issues are discovered.

---

## 1. LT-1 Citation fabrication (observed)

**What happens:** Agent generates plausible-looking URLs, DOIs, and paper titles from parametric memory instead of actual search results. This is the #1 LT-1 risk for research skills.

**How to detect:** Run `scripts/verify_citations.py`. Citations without a URL traceable to a search result in this session are suspect.

**Fix:** Every citation must come from an actual search result returned in the current session. If you cannot find the source URL in your tool call results, do not cite it. Remove fabricated citations, note the gap in Methodology under "Limitations."

---

## 2. Truncated bibliography (observed)

**What happens:** Report cites [1]-[N] but bibliography has fewer than N entries. Remaining are orphan inline citations with no backing.

**How to detect:** `scripts/validate_report.py` checks inline vs bibliography count. Also manually count.

**Fix:** Track citations per section during progressive generation. Verify count matches before finalizing.

---

## 3. Phase 6/7 collapse — skipping CRITIQUE and REFINE (observed: 2026-03-28)

**What happens:** Agent executes retrieval (Phase 3) well, then collapses Phases 4-7 into mental synthesis and jumps straight to Phase 8 (PACKAGE). The critique and refinement phases — which exist precisely to catch gaps the synthesizer misses (LT-3) — are skipped entirely. The agent rationalizes: "I can synthesize without a formal critique pass."

**How to detect:** Check whether a separate critic agent was spawned for Phase 6. If the report went straight from retrieval/synthesis to writing without a critic agent output, this gotcha has fired.

**Fix:** HARD-GATE 4 now enforces this. On deep/full modes, Phase 6 MUST spawn a critic agent. Phase 7 MUST address the critique output. These are not optional optimization steps — they are the primary LT-3 compensation mechanism.

**Evidence:** Self-audit 2026-03-28 — LT-3 thinking-mode gap was caught by sub-agents completing after the report, not by a deliberate critique pass. The gap would have been caught in Phase 6 if it had run.

---

## 4. Output contract incomplete — missing PDF and source_evaluator (observed: 2026-03-28)

**What happens:** Agent delivers Markdown + HTML but skips PDF generation and source credibility scoring. The output contract requires all three formats and credibility scores per source.

**How to detect:** Check output directory for .pdf file. Check methodology appendix for numeric credibility scores (0-100 per source).

**Fix:** GATE — Verify now requires all 3 formats + source_evaluator output before delivery. PDF requires spawning a sub-agent with the generating-pdf skill.

---

## 5. report_template.md not loaded before writing (observed: 2026-03-28)

**What happens:** Agent derives report structure from methodology.md or memory instead of loading report_template.md first. This causes missing required subsections (e.g., "Counterevidence Register" flagged by validate_report.py).

**How to detect:** If `scripts/validate_report.py` flags missing sections that are in the template, the template wasn't loaded.

**Fix:** Phase 8 MUST load `templates/report_template.md` FIRST, before generating any section. The template defines the required structure — methodology.md defines the process.

---

## 6. Monolithic report write instead of progressive sections (observed: 2026-03-28)

**What happens:** Agent writes the entire report (~45K characters) in a single Write call instead of generating one section at a time per the progressive section protocol. This works for shorter reports but violates the protocol designed to handle long reports without truncation, and bypasses the per-section quality checks (3+ paragraphs, <20% bullets, zero placeholders).

**How to detect:** Check tool call history — if the report was created with a single Write instead of sequential Write/Edit per section.

**Fix:** Follow the progressive pattern: Generate section → Write/Edit to file → Track citations → Verify section quality → Next section. See `reference/report-generation.md` Progressive Section Generation.

---

## 7. Bullet-heavy writing (observed: 2026-03-28)

**What happens:** Findings sections use bullet lists instead of narrative prose. The writing standard says 80%+ prose, <20% bullets. Bullets are for distinct enumerable items only (lists of tools, specific metrics), not for conveying analysis or argument.

**How to detect:** Scan each major section for the ratio of bullet lines to paragraph lines. If a section is >50% bullets, it fails.

**Fix:** The per-section Anti-Fatigue Quality Check in report-generation.md enforces this. Before moving to the next section, verify <20% bullet points.

---

## 8. Wrong mode on auto-trigger (observed)

**What happens:** Skill auto-triggers at research:deep (350K tokens) when research:lite (70K tokens) was appropriate. The mode selection tree says auto-trigger defaults to research:lite.

**How to detect:** Check the mode announced in Phase 2. If auto-triggered and mode is anything other than research:lite, this has fired.

**Fix:** Follow the Decision Tree strictly — auto-triggered research ALWAYS starts at research:lite. Escalate only on explicit user request.

---

## 9. ~/.claude/research_output/ copy not saved (observed: 2026-03-28)

**What happens:** Report saved to `~/Documents/` but the internal tracking copy to `~/.claude/research_output/` is forgotten.

**How to detect:** Check whether both paths exist after delivery.

**Fix:** Part of the GATE — Verify checklist. Both output locations required.

---

## 10. Sub-agent failure silently absorbed (observed)

**What happens:** A retrieval or research sub-agent fails or returns generic output. Instead of reporting the failure, the lead agent silently generates the missing content from its own context — which is lower quality and potentially hallucinated.

**How to detect:** Check whether every report section's content traces to sub-agent output or direct search results. If a section has no source attribution, it may have been silently generated.

**Fix:** Error Handling section in SKILL.md now requires: report which agent failed, offer retry/proceed-without/ask-user. Never silently substitute.

---

## 11. McKinsey template used as content structure guide (observed: 2026-03-28)

**What happens:** Agent uses mckinsey_report_template.html to determine report section structure instead of report_template.md. The McKinsey template is for HTML rendering (colors, grid, metrics dashboard) — NOT content structure. report_template.md defines per-section guidance, per-finding sub-blocks (Key Evidence + Implications + Sources), Counterevidence Register, and Claims-Evidence Table format.

**How to detect:** If validate_report.py flags missing sections (like "Counterevidence Register") that exist in report_template.md but not in the McKinsey template.

**Fix:** Phase 8 Step 1 now explicitly says: load report_template.md as EXCLUSIVE content guide. McKinsey template used only in Step 4 for HTML visual styling.

---

## 12. Using sub-agents where agent team pattern was needed (observed: 2026-03-28)

**What happens:** Agent dispatches all research as parallel independent sub-agents (no coordination). This is correct for Phase 3 retrieval (independent angles). But for Phase 5-7 synthesis/critique/refinement, a critic agent needs to READ the synthesizer's output — which requires sequential coordination, not parallel independence.

**How to detect:** If Phase 6 critique does not reference specific claims or sections from the Phase 5 synthesis, it was likely dispatched in parallel without seeing the synthesis.

**Fix:** Hybrid pattern now specified in SKILL.md: sub-agents for Phase 3 (independent retrieval), agent team for Phase 5-7 (sequential with critic). Check `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` before dispatching teams; fall back to sequential Agent calls if disabled.
