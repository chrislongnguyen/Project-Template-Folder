---
version: "1.2"
last_updated: 2026-03-30
owner: "Long Nguyen"
name: deep-research
description: Multi-source research using the 12-question CODE framework (Knowledge → Understanding → Wisdom → Expertise) with Blue-Red team falsification. 4 modes — research:lite (2-5min, ~70K tokens), research:mid (5-10min, ~200K tokens), research:deep (10-20min, ~350K tokens), research:full (20-45min, ~600K tokens). When auto-triggered, default to research:lite. Use this skill whenever the user asks to compare tools/products, analyze market trends, evaluate options for a decision, produce a cited report, or do any research requiring synthesis across 3+ sources. Do NOT use for fixing bugs, writing code, simple factual lookups, or questions with one clear answer.
agents:
  research: ltc-explorer
tool-preference: "Exa MCP and WebSearch are peers. Exa for speed; WebSearch for source quality and academic rigor."
---
# Deep Research

**Agent dispatch:** For research sub-agent spawning, use `ltc-explorer` (`.claude/agents/ltc-explorer.md`) — Haiku model, optimized for fast wide-net search. **Context packaging:** Use `.claude/skills/dsbv/references/context-packaging.md` (EO, INPUT, EP, OUTPUT, VERIFY).
**Tool preference:** Exa MCP and WebSearch are both available for external research. Exa is faster (48% fewer tool calls); WebSearch finds higher-quality sources (academic papers, official docs). Choose based on task requirements.

## Decision Tree (Execute First)

```
Request Analysis
├─ Simple lookup? → STOP: Use WebSearch, not this skill
├─ Debugging? → STOP: Use standard tools, not this skill
├─ Binary hypothesis to test? → Use SPIKE template (templates/spike-template.md)
│   ("Can we...?" / "Does X work?" / "Is Y feasible?")
└─ Topic to understand? → CONTINUE (12-question CODE research)

Mode Selection (auto-trigger defaults to research:lite)
├─ Auto-triggered or "quick look" → research:lite (all 12 Qs, 1-2 sentences each)
├─ User requests /deep-research → research:mid (all 12 Qs, 1-2 paragraphs each)
├─ "deep" or critical decision → research:deep (all 12 Qs, full analysis)
└─ "full" or "comprehensive" → research:full (all 12 Qs, maximum rigor + iterations)
```

<HARD-GATE>
1. Do NOT fabricate citations — every factual claim MUST cite a specific source [N] from a search result in this session. Never from parametric memory.
2. Do NOT skip validation — run `scripts/verify_citations.py` + `scripts/validate_report.py` before presenting. If scripts not found, perform manual verification (see Error Handling).
3. Do NOT truncate the bibliography — every [N] cited in the body must appear in Sources. Zero tolerance.
4. Do NOT skip Phase 6 (CRITIQUE) or Phase 7 (REFINE) on deep/full modes. These phases exist because LT-3 degrades synthesis quality — the critique catches gaps the synthesizer misses.
5. After 2 validation failures on the same error, STOP and ask the user for direction.
</HARD-GATE>

---

## Architecture by Mode

ALL modes answer ALL 12 questions. Depth varies, not question count.

### Hybrid Pattern: Sub-Agents for Retrieval, Agent Team for Synthesis

Phase 3 (RETRIEVE) uses **parallel sub-agents** — independent, no coordination, all return to lead. Correct when research angles are genuinely independent.

Phase 5-7 (SYNTHESIZE/CRITIQUE/REFINE) on deep/full use an **agent team** — sequential, collaborative, agents read each other's outputs. The critic reviews the synthesizer's draft before packaging.

**Pre-check (deep/full):** Before dispatching agent teams, verify `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` is enabled. If not: fall back to sub-agent pattern with explicit critic dispatch via separate Agent call. Warn user that agent teams are disabled and critique will be sequential, not collaborative.

### Mode Architectures

**research:lite** (~70K tokens, 2-5 min, 5-10 sources)
- 2 sub-agents: A handles Q1-Q6, B handles Q7-Q12
- Lead assembles report

**research:mid** (~200K tokens, 5-10 min, 10-20 sources)
- 3 sub-agents: A=Q1-Q4, B=Q5-Q8, C=Q9-Q12
- Parallel retrieval sub-agents for source gathering
- Lead assembles report

