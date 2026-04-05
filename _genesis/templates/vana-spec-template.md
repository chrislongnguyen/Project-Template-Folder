---
version: "1.1"
last_updated: 2026-04-04
owner: "Long Nguyen"
type: template
work_stream: 1-ALIGN
stage: design
sub_system: 
---
# VANA-SPEC: {system_name}

<!-- OE.6.4 Extended Template — adds §0 Force Analysis and §6 System Boundaries.
     Original OE.6.1 sections §1-§5 preserved. Old §6-§10 renumbered to §7-§11.
     Every {placeholder} is replaced with data extracted from approved sources. -->

---

## §0 Force Analysis

<!-- Derivation: ELF output + T0.P1 (UBS) + T0.P2 (UDS) + RACI from §1.
     Requires at least 1 level of recursive decomposition (Fix 7).
     All forces analyzed from BOTH R and A perspectives (general-system.md §4). -->

### §0.1 UBS — Blocking Forces (Derisk First)

#### UBS(R) — What blocks the Responsible party

| ID | Force | Mechanism | LT/Bias Root |
|---|---|---|---|
| UBS.R.1 | {blocker} | {how it blocks} | {LT-N or Bias} |
| UBS.R.2 | {blocker} | {how it blocks} | {LT-N or Bias} |

#### UBS(A) — What blocks the Accountable party

| ID | Force | Mechanism | LT/Bias Root |
|---|---|---|---|
| UBS.A.1 | {blocker} | {how it blocks} | {Bias} |

#### Recursive Decomposition (minimum 1 level)

| Parent Force | Sub-Force | Direction | Mechanism |
|---|---|---|---|
| UBS.R.1 | UBS.R.1.UB | Weakens blocker (ally) | {what naturally weakens this blocker} |
| UBS.R.1 | UBS.R.1.UD | Strengthens blocker (threat) | {what makes this blocker worse} |
| UBS.A.1 | UBS.A.1.UB | Weakens blocker (ally) | {what naturally weakens this blocker} |
| UBS.A.1 | UBS.A.1.UD | Strengthens blocker (threat) | {what makes this blocker worse} |

### §0.2 UDS — Driving Forces

#### UDS(R) — What drives the Responsible party

| ID | Force | Mechanism | Strength Source |
|---|---|---|---|
| UDS.R.1 | {driver} | {how it drives} | {Architectural / Procedural} |

#### UDS(A) — What drives the Accountable party

| ID | Force | Mechanism | Strength Source |
|---|---|---|---|
| UDS.A.1 | {driver} | {how it drives} | {System 2 strength} |

#### Recursive Decomposition (minimum 1 level)

| Parent Force | Sub-Force | Direction | Mechanism |
|---|---|---|---|
| UDS.R.1 | UDS.R.1.UD | Strengthens driver (amplify) | {what makes this driver stronger} |
| UDS.R.1 | UDS.R.1.UB | Weakens driver (silent killer) | {what could undermine this driver} |

### §0.3 Sigmoid Workstream Classification

<!-- Classify each of the 8 universal system components
     into Below Threshold / Leverage Workstream / Saturated.
     For AI agent systems, EU = Agent (LLM model), EI = Input. -->

| Component | Current Workstream | Signal | Action |
|---|---|---|---|
| EI (Effective Inputs) | {workstream} | {evidence} | {invest / keep investing / move on} |
| EU (Effective User) | {workstream} | {evidence} | {invest / keep investing / move on} |
| EA (Effective Action) | {workstream} | {evidence} | {invest / keep investing / move on} |
| EP (Effective Principles) | {workstream} | {evidence} | {invest / keep investing / move on} |
| EOE (Effective Operating Environment) | {workstream} | {evidence} | {invest / keep investing / move on} |
| EOT (Effective Operating Tools) | {workstream} | {evidence} | {invest / keep investing / move on} |
| EOP (Effective Operating Procedure) | {workstream} | {evidence} | {invest / keep investing / move on} |

### §0.4 Bottleneck Identification

**Current bottleneck:** {first component below threshold}
**Rationale:** {evidence from sigmoid classification}

### §0.5 Synergy Check

