---
version: "1.0"
status: Draft
owner: Long Nguyen
last_updated: 2026-03-29
derived_from: [Vinh ALPEI PDFs, agent-system.md, effective-agent-principles-registry.md]
---
# I1 Artifact Flow Design — Complete Zone-by-Zone Mapping

> **Purpose:** Canonical reference for how artifacts flow through the APEI zones in Iteration 1 (Concept/Sustainability). Defines the causal chain from Learning through DSBV to feedback loop.
>
> **Companion:** `i1-artifact-flow-map.html` — interactive visualization with click-to-expand artifact details.

---

## 1. Core Architecture Decisions

### 1.1 Learning is ALIGN-only

Learning pipeline exists ONLY in Zone 1 (ALIGN). Zones 2-4 are pure DSBV — they consume upstream outputs, they do not produce new knowledge. If a downstream zone discovers insufficient knowledge, it returns to ALIGN (new iteration or scope correction). This respects the versioning and causal chain from top down.

### 1.2 DSBV remains 4 stages

Scope is NOT a 5th stage. Instead, DSBV Design stage includes a "Scope Check" preamble:
- Q1: Are upstream zone outputs sufficient? (C1-C6 check)
- Q2: What's in scope / out of scope for this zone-iteration?
- Q3: Go/No-Go — proceed to DESIGN.md?

If any answer is NO → back to upstream zone. Don't design on shaky inputs.

### 1.3 Agent pattern is a Design stage decision

Any zone can use any agent pattern. The choice is made during DSBV Design stage based on the task's LT risks, not the zone name. DSBV is the constant; agent pattern is the variable.

### 1.4 Git strategy is part of DSBV

- DESIGN decides the branching plan
- SEQUENCE maps tasks to branches (parallel-safe tasks → worktrees)
- BUILD creates branches/worktrees, agents work in isolation
- VALIDATE merges via PR, cleans up worktrees/branches

---

## 2. Agent Pattern Catalog (9 patterns)

Unified from Google ADK + Anthropic "Building Effective Agents":

| # | Pattern | Core Idea | Complexity |
|---|---------|-----------|------------|
| 1 | Sequential Pipeline | A → B → C. Linear chain with gates. | Low |
| 2 | Routing / Dispatcher | Classify → route to specialist. | Low |
| 3 | Parallel Fan-Out / Gather | N agents parallel → synthesizer. | Medium |
| 4 | Orchestrator-Workers | Central LLM dynamically decomposes → delegates. | Medium |
| 5 | Generator / Critic | Generate → validate → loop until pass. | Medium |
| 6 | Iterative Refinement | Generate → Critique → Refine. Multi-pass. | High |
| 7 | Autonomous Agent | LLM plans independently, tools in loops, checkpoints. | High |
| 8 | Human-in-the-Loop | Agent groundwork → human gate at high stakes. | Low |
| 9 | Composite | Mix-and-match any above. | Varies |

### Selection Rule

**Start with the simplest pattern that adequately compensates for the task's LT risks.** (Anthropic + EP-01)

Decision tree runs during DSBV Design stage:
1. Can single agent handle it? → Single agent.
2. Known subtasks, independent? → Parallel Fan-Out.
3. Known subtasks, sequential? → Sequential Pipeline.
4. Dynamic decomposition needed? → Orchestrator-Workers.
5. Quality requires validation? → Generator/Critic or Iterative Refinement.
6. Open-ended exploration? → Autonomous Agent.
7. Multiple needs? → Composite.

Always overlay: Human-in-the-Loop at DSBV gates (G1-G4).

### DESIGN.md Execution Strategy Section

Every zone's DESIGN.md includes:
- **Pattern:** Name from catalog
- **Why this pattern:** Which LTs does it compensate?
- **Why NOT simpler:** What fails with single agent / sequential?
- **Agent config:** How many, which models, roles, handoff protocol
- **Git strategy:** Branches, worktrees, merge plan
- **Human gates:** Which decisions pause for approval
- **EP validation:** How EP-01, EP-03, EP-04, EP-09 are satisfied
- **Cost estimate:** Expected token/$ spend

---

## 3. Zone 1 — ALIGN (Learning + DSBV)

The ONLY zone with a Learning pipeline.

### Learning Pipeline (produces KNOWLEDGE)

```
learn-input → P0-P5 → VANA-SPEC → Readiness Package → [DSBV begins]
```