**research:deep** (~350K tokens, 10-20 min, 20-30 sources)
- Phase 3: Parallel sub-agents per research angle (independent retrieval)
- Phase 5-7: Agent team (if enabled) or sequential agents:
  - Blue: Researcher-Context (Q1-Q3 → §1), Researcher-Mechanics (Q4-Q5 → §2.1-2.2), Researcher-Application (Q7-Q8+Q12 → §3+§4.4)
  - Red: Critic (Q6+Q9-Q11 → §2.3+§4.1-4.3) — radical falsification
  - Lead — scopes, plans, synthesizes, writes exec summary, assembles

**research:full** (~600K tokens, 20-45 min, 30-50 sources)
- Same as deep + Red team gets 2 iterative falsification rounds
- Additional targeted retrieval after gap detection

---

## 8-Phase Workflow

**AUTONOMY PRINCIPLE:** Proceed independently. Only stop for incomprehensible queries or contradictory requirements. Scope changes require human approval; source evaluation does not.

### Phase 1-2: SCOPE + PLAN
Announce mode, budget, source target. Decompose question into search angles. Proceed without waiting.

### Phase 3: RETRIEVE
Dispatch ALL searches in parallel (single message, sub-agent pattern). Load [methodology](./reference/methodology.md) for retrieval protocol, FFS pattern, and source diversity requirements.

**GATE:** Source minimum reached (lite 5+, mid 10+, deep 20+, full 30+). If <5 after exhaustive search → report limitation, ask user.

### Phase 4: TRIANGULATE
Cross-reference claims across 3+ sources. Flag contradictions. Run `scripts/source_evaluator.py` for credibility scores. If script not found: assess credibility manually (institutional source >80, news outlet 50-70, blog/forum <40).

**GATE:** Core claims have 3+ independent sources. Single-source claims flagged.

### Phase 4.5: OUTLINE REFINEMENT (mid/deep/full only)
Compare initial scope against evidence. Adapt outline if evidence warrants. See [methodology](./reference/methodology.md) Phase 4.5 for adaptation signals.

### Phase 5: SYNTHESIZE
Generate insights. Build argument structure. Use extended reasoning for non-obvious connections.

**GATE (deep/full):** Before Phase 5, check `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`. If enabled: use agent team pattern. If disabled: use sequential Agent calls with explicit output passing. Log which pattern was used.

**HARD-GATE — Phase 6 Required (deep/full):** Do NOT proceed to Phase 8. Spawn a critic agent for Phase 6. Lite/mid: proceed to Phase 8 after self-review.

### Phase 6: CRITIQUE (deep/full — MANDATORY)
Spawn a separate critic agent. The critic reviews the Phase 5 synthesis output and asks:
- What's missing? What could be wrong? What alternative explanations exist?
- What biases might be present? What counterfactuals should be considered?

Output: list of gaps written to a temp file or returned via agent output. At least 1 gap must be identified — a "no issues found" critique is a failed critique.

**GATE:** Critique produced with ≥1 actionable gap identified. If critic returns empty → re-prompt targeting specific weak sections.

### Phase 7: REFINE (deep/full — MANDATORY)
Address every gap from Phase 6. Conduct targeted research if needed. For each gap: fix it, acknowledge it in Limitations, or justify why it's out-of-scope.

**GATE:** Every Phase 6 gap has a disposition (fixed / in Limitations / justified out-of-scope). No unaddressed gaps.

### Phase 8: PACKAGE

**Step 1:** Load [report-template.md](./templates/report-template.md) — this is the EXCLUSIVE content structure guide. It defines: required sections (1-4 mapping to 12 CODE questions), per-finding sub-block pattern (Finding → Key Evidence → Implications → Sources), Counterevidence Register in §2.3, and Claims-Evidence Table in Methodology.

**Step 2:** Generate report using progressive section assembly per [report-generation.md](./reference/report-generation.md):
- One section per Write/Edit call (not monolithic write)
- 80%+ narrative prose, <20% bullets
- Per-section quality check before moving to next

**Step 3:** Validate — run `scripts/validate_report.py` + `scripts/verify_citations.py`. If scripts not found: manually verify citations and section completeness against report-template.md.

**Step 4:** Generate HTML — use `scripts/md_to_html.py`, then inject into [mckinsey_report_template.html](./templates/mckinsey_report_template.html) for visual styling only. The McKinsey template is for HTML rendering (colors, grid, dashboard) — NOT content structure.