<!-- "Would strengthening component X lower the threshold for component Y?" -->

| Intervention | Target Component | Effect on Threshold | Synergy? |
|---|---|---|---|
| Strengthen {X} | Lowers K for {Y} | {description} | {Yes/No} |

**Highest-leverage intervention:** {the cross-component play with greatest impact}

---

## §1 System Identity

<!-- Derivation: learn-input + T0.P0 Workstream Contract -->

| Field | Value |
|-------|-------|
| System Name | {system_name} |
| Slug | {system_slug} |
| Abbreviation | {system_abbrev} |
| EO | {eo} |
| Learning Book | BOOK-{nn} |
| Topics Covered | {topic_list} |

### User Persona

<!-- Source: T0.P0 col 3 (REL) — User Persona row -->

| Attribute | Description |
|-----------|-------------|
| Who | {persona_who} |
| Goal | {persona_goal} |
| Context | {persona_context} |

### Anti-Persona

<!-- Source: T0.P0 col 4 (DEF) — Anti-Persona row -->

| Attribute | Description |
|-----------|-------------|
| Who | {anti_persona_who} |
| Why Excluded | {anti_persona_why} |

### RACI

<!-- Source: T0.P0 Workstream Contract — R=Agent, A=Human Director -->

| Role | Assignment |
|------|------------|
| Responsible (R) | {raci_r} |
| Accountable (A) | {raci_a} |
| Consulted (C) | {raci_c} |
| Informed (I) | {raci_i} |

---

## §2 Verb Acceptance Criteria

<!-- Derivation: T0.P5 — each STEP.n(R) row becomes one Verb-AC (I1).
     STEP.n(A) Col16 (NEXT) cells become SPAWNED Verb-ACs (I4).
     All use sequential Verb-ACn IDs — VANA Element column distinguishes I1 vs SPAWNED. -->

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| Verb-AC1 | {verb_word_1} | {verb_criteria_1} | T0.P5:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
| Verb-AC2 | {verb_word_2} | {verb_criteria_2} | T0.P5:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
| Verb-AC{n} | {spawned_word_1} | {spawned_criteria_1} | T0.P5:{row}:Col16 | {Deterministic\|Manual\|AI-Graded} | {threshold} | I4 |
<!-- One row per STEP.n(R) at I1; one row per STEP.n(A) Col16 NEXT cell at I4. Continuous Verb-ACn sequence. -->

---

## §3 Adverb Acceptance Criteria

<!-- Derivation: T0.P3 Principles — bucketed by S/E/Sc pillar tag.
     P(S) → SustainAdv (I1), P(E) → EffAdv (I2), P(Sc) → ScalAdv (I3). -->

### §3.1 Sustainability Adverbs (I1)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| SustainAdv-AC1 | {sustain_adv_word_1} | {sustain_adv_1} | T0.P3:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
<!-- One row per P(S) principle → adverb -->

### §3.2 Efficiency Adverbs (I2)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| EffAdv-AC1 | {eff_adv_word_1} | {eff_adv_1} | T0.P3:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I2 |
<!-- One row per P(E) principle → adverb -->

### §3.3 Scalability Adverbs (I3)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| ScalAdv-AC1 | {scal_adv_word_1} | {scal_adv_1} | T0.P3:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I3 |
<!-- One row per P(Sc) principle → adverb -->

---

## §4 Noun Acceptance Criteria

<!-- Derivation: T0.P4 Components — organized by EOE/EOT layer (I1).
     Hardening ACs derived from T0.P0 RACI(I) role — production readiness gates (I4).
     All use continuous Noun-ACn IDs — VANA Element column distinguishes I1 vs Hardening. -->

### §4.1 INFRA Layer

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| Noun-AC1 | {noun_word_1} | {noun_infra_1} | T0.P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
<!-- One row per INFRA component -->

### §4.2 WORKSPACE Layer

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| Noun-AC{n} | {noun_word_n} | {noun_workspace_1} | T0.P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
<!-- One row per WORKSPACE component -->

