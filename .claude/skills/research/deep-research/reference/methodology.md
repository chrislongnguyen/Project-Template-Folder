---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---
# Deep Research Methodology: 8-Phase Pipeline

## Overview

8-phase pipeline answering 12 CODE questions at varying depth. All modes answer all 12 questions.

### 12-Question CODE Framework

| § | Domain | Questions |
|---|--------|-----------|
| §1 Context | Knowledge | Q1: Why this matters, Q2: What is it, Q3: Landscape & alternatives |
| §2 Mechanics | Understanding | Q4: How it works, Q5: Why it works, Q6: Why it fails |
| §3 Application | Wisdom | Q7: How we benefit, Q8: Recommendations |
| §4 Mastery | Expertise | Q9: Misconceptions, Q10: Anti-patterns, Q11: Contingencies, Q12: Competitive edge |

### Hybrid Agent Pattern

Phase 3 uses **parallel sub-agents** — independent retrieval, no coordination, all return to lead. Correct when research angles are genuinely independent.

Phase 5-7 on deep/full use an **agent team** (if `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` enabled) — sequential, collaborative, critic reads synthesizer output. If teams disabled: use sequential Agent calls with explicit output passing.

| Phase | Pattern | Why |
|-------|---------|-----|
| 3 RETRIEVE | Parallel sub-agents | Research angles are independent |
| 5 SYNTHESIZE | Lead agent or team | Connects insights across all questions |
| 6 CRITIQUE | Separate critic agent (MANDATORY deep/full) | Must read Phase 5 output to challenge it |
| 7 REFINE | Lead agent | Addresses critique gaps |

---

## Phase 1: SCOPE — Research Framing

**Objective:** Define research boundaries and success criteria. Decompose into the 12 CODE questions, define scope (in/out), establish success criteria, list assumptions to validate.

**Output:** Structured scope with research boundaries and question mapping

---

## Phase 2: PLAN — Strategy Formulation

**Objective:** Create research roadmap. Identify sources, map knowledge dependencies, create search query strategy, plan triangulation, estimate effort, define quality gates.

**Output:** Research plan with prioritized investigation paths

---

## Phase 3: RETRIEVE — Parallel Information Gathering (Sub-Agent Pattern)

**Objective:** Systematically collect information using parallel sub-agents for maximum speed

**CRITICAL: Execute ALL searches in parallel using a single message with multiple tool calls**

### Query Decomposition Strategy

Before launching searches, decompose the research question into 5-10 independent search angles:

1. **Core topic (semantic search)** - Meaning-based exploration of main concept
2. **Technical details (keyword search)** - Specific terms, APIs, implementations
3. **Recent developments (date-filtered)** - What's new in 2024-2025
4. **Academic sources (domain-specific)** - Papers, research, formal analysis
5. **Alternative perspectives (comparison)** - Competing approaches, criticisms
6. **Statistical/data sources** - Quantitative evidence, metrics, benchmarks
7. **Industry analysis** - Commercial applications, market trends
8. **Critical analysis/limitations** - Known problems, failure modes, edge cases

### Parallel Execution Protocol

**Step 1: Launch ALL searches concurrently (single message)**

Route each search angle to the best available tool: Exa MCP (semantic, code, company, crawl) when available, WebSearch for breaking news and domain-filtered queries, WebFetch as crawl fallback. Never mix parameter styles between tools.

**Step 2: Spawn parallel deep-dive agents**

Use Task tool with 3-5 general-purpose agents for: academic paper analysis, documentation deep dives, repository analysis, specialized domain research.

**Step 3: Collect and organize results**

As results arrive:
1. Extract key passages with source metadata (title, URL, date, credibility)
2. Track information gaps that emerge
3. Follow promising tangents with additional targeted searches
4. Maintain source diversity (mix academic, industry, news, technical docs)
5. Monitor for quality threshold (see FFS pattern below)

### First Finish Search (FFS) Pattern

**Adaptive completion based on quality threshold:**

**Quality gate:** Proceed to Phase 4 when FIRST threshold reached:
- **Lite mode:** 10+ sources with avg credibility >60/100 OR 2 minutes elapsed
- **Mid mode:** 15+ sources with avg credibility >60/100 OR 5 minutes elapsed
- **Deep mode:** 25+ sources with avg credibility >70/100 OR 10 minutes elapsed
- **Full mode:** 30+ sources with avg credibility >75/100 OR 15 minutes elapsed

**Continue background searches:**
- If threshold reached early, continue remaining parallel searches in background
- Additional sources used in Phase 5 (SYNTHESIZE) for depth and diversity
- Allows fast progression without sacrificing thoroughness

### Quality Standards

**Source diversity requirements:**
- Minimum 3 source types (academic, industry, news, technical docs)
- Temporal diversity (mix of recent 2024-2025 + foundational older sources)
- Perspective diversity (proponents + critics + neutral analysis)
- Geographic diversity (not just US sources)

**Credibility tracking:**
- Score each source 0-100 using source_evaluator.py
- Flag low-credibility sources (<40) for additional verification
- Prioritize high-credibility sources (>80) for core claims

