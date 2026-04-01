---
version: "1.2"
last_updated: 2026-03-30
owner: "Long Nguyen"
test_date: 2026-03-30
branch: "feat/multi-agent-orchestration"
---

# Hypothesis Test Results — Multi-Agent Orchestration

> Test date: 2026-03-30. All tests ran as paired sub-agents (A=control, B=treatment) in a single session.
> Design spec: `2-LEARN/research/multi-agent-orchestration-design.md` Section 5 (Approach D).

---

## Raw Token Data

| Test | Role | Model | Total Tokens | Tool Uses | Duration (s) |
|---|---|---|---|---|---|
| H1 Control (ad-hoc prompt) | Sonnet | claude-sonnet-4-6 | 14,396 | 0 | 15.6 |
| H1 Treatment (scoped prompt) | Sonnet | claude-sonnet-4-6 | 14,257 | 0 | 9.4 |
| H2 Control (WebSearch) | Haiku | claude-haiku-4-5 | 55,055 | 6 | 24.7 |
| H2 Treatment (Exa MCP) | Haiku | claude-haiku-4-5 | 53,826 | 3 | 12.8 |
| H5 Control (ad-hoc prompt) | Sonnet | claude-sonnet-4-6 | 23,258 | 4 | 35.3 |
| H5 Treatment (context packaging v2.0) | Sonnet | claude-sonnet-4-6 | 14,685 | 0 | 14.4 |

---

## H1: Agent File Scope vs Inline Instructions

**Question:** Does a scoped system prompt (agent file style) produce better-constrained output than an ad-hoc inline prompt?

**Test artifact:** 1-page agent roster summary for 4 MECE agents (identical task for both agents).

### Scoring

| # | Measure | Control (A) | Treatment (B) | Winner |
|---|---|---|---|---|
| 1 | Stayed in scope? | Added unsolicited frontmatter + cost annotation in diagram | Strictly followed 3-section specification | B |
| 2 | Unsolicited extras? | Yes — YAML frontmatter, extended multi-line descriptions, diagram annotations | None — exactly what was specified | B |
| 3 | All 4 agents covered? | Yes | Yes | Tie |
| 4 | Structural compliance? | 3 required sections present + extras added | Exactly 3 sections, no additions | B |

### Metrics

| Metric | Control (A) | Treatment (B) | Delta |
|---|---|---|---|
| Total tokens | 14,396 | 14,257 | -1.0% |
| Tool calls | 0 | 0 | 0% |
| Wall-clock | 15.6s | 9.4s | -39.7% |

### Gate Evaluation

**Gate:** B >= A on 3/4 quality measures.
**Result: PASS** — B wins 3/4, ties 1/4.

### Key Finding

Scoped prompts enforce **scope boundaries**, not token savings. The ad-hoc agent added frontmatter, extended descriptions, and diagram annotations it was not asked for — classic LT-8 (alignment drift toward "helpful" extras). The scoped agent produced exactly what was specified. Token cost is equivalent; the value is in **behavioral constraint**.

### Implication

Agent files with explicit scope declarations are validated. The benefit is not cost reduction but **predictable output boundaries** — critical for multi-agent systems where one agent's scope creep corrupts another's input.

---

## H2: Exa MCP vs WebSearch for Research

**Question:** Does Exa MCP return higher-quality sources with less token overhead than WebSearch for a known research topic?

**Test topic:** "LLM multi-agent orchestration patterns 2025" — identical query for both agents.

### Scoring

| # | Measure | Control (WebSearch) | Treatment (Exa) | Winner |
|---|---|---|---|---|
| 1 | Source count | 10 | 10 | Tie |
| 2 | Source relevance | 3 academic papers (ArXiv), 4 official docs (OpenAI, IBM, MS, Google), 3 blogs | 0 academic papers, 1 official doc (MS Azure), 8 blogs, 1 YouTube video | A |
| 3 | Junk/duplicate ratio | 0% junk, 0 duplicates | ~10% (1 YouTube video), 0 duplicates | A |
| 4 | Structured output | Clean table + categorized summary by source type | Clean table + key patterns summary | Tie |

### Source Quality Breakdown

| Source Type | Control (WebSearch) | Treatment (Exa) |
|---|---|---|
| Academic papers | 3 (ArXiv) | 0 |
| Official documentation | 4 (OpenAI, IBM, MS, Google) | 1 (MS Azure) |
| Blogs / tutorials | 3 | 8 |
| Video | 0 | 1 |

### Metrics

| Metric | Control (A) | Treatment (B) | Delta |
|---|---|---|---|
| Total tokens | 55,055 | 53,826 | -2.2% |
| Tool calls | 6 | 3 | -50.0% |
| Wall-clock | 24.7s | 12.8s | -48.2% |

### Gate Evaluation

**Gate:** >= 30% token reduction on search operations AND >= same source quality.
**Result: FAIL** — Token reduction is 2.2% (far below 30% threshold). Source quality is worse (0 academic papers vs 3).