**Step 5:** Generate PDF via sub-agent. If PDF skill unavailable: deliver Markdown + HTML, note PDF as pending.

**Step 6:** Save to `~/Documents/[Topic]_Research_[YYYYMMDD]/` + copy to `~/.claude/research_output/`

---

## Output Contract

Report structure defined by [report-template.md](./templates/report-template.md):

| Section | Requirement |
|---|---|
| Executive Summary | 50-250 words, key findings + primary recommendation + confidence level |
| Context (§1) | Q1-Q3: relevance, definition, landscape & alternatives |
| Mechanics (§2) | Q4-Q6: how it works, why it works, why it fails (Red team findings) |
| Application (§3) | Q7-Q8: practical benefits, recommendations with actions + timelines |
| Mastery (§4) | Q9-Q12: misconceptions, anti-patterns, contingencies, competitive edge |
| Sources | EVERY citation [N] with full metadata — no ranges, no placeholders |
| Methodology | Process, source types, claims-evidence table with falsification results |

**Deliverables:** Markdown + HTML + PDF. Missing format = incomplete (note which is pending).

---

## Error Handling

- 2 validation failures on same error → stop, report to user, ask for direction
- <5 sources after exhaustive search → report limitation, request user direction
- 5-10 sources → note in limitations, proceed with extra verification
- Sub-agent returns empty/error → do NOT silently generate content yourself. Report which agent failed, offer: retry once, proceed without that section (mark `[INCOMPLETE]`), or ask user
- Scripts not found → perform manual verification: check each [N] has a Sources entry, verify section completeness against report-template.md, assess credibility in prose. Note: "Validation scripts unavailable — manual verification performed" in Methodology
- PDF skill unavailable → deliver Markdown + HTML, note PDF pending
- Critic agent fails (Phase 6) → re-prompt once with specific sections. If second attempt fails: perform self-critique, document limitation ("No independent critic — self-review only") in Methodology
- Search tools unavailable (Exa/WebSearch) → stop, report to user. Research cannot proceed without search capability
- Output directory creation fails → save to current working directory, report path to user

---

## GATE — Verify (before delivery)

Confirm ALL before presenting:
1. Every citation `[N]` in the body has a corresponding Sources entry — verify by count
2. `scripts/validate_report.py` exits 0 (or manual verification done if scripts unavailable)
3. Source credibility scores present (from script or manual assessment)
4. Output directory exists with at least Markdown + HTML (PDF noted if pending)
5. Report structure matches [report-template.md](./templates/report-template.md) sections — Glob the file, check section headers
6. (deep/full) Phase 6 critique artifact exists — point to the agent output or temp file
7. (deep/full) Every Phase 6 gap has disposition — list gap → resolution mapping
8. Process self-check: Did I load report-template.md? Did I use progressive section generation? Did I run source_evaluator?

If any check fails, fix before delivery.

---

## Gotchas

See [gotchas.md](gotchas.md) — 10 observed failure patterns.

---

## References (Load On-Demand)

- [Methodology](./reference/methodology.md) — 8-phase pipeline, retrieval protocol, FFS pattern
- [Report Generation](./reference/report-generation.md) — progressive assembly, HTML/PDF output
- [Report Template](./templates/report-template.md) — **EXCLUSIVE content structure guide** (sections, per-finding format, Claims-Evidence Table)
- [SPIKE Template](./templates/spike-template.md) — binary hypothesis investigation
- [McKinsey HTML Template](./templates/mckinsey_report_template.html) — HTML visual styling ONLY (not content structure)

## Scripts (Python stdlib only)

- `scripts/validate_report.py` — 9-check quality validation
- `scripts/verify_citations.py` — DOI resolution, fabrication detection
- `scripts/source_evaluator.py` — source credibility scoring (0-100)
- `scripts/citation_manager.py` — citation tracking
- `scripts/md_to_html.py` — markdown to HTML conversion
- `scripts/verify_html.py` — HTML output validation

## Links

- [[CLAUDE]]
- [[spike-template]]
- [[VALIDATE]]
- [[anti-patterns]]
- [[context-packaging]]
- [[dsbv]]
- [[gotchas]]
- [[ltc-explorer]]
- [[methodology]]
- [[report-generation]]
- [[report-template]]
- [[simple]]
- [[standard]]
- [[task]]