**Tool selection:** Route each search angle to the best available tool (Exa for semantic/company/code, WebSearch for news/date-filtered, WebFetch as crawl fallback). Spawn 3-5 parallel retrieval agents via Task tool.

**Output:** Organized information repository with source tracking, credibility scores, and coverage map

---

## Phase 4: TRIANGULATE - Cross-Reference Verification

**Objective:** Validate information across multiple independent sources

**Activities:**
1. Identify claims requiring verification
2. Cross-reference facts across 3+ sources
3. Flag contradictions or uncertainties
4. Assess source credibility
5. Note consensus vs. debate areas
6. Document verification status per claim

**Quality Standards:**
- Core claims must have 3+ independent sources
- Flag any single-source information
- Note recency of information
- Identify potential biases

**Output:** Verified fact base with confidence levels

**GATE:** Core claims have 3+ independent sources. Single-source claims flagged. If <5 total sources → stop, report limitation to user.

---

## Phase 4.5: OUTLINE REFINEMENT (mid/deep/full only)

**Objective:** Adapt research direction based on evidence discovered. Prevents "locked-in" research when evidence contradicts initial assumptions.

**Adaptation signals (ANY triggers refinement):**
- Major findings contradict initial assumptions
- Evidence reveals more important angle than originally scoped
- Critical subtopic emerged that wasn't in original plan
- Sources consistently discuss aspects not in initial outline

**If adaptation needed:**
1. Add/demote/reorder sections based on evidence strength
2. Launch 2-3 targeted searches for newly identified angles (time-box 2-5 min)
3. Record in methodology appendix: what changed, why, what additional research was conducted

**Constraints:** Adaptation must cite specific sources. No more than 50% outline restructuring. Retain original research question core. New sections must have supporting evidence already gathered.

**Output:** Refined outline that accurately reflects evidence landscape

---

## Phase 5: SYNTHESIZE — Deep Analysis

**Objective:** Connect insights across all 12 CODE questions. Identify patterns, map relationships, generate insights beyond source material. Use extended reasoning for non-obvious connections and second-order implications.

**Output:** Synthesized understanding with insight generation

**HARD-GATE (deep/full):** Do NOT proceed to Phase 8. MUST spawn a separate critic agent for Phase 6. Lite/mid: proceed to Phase 8 after self-review.

---

## Phase 6: CRITIQUE — Quality Assurance (MANDATORY on deep/full)

**Objective:** Independent falsification of Phase 5 synthesis. Spawn a separate critic agent that reads the synthesis output.

**Critic agent owns:** Q6 (failure modes), Q9 (misconceptions), Q10 (anti-patterns), Q11 (contingencies).

**Red Team Questions:**
- What's missing?
- What could be wrong?
- What alternative explanations exist?
- What biases might be present?
- What counterfactuals should be considered?

**A critique that finds zero issues is a failed critique.** LT-8 (alignment drift) means the synthesizer will optimize for plausible over correct. The critic exists to challenge this.

**Output:** Critique report with ≥1 actionable gap identified

**GATE:** At least 1 gap identified. If critic returns "no issues found" → re-prompt with specific sections to challenge. Do NOT proceed with an empty critique.

---

## Phase 7: REFINE — Iterative Improvement (MANDATORY on deep/full)

**Objective:** Address every gap from Phase 6 critique. For each gap: fix it, acknowledge in Limitations, or justify as out-of-scope.

**Activities:** Targeted research for gaps, strengthen weak arguments, resolve contradictions, add missing perspectives.

**Output:** Strengthened research with every critique gap dispositioned

**GATE:** Every gap from Phase 6 critique has been: fixed, acknowledged in Limitations, or justified as out-of-scope with reasoning.

---

## Phase 8: PACKAGE - Report Generation

**Objective:** Deliver professional, actionable research

**Step 1:** Load `templates/report_template.md` — EXCLUSIVE content structure guide (sections, per-finding sub-block pattern, Counterevidence Register, Claims-Evidence Table).

**Step 2:** Generate report using progressive section assembly per `reference/report-generation.md`. Section order must match report_template.md: Executive Summary → §1 Context → §2 Mechanics → §3 Application → §4 Mastery → Sources → Methodology. One Write/Edit per section — prevents LT-2 degradation.

**Step 3:** Run validation scripts. If unavailable, manual verification.

**Step 4:** Generate HTML using `mckinsey_report_template.html` for visual styling ONLY (not content structure).

**Step 5:** Generate PDF. If unavailable, note as pending.

**Step 6:** Save to `~/Documents/[Topic]_Research_[YYYYMMDD]/` + copy to `~/.claude/research_output/`

**Output:** Markdown + HTML + PDF

---

## Phase Enforcement Summary

| Transition | Gate Type | Enforcement |
|---|---|---|
| Phase 3 → 4 | GATE | Source minimum met |
| Phase 4 → 4.5 | Conditional | Mid/deep/full only |
| Phase 5 → 6 | HARD-GATE | Deep/full: MUST spawn critic agent |
| Phase 6 → 7 | GATE | ≥1 gap identified and addressed |
| Phase 7 → 8 | GATE | All Phase 6 gaps resolved |
| Phase 8 → Delivery | GATE — Verify | All output contract items present |
