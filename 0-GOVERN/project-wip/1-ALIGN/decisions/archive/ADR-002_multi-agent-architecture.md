---
version: "1.0"
status: Accepted
last_updated: 2026-03-30
owner: Long Nguyen
---

# ADR-002: Multi-Agent Architecture — Agent Files, Tool Routing, and Context Packaging
## Architecture Decision Record

**Status:** Accepted
**Date:** 2026-03-30
**Decider(s):** Long Nguyen (Builder)

---

## Context

The multi-agent orchestration feature introduces 4 MECE agents (ltc-planner, ltc-builder, ltc-reviewer, ltc-explorer) to the LTC Project Template. Before building, three architectural questions needed evidence-based answers:

1. **How to define agent scope?** Inline in each skill vs. dedicated agent files
2. **Which search tools to prefer?** Exa MCP vs. WebSearch for ltc-explorer
3. **How to package context for sub-agent dispatch?** Ad-hoc prompts vs. structured 5-field template

Three hypothesis tests (H1, H2, H5) were designed and executed on 2026-03-30 using paired sub-agents (control A vs. treatment B) on identical tasks. Decisions are grounded in measured data, not design preference.

---

## Options Considered

### Option A: Inline Agent Definitions

- **Description:** Define agent roles, tools, and scope inline within each skill's SKILL.md. No separate agent files. Sub-agents receive ad-hoc freeform prompts at dispatch time.
- **Sustainability:** Low — scope boundaries are advisory, not enforced. LT-8 (alignment drift) is uninhibited: ad-hoc prompts allow agents to add "helpful" extras that corrupt downstream inputs. No structural check on hallucination (LT-1) at dispatch.
- **Efficiency:** Marginally fewer files. But ad-hoc prompt quality varies across skill authors, producing inconsistent sub-agent behavior.
- **Scalability:** Poor — adding a new agent requires updating every skill that dispatches it. No single source of truth for agent capabilities.
- **UBS Mitigated:** None specifically.
- **UDS Leveraged:** Simplicity (fewer files to maintain).

### Option B: Agent Files + Ad-Hoc Prompts

- **Description:** Define each agent in `.claude/agents/ltc-{name}.md` with model, tools, and scope declaration. Dispatch sub-agents with ad-hoc (freeform) prompts.
- **Sustainability:** Medium — agent files establish scope (H1 validates this: scoped prompts prevented unsolicited extras while ad-hoc prompts added frontmatter, extended descriptions, and diagram annotations unprompted). But ad-hoc dispatch prompts still expose LT-1 (hallucination) risk at the call site: the H5 control (ad-hoc) agent invented two non-existent agents ("ltc-risk-auditor", "ltc-qa") because no agent roster was provided in the prompt.
- **Efficiency:** Agent files are reusable. But ad-hoc prompts require exploratory tool calls to gather context — H5 Control used 4 tool calls and 23,258 tokens to complete an identical task.
- **Scalability:** Better than Option A — agent roster is centralized. Prompt quality still varies per skill author.
- **UBS Mitigated:** LT-8 (scope enforcement via agent files).
- **UDS Leveraged:** Reusable agent definitions.

### Option C: Agent Files + Context Packaging v2.0

- **Description:** Define each agent in `.claude/agents/ltc-{name}.md`. Dispatch ALL sub-agents using the 5-field context packaging template: EO (desired outcome), INPUT (all context the agent needs), EP (behavioral constraints), OUTPUT (format specification), VERIFY (acceptance criteria the agent self-checks before returning).
- **Sustainability:** Highest — agent files enforce scope (H1: PASS, 3/4 measures), and context packaging eliminates exploratory tool calls while reducing hallucination. H5 Treatment: the packaged agent correctly named all 4 real agents vs. the ad-hoc agent hallucinating 2 non-existent ones. The VERIFY field embeds EP-10 (Define Done) at sub-agent level, enabling self-check before output is returned. Remaining risk: the one failure in H5 Treatment was a low-severity tag format error ([EOE] vs. [DERISK]) — easily mitigated by adding tag conventions to the EP field.
- **Efficiency:** Best measured. H5 Treatment: 14,685 tokens vs. H5 Control: 23,258 tokens (−37%). Zero tool calls vs. 4. Wall-clock 14.4s vs. 35.3s (−59%). The VERIFY field eliminates exploratory reads because the agent knows exactly what done looks like before starting.
- **Scalability:** Best — agent files and context packaging template are both reusable. New agents get a file + per-agent packaging examples in context-packaging.md.
- **UBS Mitigated:** LT-8 (scope via agent files), LT-1 (hallucination reduced by structured INPUT with agent roster), LT-5 (VERIFY field enables plausibility self-check).
- **UDS Leveraged:** Reusable agent definitions, structured dispatch, embedded EP-10 at sub-agent level, token efficiency.

---

## Decision

**Option C: Agent Files + Context Packaging v2.0** — selected as the standard pattern for all multi-agent dispatch in the LTC Project Template.

**Grounding:**

