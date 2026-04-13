---
version: "1.3"
iteration: 1
iteration_name: concept
status: draft
last_updated: 2026-04-11
owner: ""
type: template
stage: validate
sub_system: "{{SUBSYSTEM}}"
---
# DSBV Evaluation Protocol — {{WORKSTREAM}} × {{SUBSYSTEM}}

> For Validate stage. Covers multi-agent synthesis and single-agent validation.
> Follow mechanically. Do not skip steps.
> Source of truth for 4 universal dimensions: SKILL.md v2.1 §Stage 4: VALIDATE.

---

## 1. Success Rubric

### 1a. Universal Dimensions (all workstreams)

Four dimensions are fixed. Do NOT rename, merge, or replace them.

| Dimension | What is checked |
|-----------|-----------------|
| **Completeness** | All artifacts listed in DESIGN.md are present on disk |
| **Quality** | Each artifact passes its per-artifact success rubric from DESIGN.md |
| **Coherence** | Artifacts do not contradict each other (no orphaned conditions, no conflicting claims) |
| **Downstream Readiness** | The next workstream's Criterion 1 (clear scope) and Criterion 2 (input materials) can be satisfied from this workstream's outputs without further questions |

### 1b. Workstream-Specific Dimensions (3–4 per workstream)

Add below the universal dimensions. Weights must sum to 100% across all dimensions.

| Dimension | Weight | 10/10 | 5/10 | 0/10 |
|-----------|--------|-------|------|------|
| **[Dimension 1]** | [%] | [Excellent] | [Mediocre] | [Failure] |
| **[Dimension 2]** | [%] | [Excellent] | [Mediocre] | [Failure] |
| **[Dimension 3]** | [%] | [Excellent] | [Mediocre] | [Failure] |
| **[Dimension 4]** | [%] | [Excellent] | [Mediocre] | [Failure] |

**Workstream examples:**

- ALIGN: EU Coverage, UBS Depth, UDS Coverage, Requirements Quality
- PLAN: Architecture Completeness, Risk Mitigation, Task Decomposition, Dependency Accuracy
- EXECUTE: Code Quality, Test Coverage, Doc Completeness, Performance
- IMPROVE: Insight Depth, Action Specificity, Metric Accuracy, Feedback Closure

**Weights must sum to 100%.** Typical split: 40–50% universal + 50–60% workstream-specific.

---

## 2. Per-Criterion Verdict Table

> Copy every criterion from DESIGN.md verbatim. Do NOT paraphrase. Criterion count in this table MUST equal the criterion count in DESIGN.md — a mismatch is a coverage gap, not a rounding choice.

| Criterion | Verdict | Evidence |
|-----------|---------|----------|
| [Exact text from DESIGN.md AC-01] | PASS / FAIL / PARTIAL | [file path, line number, or excerpt proving the verdict] |
| [Exact text from DESIGN.md AC-02] | PASS / FAIL / PARTIAL | [file path, line number, or excerpt proving the verdict] |
| ... | ... | ... |

**Evidence standard (per stage-execution-guide.md §Validate stage):**
- Every verdict — PASS, FAIL, or PARTIAL — requires a file path, line number, or quoted excerpt.
- A table with all-PASS verdicts and no evidence column is a rubber-stamp. Re-run with evidence.
- PARTIAL = criterion is partly satisfied; evidence must show what is present AND what is missing.

**Verdict vocabulary:** PASS | FAIL | PARTIAL — no other values.

---

## 3. FAIL Classification

After identifying FAIL and PARTIAL items, classify each using the circuit breaker taxonomy.
Classification drives the retry vs. escalate decision in the Generator/Critic loop.

| Classification | Meaning | Action |
|----------------|---------|--------|
| **SYNTACTIC** | Format, structure, frontmatter, schema error | Auto-retry — provide specific correction instruction to builder |
| **SEMANTIC** | Wrong logic, wrong content, misunderstood requirement | ESCALATE immediately — wrong understanding, needs PM decision |
| **ENVIRONMENTAL** | Missing file, permission error, script failure | Fix environment first, then retry |
| **SCOPE** | Out of scope, undefined requirement, needs research | ESCALATE immediately — out of build scope, needs PM |

**Hard-stop rules (circuit-breaker-protocol.md §Hard-Stop Rules):**
1. Same FAIL text persists across 2 consecutive iterations → ESCALATE
2. 2 consecutive agent failures (non-zero exit) → STOP
3. All FAIL items classified as SEMANTIC → ESCALATE immediately (do not retry)
4. `loop_state.iteration >= max_iterations` (default 3) → ESCALATE

Escalation format: see `references/circuit-breaker-protocol.md §Escalation Message Format`.

**Logging:** Append each FAIL verdict with its classification to `.claude/logs/dsbv-metrics.jsonl` after every reviewer dispatch:

```json
{
  "workstream": "[WORKSTREAM]",
  "iteration": 1,
  "criterion": "AC-02",
  "verdict": "FAIL",
  "classification": "SYNTACTIC",
  "evidence": "[excerpt or file:line]",
  "timestamp": "2026-04-10T00:00:00Z"
}
```

---