### §4.3 INTEL Layer

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| Noun-AC{n} | {noun_word_n} | {noun_intel_1} | T0.P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
| Noun-AC{n} | {hardening_word_1} | {hardening_criteria_1} | T0.P0:RACI(I) | Deterministic | 100% pass rate | I4 |
<!-- One row per INTEL component (I1), then one row per Hardening AC (I4). Continuous Noun-ACn sequence. -->

---

## §5 Adjective Acceptance Criteria

<!-- Derivation: Cross-reference T0.P3 (principles) x T0.P4 (components).
     Quality attributes for Nouns, bucketed by S/E/Sc pillar. -->

### §5.1 Sustainability Adjectives (I1)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| SustainAdj-AC1 | {sustain_adj_word_1} | {sustain_adj_1} | T0.P3+P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
<!-- Quality attributes that ensure Noun sustainability -->

### §5.2 Efficiency Adjectives (I2)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| EffAdj-AC1 | {eff_adj_word_1} | {eff_adj_1} | T0.P3+P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I2 |
<!-- Quality attributes that ensure Noun efficiency -->

### §5.3 Scalability Adjectives (I3)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| ScalAdj-AC1 | {scal_adj_word_1} | {scal_adj_1} | T0.P3+P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I3 |
<!-- Quality attributes that ensure Noun scalability -->

---

## §6 System Boundaries

<!-- Derivation: general-system.md §7 — all 4 layers required (Fix 8).
     This section defines the boundary contract for the system being specified. -->

### §6.1 Layer 1 — What Flows

<!-- Five categories from general-system.md §7 Layer 1 -->

| Category | Inbound | Outbound |
|---|---|---|
| Acceptance Criteria | {what "correct" means for inputs} | {what "correct" means for outputs} |
| Signal / Data / Information | {data payloads received} | {data payloads produced} |
| Physical Resources | {hardware, infra consumed} | {hardware, infra produced/modified} |
| Human Resources | {people, roles, time consumed} | {people, roles enabled} |
| Financial Resources | {budget, token spend consumed} | {value produced, cost reduced} |

### §6.2 Layer 2 — How It Flows Reliably

<!-- Six contract fields per boundary, from general-system.md §7 Layer 2 -->

#### Input Contracts

| Field | Contract 1: {upstream_name} | Contract 2: {upstream_name} |
|---|---|---|
| Source | {who sends} | {who sends} |
| Schema | {data shape} | {data shape} |
| Validation | {rules} | {rules} |
| Error | {behavior on violation} | {behavior on violation} |
| SLA | {availability, latency} | {availability, latency} |
| Version | {contract version} | {contract version} |

#### Output Contracts

| Field | Contract 1: {downstream_name} | Contract 2: {downstream_name} |
|---|---|---|
| Consumer | {who receives} | {who receives} |
| Schema | {data shape} | {data shape} |
| Validation | {rules} | {rules} |
| Error | {behavior on violation} | {behavior on violation} |
| SLA | {availability, latency} | {availability, latency} |
| Version | {contract version} | {contract version} |

### §6.3 Layer 3 — How You Verify

<!-- Eval spec per AC, from general-system.md §7 Layer 3.
     This is the bridge to the AC-TEST-MAP (§7). -->

| A.C. ID | Eval Type | Dataset | Grader | Threshold |
|---|---|---|---|---|
| {AC-ID} | {Deterministic / Manual / AI-Graded} | {what data} | {what checks} | {pass criteria} |

### §6.4 Layer 4 — How It Fails Gracefully

<!-- Per-component failure behavior, from general-system.md §7 Layer 4 -->

| Component / Step | Recovery | Escalation | Degradation | Timeout |
|---|---|---|---|---|
| {component} | {retry, fallback, fail-fast} | {who, when} | {partial output OK? how marked?} | {max retries, max wall-clock} |

### §6.5 Integration Chain

<!-- From general-system.md §7: SYS-A OUTPUT → SYS-B INPUT → SYS-B OUTPUT → SYS-C INPUT -->

```
{upstream_system} ──[{schema}]──► THIS SYSTEM ──[{schema}]──► {downstream_system}
```

### §6.6 Feedback Loops

<!-- From SYSTEM-THINKING-DESIGN-NOTES-v2.md: identify reinforcing and balancing loops -->

