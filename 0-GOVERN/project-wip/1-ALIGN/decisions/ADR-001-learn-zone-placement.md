---
version: "1.1"
status: Executed
last_updated: 2026-03-30
owner: Long Nguyen
---

# ADR-001: LEARN Zone Placement and Artifact Model

**Status:** Executed
**Date:** 2026-03-30
**Decider(s):** Vinh (CIO/Director), Long Nguyen (Builder)
**Executed:** 2026-03-30 — Content migrated from `1-ALIGN/learning/` to `2-LEARN/`.

---

## Context

The draft charter (v1.0, 2026-03-26) placed LEARN as a subfolder inside ALIGN (`1-ALIGN/learning/`). On 2026-03-30, Vinh formally requested LEARN be extracted as its own zone in the ALPEI structure. This is an I1 Must — not a suggestion.

Key constraints from S1 (Vinh whiteboard session):
- LEARN sits AFTER ALIGN, BEFORE PLAN
- Learning outputs feed BACK into ALIGN (refine charter/requirements) AND FORWARD into PLAN (research inputs)
- Learning WIP is personal — unstructured, no template enforcement
- Three learning types with different lifecycles: genesis frameworks (org-level), tool/platform (operational), per-project (project-scoped)

The decision is not WHETHER to extract LEARN (that is decided), but WHAT artifacts the LEARN zone produces and how it interacts with adjacent zones.

## Options Considered

### Option A: Structured Outputs Only
- **Description:** LEARN zone produces only structured outputs — VANA-spec research notes, synthesis documents with frontmatter, and a learning register analogous to UBS/UDS. No WIP or unstructured content in the zone.
- **Sustainability:** High structure = high discoverability. Agents can parse all outputs. But forces premature formalization of early-stage research, creating friction that discourages learning capture.
- **Efficiency:** Low — researchers must format everything before committing. Tax on exploration.
- **Scalability:** Structured outputs scale well for search and cross-referencing. But rigid format may not accommodate all three learning types equally (genesis frameworks need different structure than per-project notes).
- **UBS Mitigated:** Agent drift (agents can parse structured inputs). Template drift (consistent format).
- **UDS Leveraged:** None unique to this option.

### Option B: Structured + Unstructured WIP Per User
- **Description:** LEARN zone has two layers: (1) `input/` for raw unstructured WIP (personal notes, drawings, slides — no format enforcement), and (2) `research/` for structured synthesis outputs that feed ALIGN and PLAN. Users work in input/, synthesize into research/.
- **Sustainability:** Respects Vinh's directive that "learning WIP is personal." Low friction for capture. Structured layer ensures agents can still consume outputs. But WIP can accumulate without synthesis, creating noise.
- **Efficiency:** Medium — capture is fast (no format tax), but synthesis step requires deliberate effort.
- **Scalability:** WIP layer may grow unbounded. Three learning types need subfolder organization within the structure.
- **UBS Mitigated:** Adoption friction (low barrier to capture). Agent drift (structured layer for consumption).
- **UDS Leveraged:** Three learning types as organizational model [S2-Vinh]. Simplicity-first principle [S2-consensus].

### Option C: Structured + Unstructured + Bidirectional Feed (ALIGN and PLAN)
- **Description:** Same two-layer model as Option B, plus explicit bidirectional flow: LEARN outputs are tagged with destination (→ALIGN for charter/requirement refinement, →PLAN for risk/driver/architecture inputs). Synthesis documents include a "feeds" field in frontmatter indicating which downstream zone consumes them. The LEARN zone has its own DESIGN.md governing what artifacts it produces per DSBV.
- **Sustainability:** Highest — captures Vinh's full mental model (LEARN feeds both directions). Explicit tagging prevents orphaned research. DESIGN.md provides governance without over-constraining.
- **Efficiency:** Slightly more overhead than B (tagging), but the tagging prevents waste downstream (no one wonders "where does this research go?").
- **Scalability:** Bidirectional flow scales because the tagging system makes connections explicit. Three learning types each get appropriate subfolder structure. As the repo grows, Obsidian CLI (ADR-002) can leverage the tags for interconnectedness.
- **UBS Mitigated:** Adoption friction (WIP layer). Agent drift (structured + tagged). Orphaned research (explicit destinations). Cognitive overload (clear flow).
- **UDS Leveraged:** ALPEI as primary flow [S1]. Three learning types [S2-Vinh]. Obsidian CLI for interconnectedness [S1]. Bidirectional feed matches Vinh's whiteboard model exactly.

## Decision

**Option C: Structured + Unstructured + Bidirectional Feed.**

Reasoning (3-pillar priority S > E > Sc):

1. **Sustainability:** Option C is the only option that fully implements Vinh's directive. The bidirectional feed (LEARN → ALIGN and LEARN → PLAN) is not optional — it is the core value proposition of LEARN as a separate zone. Without explicit flow direction, LEARN becomes a dumping ground (Option A's rigidity) or an isolated silo (Option B without tagging).

2. **Efficiency:** The tagging overhead is minimal (one frontmatter field: `feeds: "ALIGN"` or `feeds: "PLAN"` or `feeds: "ALIGN, PLAN"`). The payoff is large: downstream consumers know exactly which LEARN outputs to read.

3. **Scalability:** As the template is cloned to 8+ projects, the bidirectional model scales because it is self-documenting. New team members can trace the flow without asking Long.

## Consequences

**Positive:**
- LEARN zone matches Vinh's whiteboard architecture exactly
- Three learning types get appropriate storage (genesis → `_genesis/`, tool/platform → `research/`, per-project → `input/` + `research/`)
- Agents can consume structured outputs; humans can work freely in WIP
- Bidirectional tagging creates traceable knowledge flow

**Negative / Risks:**
- WIP layer may accumulate without synthesis
  - **Mitigation:** Periodic review in IMPROVE zone retros; LEARN zone README reminds users to synthesize
- Tagging discipline may erode over time
  - **Mitigation:** template-check.sh can validate `feeds` frontmatter on research/ files
- LEARN zone extraction requires folder restructuring
  - **Mitigation:** Execute in separate worktree per Vinh's directive; merge to branch then PR to main

## Bias Check (UT#6)
- [x] Confirmation bias: Options A and B were evaluated on their own merits. Option A was rejected for friction, not because it contradicts the preferred answer.
- [x] Anchoring: Vinh's directive anchors the decision space (LEARN must be separate), but the artifact model was evaluated independently.
- [x] Sunk-cost: Current `1-ALIGN/learning/` structure has content that must be migrated regardless of option chosen.

## Review Date
End of I1 (target: 2026-04-14) — validate that the bidirectional model is working in practice.

---

**Derived From:** S1 (Vinh whiteboard 2026-03-30), S2 (Team feedback 2026-03-30)
