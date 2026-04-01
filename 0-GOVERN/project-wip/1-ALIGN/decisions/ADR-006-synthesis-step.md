---
version: "1.0"
status: Deferred
last_updated: 2026-03-30
owner: Long Nguyen
---

# ADR-006: Synthesis Step in Learning Pipeline

**Status:** DEFERRED
**Date:** 2026-03-30
**Decider(s):** Vinh (CIO/Director), Long Nguyen (Builder)
**MoSCoW:** Should (I1)
**Deferral Target:** After LEARN zone design (ADR-001 implementation)

---

## Context

Vinh's whiteboard (S1, 2026-03-30) drew the learning pipeline as:

```
Info search → Info connection → LEARN → (?)
```

The fourth step is unclear — Vinh marked it with a question mark. The stakeholder input synthesis (2026-03-30) captured this as Open Question #2: "Is synthesis a sub-step of LEARN, a transition step between LEARN and ALIGN/PLAN, or its own phase?"

ADR-001 (Accepted) established that LEARN outputs feed bidirectionally — back into ALIGN and forward into PLAN, with a `feeds` frontmatter field tagging destination. But ADR-001 does not define WHERE synthesis happens in that flow. The synthesis step transforms raw research into actionable inputs for downstream zones.

**Why deferred:** The LEARN zone has not been built yet. Until the zone structure exists and the team runs through at least one learning cycle, the right placement for synthesis is speculative.

## Options Recorded

### Option A: Synthesis as a Sub-Step of LEARN

- **Description:** Synthesis happens inside the LEARN zone as the final sub-step. The pipeline becomes: Info search → Info connection → LEARN (capture + synthesize) → output to ALIGN/PLAN. Synthesis artifacts live in `LEARN/research/` alongside other structured outputs, distinguished by a `type: synthesis` frontmatter field.
- **Sustainability:** Simplest model — one zone owns the full pipeline. No handoff ambiguity. Users know that LEARN is not done until synthesis is complete.
- **Efficiency:** Low ceremony — no extra zone or transition step. But may overload LEARN zone with too many responsibilities (capture AND synthesize AND tag).
- **Scalability:** Clean — LEARN zone is self-contained. But synthesis quality depends on the researcher, with no structural forcing function.

### Option B: Synthesis as a Transition Step (LEARN → ALIGN/PLAN)

- **Description:** Synthesis is an explicit transition gate between LEARN and downstream zones. After LEARN produces raw outputs, a synthesis step reviews, consolidates, and routes them to ALIGN or PLAN. This could be a human gate (Director reviews and routes) or an agent step (synthesis agent consolidates).
- **Sustainability:** Clearest separation of concerns — LEARN captures, synthesis routes. Prevents raw unprocessed research from flowing into PLAN. But adds process overhead.
- **Efficiency:** Additional step = additional time. For small projects, the overhead may not be justified. For the current 8-person team, this may feel bureaucratic.
- **Scalability:** Strong at scale — the routing function prevents downstream zones from drowning in unprocessed research. Multi-agent model could assign synthesis to a dedicated agent role.

### Option C: Synthesis as Part of ALIGN (Feedback Loop)

- **Description:** LEARN produces raw outputs. ALIGN owns synthesis as part of its charter/requirement refinement process. When LEARN outputs feed back into ALIGN (via the bidirectional model from ADR-001), ALIGN synthesizes them into refined artifacts. PLAN receives only ALIGN-processed inputs, never raw LEARN outputs.
- **Sustainability:** Aligns with ALIGN's existing role as the "understanding" zone. But blurs the line between ALIGN refinement and LEARN synthesis — are they the same activity?
- **Efficiency:** No new step — synthesis is absorbed into existing ALIGN refinement. But PLAN loses direct access to LEARN research, which may reduce planning quality.
- **Scalability:** Risk — ALIGN becomes a bottleneck if it must synthesize all LEARN outputs before PLAN can proceed. The bidirectional model from ADR-001 explicitly allows LEARN → PLAN direct flow.

## Decision

**DEFERRED.** No option is chosen.

## Deferral Rationale

1. **LEARN zone not yet built.** ADR-001 was accepted but the zone extraction has not been implemented. Until the LEARN zone exists with its `input/` and `research/` layers, the synthesis question is theoretical.
2. **Experience-first.** The team needs to run at least one learning cycle (Info search → Info connection → LEARN → ?) to feel where synthesis naturally fits. Premature formalization violates Design Principle #2 (problem-first).
3. **Vinh's question mark is intentional.** The whiteboard deliberately left the fourth step unclear. This signals that Vinh wants the team to discover the answer through practice, not prescribe it upfront.
4. **Decision inputs needed:** One complete LEARN cycle executed, team retrospective on where synthesis friction occurred, comparison of Options A/B/C against actual workflow.

## Review Date

After LEARN zone is operational and the team completes at least one full learning cycle.

---

**Derived From:** S1 (Vinh whiteboard 2026-03-30), Open Question #2 in stakeholder input synthesis, ADR-001 (bidirectional feed model)