## 4. Aggregate Score

Aggregate Score = weighted average of all dimension scores (0–10 each, integer only).

```
Aggregate Score = SUM(dimension_score_i * weight_i) for all i
```

Report as: `Aggregate Score: X.X / 10`

| Aggregate Score | Decision | Action |
|-----------------|----------|--------|
| >= 8.0 | **APPROVE** | Proceed to next workstream |
| 6.0 – 7.9 | **REVISE** | Address flagged dimensions; re-run on weak areas |
| < 6.0 | **REJECT** | Re-run DSBV with improved context or approach |

**On REVISE:** List which dimensions need work and what "good" looks like. Human decides: re-prompt builder or manual fix.

**On REJECT:** Diagnose via 7-CS blame order: EP > Input > EOP > EOE > EOT > Agent. Most REJECTs trace to bad Input or missing EP context.

---

## 5. Multi-Agent Protocol (Design-Heavy Workstreams: ALIGN, PLAN)

> For single-agent workstreams (EXECUTE, IMPROVE), skip to Section 6.

**Step 1 — Read all N team outputs.** Load each team's complete workstream package. Note impressions; do not score yet.

**Step 2 — Score each team on each dimension (0–10).** One sentence justifying each score.

**Step 3 — Comparison matrix.**

```
              Completeness  Quality  Coherence  Downstream  Workstream  Weighted
Team 1:       7             6        8          7           7.0         7.1
Team 2:       8             7        6          8           8.0         7.7
```

**Step 4 — Best team per dimension.** One sentence each: "Team N wins [Dimension] because [reason]."

**Step 5 — Divergence analysis.** Use template in Section 7. Where do teams AGREE vs DIVERGE?

**Step 6 — Synthesize.** Best element per dimension from winning team. Resolve conflicts. Must be a self-consistent package — not cut-and-paste.

**Step 7 — Self-check.** Score synthesis on same rubric. Every dimension must score >= 7.

**Step 8 — Flag for Human.** Any dimension < 7: list reason and what requires Human judgment.

---

## 6. Single-Agent Protocol (Execution-Heavy Workstreams: EXECUTE, IMPROVE)

**Step 1 — Complete the Per-Criterion Verdict Table (Section 2).** One evidence entry per criterion.

**Step 2 — Score output on each universal + workstream dimension (0–10).** One sentence justifying each score.

**Step 3 — Identify weak dimensions.** Any < 7: state what is wrong and what "good" looks like for that dimension.

**Step 4 — Complete the Human Review Checklist (Section 8).** Every item must be checked.

**Step 5 — Decision.** Apply thresholds from Section 4 (Aggregate Score).

---

## 7. Divergence Analysis Template

> Used in multi-agent Step 5. Report using this exact structure.

```
AGREEMENT (majority align):
- [finding] — HIGH confidence, include as-is

DIVERGENCE (teams split):
- [finding] — Teams X,Y say A; Teams W,Z say B
  Recommendation: [which and why]
  Flag for Human: [yes/no]

UNIQUE INSIGHTS (1 team only):
- [finding] from Team N — [valuable / hallucination / edge case]
  Valuable: include. Hallucination: discard with reason. Edge case: flag for Human.
```

### Resolution Rules

| Condition | Action |
|-----------|--------|
| Majority agree (>= N/2 + 1) | Include as-is |
| Even split | Pick option with more evidence; flag for Human |
| 1 team unique finding | Validate against context; include if plausible, flag if uncertain |
| Uncertain | Flag for Human. Over-flagging > silent bad choices. |

---

## 8. Human Review Checklist

> Adapt items to workstream. Replace bracketed text with workstream-specific checks.

- [ ] EO still makes sense to me as the project owner
- [ ] No critical [stakeholder/component/artifact] is missing
- [ ] All DESIGN.md criteria are covered in the Per-Criterion Verdict Table (criterion count parity verified)
- [ ] [Quality check 1 — e.g., "UBS includes risks I've seen in practice"]
- [ ] [Quality check 2 — e.g., "Architecture handles known scale requirements"]
- [ ] [Quality check 3 — e.g., "Tests cover acceptance criteria from requirements"]
- [ ] Outputs are achievable within constraints (time, budget, team)
- [ ] A new team member could understand this workstream's output without asking me questions
- [ ] Next workstream can start without asking me questions (Downstream Readiness confirmed)
- [ ] All divergence flags reviewed and resolved (if multi-agent)
- [ ] All FAIL items are either fixed or explicitly deferred with justification

---

## Approval Log

> Human completes this section. Agent MUST NOT self-approve. `status: validated` is set by Human only.

| Date | Reviewer | Decision | Notes |
|------|----------|----------|-------|
| YYYY-MM-DD | [Name] | APPROVE / REVISE / REJECT | [reason or deferred items] |

---

## Links

- [[AGENTS]]
- [[SKILL]]
- [[VALIDATE]]
- [[architecture]]
- [[circuit-breaker-protocol]]
- [[dsbv-metrics]]
- [[gate-state]]
- [[iteration]]
- [[stage-execution-guide]]
- [[project]]
- [[task]]
- [[workstream]]