| Step | Artifact | File Path | Inputs | Outputs | WHY |
|------|----------|-----------|--------|---------|-----|
| 1 | learn-input | 1-ALIGN/learning/input/learn-input-{sys}.md | Business mandate, constraints, prior iteration feedback | Research questions, depth choice, scope | Scopes what to learn. Prevents analysis paralysis. |
| 2 | P0-P5 | 1-ALIGN/learning/output/{sys}/T{n}.P0-P5.md | learn-input, deep research | P0:Overview, P1:UBS, P2:UDS, P3:Principles, P4:Components, P5:Steps | Structured knowledge. Each page has downstream consumers. Zero orphans. |
| 3 | VANA-SPEC | 1-ALIGN/learning/specs/vana-spec.md | P0-P5 | Formal VANA grammar, AC-TEST-MAP, iteration plan | Defines "done" at every version level. Without this, acceptance is subjective. |
| 4 | Readiness Pkg | Bridge document (not a zone artifact) | VANA-SPEC, P0-P5 | C1-C6 checklist | Verifies learning is sufficient for DSBV. Prevents building on incomplete knowledge. |

### DSBV Artifacts (produces DELIVERABLES)

| ID | Artifact | File Path | Inputs | Outputs (downstream consumers) | WHY |
|----|----------|-----------|--------|-------------------------------|-----|
| A1 | PROJECT_CHARTER | 1-ALIGN/charter/PROJECT_CHARTER.md | P0, learn-input | → B6 System Design, B7 Master Plan, all zones | Single source of truth for project purpose. |
| A2 | STAKEHOLDERS | 1-ALIGN/charter/STAKEHOLDERS.md | P0 (RACI), P1, P2 | → B1 UBS Register, B4 UDS Register | Who benefits, who's affected, who can block. |
| A3 | REQUIREMENTS | 1-ALIGN/charter/REQUIREMENTS.md | VANA-SPEC, P3, P5 | → B6 System Design, B8 Execution Plan, C1 src/ | VANA-decomposed = unambiguous acceptance criteria. |
| A4 | OBJECTIVES | 1-ALIGN/okrs/OBJECTIVES.md | A1 (EO), VANA-SPEC | → A5 Key Results, D4 metrics/ | Translates charter purpose into measurable goals. |
| A5 | KEY_RESULTS | 1-ALIGN/okrs/KEY_RESULTS.md | A4, VANA-SPEC | → D4 metrics/, D1 reviews/ | Binary measurement, pillar-tagged (S/E/Sc). |
| A6 | ADR-00X | 1-ALIGN/decisions/ADR-00X.md | Learning trade-offs | → Constraints for all downstream zones | Prevents re-litigation. Captures "why." |

---

## 4. Zone 2 — PLAN (DSBV only)

Scope check: Are ALIGN outputs sufficient? If not → back to ALIGN.

| ID | Artifact | File Path | Inputs | Outputs | WHY |
|----|----------|-----------|--------|---------|-----|
| B1 | UBS_REGISTER | 2-PLAN/risks/UBS_REGISTER.md | P1, A2 | → B3, B8, C2 tests/ | Drives execution ordering (derisk-first) and test design. |
| B2 | ASSUMPTIONS | 2-PLAN/risks/ASSUMPTIONS.md | B1, A1 | → D2 retrospectives/ | Explicit assumptions are testable. Hidden ones = surprise failures. |
| B3 | MITIGATIONS | 2-PLAN/risks/MITIGATIONS.md | B1 | → B8, C3 config/ | Converts risks into actionable tasks. |
| B4 | UDS_REGISTER | 2-PLAN/drivers/UDS_REGISTER.md | P2, A2 | → B5, B6 | Identifies what to optimize after safety. |
| B5 | LEVERAGE_PLAN | 2-PLAN/drivers/LEVERAGE_PLAN.md | B4 | → B8 | How to exploit drivers. Pairs with MITIGATIONS. |
| B6 | SYSTEM_DESIGN | 2-PLAN/architecture/SYSTEM_DESIGN.md | A1, A3, P4, B1, B4 | → C1 src/, C3 config/, C4 docs/ | Architecture blueprint. Maps to UES 7 components. |
| B7 | MASTER_PLAN | 2-PLAN/roadmap/MASTER_PLAN.md | A1, VANA-SPEC, A5 | → B8, B9 | Version progression (Concept → Leadership). |
| B8 | EXECUTION_PLAN | 2-PLAN/roadmap/EXECUTION_PLAN.md | B7, B1, B5, B6, A3 | → C1-C4 (sprint backlog) | Operational contract for EXECUTE. Derisk-first ordering. |
| B9 | DEPENDENCIES | 2-PLAN/roadmap/DEPENDENCIES.md | B8, B6 | → EXECUTE Scope check | Prevents starting tasks whose deps aren't ready. |

