---
version: "1.0"
iteration: "I1: Concept"
status: Proposed
last_updated: 2026-03-26
owner: Long Nguyen
---

# ADR-001: DSBV Multi-Agent Pattern — Competing Hypotheses + Synthesis
## Architecture Decision Record

**Status:** Accepted
**Date:** 2026-03-26
**Decider(s):** Long Nguyen (Builder), pending Anh Vinh (CIO) review

---

## Context

The LTC Project Template uses a 4-phase sub-process within each APEI zone: **Design → Sequence → Build → Validate (DSBV)**. For the ALIGN zone specifically, the work is open-ended design (charter, force analysis, stakeholder mapping, requirements) — not sequential code with a single correct answer.

We need to decide how AI agents execute DSBV. The key question: **should a single agent produce the ALIGN artifacts, or should multiple agents work in parallel and their outputs be combined?**

This decision was triggered by:
1. The ALIGN phase has no "ground truth" — multiple valid framings exist for EO, UBS, UDS
2. Missing a critical risk in ALIGN propagates to PLAN → EXECUTE → IMPROVE (high blast radius)
3. Sonnet-class agents are cost-effective ($0.50-1.50 per run) making parallel runs viable
4. Research shows multi-agent outperforms single-agent by up to 90.2% on breadth-first tasks [Anthropic, 2025]

**Research basis:** 42-source deep research conducted 2026-03-26. Full report at `~/Documents/DSBV_Research_20260326/DSBV_Best_Practices_Report.md`.

---

## Options Considered

### Option A: K-Threshold Voting
- **Description:** N agents perform the same task. At each step, agents vote; majority answer proceeds. Designed for sequential tasks with binary correct/incorrect steps (MAKER paper, arXiv:2511.09030).
- **Sustainability:** Strong for deterministic tasks — voting eliminates per-step errors. Achieves zero errors over 1M+ steps.
- **Efficiency:** Cost grows linearly with K (number of voters). Each step requires K completions.
- **Scalability:** Scales well for step-based tasks. Does not scale for open-ended design where "steps" are not well-defined.
- **UBS Mitigated:** LT-3 (reasoning degradation per step).
- **UDS Leveraged:** Parallel computation, statistical error correction.
- **REJECTED because:** Assumes ground truth exists at each step. ALIGN artifacts are design decisions — voting produces mediocre consensus (regression to the mean), not the best framing. A charter that 3/5 agents agree on is the AVERAGE charter, not the BEST one.

### Option B: Orchestrator-Worker (Decompose + Parallelize)
- **Description:** One lead agent decomposes the ALIGN task into independent sub-tasks (charter, forces, requirements). Workers execute in parallel. Lead synthesizes.
- **Sustainability:** Good isolation — each worker has bounded scope.
- **Efficiency:** Maximizes parallelism. Lower total cost than competing hypotheses (each worker does less).
- **Scalability:** Scales with number of independent sub-tasks.
- **UBS Mitigated:** LT-2 (context overload per worker), LT-3 (smaller task per worker).
- **UDS Leveraged:** Parallelism, specialization.
- **REJECTED because:** ALIGN artifacts are interconnected — the charter informs forces which inform requirements. Splitting them across workers loses design coherence. A force analysis written without knowing the charter framing will miss context-dependent risks.

### Option C: Competing Hypotheses + Synthesis
- **Description:** N agents (3-5 Sonnet instances) each independently produce a **complete ALIGN package** (charter + forces + requirements). An Opus agent then **synthesizes** the best elements from all outputs (not picks a winner). Human Director reviews the synthesis.
- **Sustainability:** Multiple independent explorations catch non-obvious risks that any single agent would miss. Cross-checking surfaces where agents AGREE (high confidence) vs DIVERGE (needs human attention). Three-layer separation: Sonnet (explore) → Opus (synthesize + challenge) → Human (approve).
- **Efficiency:** Cost: 5 Sonnet runs (~$5-8) + 1 Opus synthesis (~$2-5) = ~$10-13 total. Compared to: 1 Opus run (~$3-5) that produces one perspective. The marginal cost for 4x more perspectives is ~$7-10.
- **Scalability:** Start with 3-5 teams. Scale up if outputs diverge significantly (diversity is valuable). Scale down if outputs converge (diversity is redundant). Adaptive.
- **UBS Mitigated:** LT-1 (agents hallucinate differently — synthesis catches outliers), LT-5 (multiple outputs cross-check plausibility), single-agent blind spots.
- **UDS Leveraged:** Parallel exploration, diversity of perspective, Opus reasoning for synthesis, cost-effectiveness of Sonnet for breadth.