| Loop ID | Type | Components | Delay | Effect |
|---|---|---|---|---|
| FL-1 | {Reinforcing / Balancing} | {what feeds back to what} | {short / long} | {amplifies / stabilizes what} |

---

## §7 AC-TEST-MAP (G1: Eval Specification)

<!-- Derivation: One row per A.C. from §2-§5. This is the eval-driven development
     bridge — every A.C. must have a proof-of-correctness spec before building starts.

     Note: This was §6 in OE.6.1 template. Renumbered for OE.6.4.

     Eval type selection:
       Deterministic — Noun A.C.s, data format checks, schema validation, any A.C.
                       verifiable by scripted pass/fail (pytest, regex, Pydantic parse).
       Manual        — Subjective quality, UX judgment, strategic approval, any A.C.
                       requiring Human Director review with a rubric.
       AI-Graded     — Natural language quality, reasoning checks at scale, citation
                       verification. Use with calibration threshold (e.g. 95% agreement
                       with human graders). -->

| A.C. ID | VANA Word | VANA Source | Eval Type | Dataset Description | Grader Description | Threshold |
|---------|-----------|-------------|-----------|--------------------|--------------------|-----------|
| Verb-AC1 | {verb_word} | §2 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| SustainAdv-AC1 | {adv_word} | §3.1 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| Noun-AC1 | {noun_word} | §4 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| SustainAdj-AC1 | {adj_word} | §5.1 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
<!-- One row per A.C. — MECE. Every A.C. from §2-§5 must appear exactly once. -->

---

## §8 Failure Modes & Recovery (G3)

<!-- Derivation: Seeded from T0.P1 UBS analysis (blockers) and T0.P5 col 9/10
     (UD.MECH / UB.MECH). Per-iteration table.
     Note: This was §7 in OE.6.1 template. Renumbered for OE.6.4. -->

### Iteration 1 Failure Modes

| Failure Mode | Trigger | Detection | Recovery | Escalation | Degradation | Timeout |
|-------------|---------|-----------|----------|------------|-------------|---------|
| {mode_1} | {trigger} | {detection} | {recovery} | {escalation} | {degradation} | {timeout} |

### Iteration 2 Failure Modes

| Failure Mode | Trigger | Detection | Recovery | Escalation | Degradation | Timeout |
|-------------|---------|-----------|----------|------------|-------------|---------|
| {mode_1} | {trigger} | {detection} | {recovery} | {escalation} | {degradation} | {timeout} |

### Iteration 3 Failure Modes

| Failure Mode | Trigger | Detection | Recovery | Escalation | Degradation | Timeout |
|-------------|---------|-----------|----------|------------|-------------|---------|
| {mode_1} | {trigger} | {detection} | {recovery} | {escalation} | {degradation} | {timeout} |

### Iteration 4 Failure Modes

| Failure Mode | Trigger | Detection | Recovery | Escalation | Degradation | Timeout |
|-------------|---------|-----------|----------|------------|-------------|---------|
| {mode_1} | {trigger} | {detection} | {recovery} | {escalation} | {degradation} | {timeout} |

---

## §9 Agent Behavioral Boundaries (G4)

<!-- Derivation: RACI from T0.P0 + EOP from T0.P5.
     Anthropic 3-tier system. Boundaries tighten as system matures.
     Note: This was §8 in OE.6.1 template. Renumbered for OE.6.4. -->

### Iteration 1 Boundaries

**Always (safe actions — no approval needed):**
- {always_action_1}
- {always_action_2}

**Ask First (high-impact — needs Human Director approval):**
- {ask_first_action_1}
- {ask_first_action_2}

**Never (hard stops — violation = immediate halt):**
- {never_action_1}
- {never_action_2}

### Iteration 2 Boundaries

**Always:**
- {always_action_1}

**Ask First:**
- {ask_first_action_1}

**Never:**
- {never_action_1}

### Iteration 3 Boundaries

**Always:**
- {always_action_1}

**Ask First:**
- {ask_first_action_1}

**Never:**
- {never_action_1}

### Iteration 4 Boundaries

**Always:**
- {always_action_1}

**Ask First:**
- {ask_first_action_1}

