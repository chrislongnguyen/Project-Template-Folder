# Research Prompt Template

This template defines WHAT to research and WHAT format to output. It is interpolated by `/learn:research` (Step 2) and embedded into each sub-agent's prompt. Variables are replaced with values from the `learn-input-{system}.md` file.

**This is NOT sent to the `/deep-research` skill.** Sub-agents use deep-research *methodology* (multi-angle web search, citation tracking) directly, but output in our 6-section Effective Learning format. See `2-LEARN/skills/learn-research/SKILL.md` Step 3 for the full sub-agent prompt including methodology and quality rules.

---

## Research Query (interpolated per topic)

```
Research the following system/subject comprehensively. Your output will be structured into 6 Effective Learning pages (P0–P5) for a learning library. Organize your research to map directly to these sections.

## System: {system_name} — {topic} ({topic_id})

## Effective Outcome (EO)
{eo}

## Perspective
Research from TWO perspectives simultaneously:
- Responsible (R) — who does the work: {raci_r}
- Accountable (A) — who owns the outcome: {raci_a}

Every finding should note whether it primarily affects R, A, or both.

## Research Domains
{research_domains}

---

## OUTPUT STRUCTURE (6 Sections — follow this exactly)

### Section 1: Overview & Summary (maps to P0)
- What is {topic}? Precise definition — what it is AND what it is not.
- Why does it matter? Relevance to {eo}.
- What does success look like? What does failure look like?
- For R perspective: how does {topic} affect the Responsible actor's daily work?
- For A perspective: how does {topic} affect the Accountable actor's outcomes?

### Section 2: Ultimate Blockers — Root Cause Analysis (maps to P1)
- What is the ROOT blocker preventing {eo}? Not symptoms — the deepest systemic cause.
- Build a causal chain: Root Blocker → what drives it harder (makes it worse) → what drives THAT
- Build a counter-chain: Root Blocker → what disables it (what overcomes it) → what enables THAT
- For R: what specific blockers does the Responsible actor face?
- For A: what specific blockers does the Accountable actor face?
- Go at least 5 levels deep in causal analysis. Surface-level answers are insufficient.
- Causal chain format: Root Blocker → L2 → L3 → L4 → L5
- Counter-chain format: Root Blocker ← L2 disabler ← L3 enabler ← L4 ← L5

### Section 3: Ultimate Drivers — Success Mechanism Analysis (maps to P2)
- What is the ROOT driver enabling {eo}? The deepest systemic enabler.
- Build a causal chain: Root Driver → what amplifies it → what amplifies THAT
- Build a counter-chain: Root Driver → what blocks it → what enables that blocker
- For R: what specific drivers does the Responsible actor leverage?
- For A: what specific drivers does the Accountable actor leverage?
- Go at least 5 levels deep. Show the mechanism at every level, not just the label.
- Causal chain format: Root Driver → L2 → L3 → L4 → L5
- Counter-chain format: Root Driver ← L2 blocker ← L3 ← L4 ← L5

### Section 4: Governing Principles (maps to P3)
Principles that govern success and failure in {topic}. Bucket into three categories:

**Sustainability Principles (S)** — correctness, safety, risk management:
- What principles ensure the system does the right thing without causing harm?
- What principles prevent compounding errors or data loss?

**Efficiency Principles (E)** — speed, leanness, minimal waste:
- What principles minimize time, cost, cognitive load, or resource waste?
- What principles ensure fast feedback loops?

**Scalability Principles (Sc)** — repeatability, growth, extensibility:
- What principles allow the system to handle increasing load or complexity?
- What principles ensure the approach works across different contexts?

For each principle: state it, explain WHY it works (mechanism), and cite a source framework or research if available.

### Section 5: Tools & Environment — 3 Causal Layers (maps to P4)
Organize tools and environment into three layers. The layers are CAUSAL — each depends on the one below:

**Layer 1 — Foundational (must exist first):**
- What base infrastructure, platforms, or runtime must be in place?
- Without this layer, nothing above works.

**Layer 2 — Operational (requires Layer 1):**
- What working environment, processes, or systems operate on top of the foundation?
- This is where daily work happens.

**Layer 3 — Enhancement (requires Layers 1+2):**
- What amplifies and optimizes the operational layer?
- Intelligence, automation, analytics — useless without Layers 1+2.

For each layer: list specific tools/platforms, explain why they belong in that layer, and note dependencies.

### Section 6: Operating Procedure — Steps to Apply (maps to P5)
Sequential, gated steps a practitioner follows. Organize in two phases:

**Phase A — DERISK (Sustainability steps — do these FIRST):**
- Steps that neutralize the Ultimate Blockers from Section 2.
- Each step: what to do, what input is needed, what output is produced, what can go wrong.
- These steps GATE everything below. Do not proceed to Phase B until Phase A is verified.

**Phase B — OPTIMIZE (Efficiency + Scalability steps — do these AFTER DERISK):**
- Steps that amplify the Ultimate Drivers from Section 3.
- Each step: what to do, input, output, typical failure mode.
- Efficiency steps before Scalability steps.

---

## Research Guidelines
- DEPTH over breadth. I need causal understanding, not surface-level overviews.
- CITE specific frameworks, tools, methodologies, and research where applicable.
- CONCRETE examples — name real tools, real patterns, real anti-patterns.
- DUAL PERSPECTIVE — always consider both R (doer) and A (decision-maker) viewpoints.
- NO generic advice like "follow best practices" — specify WHICH practices and WHY they work.
```

---

## Variables Reference

| Variable | Source | Description |
|----------|--------|-------------|
| `{system_name}` | learn-input §1 `system_name` | System or subject being researched |
| `{topic}` | learn-input §5 topics table | Specific topic name (e.g., "Overview & Summary", "UBS") |
| `{topic_id}` | learn-input §5 topics table | Topic ID (e.g., T0, T1, T2) |
| `{eo}` | learn-input §1 `eo` | Effective Outcome |
| `{raci_r}` | learn-input §2 `user_persona_r` | Responsible actor profile |
| `{raci_a}` | learn-input §2 `user_persona_a` | Accountable actor profile |
| `{research_domains}` | learn-input §6 | Bulleted list of research domains |

---

## Search Depth Mapping

The calling command (`/learn:research`) selects search depth based on topic depth:

| Topic Depth | Search Depth | Min Search Queries | Min Sources | Time Estimate |
|---|---|---|---|---|
| T0 | Mid | 5 | 8 | ~5-10 min |
| T0-T2 | Deep | 8 | 12 | ~10-20 min per topic |
| T0-T5 | Deep | 8 | 12 | ~10-20 min per topic |

All topics run in parallel via concurrent sub-agents.