---

## 5. Zone 3 — EXECUTE (DSBV only)

Scope check: Are PLAN outputs sufficient + prerequisites met?

| ID | Artifact | File Path | Inputs | Outputs | WHY |
|----|----------|-----------|--------|---------|-----|
| C1 | src/ | 3-EXECUTE/src/{subsystem}/ | B6, B8, A3 | → C2 tests/, D1 reviews/ | Core deliverable. Every file traces to A3 + B6. |
| C2 | tests/ | 3-EXECUTE/tests/{type}/ | B1, C1, B8 | → D3 risk-log/, D4 metrics/ | Each test proves a UBS risk is controlled. |
| C3 | config/ | 3-EXECUTE/config/ | B6 (EOE), B3 | → D3 risk-log/ | Environment config implements mitigation strategies. |
| C4 | docs/ | 3-EXECUTE/docs/ | B6 (EOP), C1, B8 | → D1 reviews/ | Runbooks, API docs. Implements EOP component. |

---

## 6. Zone 4 — IMPROVE (DSBV only)

Scope check: Are EXECUTE outputs validated and released?

| ID | Artifact | File Path | Inputs | Outputs | WHY |
|----|----------|-----------|--------|---------|-----|
| D1 | reviews/ | 4-IMPROVE/reviews/ | EXECUTE deliverables, A5 | → D5 changelog/, **→ ALIGN** | Delivery vs. promised gap analysis. |
| D2 | retrospectives/ | 4-IMPROVE/retrospectives/ | EXECUTE experience, B2, D3 | → Process improvements, **→ ALIGN** | 7-CS root cause analysis. |
| D3 | risk-log/ | 4-IMPROVE/risk-log/ | B1, C2 results, incidents | → D2, **→ ALIGN** (update UBS) | Validates risk register. Surprises = learning gaps. |
| D4 | metrics/ | 4-IMPROVE/metrics/ | A5, C2 results, production data | → D1, **→ ALIGN** (pillar targets) | 3-pillar effectiveness measurement. |
| D5 | changelog/ | 4-IMPROVE/changelog/ | D1, git history | → **ALIGN** (historical context) | Institutionalizes improvements. |

---

## 7. Feedback Loop: IMPROVE → ALIGN

| IMPROVE Output | Feeds ALIGN Input | Purpose |
|----------------|-------------------|---------|
| Validated improvement requests | learn-input (next iteration) | What to re-learn |
| Lessons learned | Learning research questions | What we got wrong |
| Updated UBS/UDS | P1/P2 refresh | New risk/driver discoveries |
| Pillar metrics | VANA-SPEC iteration targets | Next iteration success criteria |
| Assumption validation | Learning scope | Which assumptions broke |

**Rule:** Need to re-learn? Go back to ALIGN. Respect the causal chain — no local patches in downstream zones.

---

## 8. Git Strategy per DSBV

| DSBV Stage | Git Action | Branch Pattern |
|------------|-----------|----------------|
| DESIGN | Plan branching strategy | Decided in Execution Strategy |
| SEQUENCE | Map tasks to branches | Parallel-safe → separate worktrees |
| BUILD | Create branches/worktrees | `feat/{zone}-I{n}-{scope}`, `feat/{agent}-{task}` |
| VALIDATE | PR → review → merge → cleanup | Worktrees removed, feature branches deleted |

Branch hierarchy:
- **Iteration:** `I{n}-{version}` (e.g., `I1-Concept`) — PR to main when iteration complete
- **Zone:** `feat/{zone}-I{n}-{scope}` — PR to iteration branch at VALIDATE
- **Agent worktree:** `feat/{agent}-{task}` — merged to zone branch, worktree removed

---

## 9. Causal Chain Verification

Every artifact must satisfy:
- **Has inputs:** traces to upstream artifact or learning page
- **Has outputs:** at least one downstream consumer
- **Has WHY:** 1-line rationale for existence in the chain
- **No orphans:** if no outputs → dead weight, remove
- **No unsupported:** if no inputs → unfounded, trace back or remove
