---
version: "1.0"
status: Accepted
last_updated: 2026-03-30
owner: Long Nguyen
---

# ADR-007: Multi-Agent Architecture

**Status:** Accepted
**Date:** 2026-03-30
**Decider(s):** Vinh (CIO/Director — approved), Long Nguyen (Builder — designed)

---

## Context

The template needs an agent orchestration model that prevents scope leakage, controls token cost, and ensures deterministic enforcement of project rules. Single-agent operation (Claude Code with broad scope) showed ~85% rule compliance — insufficient for sustainability. The multi-agent design spec was developed on worktree `feat/multi-agent-orchestration` and approved by Vinh on 2026-03-30 [S4].

Key evidence from the design process:
- **H1 (measured):** Broad-scope agents exhibit reasoning degradation (LT-3) — confirmed via token analysis
- **H2 (measured):** Tool routing without allowlists leads to model selection waste (LT-7) — Haiku tasks routed to Opus unnecessarily
- **H5 (measured):** Agent drift (LT-8) — agents invoke skills and tools outside intended scope when boundaries are implicit

## Options Considered

### Option A: Single Agent, Expanded Rules
- **Description:** Keep one Claude Code agent, add more rules to CLAUDE.md to cover all scenarios. No sub-agents.
- **Sustainability:** Low — ~85% compliance ceiling. Rules compete for context window. No enforcement mechanism beyond self-regulation.
- **Efficiency:** Low context overhead (one agent), but high error rate means rework. Token waste from broad tool access.
- **Scalability:** Breaks at org scale — every new project type adds rules, degrading compliance further.
- **UBS Mitigated:** None — this is the status quo that produces the problems.
- **UDS Leveraged:** Simplicity (one agent is simpler to configure).

### Option B: Role-Based Agents, Trust-Based Routing
- **Description:** Multiple agents with defined roles (planner, builder, reviewer, explorer), but routing is advisory — the orchestrator suggests which agent to use, the human or lead agent decides.
- **Sustainability:** Medium — roles create clarity, but trust-based routing means drift is still possible. No enforcement hooks.
- **Efficiency:** Medium — better than A (role specialization), but advisory routing means misrouting still happens.
- **Scalability:** Scales with roles but routing discipline degrades under pressure (humans skip advisory steps).
- **UBS Mitigated:** Reasoning degradation (LT-3) via specialization. Partial drift mitigation.
- **UDS Leveraged:** MECE agent roster. Model routing table from global CLAUDE.md.

### Option C: Role-Based Agents, Deterministic Hooks, No Eval Gates
- **Description:** 4 MECE agents with tool allowlists, 3 enforcement hooks (verify-deliverables, save-context-state, resume-check), deterministic routing. Ships when hooks pass — no hypothesis-driven validation.
- **Sustainability:** High — deterministic enforcement moves compliance toward ~100%. But no eval gates means untested patterns ship.
- **Efficiency:** High — hooks prevent rework. Tool allowlists eliminate cost-tier waste.
- **Scalability:** Good — hooks are reusable across projects. But without eval gates, bad patterns can propagate to consumer repos.
- **UBS Mitigated:** Agent drift (LT-8), token waste (LT-7), reasoning degradation (LT-3).
- **UDS Leveraged:** 4 MECE agents. 3 enforcement hooks. Tool routing discipline.

### Option D: Hypothesis-Driven with Eval Gates (Approach D)
- **Description:** Everything in Option C PLUS hypothesis-driven delivery — nothing ships without measured evidence. Each major capability is framed as a hypothesis (H1-H5+), tested with A/B or before/after measurement, and only adopted if evidence supports it. 4 MECE agents: ltc-planner (Opus), ltc-builder (Sonnet), ltc-reviewer (Opus), ltc-explorer (Haiku). 3 new EPs: EP-11 (Agent Role Separation), EP-12 (Verified Handoff), EP-13 (Orchestrator Authority). Context packaging template (5-field: EO, INPUT, EP, OUTPUT, VERIFY) for sub-agent dispatch.
- **Sustainability:** Highest — deterministic enforcement + evidence-based adoption. Nothing enters the template without proof it works. Directly addresses LT-1 (cascading hallucination) through verified handoffs.
- **Efficiency:** Slightly higher upfront cost (must measure), but dramatically lower rework. Token-efficient: Haiku for exploration, Sonnet for building, Opus only for design/review.
- **Scalability:** Highest — eval gates create a quality ratchet. Consumer repos inherit proven patterns, not experiments. L3 migration guide ensures adoption in ≤10 min.
- **UBS Mitigated:** All of C's mitigations PLUS cascading hallucination (LT-1) via eval gates and verified handoffs.
- **UDS Leveraged:** All of C's drivers PLUS hypothesis-driven delivery as a cultural norm. 3 new EPs. Context packaging template.

## Decision

**Option D: Hypothesis-Driven with Eval Gates.**

This decision was made during the design phase and approved by Vinh on 2026-03-30. The reasoning:

1. **Sustainability (primary):** H1, H2, and H5 provided measured evidence that Options A and B are insufficient. Option C fixes enforcement but not validation. Only Option D ensures nothing ships without proof — the core sustainability guarantee for I1.

2. **Efficiency:** The 4-agent roster with model routing (Haiku/Sonnet/Opus) directly addresses H2's measured token waste. Context packaging template (5-field) eliminates ambiguous handoffs that cause rework.

3. **Scalability:** Eval gates create a quality ratchet — as the template is cloned to 8+ projects, only proven patterns propagate. The L3 migration guide (≤10 min adoption) ensures the multi-agent system doesn't become a barrier.

## Consequences

**Positive:**
- Rule compliance moves from ~85% (self-enforcement) to ~100% (hooks + allowlists)
- Token cost optimized via model routing discipline
- Cascading hallucination prevented via verified handoffs (EP-12)
- Consumer repos inherit battle-tested patterns
- 31 artifacts with binary ACs provide clear build scope

**Negative / Risks:**
- Complexity: 4 agents + 3 hooks + 3 EPs is more moving parts than single-agent
  - **Mitigation:** L3 migration guide; each agent has ≤7 tools; hooks are reusable
- Eval gates slow delivery
  - **Mitigation:** Gates are lightweight (before/after measurement, not formal experiments); skip gates only with explicit human approval
- Agent roster may need revision as models evolve (Mythos/Capybara tier)
  - **Mitigation:** Sc2 principle — adding a new agent requires adding one file, not rewriting the system. Review at end of I1.

## Bias Check (UT#6)
- [x] Confirmation bias: All 4 options evaluated with 3-pillar criteria. Options A-C rejected on evidence (H1, H2, H5 measurements), not preference.
- [x] Anchoring: Option D was the design team's working hypothesis, but H1/H2/H5 evidence was gathered BEFORE committing to it.
- [x] Sunk-cost: Design spec effort on Approach D did not prevent fair evaluation of simpler alternatives.

## Review Date
End of I1 (target: 2026-04-14) — validate eval gates are working and not creating excessive friction.

---

**Derived From:** S4 (Multi-agent orchestration design spec, approved 2026-03-30). Evidence: H1 (reasoning degradation), H2 (token waste), H5 (agent drift).