| Evidence | Finding | Impact on Decision |
|---|---|---|
| H1: PASS (3/4 measures) | Scoped prompts enforce output boundaries; ad-hoc prompts drift (LT-8) | Agent files required |
| H2: FAIL (−2% tokens, lower source quality) | Exa is faster but WebSearch produces better sources (3 academic papers vs. 0) | Exa NOT mandated as primary |
| H5: PASS (−37% tokens, 0 tool calls, 0 hallucinations) | Context packaging eliminates exploratory overhead and LT-1 hallucination | Packaging template required |

**Secondary decision — H2:** Exa MCP should NOT be mandated as the primary search tool for ltc-explorer. WebSearch found higher-quality sources (3 academic papers + 4 official docs vs. 0 academic papers). Exa is 48% faster and uses 50% fewer tool calls — a valid trade-off when speed matters and source authority is less critical. Both tools remain available as peers. Skills reference both without preference hierarchy.

**Alignment with principles:**

| Principle | How Option C applies |
|---|---|
| EP-01 (Brake Before Gas) | Risks in each option assessed before benefits; packaging reduces hallucination before output is returned |
| EP-10 (Define Done) | VERIFY field in packaging template embeds acceptance criteria at sub-agent level |
| UT#5 (Success = risk mgmt) | 37% token savings at dispatch scale compounds across all skill runs |
| LT-1 (Hallucination) | INPUT field with agent roster prevents invention of non-existent agents (observed in H5 Control) |
| LT-8 (Alignment drift) | Agent files + scoped prompts prevent unsolicited extras (observed in H1 Control) |

---

## Consequences

**Positive:**
- 37% token reduction on sub-agent dispatch — measured at 14,685 vs. 23,258 tokens (H5)
- Zero exploratory tool calls at dispatch — agents receive all context in INPUT field
- Scope enforcement prevents cross-agent output contamination — measured behavioral constraint (H1)
- VERIFY field embeds EP-10 at sub-agent level — agents self-check before returning output
- Standardized dispatch pattern across all skills — consistent quality floor regardless of skill author

**Negative / Risks:**
- **Template fill overhead:** Every sub-agent dispatch requires completing 5 fields (EO, INPUT, EP, OUTPUT, VERIFY)
  - **Mitigation:** Per-agent packaging examples in `context-packaging.md`. The 37% token savings and elimination of 4 exploratory tool calls more than compensates for fill time at scale.
- **Exa deprioritized despite speed advantage:** H2 shows Exa is 48% faster and uses 50% fewer tool calls — that value is deferred
  - **Mitigation:** Keep both tools available to ltc-explorer. Document the speed vs. quality trade-off in the agent file. Let skill authors choose per use case (Exa for speed-sensitive lookups; WebSearch for evidence-grade research).
- **Tag convention gap in H5:** Treatment agent used wrong EP tag ([EOE] instead of [DERISK]) — a format error, not a logic error
  - **Mitigation:** Add tag convention (`[DERISK]` or `[OUTPUT]`) to the EP constraints field when dispatching EP-related tasks. Document in context-packaging.md examples.

---

## Bias Check (UT#6)

- [x] **Confirmation bias:** H2 result (FAIL) contradicted the initial design assumption that Exa should be the primary search tool. The evidence was accepted and the recommendation revised to "both tools as peers" rather than forcing Exa into a primary role it didn't earn.
- [x] **Anchoring:** Option C was the design spec's preferred approach. H1 and H5 tests were structured to falsify it, not confirm it — H5 Control used identical content to ensure a fair baseline. The tests could have returned FAIL.
- [x] **Sunk-cost:** Context packaging v2.0 was already built (Slice 3) before H5 ran. The test was still executed to validate, not to justify prior work. A FAIL result would have required redesigning the dispatch pattern.

---

## Review Date

After I1 completion. Evaluate:
1. Does the 37% token reduction hold across diverse task types beyond EP authoring?
2. Does the 5-field template feel burdensome to skill authors after writing 5+ skills with it?
3. Has the H2 Exa vs. WebSearch balance shifted with newer Exa versions or index updates?

---

## Evidence Appendix

| Hypothesis | Gate | Result | Key Metric |
|---|---|---|---|
| H1: Scoped vs. ad-hoc prompts | B >= A on 3/4 measures | **PASS** | Scope enforcement validated (3/4); token delta −1% (negligible) |
| H2: Exa MCP vs. WebSearch | >= 30% token reduction AND >= same source quality | **FAIL** | −2% tokens (below threshold); Exa 0 academic papers vs. WebSearch 3 |
| H5: Context packaging vs. ad-hoc | B >= A on 4/5 measures | **PASS** | −37% tokens (14,685 vs. 23,258); −100% tool calls (0 vs. 4); −59% wall-clock (14.4s vs. 35.3s) |

Full test data: `4-IMPROVE/metrics/multi-agent-eval/h-test-results.md`

---

**Derived From:** UT#7 Work Stream 5 (Effective Decision Making)
**Test Protocol:** 2026-03-30 | Lead agent: Claude Opus 4.6 | Sub-agents: 4x Sonnet, 2x Haiku