**Never:**
- {never_action_1}

### Model Selection Guidance

| Task Type | Model Tier | Rationale |
|-----------|-----------|-----------|
| Sustainability-critical steps | Highest-capability | Zero tolerance for error |
| Routine data transforms | Fastest / cheapest | Speed over reasoning depth |
| Creative generation | Best reasoning | Quality over cost |

---

## §10 Iteration Plan

<!-- Every A.C. from §2-§5 assigned to exactly one iteration — MECE.
     Rule: Sustainability gates everything. No I2 work until all I1 A.C.s pass.
     Note: This was §9 in OE.6.1 template. Renumbered for OE.6.4. -->

### Master Scope Mapping

| A.C. ID | VANA Word | Criteria (short) | VANA Element | Iteration | Status |
|---------|-----------|------------------|--------------|-----------|--------|
| Verb-AC1 | {verb_word} | {short_desc} | Verb | I1 | To Do |
| SustainAdv-AC1 | {adv_word} | {short_desc} | Adverb (S) | I1 | To Do |
| Noun-AC1 | {noun_word} | {short_desc} | Noun | I1 | To Do |
| SustainAdj-AC1 | {adj_word} | {short_desc} | Adjective (S) | I1 | To Do |
| EffAdv-AC1 | {adv_word} | {short_desc} | Adverb (E) | I2 | To Do |
| EffAdj-AC1 | {adj_word} | {short_desc} | Adjective (E) | I2 | To Do |
| ScalAdv-AC1 | {adv_word} | {short_desc} | Adverb (Sc) | I3 | To Do |
| ScalAdj-AC1 | {adj_word} | {short_desc} | Adjective (Sc) | I3 | To Do |
<!-- Every A.C. appears exactly once. -->

### Iteration Sequencing

| Iteration | Name | Scope | Gate Criteria |
|-----------|------|-------|---------------|
| I1 | Concept | Verb + SustainAdv + Noun + SustainAdj | All I1 A.C.s pass eval |
| I2 | Working Prototype | + EffAdv + EffAdj | All I1+I2 A.C.s pass eval |
| I3 | MVE | + ScalAdv + ScalAdj | All I1+I2+I3 A.C.s pass eval |
| I4 | Leadership | + remaining + SPAWNED A.C.s | All A.C.s pass eval |

---

## §11 Integration Contracts (G2)

<!-- Derivation: learn-input Workstream Contract (T0.P0).
     Note: This was §10 in OE.6.1 template. Renumbered for OE.6.4. -->

### INPUT CONTRACT

<!-- One table per upstream system that provides data to this system -->

| Field | Value |
|-------|-------|
| Source | {upstream_system} |
| Schema | {input_schema} |
| Field Types | {field_types} |
| Validation Rules | {validation_rules} |
| Error Handling | {error_handling} |
| SLA | {sla} |
| Version | {version} |

### OUTPUT CONTRACT

<!-- One table per downstream system that consumes data from this system -->

| Field | Value |
|-------|-------|
| Consumer | {downstream_system} |
| Schema | {output_schema} |
| Field Types | {field_types} |
| Validation Rules | {validation_rules} |
| Error Handling | {error_handling} |
| SLA | {sla} |
| Version | {version} |

---

## Traceability Chain

<!-- Every A.C. must trace back to the EO through this 4-link chain:
     A.C. ← VANA Grammar Element ← ESD Phase 2 Decision ← ILE Page ← EO -->

| A.C. ID | VANA Element | ESD Decision | ILE Source | EO Link |
|---------|-------------|-------------|-----------|----------|
| Verb-AC1 | Verb | EOP Step {n} | T0.P5:R{r}:C{c} | {udo_short} |
| SustainAdv-AC1 | Adverb (S) | Principle P{n}(S) | T0.P3:R{r}:C{c} | {udo_short} |
| Noun-AC1 | Noun | Component {layer}.{n} | T0.P4:R{r}:C{c} | {udo_short} |
<!-- Every A.C. must have a complete chain. Broken chain = broken spec. -->

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[blocker]]
- [[general-system]]
- [[iteration]]
- [[task]]
- [[workstream]]
