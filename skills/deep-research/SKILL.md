---
name: deep-research
description: Multi-source research using the 12-question CODE framework (Knowledge → Understanding → Wisdom → Expertise) with Blue-Red team falsification. 4 modes — research:lite (2-5min, ~70K tokens), research:mid (5-10min, ~200K tokens), research:deep (10-20min, ~350K tokens), research:full (20-45min, ~600K tokens). When auto-triggered, default to research:lite. Use this skill whenever the user asks to compare tools/products, analyze market trends, evaluate options for a decision, produce a cited report, or do any research requiring synthesis across 3+ sources. Do NOT use for fixing bugs, writing code, simple factual lookups, or questions with one clear answer.
---

# Deep Research

## Decision Tree (Execute First)

```
Request Analysis
├─ Simple lookup? → STOP: Use WebSearch, not this skill
├─ Debugging? → STOP: Use standard tools, not this skill
├─ Binary hypothesis to test? → Use SPIKE template (templates/SPIKE_TEMPLATE.md)
│   ("Can we...?" / "Does X work?" / "Is Y feasible?")
└─ Topic to understand? → CONTINUE (12-question CODE research)

Mode Selection (auto-trigger defaults to research:lite)
├─ Auto-triggered or "quick look" → research:lite (all 12 Qs, 1-2 sentences each)
├─ User requests /deep-research → research:mid (all 12 Qs, 1-2 paragraphs each)
├─ "deep" or critical decision → research:deep (all 12 Qs, full analysis)
└─ "full" or "comprehensive" → research:full (all 12 Qs, maximum rigor + iterations)
```

---

## Architecture by Mode

ALL modes answer ALL 12 questions. Depth varies, not question count.

**research:lite** (~70K tokens, 2-5 min, 5-10 sources)
- 2 sub-agents (Sonnet): A handles Q1-Q6, B handles Q7-Q12
- Lead (Opus) assembles report

**research:mid** (~200K tokens, 5-10 min, 10-20 sources)
- 3 sub-agents (Sonnet): A=Q1-Q4, B=Q5-Q8, C=Q9-Q12
- Parallel retrieval sub-agents for source gathering
- Lead (Opus) assembles report

**research:deep** (~350K tokens, 10-20 min, 20-30 sources)
- Blue-Red agent team:
  - Blue: Researcher-Context (Sonnet, Q1-Q3 → §1), Researcher-Mechanics (Sonnet, Q4-Q5 → §2.1-2.2), Researcher-Application (Sonnet, Q7-Q8+Q12 → §3+§4.4)
  - Red: Critic (Opus, Q6+Q9-Q11 → §2.3+§4.1-4.3) — radical falsification
  - Lead (Opus) — scopes, plans, synthesizes, writes exec summary, assembles
- Cross-pollination via SendMessage between teammates

**research:full** (~600K tokens, 20-45 min, 30-50 sources)
- Same as deep + Red team gets 2 iterative falsification rounds
- Additional targeted retrieval after gap detection

### Model Selection

| Role | Model | Rationale |
|---|---|---|
| Retrieval sub-agents | Sonnet | Fast, cheap, search+extract |
| Blue researchers (deep/full) | Sonnet | Analysis within 3-question scope |
| Lead orchestrator | Opus | Synthesis across all 12 questions |
| Red team critic | Opus | Falsification needs deep reasoning |

---

## Workflow

**AUTONOMY PRINCIPLE:** Proceed independently. Only stop for incomprehensible queries or contradictory requirements.

1. **Clarify** (rarely needed) — derive assumptions from context, default to research:lite
2. **Plan** — announce mode, budget, source target. Proceed without waiting.
3. **Act** — dispatch sub-agents/team per mode architecture above. Load [methodology](./reference/methodology.md) on demand.
4. **Verify** — run `scripts/verify_citations.py` + `scripts/validate_report.py`. If suspicious citations: remove/replace, re-run. After 2 failures → stop and ask user.
5. **Report** — generate per [report_template.md](./templates/report_template.md), then HTML via [mckinsey template](./templates/mckinsey_report_template.html). Output: Markdown + HTML + PDF to `~/Documents/[Topic]_Research_[YYYYMMDD]/`.

---

## Blue-Red Team Protocol (deep/full only)

**Blue Team (Build the case):**
- Each Blue researcher owns a question cluster and searches across ALL source types
- Each writes their owned report sections to separate temp files
- Cross-pollinate leads via SendMessage

**Red Team (Radical falsification):**
- For each major Blue claim, actively search for COUNTER-EVIDENCE
- If claim survives falsification → mark HIGH confidence in claims-evidence table
- If claim is falsified → report honestly in §2.3 (Why It Fails)
- Challenge assumptions underneath claims, not just the claims themselves
- Check for cognitive biases: confirmation, anchoring, survivorship, availability
- Q6 (failure modes), Q9 (misconceptions), Q10 (anti-patterns), Q11 (contingencies) are Critic's PRIMARY research questions

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

- **Narrative prose** — flowing paragraphs, not bullet lists. Bullets only for distinct enumerable items.
- **Precision** — "reduced mortality 23% (p<0.01)" not "significantly improved outcomes"
- **Economy** — no fluff, every word carries intention
- **Citation density** — major claims cited in the same sentence, not end-of-paragraph
- **No placeholders** — zero TBD, TODO, "content continues", "due to length", or truncation

---

## Output Contract

Report must include all sections from [template](./templates/report_template.md):

| Section | Requirement |
|---|---|
| Executive Summary | 50-250 words, key findings + primary recommendation + confidence level |
| Context (§1) | Q1-Q3: relevance, definition, landscape & alternatives |
| Mechanics (§2) | Q4-Q6: how it works, why it works, why it fails (Red team findings) |
| Application (§3) | Q7-Q8: practical benefits, recommendations with actions + timelines |
| Mastery (§4) | Q9-Q12: misconceptions, anti-patterns, contingencies, competitive edge |
| Sources | EVERY citation [N] with full metadata — no ranges, no placeholders, no truncation |
| Methodology | Process, source types, claims-evidence table with falsification results |

**Bibliography: ZERO TOLERANCE.** If report cites [1]-[30], bibliography must contain all 30 entries in full.

---

## Error Handling

- 2 validation failures on same error → stop, report to user, ask for direction
- <5 sources after exhaustive search → report limitation, request user direction
- 5-10 sources → note in limitations, proceed with extra verification
- User interrupts or changes scope → confirm new direction before continuing

---

## Quality Gates

- Source minimums: lite 5+, mid 10+, deep 20+, full 30+ (document if fewer)
- 3+ independent sources per major claim
- Executive summary <250 words, full citations with URLs
- Credibility assessment per source (0-100 via `scripts/source_evaluator.py`)
- No placeholders anywhere in the report

---

## References (Load On-Demand)

- [Methodology](./reference/methodology.md) — phase pipeline, parallel execution
- [Report Generation](./reference/report-generation.md) — progressive assembly, HTML/PDF output
- [Report Template](./templates/report_template.md) — 12-question CODE section structure
- [SPIKE Template](./templates/SPIKE_TEMPLATE.md) — binary hypothesis investigation
- [McKinsey HTML Template](./templates/mckinsey_report_template.html) — HTML styling

## Scripts (Python stdlib only)

- `scripts/validate_report.py` — 9-check quality validation
- `scripts/verify_citations.py` — DOI resolution, fabrication detection
- `scripts/source_evaluator.py` — source credibility scoring (0-100)
- `scripts/citation_manager.py` — citation tracking
- `scripts/md_to_html.py` — markdown to HTML conversion
- `scripts/verify_html.py` — HTML output validation