### Option D: Single Agent (Opus)
- **Description:** One Opus agent runs DSBV on the ALIGN zone sequentially. Human reviews output.
- **Sustainability:** Simplest. No coordination overhead. Opus has the strongest reasoning.
- **Efficiency:** Lowest cost (~$3-5). Fastest wall-clock if no parallel infrastructure.
- **Scalability:** Does not scale — one perspective, one context window.
- **UBS Mitigated:** None specific to multi-perspective coverage.
- **UDS Leveraged:** Opus reasoning quality, simplicity.
- **REJECTED as primary approach because:** A single agent produces one framing. For ALIGN — where missing a critical risk has high blast radius — one perspective is insufficient. However, retained as the **fallback** if multi-agent infrastructure proves too complex for I1.

---

## Decision

**Option C: Competing Hypotheses + Synthesis** — selected as the primary pattern for DSBV on design-heavy zones (ALIGN, PLAN).

**Grounding in principles:**

| Principle | How Option C applies |
|-----------|---------------------|
| EP-01 (Brake Before Gas) | Multiple teams independently explore the risk landscape — more likely to surface non-obvious UBS |
| EP-03 (Two Operators) | Sonnet = Responsible (explore), Opus = Quality gate (synthesize), Human = Accountable (approve). Clean three-layer RACI. |
| EP-09 (Decompose) | Each team gets the WHOLE task (not a fragment) — design coherence preserved while diversity of approach is maximized |
| EP-10 (Define Done) | Success rubric defined BEFORE agents run — Opus evaluates against rubric, not subjective preference |
| LT-1 (Hallucination) | Agents hallucinate differently. Where 4/5 agree → high confidence. Where 1 diverges → flag for human. |
| LT-5 (Plausibility ≠ truth) | Single output "sounds right" — multiple outputs enable cross-checking |
| UT#5 (Success = risk mgmt) | Cost of missing a critical ALIGN risk >> cost of 5 Sonnet runs. Expected value is strongly positive. |

**Why synthesis over selection:**

Selection (pick winner) discards insights from non-winning teams. Synthesis (combine best elements) captures the **union** of insights: best charter framing from Team 2, best UBS from Team 4, best requirements from Team 1. The Opus synthesizer creates a result stronger than any individual team's output.

**Scope of this decision:**
- Applies to DSBV execution on **design-heavy zones** (ALIGN, PLAN)
- For **execution-heavy zones** (EXECUTE, IMPROVE), default to **single-agent** or **orchestrator-worker** — these have more deterministic outputs where diversity of approach adds less value
- The pattern is an experiment in I1 — will be evaluated in IMPROVE and adjusted for I2

---

## Consequences

**Positive:**
- Broader risk coverage — multiple agents find different UBS/UDS
- Higher-quality synthesis — best elements from N perspectives
- Cross-validation — agreement/divergence signals guide human review
- Cost-effective breadth — Sonnet is cheap enough for N=5 parallel runs
- Reusable pattern — applicable to any design-heavy DSBV phase

**Negative / Risks:**
- **Coordination overhead:** Setting up 5 parallel agents, collecting outputs, feeding to Opus
  - **Mitigation:** Script the workflow. Use Claude Code agent teams or shell-based parallel launch.
- **Sonnet quality floor:** If Sonnet agents produce uniformly poor ALIGN artifacts, synthesis can't recover quality
  - **Mitigation:** Test with N=2 first. If Sonnet quality is insufficient, fall back to Option D (single Opus).
- **Opus synthesis bias:** Opus may favor "sounds best" over "is best" (LT-5)
  - **Mitigation:** Provide structured evaluation rubric (C3). Score per dimension, not holistic.
- **Over-engineering for I1:** Multi-agent may be premature when we haven't even run DSBV once
  - **Mitigation:** Start with N=3 (not 10). The infrastructure investment is the DSBV skill + prompt engineering, which is needed regardless of single vs multi-agent.

---

## Bias Check (UT#6)

- [x] **Confirmation bias:** We considered Option D (single agent) seriously and retained it as fallback. The research shows multi-agent degrades sequential tasks by 39-70% — we acknowledged this and scoped the pattern to design-heavy zones only.
- [x] **Anchoring:** The Karpathy-inspired "run 10 agents" idea was the anchor. We adjusted down to 3-5 based on research showing diminishing returns beyond 5 teammates.
- [x] **Sunk-cost:** No prior investment in any option. Decision made fresh from research.
- [x] **Novelty bias:** Competing hypotheses is more exciting than single-agent. We mitigated by defining concrete conditions (C1-C6) that must be met before running, and by keeping Option D as fallback.

---

## Review Date

After I1 ALIGN zone is complete (estimated: end of I1). Evaluate:
1. Did 3-5 teams produce meaningfully different outputs? (If not, reduce to single-agent for I2)
2. Did Opus synthesis add value over best single team? (If not, switch to selection)
3. Was the cost justified by quality improvement? (If not, reduce N or switch to Option D)

---

**Derived From:** UT#7 Work Stream 5 (Effective Decision Making)
**Research Source:** DSBV Best Practices Report, 2026-03-26 (42 sources)