### Key Finding

Exa is **faster** (48% less time) and uses **fewer tool calls** (50%), but WebSearch produces **higher-quality sources** — particularly academic papers and official documentation. Exa's results skew toward blog content.

### Implication

Exa should NOT be mandated as the primary search tool. **Revised recommendation:** Both tools available as peers. Use Exa when speed matters and source authority is less critical. Use WebSearch when source quality and academic rigor matter (e.g., EP grounding, ADR evidence). Skills should reference both without preference hierarchy.

---

## H5: Context Packaging v2.0 vs Ad-Hoc Prompting

**Question:** Does the 5-field context packaging template (EO/INPUT/EP/OUTPUT/VERIFY) produce more complete sub-agent output than a freeform prompt?

**Test artifact:** EP-11: Agent Role Separation — identical content provided to both agents.

### Scoring

| # | Measure | Control (ad-hoc) | Treatment (packaged) | Winner |
|---|---|---|---|---|
| 1 | All 7 sections present? | Yes | Yes | Tie |
| 2 | Template placeholders remaining? | None | None | Tie |
| 3 | LT/UT grounding explicit? | Yes — explains why each LT applies | Yes — explains why each LT applies | Tie |
| 4 | APEI Application specific? | Yes — BUT hallucinated 2 non-existent agents ("ltc-risk-auditor", "ltc-qa") | Yes — all 4 real agents correctly named | B |
| 5 | Format matches EP exemplar? | Correct [DERISK] tag | Wrong tag [EOE] instead of [DERISK] | A |

### Failure Mode Analysis

| Agent | Failure | Severity | Root Cause |
|---|---|---|---|
| Control (ad-hoc) | Hallucinated 2 non-existent agents | **High** — factual error (LT-1) | No agent roster in INPUT; agent invented plausible names |
| Treatment (packaged) | Wrong EP tag format ([EOE] vs [DERISK]) | **Low** — format error | Tag convention not specified in EP constraints field |

### Metrics

| Metric | Control (A) | Treatment (B) | Delta |
|---|---|---|---|
| Total tokens | 23,258 | 14,685 | **-36.9%** |
| Tool calls | 4 | 0 | **-100%** |
| Wall-clock | 35.3s | 14.4s | **-59.2%** |

### Gate Evaluation

**Gate:** B >= A on 4/5 quality measures; B has 0 missing sections.
**Result: PASS** — B wins 1/5, A wins 1/5, 3 ties. Both have 0 missing sections. But B is dramatically more efficient AND its failure mode (format error) is less severe than A's (hallucination).

### Key Finding

Context packaging produces **37% fewer tokens** and **zero tool calls** because:
1. The VERIFY section told the agent exactly what to check — no exploratory tool calls needed
2. The INPUT section provided all context — the agent didn't need to Read files to understand the format
3. The EP section constrained behavior — less drift

The ad-hoc agent spent 4 tool calls reading the codebase to understand the EP format and **still hallucinated non-existent agents** (LT-1). The packaged agent's only error was a tag convention issue — easily fixed by adding `[DERISK/OUTPUT]` tag syntax to the EP constraints.

### Implication

Context packaging v2.0 is validated as the standard sub-agent dispatch pattern. The 37% token reduction and elimination of tool exploration is significant for cost efficiency. The VERIFY field is the highest-value addition — it acts as an embedded acceptance criterion that the agent self-checks against (EP-10: Define Done at the sub-agent level).

**Improvement:** Add tag convention (`[DERISK]` or `[OUTPUT]`) to context packaging EP field when dispatching EP-related tasks.

---

## Summary

| Hypothesis | Gate Criteria | Result | Token Delta | Key Insight |
|---|---|---|---|---|
| H1: Agent scope | B >= A on 3/4 | **PASS** | -1% | Scope enforcement, not cost savings |
| H2: Exa vs WebSearch | >= 30% token reduction | **FAIL** | -2% | Exa faster but WebSearch higher quality |
| H5: Context packaging | B >= A on 4/5 | **PASS** | **-37%** | Biggest win — fewer tokens, zero tool calls, less hallucination |

### Design Decisions Informed

1. **Agent files with scope declarations** — KEEP. H1 validates behavioral constraint value.
2. **Exa as mandatory primary** — REVISE to optional peer alongside WebSearch. H2 shows quality trade-off.
3. **Context packaging v2.0** — KEEP and STRENGTHEN. H5 validates both efficiency and quality.
4. **VERIFY field in context packaging** — highest-leverage single addition. Embeds EP-10 at sub-agent level.

### Baseline Note

T0.5 (full /deep-research baseline) remains deferred — requires a complete skill run in a dedicated session. The H2 paired test provides partial baseline data for search operations specifically.

---

*Test protocol designed and executed: 2026-03-30*
*Lead agent: Claude Opus 4.6 | Sub-agents: 4x Sonnet, 2x Haiku*
*Total test cost: 6 sub-agent dispatches (~175K tokens)*
